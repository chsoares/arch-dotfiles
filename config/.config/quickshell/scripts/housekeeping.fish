#!/usr/bin/env fish

# Arch Linux Housekeeping Script
# Compatible with Fish shell, Hyprland, and common tools

set -l RED '\033[0;31m'
set -l CYAN '\033[0;36m'
set -l YELLOW '\033[1;33m'
set -l MAGENTA '\033[0;35m'
set -l NC '\033[0m' # No Color

function print_header
    echo -e "\n$MAGENTA🧹 Arch Linux Housekeeping Script 🚀$NC"
    echo -e "$MAGENTA✨ Keeping your system clean and fast ✨$NC\n"
end

function print_section
    echo -e "\n$YELLOW🔧 [INFO]$NC $argv[1]"
end

function print_success
    echo -e "$CYAN✅ [SUCCESS]$NC $argv[1]"
end

function print_error
    echo -e "$RED❌ [ERROR]$NC $argv[1]"
end

function check_command
    if not command -v $argv[1] &> /dev/null
        print_error "Command '$argv[1]' not found. Skipping related tasks."
        return 1
    end
    return 0
end

function update_system_packages
    print_section "Updating system packages with yay..."
    if check_command yay
        yay -Syu --noconfirm
        if test $status -eq 0
            print_success "System packages updated successfully"
        else
            print_error "Failed to update system packages"
        end
    end
end

function update_pipx_packages
    print_section "Updating pipx packages..."
    if check_command pipx
        pipx upgrade-all
        if test $status -eq 0
            print_success "Pipx packages updated successfully"
        else
            print_error "Failed to update pipx packages"
        end
    end
end

function clean_package_cache
    print_section "Cleaning package cache..."
    
    # Clean yay/paru cache
    if check_command yay
        yay -Sc --noconfirm
    end
    
    # Clean pacman cache (keep only 3 most recent versions)
    sudo paccache -r -k3
    
    # Clean uninstalled packages cache
    sudo paccache -r -u -k0
    
    print_success "Package cache cleaned"
end

function remove_orphaned_packages
    print_section "Removing orphaned packages..."
    
    set -l orphans (pacman -Qtdq 2>/dev/null)
    if test (count $orphans) -gt 0
        sudo pacman -Rns $orphans --noconfirm
        print_success "Removed "(count $orphans)" orphaned packages"
    else
        print_success "No orphaned packages found"
    end
end

function clean_system_logs
    print_section "Cleaning system logs..."
    
    # Keep only last 2 weeks of logs
    sudo journalctl --vacuum-time=2weeks
    
    # Limit journal size to 100MB
    sudo journalctl --vacuum-size=100M
    
    print_success "System logs cleaned"
end

function clean_user_cache
    print_section "Cleaning user cache directories..."
    
    # Clean thumbnail cache older than 30 days
    find ~/.cache/thumbnails -type f -atime +30 -delete 2>/dev/null
    
    # Clean various application caches
    set -l cache_dirs ~/.cache/mozilla ~/.cache/chromium ~/.cache/google-chrome
    for dir in $cache_dirs
        if test -d $dir
            find $dir -type f -atime +7 -delete 2>/dev/null
        end
    end
    
    print_success "User cache cleaned"
end

function clean_temporary_files
    print_section "Cleaning temporary files..."
    
    # Clean /tmp (usually mounted as tmpfs, but just in case)
    sudo find /tmp -type f -atime +7 -delete 2>/dev/null
    
    # Clean user temp files
    find ~/.tmp -type f -atime +7 -delete 2>/dev/null
    
    print_success "Temporary files cleaned"
end

function clean_trash
    print_section "Cleaning trash/recycle bin..."
    
    if test -d ~/.local/share/Trash
        rm -rf ~/.local/share/Trash/files/* 2>/dev/null
        rm -rf ~/.local/share/Trash/info/* 2>/dev/null
        print_success "Trash emptied"
    else
        print_success "No trash directory found"
    end
end

function update_locate_database
    print_section "Updating locate database..."
    
    if check_command updatedb
        sudo updatedb
        print_success "Locate database updated"
    end
end

function clean_npm_cache
    print_section "Cleaning npm/yarn cache..."
    
    if check_command npm
        npm cache clean --force 2>/dev/null
        print_success "NPM cache cleaned"
    end
    
    if check_command yarn
        yarn cache clean 2>/dev/null
        print_success "Yarn cache cleaned"
    end
end

function check_disk_space
    print_section "Checking disk space..."
    
    echo "📊 Disk usage:"
    df -h / /home 2>/dev/null | grep -E "(Filesystem|/dev/)"
    
    echo -e "\n📁 Largest directories in /home:"
    du -sh ~/.* 2>/dev/null | sort -hr | head -5
end

function check_system_health
    print_section "Checking system health..."
    
    # Check for failed systemd services
    set -l failed_services (systemctl --failed --no-legend | wc -l)
    if test $failed_services -gt 0
        print_error "$failed_services failed systemd services found"
        systemctl --failed --no-legend
    else
        print_success "No failed systemd services"
    end
    
    # Check for corrupted packages (filter out common documentation warnings)
    if check_command pacman
        set -l package_warnings (pacman -Qk 2>&1 | grep "warning")
        
        # Filter out documentation-related warnings that are not critical
        set -l critical_warnings (echo "$package_warnings" | grep -v -E "(doc/|ri/|man/|share/man/|\.ri \(No such file)" | wc -l)
        set -l doc_warnings (echo "$package_warnings" | grep -E "(doc/|ri/|man/|share/man/|\.ri \(No such file)" | wc -l)
        
        if test $critical_warnings -gt 0
            print_error "$critical_warnings critical package issues found"
            echo "📝 Also found $doc_warnings documentation warnings (non-critical)"
            echo "Run 'pacman -Qk | grep -v \"doc/\\|ri/\\|man/\"' for critical issues only"
        else if test $doc_warnings -gt 0
            print_success "No critical package issues found"
            echo "📚 Found $doc_warnings documentation warnings (non-critical)"
        else
            print_success "No package issues found"
        end
    end
end

# Main execution
function main
    print_header
    
    # Check if running with appropriate permissions
    if test (id -u) -eq 0
        print_error "Don't run this script as root! 🚫"
        exit 1
    end
    
    # Prompt user for confirmation
    echo "⚠️  This script will perform system maintenance tasks."
    echo "🤔 Continue? (y/N)"
    read -l confirm
    
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "👋 Aborted by user"
        exit 0
    end
    
    # Execute maintenance tasks
    update_system_packages
    update_pipx_packages
    clean_package_cache
    remove_orphaned_packages
    clean_system_logs
    clean_user_cache
    clean_temporary_files
    clean_trash
    clean_npm_cache
    update_locate_database
    check_system_health
    check_disk_space
    
    print_section "Housekeeping completed! 🎉"
    echo -e "$CYAN💖 Your system is now clean and optimized! 💖$NC"
end

# Run main function
main
