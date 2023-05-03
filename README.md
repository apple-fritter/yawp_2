# yawp ][
[yawp](https://github.com/apple-fritter/yawp/blob/main/yawp.sh), the predecessor had a good reception following it's first commits. I wanted to leave it be, and update some of my strategies employed by such a script, and write something new. I also wanted to write something far less involved, than [PJ-Singh](https://github.com/PJ-Singh-001)'s [CUBIC](https://github.com/PJ-Singh-001/Cubic), which is also a very good project, while doing so from CLI.

This script allows you to update an Debian ISO file, install the latest available kernel, set it as the default boot kernel in the resulting ISO, and remove older kernel packages and related module files, while requiring little-to-no human interaction.

## Differences
In contrast to the original yawp, yawp2 is no longer also wrapper to the update cleaning routine scripts, but rather includes them in one unified script, which may be more accessible to the end user for customization purposes.

In addition to the above, there is now a specific routine to handle kernel updates to the ISO.

## Functionality
- Updates the system and upgrades all packages in the chroot environment.
- Checks for newer kernel versions and installs the latest available kernel if not already installed.
- Sets the newly installed kernel as the default boot kernel in the resulting ISO.
- Removes older kernel packages and their related module files.
- Repacks the updated chroot directory into a new ISO file.
- Cleans up temporary directories and files.

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

The script will perform the following steps:

- Extract the ISO to a temporary chroot directory.
- Update the system, install the latest kernel, set it as the default, and remove older kernels in the chroot environment.
- Set the newly installed kernel as the default boot kernel in the resulting ISO.
- Repack the updated chroot directory into a new ISO file.
- Clean up temporary directories and files.
- After the script finishes, you will find the updated ISO file in the specified output path.

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
