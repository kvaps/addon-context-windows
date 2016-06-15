function getContext($file) {
    $context = @{}
    switch -regex -file $file {
        "^([^=]+)='(.+?)'$" {
            $name, $value = $matches[1..2]
            $context[$name] = $value
        }
    }
    return $context
}

function connectSmb($context) {
    $smbId = 0;
    $smbShareKey = "SMB" + $smbId + "_SHARE"
    while ($context[$smbShareKey]) {
        # Retrieve the data
        $smbPrefix = "SHORTCUT" + $nicId + "_"

        $shareKey     = $smbPrefix + "SHARE"
        $letterKey    = $smbPrefix + "LETTER"
        $printerKey   = $smbPrefix + "PRINTER"
        $userKey      = $smbPrefix + "USER"
        $passKey      = $smbPrefix + "PASS"

        $share    = $context[$shareKey]
        $letter   = $context[$letterKey]
        $printer  = $context[$printerKey]
        $user     = $context[$userKey]
        $pass     = $context[$passKey]

        # Connect Share
        if ($share) {
            $net = new-object -ComObject WScript.Network
            $net.MapNetworkDrive($letter + ':', $share, $false, $user, $pass)
        }
        
        # Map Printer
        if ($printer) {
            (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection($printer)
        }
        
        # Next Smb
        $smbId++;
        $smbShareKey = "SMB" + $smbId + "_SHARE"
    }
}

function createShortcuts($context) {
    $shortcutId = 0;
    $shortcutNameKey = "SHORTCUT" + $shortcutId + "_NAME"
    while ($context[$shortcutNameKey]) {
        # Retrieve the data
        $shortcutPrefix = "SHORTCUT" + $nicId + "_"
        
        $nameKey     = $shortcutPrefix + "NAME"
        $progKey     = $shortcutPrefix + "PROG"
        $argsKey     = $shortcutPrefix + "ARGS"

        $name    = $context[$nameKey]
        $prog    = $context[$progKey]
        $args    = $context[$argsKey]
        
        $path = "$Home\Desktop\" + $name + ".lnk"
        
        # Create Shortcut
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($path)
        $Shortcut.TargetPath = $prog
        $Shortcut.Arguments = $args
        $Shortcut.Save()

        # Next Shortcut
        $shortcutId++;
        $shortcutNameKey = "SHORTCUT" + $shortcutId + "_NAME"   
    }


}

################################################################################
# Main
################################################################################

# Get all drives and select only the one that has "CONTEXT" as a label
$contextDrive = Get-WMIObject Win32_Volume | ? { $_.Label -eq "CONTEXT" }

if ($contextDrive) {
    # At this point we can obtain the letter of the contextDrive
    $contextLetter     = $contextDrive.Name
    $contextScriptPath = $contextLetter + "context.sh"
} else {

    # Try the VMware API
    $vmwareContext = & "$env:ProgramFiles\VMware\VMware Tools\vmtoolsd.exe" --cmd "info-get guestinfo.opennebula.context" | Out-String

    if ($vmwareContext -eq "") {
        Write-Host "No Context CDROM found."
        exit 1
    }

    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($vmwareContext)) | Out-File "$env:SystemDrive\context.sh" "UTF8"
    $contextScriptPath = "$env:SystemDrive\context.sh"
}

# Execute script
if(Test-Path $contextScriptPath) {
    $context = getContext $contextScriptPath
    createShortcuts $context
    connectSmb $context
}
