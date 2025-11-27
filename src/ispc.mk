# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ispc
$(PKG)_WEBSITE  := https://ispc.github.io/
$(PKG)_DESCR    := Intel Implicit SPMD Program Compiler
$(PKG)_IGNORE   :=

$(PKG)_VERSION  := 1.28.2

# Use the official Linux binary tarball from GitHub releases
$(PKG)_FILE     := ispc-v$($(PKG)_VERSION)-linux.tar.gz
$(PKG)_URL      := https://github.com/ispc/ispc/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_CHECKSUM := 32e611de1252cf1e09a6a13327f5746b8477f99e15ffa4cbd1b422386776688c
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD_$(BUILD)
    # Unpack the prebuilt Linux binary bundle
    mkdir -p '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && $(call UNPACK_ARCHIVE,'$(PKG_DIR)/$($(PKG)_FILE)')

    # Tarball layout is ispc-v<ver>-linux/bin/ispc
    $(INSTALL) -d '$(PREFIX)/$(BUILD)/bin'
    cp -f '$(BUILD_DIR)/ispc-v$($(PKG)_VERSION)-linux/ispc' \
          '$(PREFIX)/$(BUILD)/bin/ispc'

    '$(PREFIX)/$(BUILD)/bin/ispc' --version > '$(BUILD_DIR)/ispc-version.txt'
endef

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef