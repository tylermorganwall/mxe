// src/openimagedenoise-test.cpp

#include <OpenImageDenoise/oidn.h>

#include <cstdlib>
#include <cstdio>

int main()
{
    // Create device and commit
    OIDNDevice device = oidnNewDevice(OIDN_DEVICE_TYPE_DEFAULT);
    if (!device) {
        std::fprintf(stderr, "Failed to create OIDN device\n");
        return 1;
    }
    oidnCommitDevice(device);

    const int width  = 16;
    const int height = 16;
    const size_t numPixels = static_cast<size_t>(width) * height;

    float *color  = static_cast<float*>(std::calloc(numPixels * 3, sizeof(float)));
    float *output = static_cast<float*>(std::calloc(numPixels * 3, sizeof(float)));

    if (!color || !output) {
        std::fprintf(stderr, "Allocation failed\n");
        return 1;
    }

    // Create a basic RT filter
    OIDNFilter filter = oidnNewFilter(device, "RT");
    if (!filter) {
        std::fprintf(stderr, "Failed to create OIDN filter\n");
        return 1;
    }

    oidnSetSharedFilterImage(
        filter, "color",
        color, OIDN_FORMAT_FLOAT3,
        width, height, 0, 0, 0
    );
    oidnSetSharedFilterImage(
        filter, "output",
        output, OIDN_FORMAT_FLOAT3,
        width, height, 0, 0, 0
    );
    oidnSetFilterBool(filter, "hdr", true);
    oidnCommitFilter(filter);

    oidnExecuteFilter(filter);

    const char *message = 0;
    OIDNError error = oidnGetDeviceError(device, &message);
    if (error != OIDN_ERROR_NONE) {
        std::fprintf(stderr, "OIDN error: %s\n", message ? message : "unknown");
        return 1;
    }

    oidnReleaseFilter(filter);
    oidnReleaseDevice(device);

    std::free(color);
    std::free(output);

    return 0;
}
