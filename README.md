# tiramisu-image-builder

This is a Docker container that will create a flashable image for use with
installing Tiramisu on a Nintendo Wii U.

The scripts in this repository automate most of the process documented here:

[https://wiiu.hacks.guide/#/tiramisu/sd-preparation](https://wiiu.hacks.guide/#/tiramisu/sd-preparation)

## Using this script

This script is written in Bash, and expects docker to be available on the CLI.
On MacOS and Windows, the easiest way to get the docker CLI is by installing
Docker Desktop.

This script should work as-is on Linux and MacOS. Windows users, you're on your
own. I'm happy to accept a pull request, though! I just don't have the resources
to develop and test it.

1. Clone this repository
2. Run the `tiramisu-image-builder.sh` script, passing in the size of your SD
   card in gigabytes
3. Use Balena Etcher (or equivalent tool) to write `disk.img` to your SD card.

The `disk.img` generated by this container is a FAT32 image with 32kb cluster
size with Tiramisu and sigpatches preinstalled.

**WARNING** Writing the disk image will completely destroy any existing data
on the SD card. Using this tool means that you assume all risk of data loss.