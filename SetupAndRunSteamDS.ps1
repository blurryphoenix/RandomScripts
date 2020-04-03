# GMod - 'murder','ttt','trouble in terrorist town','sandbox','objhunt'
param(
  [Parameter()]
  [string]$game,
  [Parameter()]
  [string]$gameType,
  [Parameter()]
  [string]$gameMode,
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
if($game -eq "gmod") {
  . ".\DedicatedServer\Games\GModDS.ps1"
  $workshopId = "2043077893";
} elseif($game -eq "csgo") {
  . ".\DedicatedServer\Games\CSGO-DS.ps1"
}

if (!$installLocation) {
  $installLocation = "C:\sourceServer";
}
if (!$serverName) {
  if($game -eq "gmod") {
    $serverName = "$game $gameMode Server";
  } elseif ($game -eq "csgo") {
    $serverName = "$game $gameType $gameMode Server";
  }
  $serverName = "$game Server";
}

if($game -eq "gmod") {
  $gameArgs = GetGmodGameArgs -gameMode $gameMode;
} elseif($game -eq "csgo") {
  if(!$gameMode) {
    $gameArgs = GetCSGOGameArgs -_gameType $gameType;
  } else {
    $gameArgs = GetCSGOGameArgs -_gameType $gameType _gameMode $gameMode;
  }  
}

$serverName = $serverName.trim()
$serverName = $serverName.replace(' ', '_')
$installLocation = $installLocation.TrimEnd("\");
$steamExe = "$installLocation\steamcmd.exe"

if($game -eq "gmod") {
  $gameDir = "$installLocation\steamapps\common\GarrysModDS"
} elseif($game -eq "csgo") {
  $gameDir = "$installLocation\steamapps\common\Counter-Strike Global Offensive Beta - Dedicated Server"
}

$gameExe = "$gameDir\srcds.exe"

CheckOrInstallSteamCmd -installLocation $installLocation;

if($game -eq "gmod") {
  CloneObjHuntRepo -installLocation $gameDir -forceUpdate $forceUpdate;
  $game_Mode = GetGmodGamemode -gameMode $gameMode;
  $mapsList = SetupMapRotation -gmodDir $gameDir -gameMode $game_Mode;
} elseif($game -eq "csgo") {
  $mapsList = SetupMapRotation -csgoDir $gameDir;
}

SetupServerConfig -gameDir $gameDir;

if($game -eq "gmod") {
  $gameId = "4020"
} elseif($game -eq "csgo") {
  $gameId = "740"
}

$args = "+login anonymous +app_update $gameId validate +quit"
Start-Process -NoNewWindow -Wait -FilePath $steamExe -ArgumentList $args

if (!$map) {
  $map = $mapsList -Split '\r?\n' | Get-Random
}

$workshopGameArg = WorkshopItems -workshopId $workshopId -gameDir $gameDir
$authKey = GetAuthKey;

# +sv_setsteamaccount B69B3D3AAC2A179EA41E576C476BF8C4
$args = "-console +hostname $serverName -authkey $authKey $workshopGameArg $gameArgs +exec server.cfg +map $map"
Start-Process -NoNewWindow -FilePath $gameExe -ArgumentList $args
ShowInfoLog;
$csvMapList = $mapsList -Split '\r?\n' -Join ', '
Write-Host -ForegroundColor Green "The map list for $game" -NoNewline 
Write-Host -ForegroundColor Red "($map) :" -NoNewline
Write-Host -ForegroundColor Magenta $csvMapList