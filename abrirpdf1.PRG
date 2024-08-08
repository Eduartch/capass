LOCAL lcFile, loShell
lcFile = GETFILE("PDF")
loShell = CREATEOBJECT("Shell.Application")
loShell.ShellExecute(lcFile)
RELEASE loShell