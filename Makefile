# SPDX-License-Identifier: GPL-2.0
MODULE_NAME=quanta_uvc_video
MODULE_VERSION=1.0
KERNELS ?= $(shell ls /lib/modules | sed "s/\([^ ]*\)/'\1'/g") # Get all Avilable Kernel and enclose them in ''

uvcvideo-objs := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o \
	uvc_ctrl.o uvc_status.o uvc_isight.o uvc_debugfs.o uvc_metadata.o

ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
uvcvideo-objs += uvc_entity.o
endif

obj-$(CONFIG_USB_VIDEO_CLASS) += uvcvideo.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
install:
	@echo "Installing Module: $(MODULE_NAME)"
	rm -rf /usr/src/quanta_uvc_video-1.0
	mkdir -p /usr/src/quanta_uvc_video-1.0
	cp -R *.c *.h dkms.conf Makefile /usr/src/quanta_uvc_video-1.0
	@for KERNEL in $(KERNELS); do \
		echo -e "\n\nInstalling for linux-$$KERNEL"; \
		dkms add -m $(MODULE_NAME) -v $(MODULE_VERSION) -k $$KERNEL; \
		dkms build -m $(MODULE_NAME) -v $(MODULE_VERSION) -k $$KERNEL; \
		dkms install -m $(MODULE_NAME) -v $(MODULE_VERSION) -k $$KERNEL; \
	done
	echo "$(MODULE_NAME)" | tee /etc/modules-load.d/$(MODULE_NAME).conf
uninstall:
	@echo "Uninstalling Module: $(MODULE_NAME)"
	dkms remove --all -m $(MODULE_NAME) -v $(MODULE_VERSION)
	rm -rf /usr/src/$(MODULE_NAME)-$(MODULE_VERSION)
	rm -vf /etc/modules-load.d/$(MODULE_NAME).conf
