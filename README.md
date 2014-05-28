I2PRemoteControl
================

I2P monitor and control application for Mac OS X.

![alt tag](https://raw.github.com/miximka/I2PRemoteControl/master/Docs/ScreenshotNetwork.png)
![alt tag](https://raw.github.com/miximka/I2PRemoteControl/master/Docs/ScreenshotPeers.png)

Features
================

1. Monitor and control your i2p router (local or remote):
- Router uptime and version indication
- Current bandwidth usage monitoring
- Traffic usage monitoring (todo)
- Provides overview to peers and tunnels
- Restart or shutdown your router gracefully or instantly
- Router status indication (informational notifications and warnings)
2. Access the web console with only one click
3. Seamless integration into Mac OS X system bar
4. Autostart with user login

Prerequisites
================

"I2PControl" plugin has to be installed on the i2p node you want to control.

Plugin is available at: http://itoopie.i2p/files/I2PControl.xpi2p

To install the plugin, open the i2p console in the browser, e.g.: “http://127.0.0.1:7657/configclients”, then enter the plugin URL in the "Plugin Installation" field on the bottom of the web page, click "Install Plugin" and wait until installation is finished.

Troubleshooting
================

If you are having troubles downloading the plugin then check whether your router does know itoopie.i2p eepsite address. If not, open itoopie.i2p in the browser and follow usual steps to find out and save itoopie.i2p site address into router’s address book (use one of the available jump services like i2host.i2p or stats.i2p).

If you are using I2PRemoteControl to connect to the remote i2p router (i.e. having the IP address other than 127.0.0.1) then be sure to configure I2PControl plugin on the router to accept incoming connections from all interfaces.

To do this, first, terminate the plugin or entire router (oversize I2PControl plugin will overwrite the configuration file we age going to change). Then edit the plugins’s configuration file (“~/.i2p/plugins/I2PControl/I2PControl.conf” on Debian or “~/Library/Application Support/i2p/plugins/I2PControl/I2PControl.conf” on Mac) and add or change the following properties to the values below:

i2pcontrol.listen.address=0.0.0.0
i2pcontrol.listen.port=7650

Start the plugin or entire router again.

License
================

This project is released under a MIT License (see LICENSE for details).