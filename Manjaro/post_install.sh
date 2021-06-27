#!/bin/bash

# Add your GitHub details here:
GITHUB_USERNAME=""
GITHUB_EMAIL_ID=""
GIT_CLI_EDITOR=""

clear

banner() {
    printf "\n\n\n"
    msg="| $* |"
    edge=$(echo "$msg" | sed 's/./-/g')
    echo "$edge"
    echo "$msg"
    echo "$edge"
}


pause() {
    read -s -n 1 -p "Press any key to continue . . ."
    clear
}


enable_grub_menu() {
    # Find & Replace part contributed by: https://github.com/nanna7077
    clear
    banner "Showing the GRUB menu at boot"
    printf "\n\nThe script will change the grub default file."
    printf "\n\nThe file is: /etc/default/grub\n"
    printf "\nIn that file, there will be a line that looks like this:"
    printf "\n\n     GRUB_TIMEOUT=5\n\n"
    printf "\nThe script will change the value of GRUB_TIMEOUT to -1.\n"

    SUBJECT='/etc/default/grub'
    SEARCH_FOR='GRUB_TIMEOUT='
    sudo sed -i "/^$SEARCH_FOR/c\GRUB_TIMEOUT=-1" $SUBJECT
    printf "\n/etc/default/grub file changed.\n"

    banner "Showing the GRUB menu at boot"
    printf "\n\nGenerating the new GRUB configuration\n\n"
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    printf "\n\nGRUB config updated. It will be reflected in the next boot.\n\n"
}


nf_bash_xclip() {
    banner "Installing: neofetch bash-completion xorg-xclip"
    yes | sudo pacman -S neofetch bash-completion xorg-xclip
}


gitsetup() {
    banner "Setting up SSH for git and GitHub"
    
    if [ $GITHUB_EMAIL_ID != "" && $GITHUB_USERNAME != "" && $GIT_CLI_EDITOR != ""]
    then
        printf "\n - Configuring GitHub username as: ${GITHUB_USERNAME}"
        git config --global user.name "${GITHUB_USERNAME}"
        
        printf "\n - Configuring GitHub email address as: ${GITHUB_EMAIL_ID}"
        git config --global user.email "${GITHUB_EMAIL_ID}"
        
        printf "\n - Configuring Default git editor as: ${GIT_CLI_EDITOR}"
        git config --global core.editor "${GIT_CLI_EDITOR}"
        
        printf "\n - Generating a new SSH key for ${GITHUB_EMAIL_ID}"
        printf "\n\nJust press Enter and add passphrase if you'd like to. \n\n"
        ssh-keygen -t ed25519 -C "${GITHUB_EMAIL_ID}"
        
        printf "\n\nAdding your SSH key to the ssh-agent..\n"
        
        printf "\n - Start the ssh-agent in the background.."
        eval "$(ssh-agent -s)"
        
        print "\n\n - Adding your SSH private key to the ssh-agent"
        ssh-add ~/.ssh/id_ed25519
        
        printf "\n - Copying the SSH Key Content to the Clipboard..."
        
        printf "\n\nLog in into your GitHub account in the browser (if you have not)"
        printf "\nOpen this link https://github.com/settings/keys in the browser."
        printf "\nClik on New SSH key."
        xclip -selection clipboard < ~/.ssh/id_ed25519.pub
        printf "\nGive a title for the SSH key."
        printf "\nPaste the clipboard content in the textarea box below the title."
        printf "\nClick on Add SSH key."
    else
        printf "\nYou have not provided the configuration for Git Setup."
        printf "\nAdd them at the top of this script file and run it again."
    fi
}


audio_tools() {
    banner "Installing: Pulse Audio & Alsa Tools"
    yes | sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol alsa-utils \
    alsa-ucm-conf sof-firmware
}


lampp_stack() {
    banner "Installing: LAMP Stack Packages"
    yes | sudo pacman -S php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
    php-redis php-snmp phpmyadmin
}


package_managers() {
    banner "Installing Package Managers: composer npm yay snapd"
    yes | sudo pacman -S composer nodejs npm yay snapd
    
    printf "\nEnabling the snap daemon..."
    sudo systemctl enable --now snapd.socket
    
    printf "\nEnabling classic snap support by creating the symlink..."
    sudo ln -s /var/lib/snapd/snap /snap
}


brave_tel_vlc_discord() {
    banner "Installing: Brave Browser, Telegram, VLC & Discord"
    yes | sudo pacman -S brave telegram-desktop vlc discord
}


obs_studio() {
    banner "Installing Snap Package: OBS Studio"
    sudo snap install obs-studio
}


s_spotify() {
    banner "Installing Snap Package: Spotify"
    sudo snap install spotify
    pause
}


vscode() {
    banner "Installing Snap Package: Microsoft Visual Studio Code"
    sudo snap install code --classic
}


sublime_text() {
    banner "Installing: Sublime Text"
    
    printf "\n\nInstall the GPG key:\n"
    printf "\nGetting the GPG key using curl..."
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg
    
    printf "\nAdding the GPG key using pacman-key ..."
    sudo pacman-key --add sublimehq-pub.gpg
    
    printf "\nSigning the GPG key..."
    sudo pacman-key --lsign-key 8A8F901A
    
    printf "\nRemoving the GPG key obtained from curl ..."
    rm sublimehq-pub.gpg
    
    printf "\nChoosing the Stable x86_64 channel for install..."
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" \
    | sudo tee -a /etc/pacman.conf
    
    printf "\nUpdatig pacman and installing Sublime Text..."
    yes | sudo pacman -Syu sublime-text
}


zoom_app() {
    banner "Installing: Zoom Video Conferencing App"
    
    printf "\n - Going inside the Downloads folder..."
    cd Downloads
    
    printf "\n - Downloading the Zoom application..."
    wget https://zoom.us/client/latest/zoom_x86_64.pkg.tar.xz
    
    printf "\n - Starting the zoom installation..."
    yes | sudo pacman -U zoom_x86_64.pkg.tar.xz
    
    printf "\n - Coming out of the Downloads folder..."
    cd
}


mkvtoolnix_gui() {
    banner "Installing: MKVToolNix GUI"
    yes | sudo pacman -S mkvtoolnix-gui
}


s_qbittorrent() {
    banner "Installing: qBittorrent"
    yes | sudo pacman -S qbittorrent
}


fira_code_vim() {
    banner "Installing: Fira Code Font and Vim Editor"
    yes | sudo pacman -S ttf-fira-code vim
}


aliases_and_scripts() {
    banner "Installing Aliases and Scripts"
    
    aliasfile="\n"
    aliasfile+="if [ -f ~/.rksalias ]; then\n"
    aliasfile+=". ~/.rksalias\n"
    aliasfile+="fi\n"

    printf "\nCreating a directory to clone the KamalDGRT/rkswrites repo.."
    if [ -d ~/RKS_FILES/GitRep ]
    then
        printf "\nDirectory exists.\nSkipping the creation step..\n"
    else
        mkdir -p ~/RKS_FILES/GitRep
    fi

    printf "\nGoing inside ~/RKS_FILES/GitRep"
    cd ~/RKS_FILES/GitRep

    if [ -d ~/RKS_FILES/GitRep/rkswrites ]
    then
        printf "\nRepository exists. \nSkipping the cloning step..\n"
    else
        printf "\nCloning the GitHub Repo\n"
        git clone https://github.com/KamalDGRT/rkswrites.git
    fi

    printf "\nGoing inside rkswrites directory..."
    cd rkswrites

    printf "\nCreating the file with aliases to the ~/ location.."
    printf "\n\nChecking if the alias file exists..."
    if [ -f ~/RKS_FILES/GitRep/rkswrites/Manjaro/rksalias.txt ]
    then
        printf "\nAlias file exists.."
        cp Manjaro/rksalias.txt ~/.rksalias
    else
        printf "\nAlias file not found.."

        printf "\nMoving into /tmp directoroy.."
        cd /tmp

        printf "\nGetting the file from GitHub"
        wget https://raw.githubusercontent.com/KamalDGRT/rkswrites/master/Manjaro/rksalias.txt

        printf "\nMoving the file to ~/"
        mv rksalias.txt ~/.rksalias
    fi

    printf "\n\nAdding the aliases to the fish conf.."
    if [ -f ~/.config/fish/config.​fish ]
    then
        ~/.config/fish/config.​fish >> printf "${aliasfile}"
        printf "\nAliases added successfully to fish shell."
    else
        printf "\nYour OS does not have fish shell.\nSkipping..."
    fi

    printf "\n\nAdding the aliases to the BASH shell.."
    if [ -f ~/.bashrc ]
    then
        printf "${aliasfile}" >> ~/.bashrc 
        printf "\nAliases added successfully to BASH"
    else
        printf "\nYour OS does not have BASH shell.\nSkipping..."
    fi

    printf "\n\nAdding the aliases to the ZSH shell.."
    if [ -f ~/.zshrc ]
    then
        printf "${aliasfile}" >> ~/.zshrc
        printf "\nAliases added successfully to ZSH"
    else
        printf "\nYour OS does not have ZSH shell.\nSkipping..."
    fi

    printf "\n\nTo make the aliases, close and reopen the terminals that"
    printf " are using those shells.\n"
}


install_all_menu() {
    printf "\nThis will do the following:\n"
    printf "\nInstall: neofetch bash-completion xorg-xclip"
    printf "\nSet up SSH for git and GitHub"
    printf "\nInstall: Pulse Audio & Alsa Tools"
    printf "\nInstall: LAMP Stack Packages"
    printf "\nInstall: Package Managers: composer npm yay snapd"
    printf "\nInstall: Brave Browser, Telegram, VLC & Discord"
    printf "\nInstall: Snap Package: OBS Studio"
    printf "\nInstall: Snap Package: Spotify"
    printf "\nInstall: Snap Package: Microsoft Visual Studio Code"
    printf "\nInstall: Sublime Text"
    printf "\nInstall: Zoom Video Conferencing App"
    printf "\nInstall: MKVToolNix GUI"
    printf "\nInstall: qBittorrent"
    printf "\nInstall: Fira Code Font and Vim Editor"
}


install_all() {
    yes | sudo pacman -S neofetch bash-completion xorg-xclip pulseaudio \
    pulseaudio-alsa pavucontrol alsa-utils alsa-ucm-conf sof-firmware \
    php php-apache php-cgi php-fpm php-gd php-embed php-intl php-imap \
    php-redis php-snmp phpmyadmin brave telegram-desktop vlc discord \
    mkvtoolnix-gui qbittorrent ttf-fira-code vim fakeroot
    
    gitsetup
    sublime_text
    package_managers
    obs_studio
    spotify
    vscode
    zoom_app
}


menu_logo() {
    printf "\n\n
    ░█▀▀█ █▀▀█ █▀▀ ▀▀█▀▀ 　 ▀█▀ █▀▀▄ █▀▀ ▀▀█▀▀ █▀▀█ █── █──
    ░█▄▄█ █──█ ▀▀█ ──█── 　 ░█─ █──█ ▀▀█ ──█── █▄▄█ █── █──
    ░█─── ▀▀▀▀ ▀▀▀ ──▀── 　 ▄█▄ ▀──▀ ▀▀▀ ──▀── ▀──▀ ▀▀▀ ▀▀▀
    \n\n"
}


ask_user() {
    msg="$*"
    edge="#~~~~~~~~~~~~#"
    printf "\n${msg}\n"
    
    printf "    ${edge}\n";
    printf "    | 1.) Yes    |\n"
    printf "    | 2.) No     |\n"
    printf "    | 3.) Quit   |\n"
    printf "    ${edge}\n";
    
    read -e -p "Please select 1, 2, or 3 :   " choice
    
    if [ "$choice" == "1" ]
    then
        printf "\n\n"
        return 0
        
    elif [ "$choice" == "2" ]
    then
        printf "\n\n\n"
        return 1
        
    elif [ "$choice" == "3" ]
    then
        clear && exit 0
        
    else
        echo "Please select 1, 2, or 3." && sleep 3
        clear && ask_user ""
    fi
}


prompt_each_install() {
    if ask_user "Install: neofetch bash-completion xorg-xclip ?"
    then
        nf_bash_xclip
    else
        printf "\nSkipping: neofetch bash-completion xorg-clip..\n"
    fi
    
    if ask_user "Set up SSH for git and GitHub ?";
    then
        gitsetup
    else
        printf "\nSkipping: Git and GitHub SSH setup..\n"
    fi
    
    if ask_user "Install: Pulse Audio & Alsa Tools ?"
    then
        audio_tools
    else
        printf "\nSkipping: Audio Tools installation..\n"
    fi
    
    if ask_user "Install: LAMP Stack Packages ?"
    then
        lampp_stack
    else
        printf "\nSkipping: LAMP Stack Installtion..\n"
    fi
    
    if ask_user "Install: Package Managers: composer npm yay snapd"
    then
        package_managers
    else
        printf "\nSkipping: Package Managers: composer npm yay snapd.\n"
    fi
    
    if ask_user "Install: Brave Browser, Telegram, VLC & Discord"
    then
        brave_tel_vlc_discord
    else
        printf "\nSkipping: Brave Browser, Telegram, VLC & Discord..\n"
    fi
    
    if ask_user "Install: Snap Package: OBS Studio"
    then
        obs_studio
    else
        printf "\nSkipping: Snap Package OBS Studio..\n"
    fi
    
    if ask_user "Install: Snap Package: Spotify"
    then
        s_spotify
    else
        printf "\nSkipping: neofetch bash-completion xorg-clip..\n"
    fi
    
    if ask_user "Install: Snap Package: Microsoft Visual Studio Code"
    then
        vscode
    else
        printf "\nSkipping: VS Code Installation..\n"
    fi
    
    if ask_user "Install: Sublime Text"
    then
        sublime_text
    else
        printf "\nSkipping: Sublime Text Installation..\n"
    fi
    
    if ask_user "Install: Zoom Video Conferencing App"
    then
        zoom_app
    else
        printf "\nSkipping: Zoom App Installation..\n"
    fi
    
    if ask_user "Install: MKVToolNix GUI"
    then
        mkvtoolnix_gui
    else
        printf "\nSkipping: MKVToolNix GUI Installation..\n"
    fi
    
    if ask_user "Install: qBittorrent"
    then
        s_qbittorrent
    else
        printf "\nSkipping: qBittorrent Installation..\n"
    fi
    
    if ask_user "Install: Fira Code Font and Vim Editor"
    then
        fira_code_vim
    else
        printf "\nSkipping: Vim & Fira Code Font Installation..\n"
    fi
}


main_menu_content() {
    clear
    menu_logo
    
    printf "\n This script will install and configure some stuff for you."
    printf "\n How you want it to install, it is upto you."
    printf "\n\n 1. You can install everything it provides."
    printf "\n    This is best suited for fresh OS installs."
    printf "\n\n 2. Install selectively."
    printf "\n    Here, the script will prompt you for each install.\n\n"
}


main_menu() {
    main_menu_content
    if ask_user "So, do you want to install everything?"
    then
        printf "\nInstalling All\n"
    elif ask_user "So I guess you want to be prompted for each install?"
    then
        printf "\nBeginning Install With Prompt\n"
    fi
}

aliases_and_scripts