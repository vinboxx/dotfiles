#!/bin/bash

# List of folders to backup (relative to the user's home directory)
FOLDERS_TO_BACKUP=(
    "test-projects"
)

CURRENT_DIR=$(pwd)

# Change the current directory to the user home directory
cd "$HOME" || exit 1

FOLDERS_TO_SKIP=(
    "node_modules"
    ".next"
)

FILE_TO_SKIP=(
    ".DS_Store"
)

# Function to check if any of the folders exist
check_if_folders_exist() {
    local folders=("$@")
    local folder_not_found=0
    for folder in "${folders[@]}"; do
        local folder_with_home_path="$HOME/$folder"
        if [ ! -d "$folder_with_home_path" ]; then
            folder_not_found=1
            echo "Warning: Folder $folder_with_home_path does not exist."
        fi
    done
    return $folder_not_found
}

# Function to display each folder sizes and sum them up
check_folder_sizes() {
    local folders=("$@")
    local total_size=0
    for folder in "${folders[@]}"; do
        local folder_with_home_path="$HOME/$folder"
        if [ -d "$folder_with_home_path" ]; then
            # Use find to exclude files and calculate size
            local folder_size=$(find "$folder_with_home_path" -type f $(printf '! -name "%s" ' "${FILE_TO_SKIP[@]}") -exec du -k {} + | awk '{total += $1} END {print total * 1024}')
            local folder_size_human=$(numfmt --to=iec-i --suffix=B <<< "$folder_size")
            echo "  $folder: $folder_size_human"
            total_size=$((total_size + folder_size))
        else
            echo "Warning: Folder $folder_with_home_path does not exist."
        fi
    done
    # Convert total size to human-readable format
    local total_size_human=$(numfmt --to=iec-i --suffix=B <<< "$total_size")
    echo "Total size of folders to backup: $total_size_human"
    # Check if total size exceeds the remaining space
    local available_space=$(( $(df -k "$HOME" | awk 'NR==2 {print $4}') * 1024 ))
    local available_space_human=$(numfmt --to=iec-i --suffix=B <<< "$available_space")
    if [ "$total_size" -gt "$available_space" ]; then
        echo "Error: Not enough space to create the backup. Available space: $available_space_human"
        return 1
    fi
    echo "Sufficient space available for backup ($available_space_human)."
}

remove_unnecessary_folders() {
    local folders=("$@")
    for folder in "${folders[@]}"; do
        local folder_with_home_path="$HOME/$folder"
        if [ -d "$folder_with_home_path" ]; then
            for skip_folder in "${FOLDERS_TO_SKIP[@]}"; do
                find "$folder_with_home_path" -type d -name "$skip_folder" -exec rm -rf {} +
            done
        fi
    done
}

# Step 1: Check if folders exist
if ! check_if_folders_exist "${FOLDERS_TO_BACKUP[@]}"; then
    exit 1
fi

# Step 2: Remove all unnecessary folders
echo "Removing unnecessary folders..."
for folder in "${FOLDERS_TO_SKIP[@]}"; do
    echo "  $folder"
done
remove_unnecessary_folders "${FOLDERS_TO_BACKUP[@]}"

# Step 3: Check folder sizes
echo "-------------------------------------"
echo "Calculating folder sizes:"
if ! check_folder_sizes "${FOLDERS_TO_BACKUP[@]}"; then
    exit 1
fi

# Step 4: Create a zip file
echo "-------------------------------------"
echo "The following folders and files will be skipped:"
for folder in "${FOLDERS_TO_SKIP[@]}"; do
    echo "  $folder"
done
for file in "${FILE_TO_SKIP[@]}"; do
    echo "  $file"
done
FILE_NAME="backup_$(date +%Y%m%d).zip"
OUTPUT_ZIP="$CURRENT_DIR/$FILE_NAME"
# Delete if exists
if [ -f "$OUTPUT_ZIP" ]; then
    rm "$OUTPUT_ZIP"
fi
echo "Zipping folders..."
zip -r -X "$OUTPUT_ZIP" "${FOLDERS_TO_BACKUP[@]}" $(printf -- '-x "%s/*" ' "${FOLDERS_TO_SKIP[@]}") $(printf -- '-x "%s" ' "${FILE_TO_SKIP[@]}") >/dev/null

# Step 5: Display instructions for restoring
echo "-------------------------------------"
echo "Backup completed successfully!"
FILE_SIZE=$(find "$OUTPUT_ZIP" -type f -print0 | xargs -0 stat -f %z | awk '{total += $1} END {printf "%.1f MB\n", total/1000/1000}')
echo "The backup file is located at: $OUTPUT_ZIP ($FILE_SIZE)"

# Step 6: Provide instructions for restoring the backup
echo "-------------------------------------"
echo "To restore the backup on a new machine, use the following command:"
echo "unzip $FILE_NAME -d $HOME"
