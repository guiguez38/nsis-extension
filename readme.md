# New support for this project

Since [tomap](https://github.com/tomap) has no longer time to dedicate to it, we have forked the project in order to maintain it.
This repo has been forked from github repository https://github.com/tomap/nsis-extension

# VSTS Extension

Nsis build extension for VSTS

This extension can be used to build nsis script or to make nsis available for other tasks (as an environment variable).

[Nsis](http://nsis.sourceforge.net/Main_Page) version used is version 3.03

# Usage

* Go to VSTS Marketplace and install the extension
* In your build definition add the task "Nsis"
* Either select your nsi script (and build arguments: http://nsis.sourceforge.net/Docs/Chapter3.html#usagereference)
* Or just include NSIS as an environnement variable called NSIS_EXE that you can use in the following tasks.

There is also an option called "Include additional plugins". If you check this option, the content of the folder [nsis/plugins](../master/nsis/plugins/) will be copied to the nsis plugin folder and those plugins will be made available to your nsis script.

There is another option called "Custom Plugins Path". If you set a path on this field, the content of the referenced folder will be copied to the nsis plugin folder and those plugins will be made available to your nsis script.

To test that the task works properly, you can download [install.nsi](../master/install.nsi) and use it as a test script.

## Plugins

The nsis/plugins folder contains multiple plugins that were found on nsis web site:
* [SimpleSC](http://nsis.sourceforge.net/NSIS_Simple_Service_Plugin) NSIS Simple Service Plugin (license MPL / LGPL)
* ``Services2``, another plugin to manage services
Examples:
```
services2::IsServiceRunning "w3svc"
Pop $0
  ${If} $0 == "Yes"
...
  ${Else}
...
  ${EndIf}
```
``services2::IsServiceInstalled "w3wp"`` work the same
Also:
```
services2::SendServiceCommandWait "start" "w3wp" "120"
  Pop $0
  ${If} $0 == "Ok"
...
  ${Else}
  ...
  ${Endif}
```
* there are other plugins _to be documented_


# Availability

This extension is publicly available on VSTS Marketplace: https://marketplace.visualstudio.com/items?itemName=bizeta.nsis-task

It is build in VSTS using DevOps.
Here is the status: ![Build status](https://maximaretail.visualstudio.com/OneStore/_apis/build/status/DevOps%20extensions/dev-maxima.nsis-extension?branchName=master)

The build is done following the build steps on [Microsoft documentation page](https://docs.microsoft.com/en-us/azure/devops/extend/get-started/node?view=azure-devops)

# License

This extension is published under MIT license. See [license file](../master/license).

# Changelog
All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [1.1.2] - 2019-08-06
### Added
- new plugin option "__Custom Plugins Path__" to be able to include custom plugins path in order to be able to use custom plugins that aren't included on default plugins folder.
All plugins file in this path will be copied to nsis\plugins\x86-ansi