#!/bin/bash

sudo killall -9 pause
cat /proc/self/mountinfo | grep crio-lxc | grep overlay | cut -d" " -f 5 | sudo xargs umount
cat /proc/self/mountinfo | grep crio-lxc | grep shm | cut -d" " -f 5 | sudo xargs umount
cat /proc/self/mountinfo | grep crio-lxc | grep squashfs | cut -d" " -f 5 | sudo xargs umount
sudo rm -rf crio-lxc-test*
