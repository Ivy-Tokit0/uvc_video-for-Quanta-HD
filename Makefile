# SPDX-License-Identifier: GPL-2.0
MODULE_NAME=quanta_uvc_video
MODULE_VERSION=1.0

uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o \
	uvc_ctrl.o uvc_status.o uvc_isight.o uvc_debugfs.o uvc_metadata.o

ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
uvcvideo-objs  += uvc_entity.o
endif

obj-$(CONFIG_USB_VIDEO_CLASS) += uvcvideo.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
install:
	@echo "Installing Module: $(MODULE_NAME)"
	cp -R . /usr/src/quanta_uvc_video-1.0
	dkms add -m $(MODULE_NAME) -v $(MODULE_VERSION)
	dkms build -m $(MODULE_NAME) -v $(MODULE_VERSION)
	dkms install -m $(MODULE_NAME) -v $(MODULE_VERSION)
	echo "$(MODULE_NAME)" | tee /etc/modules-load.d/$(MODULE_NAME).conf
uninstall:
	@echo "Uninstalling M<odule: $(MODULE_NAME)"
	dkms remove -m $(MODULE_NAME) -v $(MODULE_VERSION) --all
	rm -rf /usr/src/$(MODULE_NAME)-$(MODULE_VERSION)
	rm -vf /etc/modules-load.d/$(MODULE_NAME).conf
