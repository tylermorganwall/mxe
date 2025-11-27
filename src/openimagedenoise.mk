
PKG             := openimagedenoise
$(PKG)_WEBSITE  := https://www.openimagedenoise.org/
$(PKG)_DESCR    := Intel Open Image Denoise library of high-performance denoising filters for ray-traced images
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.3
$(PKG)_GH_CONF  := OpenImageDenoise/oidn/releases, v
$(PKG)_FILE     := oidn-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://www.openimagedenoise.org/downloads/$($(PKG)_FILE)
$(PKG)_CHECKSUM := 2b32bd506b819ec0bd0137858af15186d83b760d457b0ac12bd02e0a8544381a
$(PKG)_DEPS     := cc ispc tbb

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_BUILD_TYPE=Release \
        -DOIDN_DEVICE_CPU=ON \
        -DOIDN_DEVICE_SYCL=OFF \
        -DOIDN_DEVICE_CUDA=OFF \
        -DOIDN_DEVICE_HIP=OFF \
        -DOIDN_DEVICE_METAL=OFF \
        -DOIDN_APPS=OFF \
        -DOIDN_APPS_OPENIMAGEIO=OFF \
        -DOIDN_INSTALL_DEPENDENCIES=OFF \
        -DTBB_ROOT='$(PREFIX)/$(TARGET)' \
        -DOIDN_STATIC_LIB=$(if $(BUILD_STATIC),ON,OFF)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-g++' \
        -std=c++11 -Wall -Wextra -Werror -pedantic \
        '$(TOP_DIR)/src/$(PKG)-test.cpp' \
        -I'$(PREFIX)/$(TARGET)/include' \
        -L'$(PREFIX)/$(TARGET)/lib' \
        -lOpenImageDenoise -ltbb \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe'
endef

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef