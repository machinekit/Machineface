Machineface
===========

Machineface is a remote user interface for Machinekit optimized for 3D printers and mobile devices.

This UI uses the [QtQuickVcp](https://github.com/machinekoder/QtQuickVcp) QtQuick modules.

![Alt text](/doc/Machineface.png "Machineface")


## Using Machineface

To use Machineface you have to clone the repository on your Machinekit computer:

``` bash
cd ~/
git clone https://github.com/machinekoder/Machineface.git
```

Next, you have to supply the path to the directory to the *configserver*.

``` bash
configserver -n 'My Machine' ~/Machineface
```

The UI is then automatically deployed to the [Machinekit Client](https://github.com/machinekoder/MachinekitClient)

For more information about using Machinekit with remote user interfaces please read the [QtQuickVcp documentation](https://github.com/machinekoder/QtQuickVcp#using_mkwrapper).
