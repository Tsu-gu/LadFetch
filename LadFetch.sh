#!/bin/bash

# Your system will run all of these commands. If it doesn't find let's say Zypper, it will just skip it and the output will be 0,
# therefore it wont affect the final sum'

packagesrpm=$(dnf list installed | wc -l)
clear
packagesdeb=$(apt list --installed | wc -l)
clear
packagesarch=$(pacman -Qi | grep "Name" | wc -l)
clear
packagessuse=$(zypper search -i | wc -l)
clear
packagesvoid=$(xbps-query -l | wc -l)
sum=$(( $packagesrpm + $packagesdeb + $packagesarch + $packagessuse + $packagesvoid))

packagesnixenv=$(nix-env -q | wc -l)
clear
# Delete this line in case the script is loading too slow / or you do not use AppImages
packagesappimage=$(ls -R | grep ".AppImage" | wc -l)
flatpak=$(flatpak list | wc -l)

kernel=$(uname -r)
who=$(whoami)
uptime=$(uptime -p | sed 's/up//' | sed -e 's/^[ \t]*//')
distro=$(cat /etc/*release | grep "PRETTY_NAME=" | sed 's/PRETTY_NAME=//' | sed 's/"//g')
DE=$(echo $XDG_CURRENT_DESKTOP)
# The last sed command removes any blank space at the beginning.
WM=$(wmctrl -m | grep Name: | sed 's/Name://' | sed -e 's/^[ \t]*//')
DS=$(echo $XDG_SESSION_TYPE)
CPU=$(lscpu | grep "Model name" | sed 's/Model name://' | sed -e 's/^[ \t]*//')
CPUa=$(lscpu | grep "Architecture" | sed 's/Architecture://' | sed -e 's/^[ \t]*//')
GPU=$(lspci  -v -s  $(lspci | grep ' VGA ' | cut -d" " -f 1) | grep "VGA compatible controller:" | sed 's/01:00.0 VGA compatible controller://' | sed -e 's/^[ \t]*//')
Res=$(xdpyinfo | awk '/dimensions/ {print $2}')

RAM=$(cat /proc/meminfo | grep MemTotal | sed 's/[^0-9]*//g' )
RAMtoMB=$(($RAM / 1024))

RAMavailable=$(cat /proc/meminfo | grep "MemAvailable" | sed 's/[^0-9]*//g')
RAMfree=$(($RAM - $RAMavailable))
Ramfreetomb=$(($RAMfree / 1024))

Drive=$(lsblk -b --output SIZE -n -d /dev/sda)
# The number converts bits to gigabites
DriveGB=$(($Drive / 1073741824))
Shell=$(echo $SHELL)
Python=$(python3 --version)
xorgversion=$(xdpyinfo | grep "X.Org version:" | sed 's/X.Org version://' | sed -e 's/^[ \t]*//')
# I'm afraid this might be broken for gnome-terminal users, as it prints out "bash"" instead. Works just fine on xfce tho.
Terminal=$(basename "$(cat "/proc/$PPID/comm")")

devicever=$(cat /sys/devices/virtual/dmi/id/product_version)
devicename=$(cat /sys/devices/virtual/dmi/id/product_name)
hostname=$(hostname)
# Clears the terminal from the errors
clear

echo -e "\e[0;39m------------------------------------------------------------------\e[0;39m"
echo -e "              \e[0;39m $who@$hostname - $devicename $devicever \e[0;39m"       
echo -e "\e[0;39m------------------------------------------------------------------\e[0;39m"
echo -e "       \e[1;31mDistribution:\e[1;31m \e[1;32m$distro\e[1;32m"
echo -e " \e[1;31mInstalled packages:\e[1;31m \e[1;32m$sum(Native)\e[1;32m \e[1;32m$flatpak(Flatpak) $packagesnixenv(nix-env) $packagesappimage(AppImage)\e[1;32m"
echo -e "             \e[1;31mUptime:\e[1;31m \e[1;32m$uptime\e[1;32m"
echo -e "             \e[1;31mKernel:\e[1;31m \e[1;32m$kernel\e[1;32m"
echo -e "\e[1;31mDesktop Environment:\e[1;31m \e[1;32m$DE\e[1;32m"
echo -e "     \e[1;31mWindow Manager:\e[1;31m \e[1;32m$WM\e[1;32m"
echo -e "     \e[1;31mDisplay Server:\e[1;31m \e[1;32m$DS ($xorgversion)\e[1;32m"
echo -e "              \e[1;31mShell:\e[1;31m \e[1;32m$Shell\e[1;32m"
echo -e "             \e[1;31mPython:\e[1;31m \e[1;32m$Python\e[1;32m"
echo -e "           \e[1;31mTerminal:\e[1;31m \e[1;32m$Terminal\e[1;32m"
echo -e "                \e[1;31mCPU:\e[1;31m \e[1;32m$CPU $CPUa"
echo -e "                \e[1;31mGPU:\e[1;31m \e[1;32m$GPU\e[1;32m"
echo -e "         \e[1;31mResolution:\e[1;31m \e[1;32m$Res\e[1;32m"
echo -e "                \e[1;31mRAM:\e[1;31m \e[1;32m$Ramfreetomb/$RAMtoMB MB\e[1;32m"
echo -e "          \e[1;31mDisk Size:\e[1;31m \e[1;32m$DriveGB GB\e[1;32m"

# Keep this or else the window dissapears right after the script finishes.
sleep 5000 
