#!/bin/bash
# Program name: Arch Browsers Installer
# Copyright (C) 2025 kirey-arch
# Licensed under the GNU GPL v3. See LICENSE for more information.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_dependencies() {
    local missing_deps=()
    
    if ! command -v yay >/dev/null 2>&1; then
        missing_deps+=("yay")
    fi
    
    if ! command -v pacman >/dev/null 2>&1; then
        missing_deps+=("pacman")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install yay (AUR helper) first."
        exit 1
    fi
}

confirm_dialog() {
    local browser="$1"
    local response
    
    while true; do
        echo -n " ?? Are you sure you want to install $browser? [Y/n]: "
        read -r response
        response=$(echo "$response" | tr '[:lower:]' '[:upper:]')
        
        case $response in
            Y|YES|"")
                return 0
                ;;
            N|NO)
                return 1
                ;;
            *)
                print_warning "Please enter Y for yes or N for no."
                ;;
        esac
    done
}

# installer function
install_browser() {
    local browser_name="$1"
    local package_name="$2"
    local use_pacman="${3:-false}"
    
    if confirm_dialog "$browser_name"; then
        print_info "Installing $browser_name..."
	print_info "Press ENTER, please."
        
        if [[ "$use_pacman" == "true" ]]; then
            if sudo pacman -S "$package_name" --noconfirm; then
                print_success "$browser_name installed successfully!"
            else
                print_error "Failed to install $browser_name"
                return 1
            fi
        else
            if yay -S "$package_name" --noconfirm; then
                print_success "$browser_name installed successfully!"
            else
                print_error "Failed to install $browser_name"
                return 1
            fi
        fi
    else
        print_info "Installation cancelled."
    fi
    
    echo
    read -p "Press Enter to continue..."
}

# uninstaller function
uninstall_browser_pkg() {
    local browser_name="$1"
    local package_name="$2"
    local use_pacman="${3:-false}"
    
    print_info "Uninstalling $browser_name..."
    print_info "Press ENTER, please."    
    if [[ "$use_pacman" == "true" ]]; then
        if sudo pacman -Rns "$package_name" 2>/dev/null; then
            print_success "$browser_name uninstalled successfully!"
        else
            print_warning "$browser_name was not installed or failed to uninstall"
        fi
    else
        if yay -Rns "$package_name" 2>/dev/null; then
            print_success "$browser_name uninstalled successfully!"
        else
            print_warning "$browser_name was not installed or failed to uninstall"
        fi
    fi
}

open_chromium_choice() {
    echo " | ----- Select Chromium based browser to Install ----- | "
    echo
    echo " [1] Google Chrome (please don't install this shit)"
    echo " [2] Vivaldi"
    echo " [3] Brave"
    echo " [4] Ungoogled Chromium"
    echo " [5] Microsoft Edge (... Really? Ok.)"
    echo " [6] Opera"
    echo
    echo " [0] Go back"
    echo
    echo -n " - Type option number: "
    read -r chromium_browser_choice

    case $chromium_browser_choice in
        "1")
            install_browser "Google Chrome" "google-chrome"
            open_chromium_choice
            ;;
        "2")
            install_browser "Vivaldi" "vivaldi"
            open_chromium_choice
            ;;
        "3")
            install_browser "Brave Browser" "brave-bin"
            open_chromium_choice
            ;;
        "4")
            install_browser "Ungoogled Chromium" "ungoogled-chromium-bin"
            open_chromium_choice
            ;;
		"5")
	   		install_browser "Microsoft Edge" "microsoft-edge-stable-bin"
		    open_chromium_choice
            ;;
		"6")
	    install_browser "Opera" "opera"
            open_chromium_choice
	    ;;
		"0")
            print_info "Returning to main menu..."
            sleep 0.5
            main_select_base
            ;;
        *)
            print_error "Invalid option."
            open_chromium_choice
            ;;
    esac
}

open_gecko_choice() {
    echo " | ----- Select Gecko based browser to Install ----- | "
    echo
    echo " [1] Firefox"
    echo " [2] Waterfox"
    echo " [3] LibreWolf"
    echo " [4] Tor Browser"
    echo " [5] Zen Browser"
    echo " [6] Firefox Developer"
    echo " [7] Firefox Nightly"
    echo
    echo " [0] Go back"
    echo
    echo -n " - Type option number: "
    read -r gecko_browser_choice

    case $gecko_browser_choice in
        "1")
            install_browser "Firefox" "firefox-bin"
            open_gecko_choice
            ;;
        "2")
            install_browser "Waterfox" "waterfox-bin"
            open_gecko_choice
            ;;
        "3")
            install_browser "LibreWolf" "librewolf-bin"
            open_gecko_choice
            ;;
        "4")
            install_browser "Tor Browser" "torbrowser-launcher" "true"
            open_gecko_choice
            ;;
        "5")
            install_browser "Zen Browser" "zen-browser-bin"
            open_gecko_choice
            ;;
		"6")
			install_browser "Firefox Developer" "firefox-developer-edition"
			open_gecko_choice
            ;;
		"7")
			install_browser "Firefox Nightly" "firefox-nightly"
			open_gecko_choice
			;;
		"8")
			install_browser "IceCat" "icecat-bin"
			open_gecko_choice
			;;
        "0")
            print_info "Returning to main menu..."
            sleep 0.5
            main_select_base
            ;;
        *)
            print_error "Invalid option."
            open_gecko_choice
            ;;
    esac
}

uninstall_browser() {
    echo " | ----- Uninstall Browsers ----- | "
    echo
    echo " [1] Google Chrome"
    echo " [2] Vivaldi"
    echo " [3] Brave"
    echo " [4] Ungoogled Chromium"
    echo " [5] Firefox"
    echo " [6] Waterfox"
    echo " [7] LibreWolf"
    echo " [8] Tor Browser"
    echo " [9] Zen Browser"
    echo " [10] Microsoft Edge"
    echo
    echo " [0] Go Back"
    echo
    echo -n " - Type option number: "
    read -r uninstall_choice

    case $uninstall_choice in
        "1")
            uninstall_browser_pkg "Google Chrome" "google-chrome"
            uninstall_browser
            ;;
        "2")
            uninstall_browser_pkg "Vivaldi" "vivaldi"
            uninstall_browser
            ;;
        "3")
            uninstall_browser_pkg "Brave" "brave-bin"
            uninstall_browser
            ;;
        "4")
            uninstall_browser_pkg "Ungoogled Chromium" "ungoogled-chromium-bin"
            uninstall_browser
            ;;
        "5")
            uninstall_browser_pkg "Firefox" "firefox-bin"
            uninstall_browser
            ;;
        "6")
            uninstall_browser_pkg "Waterfox" "waterfox-bin"
            uninstall_browser
            ;;
        "7")
            uninstall_browser_pkg "LibreWolf" "librewolf-bin"
            uninstall_browser
            ;;
        "8")
            uninstall_browser_pkg "Tor Browser" "torbrowser-launcher" "true"
            uninstall_browser
            ;;
        "9")
            uninstall_browser_pkg "Zen Browser" "zen-browser-bin"
            uninstall_browser
            ;;
		"10")
	   		uninstall_browser_pkg "Microsoft Edge" "microsoft-edge-stable-bin"
	    	uninstall_browser
	    	;;
		"11")
	   		uninstall_browser_pkg "Opera" "opera"
	   		uninstall_browser
	   		;;
	   	"12")
	   		uninstall_browser_pkg "Firefox Developer" "firefox-developer-edition"
	   		uninstall_browser
	   		;;
	   	"13")
	   		uninstall_browser_pkg "Firefox Nightly" "firefox-nightly"
			uninstall_browser
			;;
		"14")
			uninstall_browser "IceCat" "icecat-bin"
       		uninstall_browser
       		;;
        "0")
            main_select_base
            ;;
        *)
            print_error "Invalid option."
            uninstall_browser
            ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
    uninstall_browser
}

# welcome message
show_welcome() {
    clear
    echo "=========================================="
    echo "      Arch Browsers Installer v2.0"
    echo "=========================================="
    echo
    print_info "Welcome to the Arch Linux Browser Installer!"
    print_info "This script helps you install popular web browsers."
    echo
}

# main function
main_select_base() {
    show_welcome
    echo " | ----- Select browser base ----- | "
    echo
    echo " [1] Gecko based browsers (Firefox, LibreWolf, etc.)"
    echo " [2] Chromium based browsers (Chrome, Brave, etc.)"
    echo " [3] Uninstall Browser"
    echo
    echo " [0] Exit"
    echo
    echo -n " - Type option number: "
    read -r choice

    case $choice in
        "1")
            open_gecko_choice
            ;;
        "2")
            open_chromium_choice
            ;;
        "3")
            uninstall_browser
            ;;
        "0")
	    echo
            print_info "Thanks for using Arch Browsers Installer!"
            exit 0
            ;;
        *)
            print_error "Invalid option."
            sleep 1
            main_select_base
            ;;
    esac
}

# initialization
main() {
    # running on arch?
    if [[ ! -f /etc/arch-release ]]; then
        print_error "This script is designed for Arch Linux only!"
        exit 1
    fi
    
    # dependencies
    check_dependencies
    
    # main menu
    main_select_base
}

# Run the script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
