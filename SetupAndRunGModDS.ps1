# 'murder','ttt','trouble in terrorist town','sandbox','objhunt'
param(
  [Parameter()]
  [string]$game,
  [Parameter()]
  [string]$serverName,
  [Parameter()]
  [string]$map,
  [Parameter()]
  [string]$installLocation,
  [Parameter()]
  [boolean] $forceUpdate
)
. ".\DedicatedServer\DSHelpers.ps1"

if (!$installLocation) {
  $installLocation = "C:\sourceServer";
}
if (!$serverName) {
  $serverName = "Tucker_Smells";
}

if ($game -eq "murder") {
    $gameMode = "murder";
} elseif ($game -eq "ttt" -or $game -eq "tt" -or $game -eq "trouble in terrorist town" -or $game -eq "terrortown") {
    $gameMode = "terrortown";
} elseif ($game -eq "prop_hunt" -or $game -eq "obj_hunt" -or $game -eq "prophunt" -or $game -eq "objhunt") {
    $gameMode = "prop_hunt";
} else {
  $gameMode = "prop_hunt";
}
$gamenameArg = "+gamemode $gameMode"

$serverName = $serverName.trim()
$serverName = $serverName.replace(' ', '_')
$installLocation = $installLocation.TrimEnd("\");
$steamExe = "$installLocation\steamcmd.exe"
$gmodDir = "$installLocation\steamapps\common\GarrysModDS"
$gmodExe = "$gmodDir\srcds.exe"

CheckOrInstallSteamCmd -installLocation $installLocation;
CloneObjHuntRepo -installLocation $gmodDir -forceUpdate $forceUpdate;
SetupServerConfig -gmodDir $gmodDir;
$mapsList = SetupMapRotation -gmodDir $gmodDir -gameMode $gameMode;

# 4020 is gmod
$args = "+login anonymous +app_update 4020 validate +quit"
Start-Process -NoNewWindow -Wait -FilePath $steamExe -ArgumentList $args

if (!$map) {
  $map = $mapsList -Split '\r?\n' | Get-Random
}
Write-Output "resource.AddWorkshop("2040200286")" | Out-File $gmodDir\garrysmod\lua\autorun\server\workshop.lua -Encoding "ASCII"

# +sv_setsteamaccount B69B3D3AAC2A179EA41E576C476BF8C4
$workshopGameArg = "+host_workshop_collection 2040200286"
$args = "-console +hostname $serverName -authkey B69B3D3AAC2A179EA41E576C476BF8C4 $workshopGameArg -game garrysmod $gamenameArg +exec server.cfg +map $map"
Start-Process -NoNewWindow -FilePath $gmodExe -ArgumentList $args
Write-Host -ForegroundColor Red    "--------------------------------srcds.exe commands (the other window)------------------------------------------------"
Write-Host -ForegroundColor Yellow "| gamemode *mode*                              | changes game mode                                                  |"
Write-Host -ForegroundColor Yellow "| changelevel *map_name*                       | changes the map                                                    |"
Write-Host -ForegroundColor Yellow "| status                                       | gives information about the running server (including ip address)  |"
Write-Host -ForegroundColor Yellow "| quit                                         | exits (shut down the server)                                       |"
Write-Host -ForegroundColor Red    "--------------------------------in game dev console commands (~)-----------------------------------------------------"
Write-Host -ForegroundColor Green  "| rcon_password tH3_pw                         | drop into 'admin' mode                                             |"
Write-Host -ForegroundColor Green  "| rcon changelevel *map_name* (ph, tt, etc)    | changes the level of the server                                    |"
Write-Host -ForegroundColor Green  "| rcon gamemode *mode* (terrortown, prop_hunt) | changes the game mode                                              |"
Write-Host -ForegroundColor Red    "---------------------------------------------------------------------------------------------------------------------"
Write-Host -ForegroundColor Green  "| you can test these commands as 'changelevel' to find the map and then use 'rcon' to change ther server map        |"
Write-Host -ForegroundColor Green  "| also helpful link for commands https://steamcommunity.com/sharedfiles/filedetails/?id=170589737                   |"
Write-Host -ForegroundColor Green  "| you should have HL2 CS:S TF2 and this subscribe https://steamcommunity.com/sharedfiles/filedetails/?id=2040200286 |"
Write-Host -ForegroundColor Red    "--------------------------------------------------------------------------------------------------------------------"
$csvMapList = $mapsList -Split '\r?\n' -Join ', '
Write-Host -ForegroundColor Green "The map list for $game" -NoNewline 
Write-Host -ForegroundColor Red "($map) :" -NoNewline
Write-Host -ForegroundColor Magenta $csvMapList