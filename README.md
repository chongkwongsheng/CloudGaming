# Using Ephemeral Storage for Cloud Gaming on AWS EC2 (G5 family)

This repository is to provide Powershell scripts I use to automate backup/restoration of data on ephemeral NVMe SSD storage of AWS G5 EC2 Windows instances.

These have been tested with an G5 EC2 instance set up with a Microsoft Windows Server 2022 Base (ami-06c2ec1ceac22e8d6 64-bit x86).

### Easy way: 
Use a service like [AirGPU](https://airgpu.com)

### DIY:
1. Create Lambda functions to snapshot and create AMI of your instance from [Keith Vassallo's guide](https://github.com/keithvassallomt/parsec-aws-automation)
1. Script to quickly [install useful programs and drivers](https://github.com/chongkwongsheng/g5-cloudrig-lite)

After setting up the instance, the Powershell scripts at startup and shutdown that copies games from my Steam Library to and from the ephemeral storage on the instance. This improves the game performance due to the faster speeds on the NVMe SSD storage that comes with the G5. The first script initialises and mounts the ephemeral storage as D:\ and copies the game files to it on startup (before login) and the second script copies the game files back to a backup folder on C:\ in case of updates/changes to the game files.

## Good to know

* If using Xbox controllers to connect, ViGEm requires [manual installation for cloud setups](https://github.com/ViGEm/ViGEmBus/issues/153).

## WARNING

The startup and shutdown scripts can transfer the Hogwarts Legacy game files (~70GB) to and from ephemeral storage in under 90 seconds when the instance is fully initialised. 

However, when running the startup script to initialise an instance from a snapshot with gp3 storage with 16,000 IOPS and 1,000 MB/s, the penalty from loading snapshot intialisation can result in ***increasing startup by about 10 minutes just for Hogwarts Legacy***.

Please remember that I created these scripts with the purpose of moving Steam game files to and from 'D:\' at startup and shut down respectively.

These scripts also only make sense if you had set up your cloud gaming instance to create from a custom AMI (e.g. Keith Vassallo's guide) and are snapshotting the volumes upon termination.

## How to set up the ephemeral startup/shutdown scripts to speed up gameplay.

1. Run the `StartEphemeral.ps1` script in Powershell. It will intilise and load the ephemeral storage as `D:\`.
1. Add `D:\` to the Steam Library folders.
1. Now you will have a folder `D:\SteamLibrary\`.
1. Do not move any games to the `D:\` yet.
1. Open `Local Group Policy Editor`.
1. Navigate to Local Computer Policy > Computer Configuration > Windows Settings > Scripts (Startup/Shutdown) > Startup.
1. Add the `StartEphemeral.ps1` script for the Startup script under the Powershell tab. The script parameters should contain `-ExecutionPolicy Bypass`.
1. Do the same for `BackupEphemeral.ps1` under Shutdown.
1. Navigate to Local Computer Policy > Administrative Templates > System > Scripts > Specify maximum wait time for Group Policy scripts.
1. Enable and set this to 1800 seconds (30 min) to prevent time out. Adjust accordingly depending on how much data you will need to backup. As reference, it takes 10-12 minutes for restoring ~70GB on startup.
1. Shut down the instance and launch a new one from its snapshot.
1. When logging in, you will now see `D:\` with the Steam folder intact.
