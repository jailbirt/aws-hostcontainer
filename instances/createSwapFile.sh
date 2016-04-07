#!/bin/bash                                                                                                               
 
echo "creating swap file in /var/swap.1 ..."
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1
echo "done!"
