#!/bin/bash

#variables
Ryujinx_emuName="Ryujinx"
Ryujinx_emuType="Binary"
Ryujinx_emuPath="$HOME/Applications/publish/"

#cleanupOlderThings
Ryujinx_cleanup(){
    echo "Begin Ryujinx Cleanup"
}

#Install
Ryujinx_install(){
    echo "Begin Ryujinx Install"
    installEmuBI "Ryujinx"  "$(getReleaseURLGH "Ryujinx/release-channel-master" "-linux_x64.tar.gz")" "Ryujinx" "tar.gz"
    tar -xvf "$HOME/Applications/Ryujinx.tar.gz" -C "$HOME/Applications/"
    chmod +x "$HOME/Applications/publish/Ryujinx"
    rm -rf "$HOME/Applications/Ryujinx.tar.gz"
}

#ApplyInitialSettings
Ryujinx_init(){
    echo "Begin Ryujinx Init"

    configEmuAI "Ryujinx" "config" "$HOME/.config/Ryujinx" "$EMUDECKGIT/configs/Ryujinx" "true"
    
    Ryujinx_setEmulationFolder
    Ryujinx_setupStorage
    Ryujinx_finalize

}

#update
Ryujinx_update(){
    echo "Begin Ryujinx update"
    
    configEmuAI "yuzu" "config" "$HOME/.config/Ryujinx" "$EMUDECKGIT/configs/Ryujinx"
    
    Ryujinx_setEmulationFolder
    Ryujinx_setupStorage
    Ryujinx_finalize
}



#ConfigurePaths
Ryujinx_setEmulationFolder(){
    echo "Begin Ryujinx Path Config"
#     configFile="$HOME/.config/yuzu/qt-config.ini"
#     screenshotDirOpt='Screenshots\\screenshot_path='
#     gameDirOpt='Paths\\gamedirs\\4\\path='
#     dumpDirOpt='dump_directory='
#     loadDir='load_directory='
#     nandDirOpt='nand_directory='
#     sdmcDirOpt='sdmc_directory='
#     tasDirOpt='tas_directory='
#     newScreenshotDirOpt='Screenshots\\screenshot_path='"${storagePath}/yuzu/screenshots"
#     newGameDirOpt='Paths\\gamedirs\\4\\path='"${romsPath}/switch"
#     newDumpDirOpt='dump_directory='"${storagePath}/yuzu/dump"
#     newLoadDir='load_directory='"${storagePath}/yuzu/load"
#     newNandDirOpt='nand_directory='"${storagePath}/yuzu/nand"
#     newSdmcDirOpt='sdmc_directory='"${storagePath}/yuzu/sdmc"
#     newTasDirOpt='tas_directory='"${storagePath}/yuzu/tas"
# 
# 
#     sed -i "/${screenshotDirOpt}/c\\${newScreenshotDirOpt}" "$configFile"
#     sed -i "/${gameDirOpt}/c\\${newGameDirOpt}" "$configFile"
#     sed -i "/${dumpDirOpt}/c\\${newDumpDirOpt}" "$configFile"
#     sed -i "/${loadDir}/c\\${newLoadDir}" "$configFile"
#     sed -i "/${nandDirOpt}/c\\${newNandDirOpt}" "$configFile"
#     sed -i "/${sdmcDirOpt}/c\\${newSdmcDirOpt}" "$configFile"
#     sed -i "/${tasDirOpt}/c\\${newTasDirOpt}" "$configFile"

    #Setup Bios symlinks
    unlink "${biosPath}/ryujinx/keys"    
    mkdir -p "$HOME/.config/Ryujinx/system/"
    mkdir -p "${biosPath}/ryujinx/"
    ln -sn "$HOME/.config/Ryujinx/system" "${biosPath}/ryujinx/keys"
    
    #Disabled until further investigation
    #Ryujinx_convertFromYuzu

}

#SetupSaves
Ryujinx_setupSaves(){
    echo "Begin Ryujinx save link"
    #Ryu saves the games in the same folder as the shaders...
    #linkToSaveFolder ryujinx saves "${storagePath}/ryujinx/games/" 
}


#SetupStorage
Ryujinx_setupStorage(){
    echo "Begin Ryujinx storage config"
    
    origPath="$HOME/.config/"
    mkdir -p "${storagePath}/ryujinx/"
    rsync -av "${origPath}/Ryujinx/games/" "${storagePath}/ryujinx/games/" && rm -rf "${origPath}Ryujinx/games"
    ln -ns "${storagePath}/ryujinx/games/" "${origPath}/Ryujinx/games" 
        
}


#WipeSettings
Ryujinx_wipe(){
    echo "Begin Ryujinx delete config directories"
    rm -rf "$HOME/.config/Ryujinx"
}


#Uninstall
Ryujinx_uninstall(){
    echo "Begin Ryujinx uninstall"
    rm -rf "$Ryujinx_emuPath"
}

#Migrate
Ryujinx_migrate(){
    echo "Begin Ryujinx Migration"
    emu="Ryujinx"
#     migrationFlag="$HOME/emudeck/.${emu}MigrationCompleted"
#     #check if we have a nomigrateflag for $emu
#     if [ ! -f "$migrationFlag" ]; then	
#         #yuzu flatpak to appimage
#         #From -- > to
#         migrationTable=()
#         migrationTable+=("$HOME/.var/app/org.yuzu_emu.yuzu/data/yuzu" "$HOME/.local/share/yuzu")
#         migrationTable+=("$HOME/.var/app/org.yuzu_emu.yuzu/config/yuzu" "$HOME/.config/yuzu")
# 
#         migrateAndLinkConfig "$emu" "$migrationTable"
#     fi

    #move data from hidden folders out to these folders in case the user already put stuff here.
    origPath="$HOME/.config/"

    Ryujinx_setupStorage
    
    rsync -av "${origPath}Ryujinx/games" "${storagePath}/ryujinx/games" && rm -rf "${origPath}Ryujinx/games"
    ln -s "${storagePath}/ryujinx/games" "${origPath}ryujinx/games" 
}

Ryujinx_convertFromYuzu(){
    echo "Begin converting firmware from Yuzu"
    for entry in $biosPath/yuzu/firmware/*.nca
    do
        folder=${entry##*/}
        mkdir -p "$HOME/.config/Ryujinx/bis/system/Contents/registered/$folder/"
        cp $entry "$HOME/.config/Ryujinx/bis/system/Contents/registered/$folder/00"
        
    done
}


#setABXYstyle
Ryujinx_setABXYstyle(){
echo "NYI"
}

#WideScreenOn
Ryujinx_wideScreenOn(){
echo "NYI"
}

#WideScreenOff
Ryujinx_wideScreenOff(){
echo "NYI"
}

#BezelOn
Ryujinx_bezelOn(){
echo "NYI"
}

#BezelOff
Ryujinx_bezelOff(){
echo "NYI"
}

#finalExec - Extra stuff
Ryujinx_finalize(){
    echo "Begin Ryujinx finalize"
}