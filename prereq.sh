#!/bin/bash

yum install -y "kernel-devel-$(uname -r)" gcc perl kernel-headers kernel-devel libX11 libXt libXext libXmu elfutils-libelf-devel wget tree

reboot
