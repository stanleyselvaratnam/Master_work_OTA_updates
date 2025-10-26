#!/bin/sh
# LUKS initialization script for /dev/mmcblk0p5

DEVICE="/dev/mmcblk0p5"
MAPPER_NAME="securedata"
MOUNT_POINT="/mnt/securedata"
KEY_FILE="/data/lukskey.bin"

log() {
    echo "[LUKS-INIT] $1" | tee -a /var/log/luks-init.log
}

# Crée le répertoire de logs si nécessaire
mkdir -p /var/log

# Check if already LUKS encrypted
if cryptsetup isLuks $DEVICE >/dev/null 2>&1; then
    log "Device $DEVICE is already LUKS encrypted. Skipping initialization."
    
    # Open and mount if not already done
    if [ ! -e /dev/mapper/$MAPPER_NAME ]; then
        log "Opening LUKS device..."
        cryptsetup open $DEVICE $MAPPER_NAME --key-file $KEY_FILE
    fi
    
    if ! mountpoint -q $MOUNT_POINT; then
        mkdir -p $MOUNT_POINT
        mount /dev/mapper/$MAPPER_NAME $MOUNT_POINT
        log "Mounted $MAPPER_NAME at $MOUNT_POINT"
    fi
    
    exit 0
fi

log "Starting LUKS initialization on $DEVICE..."

# Clear any existing filesystem signatures
log "Clearing existing signatures..."
dd if=/dev/zero of=$DEVICE bs=512 count=10 2>/dev/null

# Generate random key
if [ ! -f "$KEY_FILE" ]; then
    log "Generating random LUKS key..."
    dd if=/dev/urandom of=$KEY_FILE bs=512 count=1 2>/dev/null
    chmod 0400 $KEY_FILE
    log "Key generated at $KEY_FILE"
fi

# Format as LUKS
log "Formatting $DEVICE with LUKS..."
cryptsetup luksFormat $DEVICE --key-file $KEY_FILE --batch-mode

# Open the LUKS device
log "Opening LUKS device as $MAPPER_NAME..."
cryptsetup open $DEVICE $MAPPER_NAME --key-file $KEY_FILE

# Create ext4 filesystem
log "Creating ext4 filesystem on /dev/mapper/$MAPPER_NAME..."
mkfs.ext4 -F /dev/mapper/$MAPPER_NAME -L securedata

# Create mount point and mount
mkdir -p $MOUNT_POINT
log "Mounting /dev/mapper/$MAPPER_NAME to $MOUNT_POINT..."
mount /dev/mapper/$MAPPER_NAME $MOUNT_POINT

log "LUKS initialization completed successfully."
log "Encrypted partition mounted at $MOUNT_POINT"

exit 0
