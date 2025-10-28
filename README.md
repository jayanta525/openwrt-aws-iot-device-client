# AWS IoT Device Client for OpenWrt

This repository packages the AWS IoT Device Client as an OpenWrt package, providing an init script, UCI configuration support, and a JSON template for easy integration with AWS IoT Core services.

## Features

- OpenWrt UCI configuration support
- Init script for managing multiple client instances
- Templated configuration with MQTT topic customization
- Support for AWS IoT features:
  - Jobs execution
  - Secure Tunneling
  - Device Defender (optional)
  - Fleet Provisioning (optional)
  - Pub/Sub messaging
  - Device Shadow (optional)

## Build

To build this package inside an OpenWrt build tree:

1. Clone this repository into your OpenWrt build tree:
```sh
cd package
git clone https://github.com/jayanta525/openwrt-aws-iot-device-client
cd ..
```

2. Configure and build:
```sh
make menuconfig   # select Network -> AWS IoT Device Client
make package/openwrt-aws-iot-device-client/compile
```

The produced `.ipk` will include:
- Init script (`/etc/init.d/aws-iot-device-client`)
- Default JSON template (`/etc/aws-iot-device-client.json`)
- Example job scripts (`/etc/jobs/`)
- UCI configuration template (`/etc/config/aws-iot-device-client`)

## Installation & Setup

1. Install the package on your OpenWrt device:
```sh
opkg install aws-iot-device-client_*.ipk
```

2. Copy your AWS IoT certificates to `/tmp/config/`:
```sh
mkdir -p /tmp/config
scp certificate.pem.crt root@<device-ip>:/tmp/config/
scp private.pem.key root@<device-ip>:/tmp/config/
scp AmazonRootCA1.pem root@<device-ip>:/tmp/config/
```

3. Configure the client in `/etc/config/aws-iot-device-client`

4. Enable and start the service:
```sh
/etc/init.d/aws-iot-device-client enable  # Start on boot
/etc/init.d/aws-iot-device-client start   # Start now
```

5. Check the status:
```sh
/etc/init.d/aws-iot-device-client status
logread -f  # Monitor logs
```

## Configuration (UCI)

The package uses OpenWrt's UCI system for configuration. Each AWS IoT Device Client instance is represented by a section in `/etc/config/aws-iot-device-client`:

```
config aws-iot-device-client 'instance1'
        option enabled '1'                                         # Enable this instance
        option config_file '/etc/aws-iot-device-client.json'      # JSON template path
        option thing_name 'my-device'                             # AWS IoT Thing name
        option endpoint 'abcdefgh-ats.iot.region.amazonaws.com'   # AWS IoT endpoint

```

Configuration options:
- `enabled` (required): Set to '1' to enable this instance
- `config_file` (optional): Path to JSON template (defaults to `/etc/aws-iot-device-client.json`)
- `thing_name` (required): AWS IoT Thing name for this instance
- `endpoint` (required): Your AWS IoT Core endpoint


## Prerequisites

Before using this package, you need:

1. An AWS account with IoT Core service enabled
2. A registered IoT Thing with:
   - Thing name
   - Device certificate (`.pem.crt`)
   - Private key (`.pem.key`)
   - Root CA certificate (`AmazonRootCA1.pem`)
3. AWS IoT Core endpoint URL

## JSON Configuration

The package provides a default JSON template at `/etc/aws-iot-device-client.json` with the following key features:

- Device certificates configuration
- Logging settings (supports both file and stdout)
- Jobs execution (enabled by default)
- Secure Tunneling support (enabled by default)
- Device Defender configuration (disabled by default)
- Fleet Provisioning settings (disabled by default)
- Pub/Sub messaging configuration
- Shadow state management (disabled by default)

The template supports placeholders for MQTT topics:

```json
{
    "samples": {
        "pub-sub": {
            "enabled": true,
            "publish-topic": "{{PUBLISH_TOPIC}}",
            "subscribe-topic": "{{SUBSCRIBE_TOPIC}}",
            "publish-file": "/tmp/pubsub/publish-file.txt",
            "subscribe-file": "/tmp/pubsub/subscribe-file.txt"
        }
    }
}
```

Replace placeholders (`{{PUBLISH_TOPIC}}` and `{{SUBSCRIBE_TOPIC}}`) with valid topic names.

## Jobs Support

The package includes support for AWS IoT Jobs with example job handlers in `/etc/jobs/`:

- `rebootOS.sh`: Example job handler for system reboot

To add custom job handlers:
1. Place your script in `/etc/jobs/`
2. Make it executable: `chmod +x /etc/jobs/your-handler.sh`
3. Create a job in AWS IoT Core referencing your handler

## Troubleshooting

1. **Connection Issues**
   - Verify certificates in `/tmp/config/`
   - Check AWS IoT endpoint URL
   - Ensure network connectivity
   - Review logs: `logread | grep aws-iot`

2. **Configuration Problems**
   - Validate JSON syntax
   - Check UCI configuration
   - Verify file permissions
   - Monitor syslog for errors

3. **Job Execution Failures**
   - Check job handler permissions
   - Review job handler logs
   - Verify handler path in configuration

## Security Considerations

1. Store certificates securely
2. Use unique certificates per device
3. Implement proper file permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Testing & debugging

1. Create or edit `/etc/config/aws-iot-device-client` with the sample section above.
2. Start the service and validate the temp config file was created:

```sh
/etc/init.d/aws-iot-device-client start
cat /tmp/aws-iot-device-client-instance1.json
ps aux | grep aws-iot-device-client
```

3. Check logs (the template has logging configured to `/var/log/aws-iot-device-client/` by default). If your device doesn't have persistent logging enabled, change the template to log to STDOUT or another path.

## Packaging notes

- Ensure the init script file mode is executable in the package repository: `git update-index --chmod=+x files/etc/init.d/aws-iot-device-client` so the file keeps its exec bit when packaged.
- The `Makefile` license metadata should match the repository `LICENSE` file (this repository uses MIT); the `Makefile` has been updated to `PKG_LICENSE:=MIT`.


## License

This repository is licensed under the MIT License — see `LICENSE`.
