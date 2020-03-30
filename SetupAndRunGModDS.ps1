param(
  [Parameter()]
  [ValidateSet('prop_hunt','murder','ttt','trouble in terrorist town','sandbox')]
  [string]$game,
  [Parameter()]
  [string]$serverName = "Tucker_Smells",
  [Parameter()]
  [string]$localNetworkCardIp
)

$srcdsdir = "C:\sourceServer"
$steamexe = "$srcdsdir\steamcmd.exe"
$gmodDir = "$srcdsdir\steamapps\common\GarrysModDS"
$gmod = "$gmodDir\srcds.exe"
#raw server.cfg
$serverConfig = '// Hostname for server.
hostname "Tucker_Smells"
// RCON - remote console password.
rcon_password "mutmatt_r0x!"

// Server password - for private servers.
sv_password ""

// Server Logging
log on
sv_logbans 1
sv_logecho 1
sv_logfile 1
sv_log_onefile 0
lua_log_sv 0

sv_rcon_banpenalty 0
sv_rcon_maxfailures 20
sv_rcon_minfailures 20
sv_rcon_minfailuretime 20

// Network Settings
sv_downloadurl ""
sv_loadingurl ""
net_maxfilesize 64
sv_maxrate 0
sv_minrate 800000
sv_maxupdaterate 66
sv_minupdaterate 33
sv_maxcmdrate 66
sv_mincmdrate 33

// Server Settings
sv_airaccelerate 100
sv_gravity 600
sv_allow_wait_command 0
sv_allow_voice_from_file 0
sv_turbophysics 0
sv_max_usercmd_future_ticks 12
gmod_physiterations 4
sv_client_min_interp_ratio 1
sv_client_max_interp_ratio 2
think_limit 20
sv_region 0
sv_noclipspeed 5
sv_noclipaccelerate 5
sv_lan 0
sv_alltalk 1
sv_contact youremail@changeme.com
sv_cheats 0
sv_allowcslua 0
sv_pausable 0
sv_filterban 1
sv_forcepreload 1
sv_footsteps 1
sv_voiceenable 1
sv_voicecodec vaudio_speex
sv_timeout 120
sv_deltaprint 0
sv_allowupload 0
sv_allowdownload 0

// Sandbox Settings
sbox_noclip 0
sbox_godmode 0
sbox_weapons 0
sbox_playershurtplayers 0
sbox_maxprops 100
sbox_maxragdolls 50
sbox_maxnpcs 10
sbox_maxballoons 10
sbox_maxeffects 0
sbox_maxdynamite 0
sbox_maxlamps 5
sbox_maxthrusters 20
sbox_maxwheels 20
sbox_maxhoverballs 20
sbox_maxvehicles 1
sbox_maxbuttons 20
sbox_maxemitters 0

// Misc Config$
exec banned_user.cfg
exec banned_ip.cfg
heartbeat';

$workshopGameId;
switch($game) {
  'prop_hunt' {
    break;
  }
  'murder' {
    break;
  }
  'ttt' {
    continue
  }
  'trouble in terrorist town' {
    $gamename = "terrortown";
    break;
  }
}
$gamenameArg = if (!$game) { "+gamemode sandbox" } else { "+gamemode $game" }

$networkArg = if (!$localNetworkCardIp) { "" } else { "-ip $localNetworkCardIp" }
$workshopGameArg = "+host_workshop_collection 2040200286"

$batFile = "@echo off
cls
echo Protecting srcds from crashes...
echo If you want to close srcds and this script, close the srcds window and type Y depending on your language followed by Enter.
title srcds.com Watchdog
:srcds
echo (%time%) srcds started.
start /wait srcds.exe -console -game garrysmod $gamenameArg +map gm_construct +maxplayers 16 +r_hunkalloclightmaps 0
echo (%time%) WARNING: srcds closed or crashed, restarting.
goto srcds";
# start /wait srcds.exe -console -game garrysmod $gamenameArg $workshopGameArg
# 
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}


if (!(Test-Path $srcdsdir)) {
  wget "http://media.steampowered.com/installer/steamcmd.zip" -outfile $env:USERPROFILE\Downloads\steamcmd.zip
  Unzip $env:USERPROFILE\Downloads\steamcmd.zip C:\sourceServer
}


$args = "+login anonymous +app_update 4020 validate +quit"
Start-Process -NoNewWindow -Wait -FilePath $steamexe -ArgumentList $args 


$serverConfig | Out-File $gmodDir\garrysmod\cfg\server.cfg -Encoding "ASCII"
$batFile | Out-File $gmodDir\StartGModDS.bat -Encoding "ASCII"
# $args = "-console +sv_setsteamaccount B69B3D3AAC2A179EA41E576C476BF8C4 -authkey B69B3D3AAC2A179EA41E576C476BF8C4 $workshopGameArg -game garrysmod $gamenameArg $networkArg +exec server.cfg +clientport 27006"
# Start-Process -NoNewWindow -Wait -FilePath $gmod -ArgumentList $args
# modify the server
# c:\buildslave\steam_rel_client_win32\build\src\clientdll\appdatacache.cpp (1469) : Assertion Failed: GSteamEngine().IsEngineThreadRunning()
Set-Location -Path $gmodDir
Start-Process "cmd.exe" "/c $gmodDir\StartGModDS.bat"