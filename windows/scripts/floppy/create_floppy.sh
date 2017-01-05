#!/bin/bash
set -e
VAGRANT_BOX_USER=ubuntu

if [ -f floppy01.img ]; then
  rm -f floppy01.img
fi

#Rebuild the VM in order to make sure that the files are up-to-date
vagrant destroy -f && vagrant up

#Build the floppy image
vagrant ssh -c "sudo dd bs=512 count=2880 if=/dev/zero of=floppy01.img"
vagrant ssh -c "sudo mkfs.msdos floppy01.img"
vagrant ssh -c "sudo mount -o loop floppy01.img /mnt"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/winnt.sif /mnt/winnt.sif"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/regedit.bat /mnt/regedit.bat"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/runonce.bat /mnt/runonce.bat"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/install-cygwin-sshd.bat /mnt/install-cygwin-sshd.bat"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/vagrant-ssh.bat /mnt/vagrant-ssh.bat"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/ps.bat /mnt/ps.bat"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/downloadFile.vbs /mnt/downloadFile.vbs"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/oracle-cert.cer /mnt/oracle-cert.cer"
vagrant ssh -c "sudo cp /home/$VAGRANT_BOX_USER/winrm.bat /mnt/winrm.bat"
vagrant ssh -c "sudo chown root:root /mnt/*.*"
vagrant ssh -c "sudo umount /mnt"

#Copy the image back to the host
#TODO: Do this without using the vagrant-scp plugin
vagrant scp :/home/$VAGRANT_BOX_USER/floppy01.img floppy01.img 

vagrant destroy -f
