#!/bin/bash

sudo apt-get install -y qemu cloud-image-utils
wget https://cloud-images.ubuntu.com/minimal/daily/focal/current/focal-minimal-cloudimg-amd64.img
qemu-img create -b focal-minimal-cloudimg-amd64.img -f qcow2 larger.img 10G

echo 'cloud-config' > cloudconfig.txt 
echo 'password: password123' >> cloudconfig.txt
echo 'chpasswd: { expire: False }' >> cloudconfig.txt
echo 'ssh_pwauth: True' >> cloudconfig.txt
echo 'hostname: nestedVM' >> cloudconfig.txt
cat cloudconfig.txt

cloud-localds cloudconfig.iso cloudconfig.txt
qemu-system-x86_64 -accel tcg,thread=multi -smp 6 -hda larger.img -cdrom cloudconfig.iso -m 4096 -net nic -net user,hostfwd=tcp::22222-:22 -nographic
