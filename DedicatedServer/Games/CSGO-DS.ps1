Function GetCSGOGameModeTypeArgs {
    param(
        [Parameter()]
        [string] $gameType,
        [Parameter()]
        [string] $gameMode
      )

    if($gameType -eq "classic") {
        $type = "0";
        if ($gameMode -eq "casual") {
            $mode = "0";
        } elseif($gameMode -eq "competitive" -or $gameMode -eq "comp") {
            $mode = "1";
        } elseif($gameMode -eq "scrimcomp2v2") {
            $mode = "2";
        } elseif($gameMode -eq "scrimcomp5v5") {
            $mode = "3";
        } else {
            $mode = "0";
        }
    } elseif($gameType -eq "gungame") {
        $type = "1";
        if($gameMode -eq "gungameprogressive") {
            $mode = "0";
        } elseif($gameMode -eq "gungametrbomb") {
            $mode = "1";
        } elseif($gameMode -eq "deathmatch") {
            $mode = "2";
        } else {
            $mode = "0";
        }
    } elseif($gameType -eq "training") {
        $type = "2";
        $mode = "0";
    } elseif($gameType -eq "custom") {
        $type = "3";
        $mode = "0";
    } elseif($gameType -eq "cooperative" -or $gameType -eq "coop" -or $gameType -eq "co-op") {
        $type = "4";
        if($gameMode -eq "cooperative" -or $gameMode -eq "coop" -or $gameMode -eq "co-op") {
            $mode = "0";
        } elseif ($gameMode -eq "coopmission") {
            $mode = "1";
        } else {
            $mode = "0";
        }
    } elseif($gameType -eq "skirmish") {
        $type = "5";
        $mode = "0";
    } elseif($gameType -eq "freeforall" -or $gameType -eq "ffa") {
        $type = "6";
        $mode = "0";
    } else {
        $type = "0";
        $mode = "0";
    }

    return "+game_type $type +game_mode $mode";
}

Function GetCSGOGameArgs {
    param(
    [Parameter()]
    [string] $_gameType,
    [Parameter()]
    [string] $_gameMode
  )  

  $gameModeTypeArgs = GetCSGOGameModeTypeArgs -gameType $_gameType -gameMode $_gameMode
  
  return "-game csgo $gameModeTypeArgs"
}

Function SetupMapRotation {
    param(
      [Parameter()]
      [string]$csgoDir
    )

      $maps = "cs_italy
  cs_office
  cs_militia
  cs_assault
  de_train
  de_dust2
  de_inferno
  de_mirage
  de_nuke
  de_vertigo
  de_overpass
  de_cbble
  de_canals";
    $maps | Set-Content $csgoDir\csgo\mapcycle.txt;
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
    $serverConfig | Set-Content $gameDir\csgo\cfg\server.cfg;
  }

  Function ShowInfoLog {
    Write-Host -ForegroundColor Red    "IT WORKED!"
  }

  Function GetAuthKey{
      return "5D92E243EF284E0F0097894B2BF58EAC";
  }

  Function WorkshopItems {
    param(
        [Parameter()]
        [string]$workshopId, 
        [Parameter()]
        [string]$gameDir
      )

      #Write-Output "resource.AddWorkshop("$workshopId")" | Out-File $gameDir\garrysmod\lua\autorun\server\workshop.lua -Encoding "ASCII"
      #return "+host_workshop_collection $workshopId";
  }