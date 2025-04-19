BACKUP_DIR=./backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

echo "Backing up database..."
docker exec nextcloud-db sh -c 'exec mysqldump -unextcloud -p"$MYSQL_PASSWORD" nextcloud' > "$BACKUP_DIR/db/nextcloud-db_$TIMESTAMP.sql"

echo "Backing up data volume..."
docker run --rm \
  -v nextcloud-html:/volume \
  -v "$PWD/$BACKUP_DIR/data:/backup" \
  alpine \
  sh -c "cp -a /volume/data /backup/data_$TIMESTAMP"

echo "Backing up config volume..."
docker run --rm \
  -v nextcloud-html:/volume \
  -v "$PWD/$BACKUP_DIR/config:/backup" \
  alpine \
  sh -c "cp -a /volume/config /backup/config_$TIMESTAMP"

echo "Backup completed!"
