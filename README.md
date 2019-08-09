# File Injection for Virtual Machine Boot Mechanisms
This git repo is an addition to ```network-boot```. The initrd created with the patch there will try to load a ```config.sh``` script. Here you can find examples for the ```config.sh``` file as well as a few additional ones that enable basic functionality with minimal configuration.
### ```config.sh```
```config.sh``` contains almost all parameters used during the boot process, including which kernel to boot, where to get it from, which server to load subsequent files from (can be different from the server serving ```config.sh``` itself) and the parameters to be passed to the final kernel. 
The parameters are (including default values):
* ```BOOT_MODE="NETWORK"``` - whether to use the ```network_kernel.sh``` or ```hdd_kernel.sh``` script. For the latter use ```BOOT_MODE="HDD"```
* ```KERNEL="vmlinuz-4.19.0-5-amd64"``` - the name of the kernel file.
	* If using the ```NETWORK``` boot mode, this file has to be placed on the server set by ```SERVER``` in a subfolder called ```kernels```, so that ```http://{$SERVER}/kernels/$KERNEL``` points to it.
	* If using the ```HDD``` boot mode, ```KERNEL``` has to be set to the full path of the kernel file within the filesystem given in ```HDD```, e.g. ```KERNEL="/boot/vmlinuz-4.9.0-9-amd64"```
* ```INITRD="initrd.img-4.19.0-5-amd64"``` - Name of the initrd file.
	* Similar to the ```KERNEL``` paramter, this file can be in a network location (in the ```kernels``` folder) or in the mounted filesystem, e.g. ```INITRD="/boot/initrd.img-4.9.0-9-amd64"```
* ```SERVER="192.168.123.216"``` - Which server to load all subsequent files from. This value may not contain spaces.
* ```HDD="/dev/vda1"``` - Which device contains the filesystem that files should be added to using ```add_files.sh``` and, if ```BOOT_MODE="HDD"``` is set, which device contains the kernel and initrd to load later on.
* ```FILESYSTEM="ext4"``` - What filesystem the device set with ```HDD``` contains. This is directly passed to ```mount```.
* ```CMDLINE="root=$HDD ro quiet panic=1"``` - What arguments to pass to the final kernel when booting it. ```panic=1``` is advised here as otherwise a failure will probably cause the new kernel to switch to it's own initramfs console which will be unavailable via SSH. ```panic=1``` causes most Linux kernels to reboot if a boot failure occurs, making it possible to connect to this system via SSH after it rebooted.

### ```add_files.sh```
* Automatically mounts the filesystem given by ```HDD``` and ```FILESYSTEM``` to ```/network-boot/mnt``` and unmounts it afterwards
* You can then add / remove / change any files. You can use ```SERVER``` to know where to download files from

### ```hdd_kernel.sh```
* Automatically mounts the filesystem similar to ```add_files.sh```, but read-only. Then loads the given kernel and initrd via ```kexec -l``` with ```$CMDLINE``` as the parameters.
* Afterwards, it unmounts the filesystem and boots the kernel.

### ```network_kernel.sh```
* Gets the kernel and initrd from ```http://$SERVER/kernels/{$KERNEL,$INITRD}``` and boots them with ```$CMDLINE``` as the parameters using ```kexec```
