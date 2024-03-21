# Quanta HD Kernel Module for Acer Laptops

linux 6.8 mainline kernel

## Drivers Only For
- Quanta HD User Facing
	- ID 0408:4033
	- ID 0408:4035

**check with `lsusb` utility if you are in need of this driver**

## Usage
```
make -j$(nproc --all)
sudo rmmod uvcvideo
sudo insmod ./uvcvideo.ko
```

**Install DKMS-Module**
```
sudo make install
```
## Sources Used
- [Kvalme](https://github.com/Kvalme/uvc.git)
- [Giuliano69](https://github.com/Giuliano69/uvc_driver-for-Quanta-HD-User-Facing-0x0408-0x4035-.git)
- [Diman119](https://github.com/Diman119/acer-wmi-battery.git)
