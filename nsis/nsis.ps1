$scriptFile = Get-VstsInput -Name scriptFile -Require;
$justInclude = Get-VstsInput -Name justInclude -Require;
$arguments = Get-VstsInput -Name arguments;
$includeMorePlugins = Get-VstsInput -Name includeMorePlugins -Require;
$includeCustomPluginsPath = Get-VstsInput -Name includeCustomPluginsPath -Require;


foreach ($key in $PSBoundParameters.Keys) {
    Write-Host ($key + ' = ' + $PSBoundParameters[$key])
}

$path = split-path $MyInvocation.MyCommand.Path

$output = $path + "\nsis.zip"

$destination = $path + "\nsis"

if (!(Test-Path $destination)) {

    $start_time = Get-Date

    Add-Type -assembly "system.io.compression.filesystem"

    [io.compression.zipfile]::ExtractToDirectory($output, $destination)

    $directories = Get-ChildItem -Path $destination
    $nsis3Directory = $directories[0].FullName
    
    Write-Output "Time taken (Unzip): $((Get-Date).Subtract($start_time).Seconds) second(s)"
}
else {
    $directories = Get-ChildItem -Path $destination
    $nsis3Directory = $directories[0].FullName
}

if ($includeMorePlugins -eq "yes") {
    $pluginPath = $path + "\plugins\*"
    $pluginOutput = $nsis3Directory + "\plugins\x86-ansi"
    Copy-Item $pluginPath $pluginOutput -force
}
    
if (-Not ([string]::IsNullOrEmpty($includeCustomPluginsPath))) {
    $pluginPath = $includeCustomPluginsPath + "\*"
    $pluginOutput = $nsis3Directory + "\plugins\x86-ansi"
    Copy-Item $pluginPath $pluginOutput -force
}

$nsis3Exe = $nsis3Directory + "\makensis.exe"

$env:NSIS_EXE = $nsis3Exe
Write-Host("##vso[task.setvariable variable=NSIS_EXE;]$nsis3Exe")

if ($justInclude -eq "no") {
    $args = ''

    if ($arguments -notcontains "/V") {
        if ($env:Debug -eq "true") {
            $args += "/V4 "
        }
        if ($env:Debug -eq "false") {
            $args += "/V1 "
        }
    }
    $args += $arguments + ' "' + $scriptFile + '"'

    Write-Host("Executing nsis $nsis3Exe with args: $args")

    Invoke-VstsTool -FileName $nsis3Exe -Arguments $args -RequireExitCodeZero
}
else {
    Write-Host("Including nsis in variable NSIS_EXE: $nsis3Exe")
}
