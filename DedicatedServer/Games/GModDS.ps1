Function GetGmodGamemode {
    param(
        [Parameter()]
        [string] $gameMode
      )

    if ($gameMode -eq "murder") {
        $_gameMode = "murder";
    } elseif ($gameMode -eq "ttt" -or $gameMode -eq "tt" -or $gameMode -eq "trouble in terrorist town" -or $gameMode -eq "terrortown") {
        $_gameMode = "terrortown";
    } elseif ($gameMode -eq "prop_hunt" -or $gameMode -eq "obj_hunt" -or $gameMode -eq "prophunt" -or $gameMode -eq "objhunt") {
        $_gameMode = "prop_hunt";
    } else {
    $_gameMode = "sandbox";
    } 

    return $_gameMode;
}

Function GetGmodGameArgs {
    param(
    [Parameter()]
    [string] $gameMode
  )  

  $gameMode = GetGmodGamemode -gameMode $gameMode
  return "-game garrysmod +gamemode $gameMode"
}

Function CloneObjHuntRepo {
    param(
      [Parameter()]
      [string] $installLocation,
      [Parameter()]
      [boolean] $forceUpdate
    )
  
    if (!(Test-Path $installLocation\garrysmod\gamemodes\prop_hunt)) {
      New-Item -Path $installLocation\garrysmod\gamemodes\prop_hunt -ItemType "directory"
    }
    if (!(Test-Path $installLocation\garrysmod\gamemodes\prop_hunt\prop_hunt.txt)) {
      New-Item -Path $installLocation\garrysmod\gamemodes\prop_hunt -Name "prop_hunt.txt" -ItemType "file" -Value "empty"
    }
    $firstLineOfPropHunt = Get-Content $installLocation\garrysmod\gamemodes\prop_hunt\prop_hunt.txt -First 1
    if ($firstLineOfPropHunt -notmatch "objhunt" -or $forceUpdate) {
      git clone https://github.com/Newbrict/ObjHunt.git $env:USERPROFILE\Downloads\objhunt
      Remove-Item -Path $installLocation\garrysmod\gamemodes\prop_hunt -Recurse -Force
      Move-Item -Force $env:USERPROFILE\Downloads\objhunt\* $installLocation\garrysmod\gamemodes\prop_hunt
      Remove-Item -Path $env:USERPROFILE\Downloads\objhunt -Recurse -Force
    }
}

  Function SetupMapRotation {
    param(
      [Parameter()]
      [string]$gmodDir,
      [Parameter()]
      [string]$gameMode
    )
    #between fountain and arena  is supposed to be "Awesome Building - Prop Hunt"
    if ($gameMode -eq 'prop_hunt') {
      $maps = "ph_restaurant
  ph_niteoflivingdead
  ph_office
  ph_fancyhouse
  ph_parkinglot
  ph_starship
  ph_fountain
  ph_arena
  ph_chinese
  ph_bank
  ph_saltfactory
  ph_motelblacke_redux
  ph_apartment_v2
  ph_spieje
  ph_house_v3
  ph_mansion_v1
  ph_diordna_hotel_2
  ph_houseplace
  ph_gas_stationrc7_xmas
  ph_grand_hotel_night";
    } elseif ($gameMode -eq 'terrortown') {
      $maps = "ttt_nuclear_power_b2
  ttt_camel_v1
  ttt_old_factory
  ttt_sewer_system
  ttt_skycity4
  ttt_slender_v3_fix
  
  ttt_theship_v1
  ttt_aircraft_v1b
  ttt_subway_b4
  ttt_minecraft_b5
  ttt_swimming_pool_v2
  ttt_traitorville_v2
  ttt_bb_teenroom_b2
  ttt_bb_outpost57_b5
  ttt_fastfood_a6
  ttt_community_bowling
  ttt_chaser
  ttt_icarus_r1_a2
  ttt_lttp_kakariko
  ttt_lumos
  ttt_mc_skyislands
  ttt_metropolis
  ttt_richland
  ttt_vessel
  ttt_terrortown
  ttt_casino_b2
  ttt_cluedo_b5_improved1
  ttt_oldruins";
    } elseif ($gameMode -eq 'murder') {
      $maps = "ph_office
  ph_restaurant";
    } elseif ($gameMode -eq 'sandbox') {
      $maps = "gm_construct";
    }
    $maps | Set-Content $gmodDir\garrysmod\cfg\mapcycle.txt;
    return $maps;
  }

  Function SetupServerConfig {
    param(
      [Parameter()]
      [string]$gameDir
    )
    $serverConfig = '// Hostname for server.
  // RCON - remote console password.
  rcon_password "mutmatt_r0x!"
  
  // Server password - for private servers.
  sv_password "tempfriends"
  
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
    $serverConfig | Set-Content $gameDir\garrysmod\cfg\server.cfg;
  }

  Function WorkshopItems {
    param(
        [Parameter()]
        [string]$workshopId, 
        [Parameter()]
        [string]$gameDir
      )

      Write-Output "resource.AddWorkshop("$workshopId")" | Out-File $gameDir\garrysmod\lua\autorun\server\workshop.lua -Encoding "ASCII"
      return "+host_workshop_collection $workshopId";
  }

  Function ShowInfoLog {
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
    Write-Host -ForegroundColor Green  "| you should have HL2 CS:S TF2 and this subscribe https://steamcommunity.com/sharedfiles/filedetails/?id=2043077893 |"
    Write-Host -ForegroundColor Red    "--------------------------------------------------------------------------------------------------------------------"
  }

  Function GetAuthKey{
    return "B69B3D3AAC2A179EA41E576C476BF8C4";
}