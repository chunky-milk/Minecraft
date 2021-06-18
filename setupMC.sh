#!/bin/sh -e

#determine if host system is 64 bit arm64 or 32 bit armhf
if [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 64)" ];then
  MACHINE='aarch64'
elif [ ! -z "$(file "$(readlink -f "/sbin/init")" | grep 32)" ];then
  MACHINE='armv7l'
else
  echo "Failed to detect OS CPU architecture! Something is very wrong."
fi
DIR=~/Minecraft

# create folders
if [ ! -d "$DIR" ]; then
    mkdir "$DIR"
fi
cd "$DIR"
pwd

if [ "$MACHINE" = "aarch64" ]; then
    echo "Raspberry Pi OS (64 bit)"
    if [ ! -d ~/lwjgl3arm64 ]; then
        mkdir ~/lwjgl3arm64
    fi
else
    echo "Raspberry Pi OS (32 bit)"
    if [ ! -d ~/lwjgl3arm32 ]; then
        mkdir ~/lwjgl3arm32
    fi
    if [ ! -d ~/lwjgl2arm32 ]; then
        mkdir ~/lwjgl2arm32
    fi
fi

# download minecraft launcher
if [ ! -f launcher.jar ]; then
    wget https://launcher.mojang.com/v1/objects/eabbff5ff8e21250e33670924a0c5e38f47c840b/launcher.jar
fi
 
# download java  
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f OpenJDK16U-jdk_aarch64_linux_hotspot_2021-05-08-12-45.tar.gz ]; then
        wget https://github.com/chunky-milk/Minecraft/releases/download/2021-05-08-12-45/OpenJDK16U-jdk_aarch64_linux_hotspot_2021-05-08-12-45.tar.gz
    fi
else
    if [ ! -f OpenJDK16U-jdk_arm_linux_hotspot_2021-05-08-12-45.tar.gz ]; then
        wget https://github.com/chunky-milk/Minecraft/releases/download/2021-05-08-12-45/OpenJDK16U-jdk_arm_linux_hotspot_2021-05-08-12-45.tar.gz
    fi
fi

# download lwjgl3arm*
if [ "$MACHINE" = "aarch64" ]; then
    if [ ! -f lwjgl3arm64.tar.gz ]; then
        wget https://github.com/chunky-milk/Minecraft/raw/main/lwjgl3arm64.tar.gz
    fi
else
    if [ ! -f lwjgl3arm32.tar.gz ]; then
        wget https://github.com/chunky-milk/Minecraft/raw/main/lwjgl3arm32.tar.gz
    fi
    if [ ! -f lwjgl2arm32.tar.gz ]; then
        wget https://github.com/chunky-milk/Minecraft/raw/main/lwjgl2arm32.tar.gz
    fi
fi

# extract oracle java  8
echo Extracting java ...
if [ "$MACHINE" = "aarch64" ]; then
    sudo tar -zxf OpenJDK16U-jdk_aarch64_linux_hotspot_2021-05-08-12-45.tar.gz -C /opt
    # install opnjdk for launcher.jar and optifine install
    sudo apt install openjdk-11-jdk -y
else
    sudo tar -zxf OpenJDK16U-jdk_arm_linux_hotspot_2021-05-08-12-45.tar.gz -C /opt
    # install openjdk for launcher and optifine if needed
    sudo apt install openjdk-11-jdk -y
fi

# extract lwjgl*
echo Extracting lwjgl...
if [ "$MACHINE" = "aarch64" ]; then
    tar -zxf lwjgl3arm64.tar.gz -C ~/lwjgl3arm64
else
    tar -zxf lwjgl3arm32.tar.gz -C ~/lwjgl3arm32
    tar -zxf lwjgl2arm32.tar.gz -C ~/lwjgl2arm32
fi

echo end setupMC
