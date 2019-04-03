# owserver [![Build Status](https://travis-ci.org/smarthomerocks/owserver.svg?branch=master)](https://travis-ci.org/smarthomerocks/owserver)

Docker image for owserver, an open source service for interconnecting with Dallas Semiconductor/Maxim 1-wire systems.

### Build Details
- [Source Repository](https://github.com/smarthomerocks/owserver)
- [DockerHub](https://cloud.docker.com/u/smarthomerocks/repository/docker/smarthomerocks/owserver)


#### Build the Docker Image
```bash
make build
```

#### Run the Docker Image and get the version of installed Owserver
```bash
make version
```

#### Push the Docker Image to the Docker Hub
* First use a `docker login` with username, password and email address
* Second push the Docker Image to the official Docker Hub

```bash
make push
```

Running your Owserver image
---------------------------

To start your image you need to bind the external port `4304` of your containers and provide owserver with the settings it needs.
Owserver needs to know what kind of physical device that is connected to the host and the path to the device, this is provided by the environment "-e" parameters.
The supported devicetypes are:

* I2C - i2c connected boards, e.g. [AbioWire](http://www.axiris.eu/download/abiowire/AbioWire_um_en_us_2013_07_09.pdf)
* SERIAL - serialport (RS-232) connected adapters, e.g. [Maxim DS9097U](https://www.maximintegrated.com/en/products/ibutton/ibutton/DS9097U-S09.html)
* USB - USB connected adapters, e.g. [DS9490](http://pdfserv.maximintegrated.com/en/ds/DS9490-DS9490R.pdf)
* FAKE - a emulation-mode where owserver emulates the presence of 1-wire devices. Good for mocking and testing softwares when you don't have "the real deal".

Here are some examples on how you could start containers:

    # start owserver using a i2c-adapter, scanning for all available adapters.
    docker run -d -p 4304:4304 --privileged --restart on-failure:5 -e I2C=ALL:ALL smarthomerocks/owserver-armhf

    # start owserver using a serial-adapter on device "/dev/ttyS0"
    docker run -d -p 4304:4304 --privileged --restart on-failure:5 -e SERIAL=/dev/ttyUSB0 smarthomerocks/owserver-armhf

    # start owserver using a USB-adapter on device "/dev/ttyUSB0"
    docker run -d -p 4304:4304 --privileged --restart on-failure:5 -e USB=/dev/ttyUSB0 smarthomerocks/owserver-armhf

    # start owserver using a FAKE-adapter (emulates real devices), in this case we emulates two DS18S20 temperature sensors and one DS2408 8-Channel Addressable Switch
    docker run -d -p 4304:4304 --privileged --restart on-failure:5 -e FAKE=DS18S20,DS18S20,DS2408 smarthomerocks/owserver-armhf


Query 1-wire bus within container
-------------------------

You can use the OWFS commands to query the 1-wire bus within the container in case you need to debug your software or during fault-finding. While the container is running, you enter the container with the following command:

  ```
  docker exec -it <owserver-container-name> bash
  root@53ae0aca3603:/# owdir
  /10.67C6697351FF
  /10.4AEC29CDBAAB
  /29.F2FBE3467CC2
  /bus.0
  /uncached
  /settings
  /system
  /statistics
  /structure
  /simultaneous
  /alarm

  root@53ae0aca3603:/# owget /10.67C6697351FF/temperature
     66.3067root@53ae0aca3603:/#
  ```

## License

The MIT License (MIT)

Copyright (c) 2017 Liquidbytes.se

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
