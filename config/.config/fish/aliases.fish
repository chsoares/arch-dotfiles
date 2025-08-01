# General
## Aliases
alias whatsapp 'chromium --app="http://web.whatsapp.com" -enable-features=UseOzonePlatform -ozone-platform=wayland'
alias zen zen-browser
alias editor gnome-text-editor

alias ls 'eza --icons'
alias tree 'eza --icons --tree'

## Abbreviations
abbr --add yay 'yay -Sy'
abbr --add install 'yay -Sy'
abbr --add update 'yay -Syu --noconfirm'

abbr --add gs "git status"
abbr --add ga "git add ."
abbr --add gc "git commit -m"


# CTFs and stuff
## Aliases
alias www 'ls; python -m http.server 8888'

## Functions
function bloodhound
    set oldpwd (pwd)
    cd ~/.config/bloodhound
    docker compose up -d
    cd $oldpwd
end

function claudectf
    set oldpwd (pwd)
    cd $OBSIDIAN
    claude
    cd $oldpwd
end

function binbag
    set oldpwd (pwd)
    cd ~/Lab/binbag
    ls
    python -m http.server 8080
    cd $oldpwd
end

## Abbreviations
abbr --add nmap 'sudo nmap --min-rate 10000'
abbr --add ovpn 'sudo openvpn'
abbr --add box 'cd $boxpwd'
abbr --add john 'john -w=$rockyou'

## Variables
if test -f ~/Lab/env.fish
    source ~/Lab/env.fish
    cd $boxpwd
end
set -x rockyou '/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt'
set -x weblist '/home/chsoares/Repos/ezpz/utils/weblist_ezpz.txt'

## Executables
alias ligolo 'sudo /usr/share/ligolo/linux/proxy/amd64/proxy -selfcert'
alias penelope '/opt/penelope/penelope.py -i tun0'

## ezpz
#set -Ux EZPZ_HOME '/home/chsoares/Repos/ezpz' 
#set -U fish_function_path "$EZPZ_HOME/functions" $fish_function_path
#set -U fish_complete_path "$EZPZ_HOME/completions" $fish_complete_path
abbr --add netscan 'ezpz netscan'
abbr --add webscan 'ezpz webscan'
abbr --add adscan 'ezpz adscan'
abbr --add testcreds 'ezpz testcreds'
abbr --add checkvulns 'ezpz checkvulns'
abbr --add loot 'ezpz loot'
abbr --add secretsparse 'ezpz secretsparse'
abbr --add enumsqli 'ezpz enumsqli'
abbr --add enumdomain 'ezpz enumdomain'
abbr --add enumuser 'ezpz enumuser'
abbr --add enumshares 'ezpz enumshares'
abbr --add enumnull 'ezpz enumnull'

## ctf-utils
#set -Ux CTF_HOME '/home/chsoares/Repos/ctf-utils' 
#set -U fish_function_path "$CTF_HOME/functions" $fish_function_path
#set -U fish_complete_path "$CTF_HOME/completions" $fish_complete_path