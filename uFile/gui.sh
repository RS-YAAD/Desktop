#!/bin/bash
r='\033[1;31m'     
g='\033[1;32m'     
c='\033[1;36m'     
w='\033[1;37m'
n='\033[0m' 

banner(){
   echo -e "${g} 
██╗░░░██╗██████╗░██╗░░░██╗███╗░░██╗████████╗██╗░░░██╗
██║░░░██║██╔══██╗██║░░░██║████╗░██║╚══██╔══╝██║░░░██║
██║░░░██║██████╦╝██║░░░██║██╔██╗██║░░░██║░░░██║░░░██║
██║░░░██║██╔══██╗██║░░░██║██║╚████║░░░██║░░░██║░░░██║
╚██████╔╝██████╦╝╚██████╔╝██║░╚███║░░░██║░░░╚██████╔╝
░╚═════╝░╚═════╝░░╚═════╝░╚═╝░░╚══╝░░░╚═╝░░░░╚═════╝░

░██████╗░██╗░░░██╗██╗
██╔════╝░██║░░░██║██║
██║░░██╗░██║░░░██║██║
██║░░╚██╗██║░░░██║██║
╚██████╔╝╚██████╔╝██║
░╚═════╝░░╚═════╝░╚═╝${n}"
}

progress() {
    PRC=`printf "%.0f" ${1}`
    SHW=`printf "%3d\n" ${PRC}`
    LNE=`printf "%.0f" $((${PRC}/2))`
    LRR=`printf "%.0f" $((${PRC}/2-12))`; if [ ${LRR} -le 0 ]; then LRR=0; fi;
    LCC=`printf "%.0f" $((${PRC}/2-36))`; if [ ${LCC} -le 0 ]; then LCC=0; fi;
    LGG=`printf "%.0f" $((${PRC}/2-48))`; if [ ${LGG} -le 0 ]; then LGG=0; fi;
    LRR_=""
    LCC_=""
    LGG_=""
    for ((i=1;i<=13;i++))
    do
    	DOTS=""; for ((ii=${i};ii<13;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}#"; else LRR_="${LRR_}."; fi  
    	echo -ne "  ${w}${SEC}  ${r}${LRR_}${DOTS}${c}............${g}............ ${SHW}%${n}\r" 	
    	if [ ${LNE} -ge 14 ]; then sleep .01; fi
    done
    for ((i=26;i<=37;i++))
    do
    	DOTS=""; for ((ii=${i};ii<37;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}#"; else LCC_="${LCC_}."; fi
    	echo -ne "  ${w}${SEC}  ${r}${LRR_}${LY}${LYY_}${c}${LCC_}${DOTS}${g}............ ${SHW}%${n}\r"
    	if [ ${LNE} -ge 26 ]; then sleep .01; fi
    done
    for ((i=38;i<=49;i++))
    do
    	DOTS=""; for ((ii=${i};ii<49;ii++)); do DOTS="${DOTS}."; done
    	if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}#"; else LGG_="${LGG_}."; fi
    	echo -ne "  ${w}${SEC}  ${r}${LRR_}${LY}${LYY_}${c}${LCC_}${g}${LGG_}${DOTS} ${SHW}%${n}\r"
    	if [ ${LNE} -ge 38 ]; then sleep .01; fi
    done
}

loading (){
printf "\n\n\n\n\n\n\n\n"
echo -ne "\n\n\n\n\n\n\n"
progress 0
progress 5
progress 10
progress 15
progress 20
progress 25
progress 30
progress 35
progress 40
progress 45
progress 50
progress 55
progress 60
progress 65
progress 70
progress 75
progress 80
progress 85
progress 90
progress 95
progress 100
printf "\n\n\n\n\n\n\n\n"
}

sudo() {
    echo -e "${c} [${n}-${c}]${g} Installing Sudo...${n}"
    apt update -y
    apt install sudo -y
    apt install wget apt-utils locales-all dialog -y
}

login() {
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\en' user
    echo -e "${w}"
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m\en' pass
    echo -e "${w}"
    useradd -m -s $(which bash) ${user}
    echo "${user}:${pass}" | chpasswd
    echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "proot-distro login --user $user ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/ubuntu
chmod +x /data/data/com.termux/files/usr/bin/ubuntu
}


upkg() {
    echo -e "${c} [${n}-${c}]${g} Checking required packages...${n}"
    sudo apt-get update -y
    sudo apt-get upgrade -y 
    sudo apt install udisks2 -y
    sudo rm /var/lib/dpkg/info/udisks2.postinst
    echo "" > /var/lib/dpkg/info/udisks2.postinst
    sudo dpkg --configure -a
    sudo apt-mark hold udisks2
    pkgs=("sudo" "curl" "dialog" "dbus-x11" "exo-utils" "firefox" "fonts-beng-extra" "fonts-beng" "gnupg2" "gtk2-engines-pixbuf" "gtk2-engines-murrine" "inetutils-tools" "keyboard-configuration" "librsvg2-common" "mpv" "menu" "tzdata" "tigervnc-standalone-server" "tigervnc-common" "tigervnc-tools" "vlc" "wget" "xfce4" "xfce4-goodies" "xfce4-terminal")
    for pkg in "${pkgs[@]}"; do
        type -p "$pkg" &>/dev/null || {
            echo -e "${g}$pkg ${N}: ${r}Not Installed... ${g}Wait For Install It"
            sudo apt-get install "$pkg" -y --no-install-recommends
        }
    done    
}


chromium() {
    echo -e "${c} [${n}-${c}]${g} Uninstalling OLD chromium...${n}"
    chrome=(chromium* chromium-browser* snapd)
    for pkg in "${chrome[@]}"; do
        type -p "$pkg" &>/dev/null || {
            echo -e "\n${c} [${n}-${c}]${g} Installing new chromium package ${n}: ${g}$pkg${n}"
            apt purge "$pkg" -y 
            sudo apt purge "$pkg" -y 
        }
    done
    sudo apt install software-properties-common gnupg2 --no-install-recommends -y
    echo -e "${c} [${n}-${c}]${g} Installing Chromium...${n}"
    sudo echo "deb http://ftp.debian.org/debian buster main
deb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    sudo apt update -y
    sudo apt install chromium -y
    sudo sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop
    sudo apt-get upgrade -y
}


sublime() {
	 echo
  sudo apt install gnupg2 -y
	sudo apt install  software-properties-common gnupg2 --no-install-recommends -y
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install sublime-text -y 
}


vscode() {
	 echo
  sudo apt install gnupg2 -y 
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt install apt-transport-https -y
    sudo apt update -y
    sudo apt install code -y
  echo -e "${g}Patching vscode...${n}"
  echo
  mv /data/data/com.termux/files/home/modded-ubuntu/patches/code.desktop /usr/share/applications/
}

refs() {
   echo -e "${g} Installing theme${n}"
    sudo apt update && yes | sudo apt install gnupg2
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    sudo apt-get upgrade -y
    sudo apt install gnupg2 gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin -y
    echo
    git clone --depth=1 https://github.com/vinceliuice/Layan-gtk-theme.git $HOME/Layan-gtk-theme
    sudo chmod +x $HOME/Layan-gtk-theme/install.sh
    sudo bash $HOME/Layan-gtk-theme/install.sh
	
	git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/WhiteSur-gtk-theme
	sudo chmod +x $HOME/WhiteSur-gtk-theme/install.sh
	sudo bash $HOME/WhiteSur-gtk-theme/install.sh
	
	git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/WhiteSur-icon-theme
	sudo chmod +x $HOME/WhiteSur-icon-theme/install.sh
	sudo bash $HOME/WhiteSur-icon-theme/install.sh 
	

    git clone --depth=1 https://github.com/vinceliuice/Qogir-icon-theme.git $HOME/Qogir-icon-theme
    sudo chmod +x $HOME/Qogir-icon-theme/install.sh
    sudo bash $HOME/Qogir-icon-theme/install.sh --name ubuntu  

    sudo apt update -y
}

add_sound() {
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu
}

clenup() {
	echo -e "${g}Cleaning up system..${n}"
	echo
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
	sudo rm -rf $HOME/WhiteSur-gtk-theme $HOME/WhiteSur-icon-theme $HOME/Layan-gtk-theme $HOME/Qogir-icon-theme
}

vnc() {
    echo -e "${c} [${n}-${c}]${g} Setting up VNC Server...${n}"

    if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi

    if [[ -e "$HOME/.vnc/xstartup" ]]; then
        rm -rf $HOME/.vnc/xstartup
    fi

    wget https://raw.githubusercontent.com/RS-YAAD/Desktop/main/uFile/xstartup
    mv -f xstartup $HOME/.vnc/xstartup
    chmod +x $HOME/.vnc/xstartup

    if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi

    wget https://raw.githubusercontent.com/RS-YAAD/Desktop/main/uFile/vncstart
    mv -f vncstart /usr/local/bin/vncstart
    chmod +x /usr/local/bin/vncstart

    if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi

    wget https://raw.githubusercontent.com/RS-YAAD/Desktop/main/uFile/vncstop
    mv -f vncstop /usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop

    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
    source /etc/profile

}

note() {
    echo -e "${c}[${g}-${c}]${g} Installed Successfully${n}"
    echo
    echo -e "${c}[${g}-${c}]${g} Type ${c}vncstart${g} for run VNCserver.${n}"
    echo
    echo -e "${c}[${g}-${c}]${g} Type ${c}vncstop${g} for stop VNCserver.${n}"
    echo
    echo -e "${c}[${g}-${c}]${g} Open VNC VIEWER apk & Click on ${c}+ ${g}Button.${n}"
    echo
    echo -e "${c}[${g}-${c}]${g} Enter the Address ${c}localhost:1 ${g}& Name anything.${n}"
    echo
    echo -e "${c}[${g}-${c}]${g} Set the Picture Quality to High for better Quality.${n}"
    echo
    echo -e "${c}[${g}-${c}]${g} Click on ${c}Connect ${g}& Input the ${c}Password ${n}"
    echo
}


#start
clear
loading
clear
banner
sudo
login
upkg
chromium
sublime
vscode
refs
add_sound
clenup
vnc
clear
banner
note
