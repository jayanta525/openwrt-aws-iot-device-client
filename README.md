# Introduction

AWS IoT Device Client for OpenWrt

## Build

To build as an OpenWrt package, run the normal OpenWrt build system steps. From the top of your OpenWrt build tree:

```sh
# place this package under package/yourpath and then
make menuconfig   # select aws-iot-device-client
make
```

## Installation & Usage

After installation, the init script is at `/etc/init.d/aws-iot-device-client` and the default config is at `/etc/config/aws-iot-device-client`.

Example config (already included in files/):

```
config aws-iot-device-client config
    option thing_name myawsthing
    option certs_path /tmp/certs
```

Enable and start the service:

```sh
/etc/init.d/aws-iot-device-client enable
/etc/init.d/aws-iot-device-client start
```

To run multiple instances, add additional `config aws-iot-device-client <name>` sections and set `option enabled 1` and `option duration <seconds>` as needed.

## Notes

- The init script currently uses the classic OpenWrt start/stop helpers. If you need process supervision/restart, consider converting to a `procd`-based init script.
- Ensure license metadata in the Makefile matches `LICENSE`.