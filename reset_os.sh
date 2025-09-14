#!/bin/bash

cp /etc/skel/.bashrc ~/
source ~/.bashrc
sudo timeshift --restore
