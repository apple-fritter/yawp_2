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

  # Cleanup
  #!/bin/bash

  # Clean up home directory
  cd ~
  rm -rv .cache/
  rm -v .wget-hsts

  # Define the directory that contains the schema files
  SCHEMA_DIR="/usr/share/glib-2.0/schemas"

  # Check if the directory exists
  if [ ! -d "$SCHEMA_DIR" ]
    then echo "Directory $SCHEMA_DIR not found."
    exit
  fi

  # Find all the schema files that are not used by any installed applications
    UNUSED_SCHEMAS=$(find $SCHEMA_DIR -type f -name "*.gschema.xml" -print0 | xargs -0 grep -L "gettext" 2>/dev/null)

  # Remove the unused schema files
  for schema in $UNUSED_SCHEMAS; do
    rm -f $schema
    echo "Removed $schema"
  done

  # Compile the remaining schema files
  glib-compile-schemas $SCHEMA_DIR

  # Clean up bash history
  find ~/.bash_history -delete

  # Clean up backup files
  find ~/ -name "*.bak" -delete

  # Clean up DS_Store files
  find ~/ -name ".DS_Store" -delete

  # Clean up Thumbs.db files
  find ~/ -name "Thumbs.db" -delete

  # Clean up tmp files
  find ~/ -name "*.tmp" -delete

  # Clean up Java cache
  find ~/.cache/ -name "hsperfdata_*" -delete

  # Clean up SQLite3 history
  find ~/.sqlite_history -delete

  # Clean up system cache
  find ~/ -name "*~" -delete

  # Clean up rotated logs
  sudo find /var/log/ -name "*.gz" -delete

  # Clean up trash
  rm -rf ~/.local/share/Trash/*

  # Clean up thumbnail cache
  find ~/.cache/thumbnails -delete

  # Clean up X11 debug logs
  find ~/.xsession-errors -delete

  # Remove packages that are no longer needed
  apt-get clean -y
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
