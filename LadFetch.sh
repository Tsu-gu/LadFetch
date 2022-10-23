#!/bin/bash

kernel=$(uname -r)
ktosom=$(whoami)
packagesrpm=$(dnf list installed | wc -l)
packagesdeb=$(apt list --installed | wc -l)
packagesarch=$(pacman -Qi | grep "Name" | wc -l)
packagesnixenv=$(nix-env -q | wc -l)

# Delete this line in case the script is loading too slow / or you do not use AppImages
packagesappimage=$(ls -R | grep ".AppImage" | wc -l)

flatpak=$(flatpak list | wc -l)
uptime=$(uptime -p | sed 's/up//' | sed -e 's/^[ \t]*//')
distro=$(cat /etc/*release | grep "PRETTY_NAME=" | sed 's/PRETTY_NAME=//' | sed 's/"//g')
DE=$(echo $XDG_CURRENT_DESKTOP)
WM=$(wmctrl -m | grep Name: | sed 's/Name://' | sed -e 's/^[ \t]*//')
DS=$(echo $XDG_SESSION_TYPE)
CPU=$(lscpu | grep "Model name" | sed 's/Model name://' | sed -e 's/^[ \t]*//')
GPU=$(lspci  -v -s  $(lspci | grep ' VGA ' | cut -d" " -f 1) | grep "VGA compatible controller:" | sed 's/01:00.0 VGA compatible controller://' | sed -e 's/^[ \t]*//')
Res=$(xdpyinfo | awk '/dimensions/ {print $2}')
RAM=$(cat /proc/meminfo | grep MemTotal | sed 's/[^0-9]*//g' )
RAMtoMB=$(($RAM / 1024))
Drive=$(lsblk -b --output SIZE -n -d /dev/sda)
DriveGB=$(($Drive / 1073741824))
Shell=$(echo $SHELL)
Python=$(python3 --version)
echo -e "\e[0;39m-----------------------------LadFetch-------------------------------\e[0;39m"
echo -e "\e[1;31mDistro:\e[1;31m \e[1;32m$distro\e[1;32m"
echo -e "\e[1;31mInstalled packages:\e[1;31m \e[1;32m$packagesrpm(RPM) $packagesdeb(DEB) $packagesarch(ARCH) $flatpak(Flatpak) $packagesnixenv(nix-env) $packagesappimage(AppImage)\e[1;32m"
echo -e "\e[1;31mUptime:\e[1;31m \e[1;32m$uptime\e[1;32m"
echo -e "\e[1;31mUsername:\e[1;31m \e[1;32m$ktosom\e[1;32m"
echo -e "\e[1;31mKernel:\e[1;31m \e[1;32m$kernel\e[1;32m"
echo -e "\e[1;31mDesktop Environment:\e[1;31m \e[1;32m$DE\e[1;32m"
echo -e "\e[1;31mWindow Manager:\e[1;31m \e[1;32m$WM\e[1;32m"
echo -e "\e[1;31mDisplay Server:\e[1;31m \e[1;32m$DS\e[1;32m"
echo -e "\e[1;31mCPU:\e[1;31m \e[1;32m$CPU\e[1;32m"
echo -e "\e[1;31mGPU:\e[1;31m \e[1;32m$GPU\e[1;32m"
echo -e "\e[1;31mResolution:\e[1;31m \e[1;32m$Res\e[1;32m"
echo -e "\e[1;31mRAM:\e[1;31m \e[1;32m$RAMtoMB MB\e[1;32m"
echo -e "\e[1;31mDisk Size:\e[1;31m \e[1;32m$DriveGB GB\e[1;32m"
echo -e "\e[1;31mShell:\e[1;31m \e[1;32m$Shell\e[1;32m"
echo -e "\e[1;31mPython:\e[1;31m \e[1;32m$Python\e[1;32m"
echo -e "\e[0;39m--------------------------------------------------------------------\e[0;39m"
sleep 5000 # Else the window dissapears right after the script finishes.
