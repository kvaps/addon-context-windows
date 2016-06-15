Set fso = CreateObject("Scripting.FileSystemObject")

If NOT Len(driveLetter) Then
    driveLetter = "C:"
End If

contextPath = driveLetter & "\contextuser.ps1"
 
If fso.FileExists(contextPath) Then
    Set objShell = CreateObject("Wscript.Shell")
    objShell.Run("powershell -NonInteractive -NoProfile -NoLogo -ExecutionPolicy Unrestricted -file " & contextPath), 0
End If
