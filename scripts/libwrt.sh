#添加机型&修复雅典娜LED控制
rm -rf package/emortal/luci-app-athena-led
git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led package/luci-app-athena-led
chmod +x package/luci-app-athena-led/root/etc/init.d/athena_led package/luci-app-athena-led/root/usr/sbin/athena-led
#修改基础信息
sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate
sed -i -e "s/set system\.@system\[-1\]\.hostname='LibWrt'/set system.@system[-1].hostname='Oyyl_Router'/" package/base-files/files/bin/config_generate
sed -i -e "/add_list system.ntp.server='ntp.ntsc.ac.cn'/d" package/base-files/files/bin/config_generate
sed -i -e "/add_list system.ntp.server='cn.ntp.org.cn'/d" package/base-files/files/bin/config_generate
sed -i 's/^root:::0:99999:7:::/#&/' package/base-files/files/etc/shadow
sed -i '/^#root:::0:99999:7:::/a\root:$5$xmxpvLvUA0puov/Q$8VyXs7lx90md2yVksUedqKP5JyCQzpU7wY8JyqQv9e/:20389:0:99999:7:::' package/base-files/files/etc/shadow
# 移除 openwrt feeds 自带的核心库
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall/passwall-packages
# 移除 openwrt feeds 过时的luci版本
rm -rf feeds/luci/applications/luci-app-passwall
git clone https://github.com/Openwrt-Passwall/openwrt-passwall2 package/passwall/passwall-luci
git clone --depth=1 https://github.com/laipeng668/luci-app-gecoosac package/openwrt-gecoosac
git clone --depth 1 --branch master --single-branch --no-checkout https://github.com/muink/openwrt-stuntman.git package/stuntman
pushd package/stuntman
umask 022
git checkout
popd
git clone --depth 1 --branch master --single-branch --no-checkout https://github.com/muink/openwrt-natmapt.git package/natmapt
pushd package/natmapt
umask 022
git checkout
popd
git clone --depth 1 --branch master --single-branch --no-checkout https://github.com/muink/luci-app-natmapt.git package/luci-app-natmapt
pushd package/luci-app-natmapt
umask 022
git checkout
popd
# ===================== DIY自定义部分 开始 =====================
# 修改OpenWrt默认LAN IP
sed -i 's/192.168.88.1/192.168.1.13/g' package/base-files/files/bin/config_generate

# 替换opkg源为科大镜像源
sed -i 's#https://downloads.openwrt.org#https://mirrors.ustc.edu.cn/openwrt#g' package/base-files/files/etc/opkg/distfeeds.conf

# 注释掉源码自带的官方源（备用）
# sed -i 's#http://downloads.openwrt.org#https://mirrors.ustc.edu.cn/openwrt#g' feeds.conf.default

# 开启中文支持
sed -i 's/option lang en/option lang zh_cn/g' feeds/luci/modules/luci-base/root/etc/uci-defaults/99-luci

# 设置时区上海
sed -i 's#UTC#CST-8#g' package/base-files/files/bin/config_generate

# ===================== DIY自定义部分 结束 =====================
