param(
  [Parameter()]
  [string]$game,
  # 'murder','ttt','trouble in terrorist town','sandbox','objhunt'
  [Parameter()]
  [string]$serverName = "Tucker_Smells",
  [Parameter()]
  [string]$map,
  [Parameter()]
  [string]$installLocation = "C:\sourceServer"
)
$serverName = $serverName.trim()
$serverName = $serverName.replace(' ', '_')
$steamexe = "$installLocation\steamcmd.exe"
$gmodDir = "$installLocation\steamapps\common\GarrysModDS"
$gmod = "$gmodDir\srcds.exe"
#raw server.cfg
$serverConfig = '// Hostname for server.
// RCON - remote console password.
rcon_password "mutmatt_r0x!"

// Server password - for private servers.
sv_password "derp"

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
sv_allow_voice_from_file 0
sv_turbophysics 0
sv_client_min_interp_ratio 1
sv_client_max_interp_ratio 2
think_limit 20
sv_region 0
sv_noclipspeed 5
sv_noclipaccelerate 5
sv_lan 0
sv_alltalk 1
sv_contact server_admin@matterickson.me
sv_cheats 0
sv_allowcslua 0
sv_pausable 0
sv_filterban 1
sv_forcepreload 1
sv_footsteps 1
sv_voiceenable 1
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

# start /wait srcds.exe -console -game garrysmod $gamenameArg $workshopGameArg
# 
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}


if (!(Test-Path $installLocation)) {
  wget "http://media.steampowered.com/installer/steamcmd.zip" -outfile $env:USERPROFILE\Downloads\steamcmd.zip
  Unzip $env:USERPROFILE\Downloads\steamcmd.zip C:\sourceServer
}


$args = "+login anonymous +app_update 4020 validate +quit"
Start-Process -NoNewWindow -Wait -FilePath $steamexe -ArgumentList $args 

if (!$map) {
  $map = Get-ChildItem $gmodDir\garrysmod\maps -Filter *.bsp -Recurse | Get-Random
}
$serverConfig | Out-File $gmodDir\garrysmod\cfg\server.cfg -Encoding "ASCII"
echo "resource.AddWorkshop("2040200286")" | Out-File $gmodDir\garrysmod\lua\autorun\server\workshop.lua -Encoding "ASCII"

$args = "-console +hostname $serverName -authkey B69B3D3AAC2A179EA41E576C476BF8C4 $workshopGameArg -game garrysmod $gamenameArg $networkArg +exec server.cfg +map $map"
Start-Process -NoNewWindow -FilePath $gmod -ArgumentList $args
echo "----------------------srcds.exe commands (the other window)---------------------------------------------------------"
echo "| changelevel *map_name*                       | changes the map                                                   |"
echo "| status                                       | gives information about the running server (including ip address) |"
echo "| quit                                         | exits (shut down the server)                                      |"
echo "----------------------in game dev console commands (~)--------------------------------------------------------------"
echo "| rcon_password tH3_pw                         | drop into 'admin' mode                                            |"
echo "| rcon changelevel *map_name* (ph, tt, etc)    | changes the level of the server                                   |"
echo "| rcon gamemode *mode* (terrortown, prop_hunt) | changes the level of the server                                   |"
echo "| also helpful link for commands https://steamcommunity.com/sharedfiles/filedetails/?id=170589737                  |"
echo "--------------------------------------------------------------------------------------------------------------------"