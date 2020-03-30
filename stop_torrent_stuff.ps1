Stop-Process -Name "SickBeard"
Stop-Process -Name "CouchPotato"
Stop-Process -Name "uTorrent"
& "$env:ProgramW6432\Private Internet Access\piactl.exe" disconnect