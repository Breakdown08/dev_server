#!/bin/bash

cp /etc/skel/.bashrc ~/
cp /etc/skel/.profile ~/
source ~/.bashrc
source ~/.profile
sudo timeshift --restore
