# VSTS Extension

Nsis build extension for VSTS

This extension can be used to build nsis script or to make nsis available for other tasks (as an environment variable).

[Nsis](http://nsis.sourceforge.net/Main_Page) version used is version 3.01

# Usage

* Go to VSTS Marketplace and install the extension
* In your build definition add the task "Nsis"
* Either select your nsi script (and build arguments: http://nsis.sourceforge.net/Docs/Chapter3.html#usagereference)
* Or just include NSIS as an environement variable called NSIS_EXE that you can use in the following tasks.

To test that the task works properly, you can download [install.nsi](../blob/master/install.nsi) and use it as a test script.

# Availability

This extension is publicly available on VSTS Marketplace: https://marketplace.visualstudio.com/items?itemName=ThomasP.nsis-task

It is build in VSTS using VSTS Developer Tools Build Task (https://marketplace.visualstudio.com/items?itemName=ms-devlabs.vsts-developer-tools-build-tasks).
Here is the status: ![Build status](https://tomap.visualstudio.com/_apis/public/build/definitions/6d190468-0f5e-4624-9d49-8446c00b4b51/1/badge)

The build number is automaticaly incremented on each commit by the VSTS Build task by a pattern like "0.2.$(Build.BuildId)". See https://www.visualstudio.com/en-us/docs/build/define/variables#predefined-variables for reference.

# License

This extension is published under MIT license. See [license file](../blob/master/LICENSE).