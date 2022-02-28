#!/bin/sh

set -e
MMCDEV_P1=/dev/mmcblk0p1
MMCDEV_P2=/dev/mmcblk0p2
mkfs.ext4 $MMCDEV_P2
if [ -z $BUILDROOT ]; then
 echo "please define BUILDROOT" >&2
 exit 1
fi
if [ -z $BOARD2BIN ]; then
 echo "please define BOARD2BIN" >&2
 exit 1
fi
BASE=$BUILDROOT/bin
#ATH11KFW_SRC=$BUILDROOT/../ath11k-firmware/QCN9074
IMG=$BASE/targets/imx/cortexa9
PKG=$BASE/packages
mount $MMCDEV_P2 /mnt
cd /mnt
tar xzvf $IMG/openwrt-imx-cortexa9-phytec_mira-rootfs.tar.gz
cp -r $PKG .
cp -r $IMG/packages kernel-packages
ATH11KFW=lib/firmware/ath11k/QCN9074
mkdir -p $ATH11KFW/hw1.0
cp $BOARD2BIN $ATH11KFW/hw1.0/board-2.bin
#cp $ATH11KFW_SRC/hw1.0/2.5.0.1/WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1/*.bin $ATH11KFW/hw1.0
echo 'src/gz openwrt_core file:///kernel-packages' > etc/opkg/distfeeds.conf
echo 'src/gz openwrt_base file:///packages/arm_cortex-a9_neon/base' >> etc/opkg/distfeeds.conf
echo 'src/gz openwrt_packages file:///packages/arm_cortex-a9_neon/packages' >> etc/opkg/distfeeds.conf
echo 'src/gz openwrt_luci file:///packages/arm_cortex-a9_neon/luci' >> etc/opkg/distfeeds.conf
cd /

umount /mnt
mount $MMCDEV_P1 /mnt
cp $IMG/openwrt-imx-cortexa9-phytec_mira-zImage /mnt/openwrt-zImage
umount /mnt
