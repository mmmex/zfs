#!/bin/bash

yum install "kernel-devel-$(uname -r)" -y

yum install -y gcc perl kernel-headers kernel-devel libX11 libXt libXext libXmu elfutils-libelf-devel wget tree

reboot
