#!/bin/sh
LOG_FILE="/run/sync-secure-files.log"
echo "*** Starting sync-secure-files at $(date)" > $LOG_FILE

MAPPING_LIST="/etc/mapping.list"
MOUNT_POINT="/mnt/securedata"

if [ ! -d "$MOUNT_POINT" ]; then
    echo "ERROR: Mount point $MOUNT_POINT not found!" >> $LOG_FILE
    exit 1
fi

if [ ! -f "$MAPPING_LIST" ]; then
    echo "ERROR: Mapping list $MAPPING_LIST missing" >> $LOG_FILE
    exit 1
fi

while IFS=: read -r symlink target; do
    [ -z "$symlink" ] && continue
    echo "Processing symlink $symlink -> $target" >> $LOG_FILE

    # Copy the source file to the encrypted partition if it does not exist there
    if [ ! -f "$target" ]; then
        if [ -f "$symlink" ]; then
            mkdir -p "$(dirname "$target")"
            cp -pf "$symlink" "$target"
            echo "Copied $symlink to $target" >> $LOG_FILE
        else
            echo "WARNING: Source file $symlink does not exist, cannot copy" >> $LOG_FILE
            continue
        fi
    fi

    mkdir -p "$(dirname "$symlink")"

    # Remove existing file or symlink
    if [ -L "$symlink" ]; then
        rm -f "$symlink"
        echo "Removed existing symlink $symlink" >> $LOG_FILE
    elif [ -f "$symlink" ] || [ -d "$symlink" ]; then
        rm -rf "$symlink"
        echo "Removed existing file/directory $symlink" >> $LOG_FILE
    fi

    # Create the new symbolic link
    ln -s "$target" "$symlink"
    echo "Created symlink $symlink -> $target" >> $LOG_FILE
done < "$MAPPING_LIST"

echo "*** Finished sync-secure-files at $(date)" >> $LOG_FILE
