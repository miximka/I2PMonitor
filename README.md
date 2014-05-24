I2PRemoteControl
================

Remote control application for I2P router for Mac OS X

Prerequisites
================

"I2PControl" plugin has to be installed on the i2p node you want to control.

Plugin is available at: http://itoopie.i2p/files/I2PControl.xpi2p

To install the plugin, open the i2p console in the browser, e.g.: “http://localhost:7657/configclients”, then enter the plugin URL in the "Plugin Installation" field on the bottom of the web page, click "Install Plugin" and wait until installation is finished.

Troubleshooting
================

If you are having troubles downloading the plugin then check whether your router does know itoopie.i2p eepsite address. If not, open itoopie.i2p in the browser and follow usual steps to find out and save itoopie.i2p site address into router’s address book (use one of the available jump services like i2host.i2p or stats.i2p).

If you are having troubles to connect to the remote i2p router (i.e. having IP other than 127.0.0.1) then be sure to configure I2PControl plugin to accept incoming connections on all interfaces. You can do this by changing IP from 127.0.0.1 to 0.0.0.0 in the plugins’s configuration file I2PControl.conf (~/.i2p/plugins/I2PControl/I2PControl.conf on Debian).

License
================

This project is released under a MIT License (see LICENSE for details).