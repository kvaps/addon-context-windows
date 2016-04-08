$SCRIPT='
$Letter = "o:"
$Share = ""\\server.domain.tld\share"
$User = "\user"
$Password = "password"
$Printers = @("\\server.domain.tld\printer1", "\\server.domain.tld\printer2")


Remove-Item "C:\TEMP\.opennebula-startscript-is-done.txt"

# Connect Share
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive($Letter, $Share, $false, $User, $Password)

# Map Printers
function Map-Printers($Printers) {
  foreach ($Printer in $Printers) {
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection($Printer)
  }
}

Map-Printers -Printers $Printers
'

$SCRIPT | Out-File 'C:\.opennebula-userscript.ps1'

# Report done
New-Item "C:\TEMP" -type directory
$DoneFile = "C:\TEMP\.opennebula-startscript-is-done.txt"
New-Item $DoneFile -type file
cacls $DoneFile /g everyone:f
