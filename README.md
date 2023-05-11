# yawp ][
This script automates the process of updating and repackaging an ISO file using chroot.

[yawp](https://github.com/apple-fritter/yawp), the predecessor, had a good reception following its first commits. I wanted to leave it be, and update some of my strategies employed by such a script and write something new. I also wanted to write something far less involved than [PJ-Singh](https://github.com/PJ-Singh-001)'s [CUBIC](https://github.com/PJ-Singh-001/Cubic), which is also a very good project, while doing so from CLI. Please also consider checking out my related project, [iSOnject](https://github.com/apple-fritter/iSOnject).

## Functionality
yawp ][ performs the following tasks:
- Mounts the input ISO file
- Extracts the ISO contents to a chroot directory
- Updates installed packages and installs the latest available kernel
- Sets the newly installed kernel as the default boot kernel
- Updates the diskdefines file with the accurate disk size
- Updates the diskdefines file with a custom label
- Repacks the updated chroot directory into a new ISO file
- Cleans up temporary directories

## Differences
In contrast to the original yawp, yawp2 is no longer also wrapper to the update and cleaning routine scripts, but rather includes them in one unified script, which may be more accessible to the end user for customization purposes.

In addition to the above, there exists now a specific routine to handle kernel updates to the ISO, and modifies the diskdefines to accurately reflect the size of the new ISO's filesystem.

## Flowchart
This representation provides a clear overview of the script flow.
```
┌─ Start Program
│
├─ [Mount ISO]
│   ├─ [Extract ISO contents to chroot directory]
│   │   ├─ [Update installed packages]
│   │   ├─ [Install latest available kernel]
│   │   │   ├─ [Set installed kernel as default]
│   │   │   └─ [Update grub]
│   │   │
│   │   ├─ [Clean up unnecessary files]
│   │   │   ├─ [Remove .cache/ directory]
│   │   │   ├─ [Remove .wget-hsts file]
│   │   │   ├─ [Remove unused schema files]
│   │   │   ├─ [Compile remaining schema files]
│   │   │   ├─ [Delete .bash_history file]
│   │   │   ├─ [Delete .bak backup files]
│   │   │   ├─ [Delete .DS_Store files]
│   │   │   ├─ [Delete Thumbs.db files]
│   │   │   ├─ [Delete .tmp temporary files]
│   │   │   ├─ [Delete Java cache files]
│   │   │   ├─ [Delete .sqlite_history file]
│   │   │   ├─ [Delete files ending with ~]
│   │   │   ├─ [Delete rotated log files]
│   │   │   ├─ [Empty trash]
│   │   │   ├─ [Delete thumbnail cache files]
│   │   │   └─ [Delete X11 debug logs]
│   │   │
│   │   └─ [Update diskdefines]
│   │       ├─ [new disk size]
|   |       └─ [new label]
│   │
│   └─ [Repack chroot directory into new ISO file]
│       └─ [Create new ISO image]
│
├─ [Set permissions and ownership]
│
├─ [Clean up temporary directories]
│
└─ End Program
```
## Usage

1. Clone or download the repository to your local machine.

2. Ensure that you have the necessary dependencies installed:
   - `unsquashfs`: To extract the ISO filesystem.
   - `mksquashfs`: To repack the updated chroot directory into a new ISO.
   - `xorriso`: To create the new ISO image.

3. Place your original Debian ISO file in the same directory as the script.

4. Open a terminal and navigate to the script directory.

5. Make the script executable and execute it using the following command:
   ```bash
   yawp2.sh
   ```
Follow the prompts to provide the input and output paths. The default output path will be displayed, which you can use or specify a different path.

## The diskdefines file
> The script now automates the process of modifying the `diskdefines` file inside an ISO image.

The diskdefines file is a text file used in Ubuntu and some other Linux distributions to provide metadata about an ISO image. It is typically found in the root directory of the ISO file and is named "diskdefines". This file contains information such as the name and version of the distribution, release date, and other details. It is used by the installer to display this information during the installation process.

### Example diskdefines file:

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
