
BACKUP_DIR="/backup"
SOURCE_DIR="/var/www"
ARCHIVE_NAME="backup_$(date +%F_%T).tar.gz"
REMOTE_SERVER="user@backup-server:/remote-backup"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

scp "$BACKUP_DIR/$ARCHIVE_NAME" "$REMOTE_SERVER"

echo "[$(date)] Backup created: $ARCHIVE_NAME" >> /var/log/backup.log

USER_LIST="users.txt"
DEFAULT_PASSWORD="ChangeMe123"

if [ ! -f "$USER_LIST" ]; then
    echo "File $USER_LIST not found!"
    exit 1
fi

while IFS= read -r user; do
    if id "$user" &>/dev/null; then
        echo "User $user already exists."
    else
        sudo useradd -m -s /bin/bash "$user"
        echo "$user:$DEFAULT_PASSWORD" | sudo chpasswd
        echo "User created: $user"
    fi
done < "$USER_LIST"

echo "[$(date)] Users created from $USER_LIST" >> /var/log/user_creation.log