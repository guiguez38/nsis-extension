$scriptFile = Get-VstsInput -Name scriptFile -Require;
$justInclude = Get-VstsInput -Name justInclude -Require;
$arguments = Get-VstsInput -Name arguments;
$includeMorePlugins = Get-VstsInput -Name includeMorePlugins -Require;
$includeCustomPlugins = Get-VstsInput -Name includeCustomPlugins -Require;
$includeCustomPluginsPath = Get-VstsInput -Name includeCustomPluginsPath -Require;

Write-Host "scriptFile = $scriptFile"
Write-Host "justInclude = $justInclude"
Write-Host "arguments = $arguments"
Write-Host "includeMorePlugins = $includeMorePlugins"
Write-Host "includeCustomPluginsPath = $includeCustomPluginsPath"
Write-Host "" # write new line

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
    Write-Host "" # write new line
}
else {
    $directories = Get-ChildItem -Path $destination
    $nsis3Directory = $directories[0].FullName
}

if ($includeMorePlugins -eq "yes") {

    # Copy include folder
    $pluginPath = $path + "\include\*"
    $pluginOutput = $nsis3Directory + "\include"
    Copy-Item $pluginPath $pluginOutput -force

    Write-Output "[includeMorePlugins] dump '$pluginOutput':"
    Get-ChildItem $pluginOutput
    Write-Host "" # write new line

    # Copy ansi plugin folder
    $pluginPath = $path + "\plugins\x86-ansi\*"
    $pluginOutput = $nsis3Directory + "\plugins\x86-ansi"
    Copy-Item $pluginPath $pluginOutput -force

    Write-Output "[includeMorePlugins] dump '$pluginOutput':"
    Get-ChildItem $pluginOutput
    Write-Host "" # write new line

    # Copy unicode plugin folder
    $pluginPath = $path + "\plugins\x86-unicode\*"
    $pluginOutput = $nsis3Directory + "\plugins\x86-unicode"
    Copy-Item $pluginPath $pluginOutput -force

    Write-Output "[includeMorePlugins] dump '$pluginOutput':"
    Get-ChildItem $pluginOutput
    Write-Host "" # write new line
}
Write-Host "" # write new line

if ($includeCustomPlugins -eq "yes") {
    
    $customIncludePath = $includeCustomPluginsPath + '\include';
    $hasIncludePath = Test-Path $customIncludePath;
    $customAnsiPath = $includeCustomPluginsPath + '\x86-ansi';
    $hasAnsiPath = Test-Path $customAnsiPath;
    $customUnicodePath = $includeCustomPluginsPath + '\x86-unicode';
    $hasUnicodePath = Test-Path $customUnicodePath;
    
    
    # Has include folder, copy in appropriate out folder
    if ($hasIncludePath) {
        $pluginPath = $customIncludePath + "\*"
        $pluginOutput = $nsis3Directory + "\include"
        
        Write-Output "[includeCustomPluginsPath - include detected] dump '$pluginPath':"
        Get-ChildItem $pluginPath
        
        Copy-Item $pluginPath $pluginOutput -force

        Write-Output "[includeCustomPluginsPath] dump '$pluginOutput':"
        Get-ChildItem $pluginOutput
        Write-Host "" # write new line
    }

    # Has ansi plugin folder, copy in appropriate out folder
    if ($hasAnsiPath) {
        $pluginPath = $customAnsiPath + "\*"
        $pluginOutput = $nsis3Directory + "\plugins\x86-ansi"
        
        Write-Output "[includeCustomPluginsPath - x86-ansi detected] dump '$pluginPath':"
        Get-ChildItem $pluginPath
        
        Copy-Item $pluginPath $pluginOutput -force

        Write-Output "[includeCustomPluginsPath] dump '$pluginOutput':"
        Get-ChildItem $pluginOutput
        Write-Host "" # write new line
    }
    
    # Has unicode plugin folder, copy in appropriate out folder
    if ($hasUnicodePath) {
        $pluginPath = $customUnicodePath + "\*"
        $pluginOutput = $nsis3Directory + "\plugins\x86-unicode"
        
        Write-Output "[includeCustomPluginsPath - x86-unicode detected] dump '$pluginPath':"
        Get-ChildItem $pluginPath

        Copy-Item $pluginPath $pluginOutput -force

        Write-Output "[includeCustomPluginsPath] dump '$pluginOutput':"
        Get-ChildItem $pluginOutput
        Write-Host "" # write new line
    }

    # No ansi/unicode path provided, interpret it as ansi to be backward compatible
    if (-Not $hasIncludePath -and -Not $hasAnsiPath -and -Not $hasUnicodePath) {
        $pluginPath = $includeCustomPluginsPath + "\*"
        $pluginOutput = $nsis3Directory + "\plugins\x86-ansi"
        
        Write-Output "[includeCustomPluginsPath - no x86-ansi no x86-unicode detected - fallback to x86-ansi] dump '$pluginPath':"
        Get-ChildItem $pluginPath

        Copy-Item $pluginPath $pluginOutput -force

        Write-Output "[includeCustomPluginsPath] dump '$pluginOutput':"
        Get-ChildItem $pluginOutput
        Write-Host "" # write new line
    }
}
Write-Host "" # write new line

$nsis3Exe = $nsis3Directory + "\makensis.exe"

$env:NSIS_EXE = $nsis3Exe
Write-Host("##vso[task.setvariable variable=NSIS_EXE;]$nsis3Exe")

if ($justInclude -eq "no") {
    $consolidatedArguments = ''

    if ($arguments -notcontains "/V") {
        if ($env:Debug -eq "true") {
            $consolidatedArguments += "/V4 "
        }
        if ($env:Debug -eq "false") {
            $consolidatedArguments += "/V1 "
        }
    }
    $consolidatedArguments += $arguments + ' "' + $scriptFile + '"'

    #$workingDir = Split-Path -Path $scriptFile;
    #Write-Host("Executing nsis '$nsis3Exe' with : `r`n - arguments: '$consolidatedArguments' `r`n - workingDir: $workingDir")
    #Invoke-VstsTool -WorkingDirectory $workingDir -FileName $nsis3Exe -Arguments $consolidatedArguments -RequireExitCodeZero

    Write-Host("Executing nsis '$nsis3Exe' with : `r`n - arguments: '$consolidatedArguments'")
    Invoke-VstsTool $nsis3Exe -Arguments $consolidatedArguments -RequireExitCodeZero
}
else {
    Write-Host("Including nsis in variable NSIS_EXE: $nsis3Exe")
}
