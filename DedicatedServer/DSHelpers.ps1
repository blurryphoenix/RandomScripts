Function CheckOrInstallSteamCmd {
  param(
    [Parameter()]
    [string] $installLocation
  )
  
  # start /wait srcds.exe -console -game garrysmod $gamenameArg $workshopGameArg
  # 
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  if (!(Test-Path $installLocation\steamcmd.exe)) {
    Invoke-WebRequest "http://media.steampowered.com/installer/steamcmd.zip" -outfile $env:USERPROFILE\Downloads\steamcmd.zip
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$env:USERPROFILE\Downloads\steamcmd.zip", $installLocation);
    Remove-Item -Path $env:USERPROFILE\Downloads\steamcmd.zip -Recurse -Force
  }
}