# New support for this project

Since [tomap](https://github.com/tomap) has no longer time to dedicate to it, we have forked the project in order to maintain it.
This repo has been forked from github repository https://github.com/tomap/nsis-extension

# VSTS Extension

Nsis build extension for VSTS

This extension can be used to build nsis script or to make nsis available for other tasks (as an environment variable).

[Nsis](http://nsis.sourceforge.net/Main_Page) version used is version 3.08

# Usage

* Go to VSTS Marketplace and install the extension
* In your build definition add task "Nsis"
* And either :
  * Select your NSI script (and build arguments: http://nsis.sourceforge.net/Docs/Chapter3.html#usagereference)
  * Include NSIS as an environnement variable called NSIS_EXE that you can use in the following tasks.

## Include additional plugins

There is also an option called `"Include additional plugins"`. If you check this option, the content of the folder [nsis/plugins](../master/nsis/plugins/) will be copied to the nsis plugin folder and those plugins will be made available to your nsis script.

## Custom Plugins Path

There is another option called `"Custom Plugins Path"`

To enable this option, you must enable `Include custom plugins` flag.

If you set a path on this field, the content of the referenced folder will be copied to the NSIS plugin folder and those plugins will be made available to your NSIS script as follow.

```
<Custom-Plugins-Path>
│
│  plugin01.dll
│  plugin02.dll
```


Note that you can provide unicode/ansi support by creating sub-folders named `x86-unicode` and `x86-ansi` with their respective dlls as follow ( Specify only the custom-plugins-path, and the NSIS task will scan for these folders ) :

```
<Custom-Plugins-Path>
│
└─── x86-ansi
│   │   plugin01.dll
│   │   plugin02.dll
│   
└───x86-unicode
│   │   plugin01.dll
│   │   plugin02.dll
```

To test that the task works properly, you can download [install.nsi](../master/install.nsi) and use it as a test script.

## Plugins

The nsis/plugins folder contains multiple plugins that were found on nsis web site:
* [SimpleSC](https://nsis.sourceforge.io/NSIS_Simple_Service_Plugin) (ansi + unicode) This plugin contains basic service functions like start, stop the service or checking the service status. It also contains advanced service functions for example setting the service description, changed the logon account, granting or removing the service logon privilege.
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

* [AccessControl](https://nsis.sourceforge.io/AccessControl_plug-in) (ansi + unicode)  The AccessControl plugin for NSIS provides a set of functions related to Windows NT access control list (ACL) management.
* [DotNetChecker](https://github.com/tbnorris/NsisDotNetChecker) (ansi + unicode)  The .NET Framework Checker NSIS plugin is used to detect if the required .NET Framework is installed and if it is not - plugin will download and install the required package. The plugin's C++ source code is based on the work of Aaron Stebner.
* [DumpLog](https://nsis.sourceforge.io/DumpLog_plug-in) (ansi + unicode) This plug-in will dump the log of the installer (installer details) to a file.
* [FindProcDLL](https://nsis.sourceforge.io/FindProcDLL_plug-in) (ansi + unicode)  This plugin provides the ability to check if any process running just with the name of its .exe file
* [KillProcDLL](https://nsis.sourceforge.io/KillProcDLL_plug-in) (ansi + unicode)  This NSIS DLL plug-in provides one function that has the ability to close any process running, without the need to have the 'class name' or 'window handle' you used to need when using the Windows API TerminateProcess or ExitProcess, just with the name of its .exe file.
* [MSSQL OLEDB](https://nsis.sourceforge.io/MSSQL_OLEDB_plug-in) (ansi + unicode)  The MSSQL OLEDB plugin for NSIS provides some functions to add MSSQL interoperability within an install script.
* [NsProcess](https://nsis.sourceforge.io/NsProcess_plugin) (ansi + unicode) Find and close/kill process.
* [NsisXML](https://nsis.sourceforge.io/NsisXML_plug-in_(by_Wizou)) (ansi + unicode) Small NSIS plugin to manipulate XML data through MSXML.
* [services](https://nsis.sourceforge.io/Services_plug-in) (ansi only) Collection of functions that can be used from an NSIS script (Nullsoft Installation System, to manipulate Windows NT (and hopefully 2000 and XP) Services
* [ToolTips](https://nsis.sourceforge.io/ToolTips_plug-in) (ansi only) Plugin that will display a custom tooltip (modern or classic) in the user selected control.
* [UserMgr](https://nsis.sourceforge.io/UserMgr_plug-in) (ansi + unicode)  Plugin to create Windows User accounts and permissions

# Availability

This extension is publicly available on VSTS Marketplace: https://marketplace.visualstudio.com/items?itemName=bizeta.nsis-task

It is build in VSTS using DevOps.
Here is the status: [![Build Status](https://maximaretail.visualstudio.com/OneStore/_apis/build/status/DevOps%20extensions/development-bizeta-mestre.nsis-extension?branchName=master)](https://maximaretail.visualstudio.com/OneStore/_build/latest?definitionId=38&branchName=master)

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

## [1.1.9] - 2020-11-10
### Fixes
- Ensure parameter `arguments` is not required when parameter `justInclude=yes` [Issue #4](https://github.com/development-bizeta-mestre/nsis-extension/issues/4)
- Build pipeline not working [Issue #2](https://github.com/development-bizeta-mestre/nsis-extension/issues/2)
- NSIS job fails when attempting to run [Issue #10](https://github.com/development-bizeta-mestre/nsis-extension/issues/10)

## [2.0.0] - 2020-11-11
### Added
- Provide x86-unicode plugins along with x86-ansi [Issue #7](https://github.com/development-bizeta-mestre/nsis-extension/issues/7). to make this work, please select `version 2` of the task

## [3.0.0] - 2021-10-21
### Added
- Updated nsis version to v3.08 [PR #16](https://github.com/development-bizeta-mestre/nsis-extension/pull/16). To make this work, please select `version 3` of the task.

## [3.0.6] - 2022-07-06
### Added
- Fix $arguments option
- Set vsts task working directory as script's directory

## [3.0.8] - 2024-09-23
### Added
- Update NSIS to 3.10
- Fix issue with SimpleSC plugin in unicode
- Add some plugins with 'include' folder associated to it to work in x86 and Unicode