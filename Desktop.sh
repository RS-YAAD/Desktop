#!/bin/bash
    r='\033[1;31m'
    g='\033[1;32m'
    c='\033[1;36m'
    w='\033[1;37m'
    n='\033[0m'
    bg='\033[42m'
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

upkg(){
    pkgs=( "pulseaudio" "proot-distro" "wget" )
    for pkg in "${pkgs[@]}";do    
    command -v $pkg >/dev/null 2>&1 || { echo -e >&2 "${g}$pkg ${N}: ${r}Not Installed... ${g}Wait For Install It" && apt-get install $pkg -y
    }
done
}

inubuntu(){
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
        echo -e "${c} [${n}-${c}]${g} Ubuntu already installed.${n}"
        exit 0
    else
        echo -e "${g} Installing Ubuntu${n}"
        proot-distro install ubuntu
    fi
    
    if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
        echo -e "${c} [${n}-${c}]${g} Installed Successfull${n}"
    else
        echo -e "\n${c} [${r}!${c}]${r} Error Installing Ubuntu${n}"
        exit 0
    fi
        if [[ ! -e "$HOME/.sound" ]]; then
        touch $HOME/.sound
    fi    
    echo "pulseaudio --start --exit-idle-time=-1" >> $HOME/.sound
    echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> $HOME/.sound

       if [[ -e "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/gui.sh" ]]; then
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/gui.sh
    else
        wget https://raw.githubusercontent.com/RS-YAAD/Desktop/main/uFile/gui.sh
        mv -f gui.sh $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/gui.sh
        chmod +x $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/gui.sh
    fi
        echo "proot-distro login ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > $PREFIX/bin/ubuntu

        if [[ -e "$PREFIX/bin/ubuntu" ]]; then
        chmod +x $PREFIX/bin/ubuntu
        termux-reload-settings
        banner
        msg
        exit 0
    else
        echo -e "${c} [${r}!${c}]${r} Error Installing Distro!${n}"
        exit 0
        fi
}

setup_config() {
	configs=($(ls -A $(pwd)/files))
	echo -e "${g}\n[*] Backing up your files and dirs...${n}"
	for file in "${configs[@]}"; do
		echo -e "${g}\n[*] Backing up $file...${n}"
		if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
			{ mv -u ${HOME}/${file}{,.old}; }
		else
			echo -e "${r}\n[!] $file Doesn't Exist.${n}"			
		fi
	done
	
	# Copy config files
	echo -e "${g}\n[*] Coping config files... "
	for _config in "${configs[@]}"; do
		echo -e "${g}\n[*] Coping $_config...${n}"
		{ cp -rf $(pwd)/files/$_config $HOME; }
	done
	if [[ ! -d "$HOME/Desktop" ]]; then
		mkdir $HOME/Desktop
	fi
}

setup_vnc() {
	if [[ -d "$HOME/.vnc" ]]; then
		mv $HOME/.vnc{,.old}
	fi
	echo -e "${g}\n[*] Setting up VNC Server...${n}"
	{ vncserver -localhost; }
	sed -i -e 's/# geometry=.*/geometry=1366x768/g' $HOME/.vnc/config
	cat > $HOME/.vnc/xstartup <<- _EOF_
		#!/data/data/com.termux/files/usr/bin/bash
		## This file is executed during VNC server
		## startup.
		# Launch Openbox Window Manager.
		openbox-session &
	_EOF_
	if [[ $(pidof Xvnc) ]]; then
		    echo -e "${g}[*] Server Is Running...${n}"
		    { vncserver -list; }
	fi
}

setup_launcher() {
	file="$HOME/.local/bin/startdesktop"
	if [[ -f "$file" ]]; then
		rm -rf "$file"
	fi
	echo -e "${g}\n[*] Creating Launcher Script... \n"
	{ touch $file; chmod +x $file; }
	cat > $file <<- _EOF_
		#!/data/data/com.termux/files/usr/bin/bash
		# Export Display
		export DISPLAY=":1"
		# Start VNC Server
		if [[ \$(pidof Xvnc) ]]; then
		    echo -e "\\n[!] Server Already Running."
		    { vncserver -list; echo; }
		    read -p "Kill VNC Server? (Y/N) : "
		    if [[ "\$REPLY" == "Y" || "\$REPLY" == "y" ]]; then
		        { killall Xvnc; echo; }
		    else
		        echo
		    fi
		else
		    echo -e "\\n[*] Starting VNC Server..."
		    vncserver
		fi
	_EOF_
	if [[ -f "$file" ]]; then
		echo -e "${g}[*] Script ${c}$file ${g}created successfully.${n}"
	fi
}
u_msg(){
    echo -e "${g}\n[*] Ubuntu Installed Successfull.\n${n}"
    echo -e "${c}[-] Restart termux and enter ${g}ubuntu ${c}command for start the Ubuntu..\n	[-] Then type gui.sh in Ubuntu for setup VNC.${n}"
}
t_msg() {
	echo -e "${g}\n[*] Termux Desktop Installed Successfull.\n${n}"
echo -e "${c}[-] Restart termux and enter ${g}startdesktop ${c}command to start the VNC server.\n${c}[-] In VNC client, enter ${g}127.0.0.1:5901 ${c}as Address and Password you created to connect.	\n	[-] To connect via PC over Wifi or Hotspot, use it's IP, ie: ${g}192.168.43.1:5901 ${c}to connect. Also, use TigerVNC client.	\n[-] Make sure you enter the correct port. ie: If server is running on ${g}Display :2 ${c}then port is ${g}5902 ${c}and so on.${n}"
	{ exit 0; }
}


setup_base() {
	echo -e "${g}\n[*] Installing Termux Desktop..."
	echo -e "${g}\n[*] Updating Termux Base... \n${n}"
	{ pkg autoclean; pkg upgrade -y; }
	echo -e "${g}\n[*] Enabling Termux X11-repo... \n${n}"
	{ pkg install -y x11-repo; }
	echo -e "${g}\n[*] Installing required programs... \n"
	tpkgs=( "bc" "bmon" "calc" "calcurse" "curl" "dbus" "desktop-file-utils" "elinks" "feh" "fontconfig-utils" "fsmon" "geany" "gtk2" "gtk3" "htop-legacy" "imagemagick" "jq" "leafpad" "man" "mpc" "mpd" "mutt" "ncmpcpp" "ncurses-utils" "neofetch" "netsurf" "obconf" "openbox" "openssl-tool" "polybar" "ranger" "rofi" "startup-notification" "termux-api" "thunar" "tigervnc" "vim" "wget" "xarchiver" "xbitmaps" "xcompmgr" "xfce4-settings" "xfce4-terminal" "xmlstarlet" "xorg-font-util" "xorg-xrdb" "zsh")
    for pkg in "${tpkgs[@]}";do    
    command -v $pkg >/dev/null 2>&1 || { echo -e >&2 "${g}$pkg ${N}: ${r}Not Installed... ${g}Wait For Install It" && apt-get install $pkg -y
    }
	done	
}


banner(){
    echo -e "${g}
██████╗░███████╗░██████╗██╗░░██╗████████╗░█████╗░██████╗░
██╔══██╗██╔════╝██╔════╝██║░██╔╝╚══██╔══╝██╔══██╗██╔══██╗
██║░░██║█████╗░░╚█████╗░█████═╝░░░░██║░░░██║░░██║██████╔╝
██║░░██║██╔══╝░░░╚═══██╗██╔═██╗░░░░██║░░░██║░░██║██╔═══╝░
██████╔╝███████╗██████╔╝██║░╚██╗░░░██║░░░╚█████╔╝██║░░░░░
╚═════╝░╚══════╝╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░░░░${n}
\t\t${bg}  Creator: RS YAAD  \n\t\tRepositorie: Desktop${n}"
}
    
list(){
    echo -e "\n${c}[${g}1${c}]${g} Termux Gui\n${c}[${g}2${c}]${g} Ubuntu Install+Gui\n${c}[${g}3${c}]${g} Kali Linux Install+Gui\n${c}[${g}4${c}]${g}Update Tool \n${c}[${g}5${c}]${g} Contact With Me\n${n}"
}

listc(){
    echo -e "\n${c}[${g}1${c}]${g} Facebook\n${c}[${g}2${c}]${g} Messenger\n${c}[${g}3${c}]${g} Gmail${n}"
}


termux(){
    read -p "Press enter for install" enter
    echo -e "${g} Please wait for checking package${n}"
    git clone https://github.com/adi1090x/termux-desktop; cd termux-desktop; chmod +x setup.sh; ./setup.sh --install
}



#start
clear
loading
clear
banner
list
echo -en "${c}[${g}+${c}]${g} Choice A Option: "
read op
case $op in

1) echo -ne "\t\t${c}LOADING ${g}"
for((;T++<=10;)) { printf '>'; sleep 0.2; }
   setup_base
   setup_config
   setup_vnc
   setup_launcher
   clear
   banner
   echo -e "\n\n"
   t_msg
;;
2) echo -ne "\t\t${c}LOADING ${g}"
for((;T++<=10;)) { printf '>'; sleep 0.2; }
   upkg
   inubuntu
   clear
   banner
   echo -e "\n\n"
   u_msg
;;
3) echo -ne "\t\t${c}LOADING ${g}"
for((;T++<=10;)) { printf '>'; sleep 0.2; }
   echo -e "${g} Coming Soon... please wait for next update${n}"
;;
4) rm -rf $HOME/Desktop
   git clone https://github.com/RS-YAAD/Desktop
   cd Desktop; chmod +x Desktop.sh; bash Desktop.sh
;;
5) echo -ne "\t\t${c}LOADING ${g}"
for((;T++<=10;)) { printf '>'; sleep 0.2; }
   listc
   echo -en "${c}[${g}+${c}]${g} Choice A Option: "
   read opc
   case $opc in
   1) echo -e "${g}Facebook: ${c}\n${g}FB Link:${c} https://www.facebook.com/its.rs.yaad"
      xdg-open "https://www.facebook.com/its.rs.yaad"
      read -p "Press enter for menu" enter
      bash Desktop.sh
      ;;
   2) echo -e "${g}Messenger:${c} RS YAAD\nMessenger Link: ${c}https://m.me/its.rs.yaad"
      xdg-open "https://m.me/its.rs.yaad"
      read -p "Press enter for menu" enter
      bash Desktop.sh
      ;;
   3) echo -e "${g}Gmail:${c} RS YAAD\n${g}Gmail Link: ${c}its.rs.yaad@gmail.com"
      xdg-open "mailto: its.rs.yaad@gmail.com"
      read -p "Press enter for menu" enter
      bash Desktop.sh
      ;;
   *) echo -e "${r}Wrong Input......."
      sleep 1
      clear
      bash Desktop.sh
      ;;
      esac
;;
*) echo -e "${r}Wrong Input......."
sleep 1
clear
bash Desktop.sh
;;
esac
 
