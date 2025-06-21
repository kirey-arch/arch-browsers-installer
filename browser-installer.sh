confirm_dialog() {
    echo " ?? Are you sure you want install $1? [Y/N]: "; read confirm
    confirm=$(echo "$confirm" | tr '[:lower:]' '[:upper:]')
}

open_chromium_choice() {
	echo " | ----- Select Chromium based browser to Install ----- | "
	echo
	echo " [1] Google Chrome (please don't install this shit)"
	echo " [2] Vivaldi"
	echo " [3] Brave"
	echo " [4] Ungoogled Chromium"
	echo
	echo " [0] Go back"
	echo
	echo " - Type option number"; read chromium_browser_choice

	case $chromium_browser_choice in
		"1")
            confirm_dialog "Google Chrome"
            if [[ "$confirm" == "Y" ]]; then
				echo "Installing Google Chrome..."
				yay -S google-chrome --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_chromium_choice
			else
				echo " !! Invalid option."
			fi
			;;

		"2")
            confirm_dialog "Vivaldi"

			if [[ "$confirm" == "Y" ]]; then
				echo "Installing Vivaldi..."
				yay -S vivaldi --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_chromium_choice
			else
				echo " !! Invalid option."
			fi	
			;;
	
		"3")
            confirm_dialog "Brave Browser"
			if [[ "$confirm" == "Y" ]]; then
				echo "Installing Brave..."
				yay -S brave-bin --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_chromium_choice
			else
				echo " !! Invalid option."
			fi
			;;

		"4")
            confirm_dialog "Ungoogled Chromium"
			if [[ "$confirm" == "Y" ]]; then
				echo "Installing Ungoogled Chromium..."
				yay -S ungoogled-chromium-bin --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_chromium_choice
			else
				echo " !! Invalid option."
			fi
			;;

		"0")
			echo "Ok..."
			sleep 0.5
			main_select_base
			;;

		*)	
			echo " !! Invalid option."
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
	echo " [5] Zen Browser" # zen-browser-bin
	echo
	echo " [0] Go back"
	echo
	echo " - Type option number"; read gecko_browser_choice

	case $gecko_browser_choice in
		"1")
            confirm_dialog "Firefox"
			if [[ "$confirm" == "Y" ]]; then
				echo "Installing Firefox..."
				yay -S firefox-bin --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_gecko_choice
			else
				echo " !! Invalid option."
			fi
			;;

		"2")
            confirm_dialog "Waterfox"
			if [[ "$confirm" == "Y" ]]; then
				echo "Installing Waterfox..."
				yay -S waterfox-bin --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_gecko_choice
			else
				echo " !! Invalid option."
			fi
			;;
		

		"3")
            confirm_dialog "LibreWolf"
			if [[ "$confirm" == "Y" ]]; then
				echo "Installing LibreWolf..."
				yay -S librewolf-bin --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_gecko_choice
			else
				echo " !! Invalid option."
			fi
			;;

        "4")
          confirm_dialog "Tor Browser"
          if [[ "$confirm" == "Y" ]]; then
            echo "Installing Tor Browser..."
            sudo pacman -S torbrowser-launcher --noconfirm

          elif [[ "$confirm" == "N" ]]; then
            echo "Ok... Exiting."
            open_gecko_choice
          else
            echo " !! Invalid option."
          fi
          ;;
		"5")
            confirm_dialog "Zen Browser"
			if [[ "$confirm" == "Y" ]]; then
				echo "Installing Zen Browser..."
				yay -S zen-browser-bin --noconfirm
			elif [[ "$confirm" == "N" ]]; then
				echo "Ok... Exiting."
				open_gecko_choice
			else
				echo " !! Invalid option."
			fi
			;;


		"0")
			echo "Ok..."
			sleep 0.5
			main_select_base
			;;

		*)	
			echo " !! Invalid option."
			open_chromium_choice
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
	echo " [7] Librewolf"
	echo " [8] Tor Browser"
	echo " [9] Zen Browser"
	echo
	echo " [0] Go Back"
	echo
	echo " - Type option number: "; read uninstalL_choice

	case $uninstalL_choice in
		"1") yay -Rns google-chrome ;;
		"2") yay -Rns vivaldi ;;
		"3") yay -Rns brave-bin ;;
		"4") yay -Rns ungoogled-chromium-bin ;;
		"5") yay -Rns firefox-bin ;;
		"6") yay -Rns waterfox-bin ;;
		"7") yay -Rns librewolf-bin ;;
		"8") sudo pacman -Rns torbrowser-launcher ;;
		"9") yay -Rns zen-browser-bin ;;
		"0") main_select_base ;;
		*) echo " !! Invalid option"; uninstall_browser ;;
	esac
}

main_select_base() {
	echo " | ----- Select browser base ----- | "
	echo
	echo " [1] Gecko"
	echo " [2] Chromium"
	echo " [3] Uninstall Browser"
	echo
	echo " [0] Exit"
	echo
	echo " - Type option number: "; read choice

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
			exit 1
			;;
		*)
			echo " !! Invalid option."
			main_select_base
			;;
	esac

}

main_select_base
