#!/bin/bash

shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

rm -rf package/boot package/firmware/ipq-wifi target/linux/generic target/linux/qualcommax package/firmware/ath11k-firmware package/kernel/mac80211 package/kernel/nat46

git_clone_path 25.12-nss https://github.com/LiBwrt/openwrt-6.x target/linux/generic target/linux/qualcommax package/boot package/firmware/ipq-wifi package/firmware/ath11k-firmware package/kernel/mac80211 package/kernel/nat46

wget -N https://github.com/LiBwrt/openwrt-6.x/raw/refs/heads/25.12-nss/include/image-commands.mk -P include/
wget -N https://github.com/LiBwrt/openwrt-6.x/raw/refs/heads/25.12-nss/config/Config-ipq.in -P config/
wget -N https://github.com/LiBwrt/openwrt-6.x/raw/refs/heads/25.12-nss/Config.in -P ./


rm -rf feeds/kiddin9/shortcut-fe

# Remove incompatible modem packages (kernel 6.12)
rm -rf feeds/kiddin9/quectel-gobinet feeds/kiddin9/quectel-mhi-pcie feeds/kiddin9/quectel-gobipcie feeds/kiddin9/fibocom-dial feeds/kiddin9/fibocom_QMI_WWAN feeds/kiddin9/quectel-cm feeds/kiddin9/quectel_Gobinet feeds/kiddin9/quectel_MHI feeds/kiddin9/quectel_QMI_WWAN feeds/kiddin9/quectel_SRPD_PCIE feeds/kiddin9/quectel_cm_5G feeds/kiddin9/simcom_QMI_WWAN feeds/kiddin9/xmm-modem

# Remove incompatible firewall fullconenat patch
find package/network/config/firewall/patches/ -name "*.patch" -exec rm -f {} \; 2>/dev/null || true
sed -i "s/+iptables-mod-fullconenat//g" package/network/config/firewall/Makefile 2>/dev/null || true

sed -i "s/# CONFIG_DEBUG_INFO_BTF is not set/CONFIG_DEBUG_INFO_BTF=y/" target/linux/generic/config-*

git clone https://github.com/qosmio/nss-packages.git package/nss-packages
git clone https://github.com/qosmio/sqm-scripts-nss.git package/sqm-scripts-nss

sed -i "/ECM_INTERFACE_RAWIP_ENABLE/d"  package/nss-packages/qca-nss-ecm/Makefile
rm -rf package/nss-packages/nss-userspace-oss

sed -i "s/luci uboot-envtools wpad-openssl/luci uboot-envtools wpad-mbedtls/" target/linux/qualcommax/Makefile
