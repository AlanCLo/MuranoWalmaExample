# Murano Walma Whiteboard Example.

This Murano package designed for the Nectar cloud deploys Walma. Walma is a collaborative whiteboard that works on any modern web browser. It is intended to be a useful application for general purposes and also provides a reference implementation as a contribution from The University of Melbourne's Nectar community.

**This setup is not designed to be a long-standing Walma server**. Start a new instance of Walma with Murano and use it for your workshop/conference/etc for the next few days. Once you are done you should shutdown the instance from Nectar dashboard.

Links
* https://wiki.openstack.org/wiki/Murano
* http://nectar.org.au
* https://walmademo.opinsys.fi/

## Building the Murano package

Murano packages are shipped as zip files. I've used [Make](https://www.gnu.org/software/make/) here to construct it. Use make on any GNU system to generate DemoWalma.zip
```
$> git clone https://github.com/AlanCLo/MuranoWalmaExample.git
$> cd MuranoWalmaExample
$> make

 *** Building murano zip package
zip -r DemoWalma.zip manifest.yaml Classes/Walma.yaml Resources/Deploy.template Resources/scripts/deploy.sh UI/ui.yaml
  adding: manifest.yaml (deflated 34%)
  adding: Classes/Walma.yaml (deflated 61%)
  adding: Resources/Deploy.template (deflated 37%)
  adding: Resources/scripts/deploy.sh (deflated 43%)
  adding: UI/ui.yaml (deflated 65%)

 *** Build complete
```

## Using the Murano package

Dependencies
* NeCTAR Ubuntu 14.04 (Trusty) amd64 (**Special Note**: Walma needs to run on older versions of Node.js which does not come in more recent versions of Ubuntu)
* Minimum Root Disk size: 10GB

Check the Murano's quickstart guide here: http://docs.openstack.org/developer/murano/enduser-guide/quickstart.html

Once the deployment is complete, point your web browser to the IP address of the new server displayed on the Nectar Dashboard.

## Setup

This package performs a simple deployment of Walma git version f6fb11d47feaa1597cfd1aacbf8d09aeaff3f769 on a single Ubuntu server with the following configuration:
* Server only permits http (80), https (443), and ssh (20) connections
* Walma runs on port 1337 as **walma** user
* Nginx will pass traffic from port 80 to Walma on 1337
* Walma is process controlled by supervisord to automatically restart
* Data is stored locally on mongodb

This is not designed to be a long-standing deployment.

## Main contents of the package

1. Resources/scripts/deploy.sh
 * Installs and configures the application after VM is instantiated
2. UI/ui.yaml
 * Defines all the variables & labels in the Dashboard wizard to setup the application
3. Classes/Walma.yaml
 * Backend Murano script that orchestrates the deployment process based on parameters provided
