# Cloud Gaming on AWS EC2 (G5 family)

This repository is to provide information relevant to my AWS Cloud Gaming setup.

These have been tested with an G5 EC2 instance set up with a Microsoft Windows Server 2022 Base (ami-06c2ec1ceac22e8d6 64-bit x86).

1. Script to set up a fresh instance: https://github.com/chongkwongsheng/g5-cloudrig-lite
1. Create Lambda functions to snapshot and create AMI of your instance: https://github.com/keithvassallomt/parsec-aws-automation#creating-the-automation-script
1. Set up Powershell scripts to automate backup/restoration of data on ephemeral NVMe SSD storage

After setting up the instance, the Powershell scripts at startup and shutdown that copies games from my Steam Library to and from the ephemeral storage on the instance. This improves the game performance due to the faster speeds on the NVMe SSD storage that comes with the G5. The first script initialises and mounts the ephemeral storage as D:\ and copies the game files to it on startup (before login) and the second script copies the game files back to a backup folder on C:\ in case of updates/changes to the game files.

## Things to note

* ViGEm requires manual installation for cloud setups. See more here: https://github.com/ViGEm/ViGEmBus/issues/153

## How to set up the ephemeral startup/shutdown scripts

To be added
