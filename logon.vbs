Set fso = CreateObject("Scripting.FileSystemObject")

' Wait for .opennebula-startscript-is-done.txt
While Not fso.FileExists("C:\TEMP\.opennebula-startscript-is-done.txt")
  WScript.Sleep 1000
Wend

If NOT Len(driveLetter) Then
    driveLetter = "C:"
End If

contextPath = driveLetter & "\.opennebula-userscript.ps1"
 
If fso.FileExists(contextPath) Then
    Set objShell = CreateObject("Wscript.Shell")
    objShell.Run("powershell -NonInteractive -NoProfile -NoLogo -ExecutionPolicy Unrestricted -file " & contextPath), 0
End If
