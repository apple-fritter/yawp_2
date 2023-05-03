# yawp ][
[yawp](https://github.com/apple-fritter/yawp), the predecessor, had a good reception following its first commits. I wanted to leave it be, and update some of my strategies employed by such a script, and write something new. I also wanted to write something far less involved, than [PJ-Singh](https://github.com/PJ-Singh-001)'s [CUBIC](https://github.com/PJ-Singh-001/Cubic), which is also a very good project, while doing so from CLI.

This script allows you to update an Debian ISO file, install the latest available kernel, set it as the default boot kernel in the resulting ISO, and remove older kernel packages and related module files, while requiring little-to-no human interaction.

## Differences
In contrast to the original yawp, yawp2 is no longer also wrapper to the update and cleaning routine scripts, but rather includes them in one unified script, which may be more accessible to the end user for customization purposes.

In addition to the above, there exists now a specific routine to handle kernel updates to the ISO.

## Logical flow
```
Start
├─┬ Input ISO
│ └── Output ISO
├─┬ Create Temporary Directories
│ ├─┬ Mount ISO
│ │ ├── Extract ISO
│ │ └── Inject Scripts
│ └─┬ Add Network Connectivity to Chroot
│   ├── Mount /dev, /dev/pts, /proc, /sys
│   └── Chroot Environment
│     ├── Update System
│     ├── Install Latest Kernel
│     ├── Set Default Kernel
│     └── Cleanup
│       ├── Clean Home Directory
│       ├── Remove Unused Schema Files
│       ├── Compile Remaining Schema Files
│       ├── Clean Bash History
│       ├── Clean Backup Files
│       ├── Clean Temporary Files
│       ├── Clean Java Cache
│       ├── Clean SQLite3 History
│       ├── Clean System Cache
│       ├── Clean Rotated Logs
│       ├── Clean Trash
│       ├── Clean Thumbnail Cache
│       └── Clean X11 Debug Logs
├── Exit Chroot Environment
├── Unmount Bind Mounts
├─┬ Set Custom Label
│ ├─┬ Mount ISO
│ │ └── Modify Diskdefines File
│ └── Unmount ISO
├─┬ Repack ISO
│ ├─┬ Create New SquashFS
│ │ └── Cleanup Chroot
│ └── Create New ISO
└── Cleanup Temporary Directories
```
This representation provides a clear overview of the script flow. It starts with input and output handling, followed by creating temporary directories. Then, it mounts the ISO and extracts it. It sets a custom label by modifying the diskdefines file. Next, it adds network connectivity and enters the chroot environment. Inside the chroot, it updates the system, installs the latest kernel, sets the default kernel, and performs various cleanup operations. After exiting the chroot environment, it unmounts the bind mounts. It proceeds to repack the ISO by creating a new squashFS and generating a new ISO. Finally, it cleans up the temporary directories.

## Usage

1. Clone or download the repository to your local machine.

2. Ensure that you have the necessary dependencies installed:
   - `unsquashfs`: To extract the ISO filesystem.
   - `mksquashfs`: To repack the updated chroot directory into a new ISO.
   - `xorriso`: To create the new ISO image.

3. Place your original Debian ISO file in the same directory as the script.

4. Open a terminal and navigate to the script directory.

5. Run the script using the following command:
   ```bash
   yawp2.sh
   ```
Follow the prompts to provide the input and output paths. The default output path will be displayed, which you can use or specify a different path.

## The diskdefines file
The diskdefines file is a text file used in Ubuntu and some other Linux distributions to provide metadata about an ISO image. It is typically found in the root directory of the ISO file and is named "diskdefines". This file contains information such as the name and version of the distribution, release date, and other details. It is used by the installer to display this information during the installation process.

Here's an example of the contents of a diskdefines file:

```
#define DISKNAME  Ubuntu 20.04 LTS
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  amd64
#define ARCHamd64  1
#define DISKNUM  1
#define TOTALNUM  0
#define DISKSIZE  4.7GB
#define LABEL  Ubuntu 20.04 LTS amd64
#define CDLABEL  Ubuntu 20.04 LTS
#define MENU  /isolinux/splash.txt
#define AUTOMENU  /casper/automenu.txt
#define HELP  /casper/help.txt
#define NOHELP  /casper/nohelp.txt
#define INDEX  /casper/index.txt
#define KERNEL  /casper/vmlinuz
#define APPEND  file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd quiet splash ---
#define TEXTHELP  /casper/text.cfg
```

### The script now automates the process of modifying the `diskdefines` file inside an ISO image.
- The script prompts the user to enter the path to the ISO file that needs to be modified and stores it in the input_iso variable.
- It sets a custom label by appending the current date (in the format YYYY.MM.DD) to the string "Custom".
- The diskdefines_path variable is set to the path of the diskdefines file within the mounted ISO.
- Using sudo sed -i, the script removes the lines starting with #define DISKLABEL, #define LABEL, and #define CDLABEL from the diskdefines file.
- The custom label lines are appended at the end of the diskdefines file using sudo tee -a.

## Possible Concerns
### System Compatibility
The script is designed for Debian-based systems and may not work correctly on other distributions.
### Dependency Requirements
Ensure that you have the necessary dependencies installed (unsquashfs, mksquashfs, and xorriso) to avoid any issues during the update and ISO creation process.
### Custom Modifications:
If you have made custom changes to your Debian ISO, running this script may overwrite or modify those changes. Make sure to backup any important data before using the script.
### Kernel Installation:
The script installs the latest available kernel. Ensure that you understand the implications of upgrading the kernel and verify its compatibility with your system.
### Testing:
It's recommended to test the resulting ISO in a virtual machine or non-production environment before using it in a live system.

## [Disclaimer](DISCLAIMER)
**This software is provided "as is" and without warranty of any kind**, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

**The authors do not endorse or support any harmful or malicious activities** that may be carried out with the software. It is the user's responsibility to ensure that their use of the software complies with all applicable laws and regulations.

## License

These files released under the [MIT License](LICENSE).
