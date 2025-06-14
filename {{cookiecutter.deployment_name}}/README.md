# {{cookiecutter.deployment_name}} Application

This deployment was auto-generated by the F' utility tool.

## Building and Running the {{cookiecutter.deployment_name}} Application

In order to build the {{cookiecutter.deployment_name}} application, or any other F´ application, we first need to generate a build directory. This can be done with the following commands:

```sh
fprime-util generate
```

The next step is to build the {{cookiecutter.deployment_name}} application's code.
```sh
fprime-util build
```

## Running the application and F' GDS

The following command will spin up the F' GDS. Examples are avilable for UART, TcpServer, and TcpClient:

### UART

```sh
fprime-gds -n --dictionary ./build-artifacts/<build name>/{{cookiecutter.deployment_name}}/dict/{{cookiecutter.deployment_name}}TopologyDictionary.json --communication-selection uart --uart-device /dev/ttyACM0 --uart-baud 115200
```

> [!NOTE]
> Change `<build name>` to the build of your deployment (i.e. `teensy41`, `featherM0`, etc.).
>
> `/dev/ttyACM0` may vary for your system/device. It may also be `/dev/ttyUSB0`. For MacOS, it will be along the lines of `/dev/tty.usbmodem12345`. Change accordingly.
>
> To view the list of your connected devices, run: `ls /dev/tty*`.

### TcpServer

```sh
fprime-gds -n --dictionary ./build-artifacts/<build name>/{{cookiecutter.deployment_name}}/dict/{{cookiecutter.deployment_name}}TopologyDictionary.json --ip-client --ip-address <device-ip-address>
```

> [!NOTE]
> Change `<build name>` to the build of your deployment (i.e. `teensy41`, `featherM0`, etc.).
>
> Change `<device-ip-address>` to the IP address of your board. Your machine must be in the same network as the board.

### TcpClient

```sh
fprime-gds -n --dictionary ./build-artifacts/<build name>/{{cookiecutter.deployment_name}}/dict/{{cookiecutter.deployment_name}}TopologyDictionary.json
```

> [!NOTE]
> Change `<build name>` to the build of your deployment (i.e. `teensy41`, `featherM0`, etc.).
