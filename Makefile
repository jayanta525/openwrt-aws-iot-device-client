#
# This software is licensed under the MIT License.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=aws-iot-device-client
PKG_VERSION:=1.10.1
PKG_RELEASE:=1
PKG_REV:=7f9547bca3e1a199f2824f4376e1782b082b226f

PKG_MAINTAINER:=Jayantajit Gogoi <jayanta.gogoi525@gmail.com>

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/awslabs/aws-iot-device-client.git
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_REV).tar.gz

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/aws-iot-device-client
        SECTION:=utils
        CATEGORY:=Utilities
        TITLE:=AWS IoT Device Client.
        DEPENDS:=+libstdcpp +libopenssl +libcurl +libgcrypt
        URL:=https://github.com/awslabs/aws-iot-device-client
endef

define Package/aws-iot-device-client/description
        AWS IoT Device Client for OpenWrt
endef

CMAKE_OPTIONS +=\
        -DBUILD_TESTING=OFF

define Build/Compile
        $(call Build/Compile/Default, \
          aws-iot-device-client \
        )
endef

define Package/aws-iot-device-client/install
        $(CP) ./files/* $(1)/

        $(INSTALL_DIR) $(1)/usr/bin
        $(INSTALL_BIN) $(PKG_BUILD_DIR)/aws-iot-device-client $(1)/usr/bin/
endef

$(eval $(call BuildPackage,aws-iot-device-client))
