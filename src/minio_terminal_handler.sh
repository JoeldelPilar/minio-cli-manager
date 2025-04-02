#!/bin/bash

# Clear terminal at start
clear

# Color settings
SAKURA_PINK='\033[38;2;255;159;172m' # sakura-pink ("Kanawaga")
TEXT_COLOR='\033[38;2;228;228;236m'  # off-white ("Fuji White")
MENU_COLOR='\033[38;2;97;175;239m'   # soft blue ("Dragon Blue")
BOLD='\033[1m'                       # bold text
NC='\033[0m'             	     # reset color

# Display welcome message and important information
echo ""
echo -e "${MENU_COLOR}${BOLD}=== MinIO File Management Script ===${NC}"
echo -e "${TEXT_COLOR}NOTE: This script assumes that MinIO aliases are already configured."
echo -e "${TEXT_COLOR}If you haven't set up aliases, use: mc alias set <alias-name> <minio-url> <access-key> <secret-key>${NC}"
echo ""

# Function to exit the script with a farewell
exit_script() {
    clear
    echo ""
    echo -e "${TEXT_COLOR}Thank you for using MinIO File Management Script. Goodbye!${NC}"
    exit 0
}

# Function to select alias
select_alias() {
    declare -a ALIASES=()
    
    if [ -n "$MINIO_ALIAS_ONE" ]; then
        ALIASES+=("$MINIO_ALIAS_ONE")
    fi
    if [ -n "$MINIO_ALIAS_TWO" ]; then
        ALIASES+=("$MINIO_ALIAS_TWO")
    fi
    if [ -n "$MINIO_ALIAS_THREE" ]; then
        ALIASES+=("$MINIO_ALIAS_THREE")
    fi
    if [ -n "$MINIO_ALIAS_FOUR" ]; then
        ALIASES+=("$MINIO_ALIAS_FOUR")
    fi
    if [ -n "$MINIO_ALIAS_FIVE" ]; then
        ALIASES+=("$MINIO_ALIAS_FIVE")
    fi
    
    if [ ${#ALIASES[@]} -eq 0 ]; then
        echo -e "${TEXT_COLOR}No MinIO aliases defined via environment variables.${NC}"
        echo -e "${TEXT_COLOR}Define aliases with MINIO_ALIAS_ONE to MINIO_ALIAS_FIVE.${NC}"
        echo -e "${TEXT_COLOR}Using default aliases for now.${NC}"
        ALIASES=("mlgn" "mlgn-hallonpi")
    fi
    
    while true; do
        echo -e "${TEXT_COLOR}Select a MinIO alias:${NC}"
        for i in "${!ALIASES[@]}"; do
            echo -e "${TEXT_COLOR}$((i+1))) ${ALIASES[$i]}${NC}"
        done
        echo -e "${TEXT_COLOR}0) Back to main menu${NC}"
	echo ""
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" ALIAS_CHOICE
	echo ""
        
        if [ "$ALIAS_CHOICE" == "0" ]; then
            return 1
        elif [[ "$ALIAS_CHOICE" =~ ^[0-9]+$ ]] && [ "$ALIAS_CHOICE" -ge 1 ] && [ "$ALIAS_CHOICE" -le "${#ALIASES[@]}" ]; then
            SELECTED_ALIAS="${ALIASES[$((ALIAS_CHOICE-1))]}"
            return 0
        else
            echo -e "${TEXT_COLOR}Invalid choice. Try again.${NC}"
        fi
    done
}

# Function to select bucket
select_bucket() {
    while true; do
        clear
        echo ""
        echo -e "${MENU_COLOR}${BOLD}=== Select Bucket from $SELECTED_ALIAS ===${NC}"
        echo ""
        
        echo -e "${TEXT_COLOR}Retrieving available buckets from $SELECTED_ALIAS...${NC}"
        BUCKETS=$(mc ls "$SELECTED_ALIAS" 2>/dev/null | awk '{print $NF}' | tr -d '/')
        
        if [ $? -ne 0 ]; then
            echo -e "${TEXT_COLOR}Error: Failed to connect to $SELECTED_ALIAS. Please check your connection and credentials.${NC}"
            echo -e "${TEXT_COLOR}0) Back to main menu${NC}"
            echo -e "${TEXT_COLOR}9) Exit script${NC}"
            echo ""
            read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" CHOICE
            echo ""
            if [ "$CHOICE" == "0" ]; then
                return 1
            elif [ "$CHOICE" == "9" ]; then
                exit_script
            else
                continue
            fi
        fi
        
        if [ -z "$BUCKETS" ]; then
            echo -e "${TEXT_COLOR}No buckets found in $SELECTED_ALIAS. Check your MinIO configuration.${NC}"
            echo -e "${TEXT_COLOR}0) Back to main menu${NC}"
            echo -e "${TEXT_COLOR}9) Exit script${NC}"
            echo ""
            read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" CHOICE
            echo ""
            if [ "$CHOICE" == "0" ]; then
                return 1
            elif [ "$CHOICE" == "9" ]; then
                exit_script
            else
                continue
            fi
        fi

        IFS=$'\n' read -d '' -ra BUCKET_ARRAY <<< "$BUCKETS"
        echo -e "${TEXT_COLOR}Available buckets in $SELECTED_ALIAS:${NC}"
        for i in "${!BUCKET_ARRAY[@]}"; do
            echo -e "${TEXT_COLOR}$((i+1))) ${BUCKET_ARRAY[$i]}${NC}"
        done
        echo -e "${TEXT_COLOR}0) Back to main menu${NC}"
        echo ""
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" BUCKET_CHOICE
        echo ""
        
        if [ "$BUCKET_CHOICE" == "0" ]; then
            return 1
        elif [[ "$BUCKET_CHOICE" =~ ^[0-9]+$ ]] && [ "$BUCKET_CHOICE" -ge 1 ] && [ "$BUCKET_CHOICE" -le "${#BUCKET_ARRAY[@]}" ]; then
            SELECTED_BUCKET="${BUCKET_ARRAY[$((BUCKET_CHOICE-1))]}"
            CURRENT_PATH="$SELECTED_ALIAS/$SELECTED_BUCKET"
            return 0
        else
            echo -e "${TEXT_COLOR}Invalid choice. Try again.${NC}"
            sleep 1
        fi
    done
}

# Modified function to navigate directory structure with numeric choices only
navigate_directories() {
    local path_stack=()
    path_stack+=("$CURRENT_PATH")
    local current_index=0

    while true; do
        clear
        echo ""
        echo -e "${MENU_COLOR}${BOLD}=== Navigate in $SELECTED_ALIAS/$SELECTED_BUCKET ===${NC}"
        echo ""
        
        # Get contents of current directory
        CONTENTS=$(mc ls "${path_stack[$current_index]}" 2>/dev/null | grep -v "^$")
        
        if [ $? -ne 0 ]; then
            echo -e "${TEXT_COLOR}Error: Failed to access ${path_stack[$current_index]}. Please check your connection and permissions.${NC}"
            echo -e "${TEXT_COLOR}0) Back to main menu${NC}"
            echo ""
            read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" NAV_CHOICE
            echo ""
            if [ "$NAV_CHOICE" == "0" ]; then
                return 1
            else
                continue
            fi
        fi

        if [ -z "$CONTENTS" ]; then
            echo -e "${TEXT_COLOR}Current location: ${path_stack[$current_index]}${NC}"
            echo -e "${TEXT_COLOR}No files or folders found in this directory.${NC}"
            echo ""
            echo -e "${TEXT_COLOR}1) Stay at current level${NC}"
            [ $current_index -gt 0 ] && echo -e "${TEXT_COLOR}2) Go back to previous folder${NC}"
            echo -e "${TEXT_COLOR}0) Back to main menu${NC}"
            echo ""
            read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" NAV_CHOICE
            echo ""
            case $NAV_CHOICE in
                1) 
                    CURRENT_PATH="${path_stack[$current_index]}"
                    return 0
                    ;;
                2)
                    if [ $current_index -gt 0 ]; then
                        current_index=$((current_index-1))
                        continue
                    else
                        echo -e "${TEXT_COLOR}Cannot go back any further.${NC}"
                        sleep 1
                    fi
                    ;;
                0) return 1 ;;
                *) 
                    echo -e "${TEXT_COLOR}Invalid choice. Try again.${NC}"
                    sleep 1
                    ;;
            esac
            continue
        fi

        # Separate folders and files
        DIRS=$(echo "$CONTENTS" | awk '{print $NF}' | grep '/$' | tr -d '/')
        FILES=$(echo "$CONTENTS" | awk '{print $NF}' | grep -v '/$')

        IFS=$'\n' read -d '' -ra DIR_ARRAY <<< "$DIRS"
        IFS=$'\n' read -d '' -ra FILE_ARRAY <<< "$FILES"

        # Build a menu with numbers
        declare -a OPTION_TYPE
        declare -a OPTION_VALUE
        option_index=1

        # Add folders
        for dir in "${DIR_ARRAY[@]}"; do
            OPTION_TYPE[option_index]="dir"
            OPTION_VALUE[option_index]="$dir"
            option_index=$((option_index+1))
        done

        # Add files (only if not in upload mode)
        if [ "$MODE" != "upload" ]; then
            for file in "${FILE_ARRAY[@]}"; do
                OPTION_TYPE[option_index]="file"
                OPTION_VALUE[option_index]="$file"
                option_index=$((option_index+1))
            done
        fi

        # Add extra navigation options
        OPTION_TYPE[option_index]="stay"
        OPTION_VALUE[option_index]="Stay at current level"
        option_index=$((option_index+1))
        if [ $current_index -gt 0 ]; then
            OPTION_TYPE[option_index]="back"
            OPTION_VALUE[option_index]="Go back to previous folder"
            option_index=$((option_index+1))
        fi
        OPTION_TYPE[option_index]="main"
        OPTION_VALUE[option_index]="Back to main menu"

        # Print the menu
        echo -e "${TEXT_COLOR}Current location: ${path_stack[$current_index]}${NC}"
        echo ""
        for ((i=1; i<=option_index; i++)); do
            # Set prefix based on type
            case "${OPTION_TYPE[i]}" in
                dir)
                    prefix="📁 "
                    ;;
                file)
                    prefix="📄 "
                    ;;
                stay)
                    prefix="📍 "
                    ;;
                back)
                    prefix="⬅️  "
                    ;;
                main)
                    prefix="🏠 "
                    ;;
                *)
                    prefix=""
                    ;;
            esac
            echo -e "${TEXT_COLOR}$i) ${prefix}${OPTION_VALUE[i]}${NC}"
        done

        # Read user's choice
        echo ""
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice (number): ${NC}")" CHOICE
        echo ""

        # Check that the choice is a valid number
        if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
            echo -e "${TEXT_COLOR}Please enter a number.${NC}"
            sleep 1
            continue
        fi

        if [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le $option_index ]; then
            case "${OPTION_TYPE[CHOICE]}" in
                dir)
                    # Enter selected folder
                    NEW_PATH="${path_stack[$current_index]}/${OPTION_VALUE[CHOICE]}"
                    current_index=$((current_index+1))
                    path_stack[$current_index]="$NEW_PATH"
                    ;;
                file)
                    # For download: select file and exit with special code 2
                    SELECTED_FILE="${OPTION_VALUE[CHOICE]}"
                    CURRENT_PATH="${path_stack[$current_index]}"
                    SELECTED_FILE_PATH="$CURRENT_PATH/$SELECTED_FILE"
                    return 2
                    ;;
                stay)
                    CURRENT_PATH="${path_stack[$current_index]}"
                    return 0
                    ;;
                back)
                    current_index=$((current_index-1))
                    ;;
                main)
                    return 1
                    ;;
            esac
        else
            echo -e "${TEXT_COLOR}Invalid choice. Try again.${NC}"
            sleep 1
        fi
    done
}

# Function to list files
list_files() {
    clear
    echo ""
    echo -e "${MENU_COLOR}${BOLD}=== List Files in MinIO ===${NC}"
    echo ""
    
    if ! select_alias; then
        return
    fi
    
    if ! select_bucket; then
        return
    fi
    
    while true; do
        MODE="list"
        navigate_directories
        NAV_RESULT=$?
        if [ "$NAV_RESULT" -eq 1 ]; then
            # Back to main menu
            return
        fi
        
        echo -e "${TEXT_COLOR}Contents of $CURRENT_PATH:${NC}"
        mc ls --recursive "$CURRENT_PATH"
        
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Press Enter to continue, 0 for main menu: ${NC}")" LIST_CHOICE
        if [ "$LIST_CHOICE" == "0" ]; then
            return
        fi
    done
}

# Function to upload files
upload_file() {
    clear
    echo ""
    echo -e "${MENU_COLOR}${BOLD}=== Upload File to MinIO ===${NC}"
    echo ""
    
    if ! select_alias; then
        return
    fi
    if ! select_bucket; then
        return
    fi
    
    MODE="upload"
    if ! navigate_directories; then
        return
    fi
    
    echo -e "${TEXT_COLOR}The file will be uploaded to: $CURRENT_PATH/${NC}"
    read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter the path to the file you want to upload (0 for main menu): ${NC}")" FILE_PATH
    
    [ "$FILE_PATH" == "0" ] && return
    
    if [ ! -f "$FILE_PATH" ]; then
        echo -e "${TEXT_COLOR}Error: File does not exist at '$FILE_PATH'.${NC}"
        return
    fi
    
    FILENAME=$(basename "$FILE_PATH")
    read -p "$(echo -e "${SAKURA_PINK}${BOLD}Upload as '$FILENAME'? (y/n, 0 for main menu): ${NC}")" USE_ORIGINAL_NAME
    if [ "$USE_ORIGINAL_NAME" == "0" ]; then
        return
    elif [[ "$USE_ORIGINAL_NAME" =~ ^[Nn] ]]; then
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter name for the file in the bucket (0 for main menu): ${NC}")" NEW_FILENAME
        [ "$NEW_FILENAME" == "0" ] && return
        FILENAME="$NEW_FILENAME"
    fi
    
    DESTINATION="$CURRENT_PATH/$FILENAME"
    echo -e "${TEXT_COLOR}Ready to upload '$FILE_PATH' to '$DESTINATION'.${NC}"
    read -p "$(echo -e "${SAKURA_PINK}${BOLD}Continue with upload? (y/n, 0 for main menu): ${NC}")" CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy] ]]; then
        echo -e "${TEXT_COLOR}Uploading...${NC}"
        mc cp "$FILE_PATH" "$DESTINATION"
        if [ $? -eq 0 ]; then
            clear
            echo -e "${TEXT_COLOR}Upload successful! The file is now at: $DESTINATION${NC}"
            read -p "$(echo -e "${SAKURA_PINK}${BOLD}Press Enter to continue...${NC}")"
        else
            echo -e "${TEXT_COLOR}Upload failed. Check connection and permissions.${NC}"
        fi
    fi
}

# Function to download files
download_file() {
    clear
    echo ""
    echo -e "${MENU_COLOR}${BOLD}=== Download File from MinIO ===${NC}"
    echo ""
    
    if ! select_alias; then
        return
    fi
    if ! select_bucket; then
        return
    fi
    
    MODE="download"
    navigate_directories
    NAV_RESULT=$?
    if [ "$NAV_RESULT" -eq 1 ]; then
        return
    elif [ "$NAV_RESULT" -eq 2 ]; then
        echo -e "${TEXT_COLOR}Selected file: $SELECTED_FILE${NC}"
    else
        echo -e "${TEXT_COLOR}No file selected. Try again.${NC}"
        return
    fi
    
    read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter local folder to save the file (0 for main menu): ${NC}")" DOWNLOAD_PATH
    [ "$DOWNLOAD_PATH" == "0" ] && return
    if [ ! -d "$DOWNLOAD_PATH" ]; then
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Folder does not exist. Create folder? (y/n): ${NC}")" CREATE_DIR
        if [[ "$CREATE_DIR" =~ ^[Yy] ]]; then
            mkdir -p "$DOWNLOAD_PATH"
        else
            return
        fi
    fi
    
    read -p "$(echo -e "${SAKURA_PINK}${BOLD}Save as '$SELECTED_FILE'? (y/n, 0 for main menu): ${NC}")" USE_ORIGINAL_NAME
    [ "$USE_ORIGINAL_NAME" == "0" ] && return
    SAVE_AS="$SELECTED_FILE"
    if [[ "$USE_ORIGINAL_NAME" =~ ^[Nn] ]]; then
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter new filename: ${NC}")" NEW_FILENAME
        [ "$NEW_FILENAME" == "0" ] && return
        SAVE_AS="$NEW_FILENAME"
    fi
    
    SAVE_PATH="$DOWNLOAD_PATH/$SAVE_AS"
    if [ -f "$SAVE_PATH" ]; then
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}File already exists. Overwrite? (y/n): ${NC}")" OVERWRITE
        if ! [[ "$OVERWRITE" =~ ^[Yy] ]]; then
            return
        fi
    fi
    
    echo -e "${TEXT_COLOR}Downloading '$SELECTED_FILE_PATH' to '$SAVE_PATH'...${NC}"
    mc cp "$SELECTED_FILE_PATH" "$SAVE_PATH"
    if [ $? -eq 0 ]; then
        clear
        echo -e "${TEXT_COLOR}Download successful! File saved to: $SAVE_PATH${NC}"
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Press Enter to continue...${NC}")"
    else
        echo -e "${TEXT_COLOR}Download failed.${NC}"
    fi
}

# Main menu
main_menu() {
    while true; do
        clear
        echo ""
        echo -e "${MENU_COLOR}${BOLD}=== MinIO File Management System ===${NC}"
        echo ""
        echo -e "${TEXT_COLOR}1) Upload a file${NC}"
        echo -e "${TEXT_COLOR}2) Download a file${NC}"
        echo -e "${TEXT_COLOR}3) List files${NC}"
        echo -e "${TEXT_COLOR}0) Exit script${NC}"
        echo ""        
        read -p "$(echo -e "${SAKURA_PINK}${BOLD}Enter your choice: ${NC}")" MENU_CHOICE
        echo ""
        
        case $MENU_CHOICE in
            1)
                upload_file
                ;;
            2)
                download_file
                ;;
            3)
                list_files
                ;;
            0)
                exit_script
                ;;
            *)
                echo -e "${TEXT_COLOR}Invalid choice. Try again.${NC}"
                ;;
        esac
    done
}

# Start the script
main_menu
