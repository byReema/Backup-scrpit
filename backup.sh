#!/bin/bash

# Global variables
SOURCE_PARTITION="/"
DESTINATION_DIR="/home/reema/backup"
BACKUP_FILE="backup$(date +%d%m%y).tar.gz"
encryptedBackupFile="$DESTINATION_DIR/backup$(date +%d%m%y).tar.gz.gpg"
EMAIL_TO="reema13.1hime@hotmail.com"
GPG_PASSPHRASE="427E31AE2B3CC18649229205A27645D2CE7DA8CD"

backup() {
    echo "📂 Doing backup 📂"

    #Create directory if it doesn't exist
    if [ ! -d "$DESTINATION_DIR" ]; then
        mkdir -p "$DESTINATION_DIR"
    fi

    #Remove the previous backup
    # rm -rf /home/reema/backup

    #Backup and exclude directories that are not needed
    sudo tar --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} -czf "$DESTINATION_DIR"/"$BACKUP_FILE" .


    echo "🚀 Encrypt the backup"
    
    # Encrypt the backup using GPG with the passphrase provided directly
    gpg --batch --passphrase "$GPG_PASSPHRASE" --symmetric --output "$encryptedBackupFile" "$DESTINATION_DIR"/"$BACKUP_FILE"

    echo "🚀 Backup is done 🚀"
}

send_email() {
    EMAIL_SUBJECT="Weekly Backup"
    EMAIL_BODY="📫 Here's your weekly backup 📫"
    echo " Sending email 📧"

    # Send an email with the encrypted backup file
    echo "$EMAIL_BODY" | mutt -s "$EMAIL_SUBJECT" -a "$encryptedBackupFile" -- "$EMAIL_TO"
}

# Call functions
backup
send_email

echo "🎉 All done! 🎉"