EDK_CODE=/usr/share/edk2/ovmf/OVMF_CODE.fd
EDK_VARS=/usr/share/edk2/ovmf/OVMF_VARS.fd

#!/bin/sh
qemu-kvm        \
 -machine q35   \
 -cpu host      \
 -enable-kvm    \
 -smp 8         \
 -drive file=${EDK_CODE},if=pflash,format=raw,unit=0,readonly=on \
 -drive file=${EDK_VARS},if=pflash,format=raw,unit=1 \
 -m 16G  \
 -qmp tcp:localhost:4444,server,nowait   \
 -boot menu=on -boot splash-time=10 \
 -drive file=./mydisk.qcow2,if=none,id=disk1,format=qcow2 \
 -device virtio-blk-pci,scsi=off,drive=disk1,bootindex=1 \
 -serial mon:telnet:localhost:66665,server,nowait \
 -nographic \
 -net nic,model=virtio \
 -net tap,ifname=tap2,script=no,downscript=no   \
 -netdev user,id=internet,hostfwd=tcp::55555-:22    \
 -device virtio-net-pci,mac=50:54:11:00:00:50,netdev=internet,id=internet-dev    \
 -monitor stdio

 #-drive file=./CentOS-8.5.2111-x86_64-dvd1.iso,if=none,id=cdrom1,format=raw,readonly=on \
 #-device ide-cd,drive=cdrom1,bootindex=1 \
 #-cdrom ./CentOS-8.5.2111-x86_64-dvd1.iso -net none\
