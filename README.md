# Docker files for the UniFi controller

This was built and tested with the "Unifi Network Server" version 8.1.127 and Debian Bookworm.
It was tested with podman but should work with docker.

### Network Mode
Given that the software needs access to a mix of UDP and TCP ports ([UniFi Required Ports Reference](https://help.ui.com/hc/en-us/articles/218506997-UniFi-Network-Required-Ports-Reference)), and that the idea here is emulating running it locally but easily portable from one laptop to another, it was easier to set it up with `network_mode: "host"`


### Usage
- download the dot deb file from https://ui.com/download
- move it to this current directory
- adjust the name of the package in the Dockerfile (currently "unifi_sysvinit_all.deb")
- Create an empty "data"directory: `mkdir data` (or copy an existing one from the same version)
- to keep track of the software version in the same directory as the data you can run: `dpkg-deb -I unifi_sysvinit_all.deb  |grep Version > data/VERSION`
- podman-compose build
- podman-compose up -d
- point your browser to `https://localhost:8443`
- you can do local admin only (no "UI Account") by choosing "Advanced Setup" and "skip"

### Backups
Restoring from backup is easier than from old data from an unknown software version.

Clicking on "Download" in Settings > Backups, will create/update the backup file in data/backup, which will be named after the software version with the ".unf" extension. The file is overridden every time you click on the Download button.

The auto backup will only be triggered if the software is running at the scheduled time, which is unlikely if you bring it up only when you need it. Since the downloaded backup is time stamped, moving it to the `data/backup` directory makes it easy to keep everything in one place and have multiple version of the backup.
