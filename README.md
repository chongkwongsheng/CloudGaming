# Cloud Gaming on AWS EC2 (G5 family)

This repository is to provide information relevant to my AWS Cloud Gaming setup.

These have been tested with an G5 EC2 instance set up with a Microsoft Windows Server 2022 Base (ami-06c2ec1ceac22e8d6 64-bit x86).

These were also installed in the following order after the instance was set up:
1. Wireguard for VPN to a private network (https://www.wireguard.com)
1. Nvidia gaming drivers using Option 4 in AWS documentation (https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/install-nvidia-driver.html)
1. Ran and installed steam with g5-cloudrig script (https://github.com/tomgrice/g5-cloudrig) - I removed the graphics installation step as well since I ran installed with the steps with AWS documentation
1. Sunshine for connecting to the instance with Moonlight (https://github.com/LizardByte/Sunshine)

I was also inspired by https://github.com/keithvassallomt/parsec-aws-automation#creating-the-automation-script to create Lambda functions to launch my Cloud Gaming instance on iOS.

The only original code is the Powershell Scripts at startup and shutdown that copies games from my Steam Library to and from the ephemeral storage on the instance. This improves the game performance due to the faster speeds on the NVMe SSD storage that comes with the G5. The first script initialises and mounts the ephemeral storage as D:\ and copies the game files to it on startup (before login) and the second script copies the game files back to a backup folder on C:\ in case of updates/changes to the game files.

## How to set up the ephemeral startup/shutdown scripts

To be added
