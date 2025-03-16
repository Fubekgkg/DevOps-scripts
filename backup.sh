
BACKUP_DIR="/backup"
SOURCE_DIR="/var/www"
ARCHIVE_NAME="backup_$(date +%F_%T).tar.gz"
REMOTE_SERVER="user@backup-server:/remote-backup"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR"

scp "$BACKUP_DIR/$ARCHIVE_NAME" "$REMOTE_SERVER"

echo "[$(date)] Backup created: $ARCHIVE_NAME" >> /var/log/backup.log

