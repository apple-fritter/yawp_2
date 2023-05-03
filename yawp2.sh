#!/bin/bash

# Set the chroot environment as a temporary variable
chrootDir="./chrootDir"

# Prompt user for input and output paths
read -p "Enter path to input ISO: " input_iso
read -p "Enter path to output ISO (press enter for default): " output_iso

# Set default output path if not specified by user
if [ -z "$output_iso" ]; then
  output_iso="${input_iso%.*}_updated_$(date +%y%m%d).iso"
fi

# Create temporary directories for mount and chroot
mkdir -p isomount "$chrootDir"

# Mount ISO to isomount directory
sudo mount -o loop "$input_iso" isomount

# Extract the ISO to chrootDir directory
sudo unsquashfs -d "$chrootDir" isomount/casper/filesystem.squashfs

# Copy update_installed_packages.sh to chrootDir/root
sudo cp "$(dirname $0)/update_installed_packages.sh" "$chrootDir/root/"

# Set permissions of update_installed_packages.sh to 777
sudo chmod 777 "$chrootDir/root/update_installed_packages.sh"

# Add network connectivity to the chroot environment
sudo mount --bind /dev "$chrootDir/dev"
sudo mount --bind /dev/pts "$chrootDir/dev/pts"
sudo mount --bind /proc "$chrootDir/proc"
sudo mount --bind /sys "$chrootDir/sys"

# Chroot into the environment and execute commands
sudo chroot "$chrootDir" /bin/bash -c "
  # The update_installed_packages.sh script
  apt-get update -y
  apt-get dist-upgrade -y

  # Get the currently running kernel version
  current_kernel=\$(uname -r)

  # Check if there are newer kernel versions available
  available_kernels=\$(apt-cache policy linux-image-generic | grep Candidate | awk '{print \$2}')

  # Install the latest available kernel
  if [[ \$available_kernels != *\"\$current_kernel\"* ]]; then
    latest_kernel=\$(echo \"\$available_kernels\" | head -n1)
    apt-get install -y linux-image-generic=\$latest_kernel
    if [ \$? -eq 0 ]; then
      echo \"Kernel installation successful\"
    else
      echo \"Error: Failed to install the kernel\"
      exit 1
    fi
  fi

  # Set the newly installed kernel as default
  update-grub
  if [ \$? -eq 0 ]; then
    echo \"Default kernel set successfully\"
  else
    echo \"Error: Failed to set the default kernel\"
    exit 1
  fi

  # Remove older kernel packages and their related module files
  apt-get autoremove --purge -y
  if [ \$? -eq 0 ]; then
    echo \"Older kernels and related modules removed successfully\"
  else
    echo \"Error: Failed to remove older kernels and related modules\"
    exit 1
  fi
"

# Exit chroot environment and unmount bind mounts
sudo umount "$chrootDir/{dev/pts,dev,proc,sys}"

# Set the newly installed kernel as default in the resulting ISO
sudo sed -i 's/default\ .*$/default\ new_kernel_name/g' isomount/boot/grub/grub.cfg

# Repack the updated chroot directory into a new ISO file
sudo mksquashfs "$chrootDir" isomount/casper/filesystem.squashfs -comp xz -wildcards

# Create the new ISO image
sudo xorriso -as mkisofs -iso-level 3 -o "$output_iso" isomount

# Cleanup temporary directories
sudo umount isomount
sudo rm -rf isomount "$chrootDir"
