#!/bin/bash

CONFIG_TEMPLATE="/owfs.templ"
CONFIG_FILE="/etc/owfs.conf"
OWSERVER_HOST="localhost"
OWSERVER_PORT="4303"

echo "=> Setting up config ..."
if [[ -z $FAKE && -z $USB && -z $SERIAL && -z $I2C ]]; then
 echo "Missing parameters! You must set either of FAKE, USB, SERIAL, or USB as environment variables." 1>&2
 exit 1
fi

cp -f $CONFIG_TEMPLATE $CONFIG_FILE

# use FAKE devices
if [ -n "$FAKE" ]; then
    echo "Using FAKE devices: $FAKE"
    sed -i -r -e "s/#\[\[FAKE\]\]/server: FAKE = ${FAKE}/" ${CONFIG_FILE}
fi
# use USB device
if [ -n "$USB" ]; then
    echo "Using USB device: $USB"
    sed -i -r -e "s/#\[\[USB\]\]/server: usb = ${USB}/" ${CONFIG_FILE}
fi
# use Serial port
if [ -n "$SERIAL" ]; then
    echo "Using Serial device: $SERIAL"
    sed -i -r -e "s/#\[\[SERIAL\]\]/server: device = ${SERIAL}/" ${CONFIG_FILE}
fi
# use I2C device
if [ -n "$I2C" ]; then
    echo "Using I2C device: $I2C"
    sed -i -r -e "s/#\[\[I2C\]\]/server: i2c = ${I2C}/" ${CONFIG_FILE}
fi

echo "=> Starting owserver ..."
exec owserver -c $CONFIG_FILE --foreground --error_level=1
