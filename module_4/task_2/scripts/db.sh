DB="../data"
USERS="$DB/users.db"
BACKUP="$DB/backups"
SCRIPTS="../scripts"

menu() {
    echo "Use: $0 [command]"
    echo "Commands:"
    echo "add       - Add a new user"
    echo "backup    - Create a backup"
    echo "restore   - Restore db from backup"
    echo "find      - Find a user"
    echo "list      - List all users"
    echo "help      - Show this help message"
}

checkDbExists() {
    if [ ! -e "$USERS" ]; then
        read -p "users.db file does not exist. Create? (y/n): " createDb
        if [ "$createDb" = "y" ]; then
            mkdir -p "$DB"
            touch "$USERS"
            echo "users.db created"
        else
            echo "exit"
            exit 1
        fi
    fi
}

validate() {
    if ! echo "$1" | grep -Eq "^[a-zA-Z]+$"; then
        echo "use only latin letters"
        exit 1
    fi
}

addUser() {
    checkDbExists
    read -p "enter username: " userName
    validate "$userName"
    read -p "enter role: " role
    validate "$role"
    echo "$userName, $role" >> "$USERS"
    echo "user added"
}

backup() {
    checkDbExists
    mkdir -p "$BACKUP"
    backupFile="$BACKUP/$(date +'%Y-%m-%d')-users.db.backup"
    cp "$USERS" "$backupFile"
    echo "backup created: $backupFile"
}

restore() {
    checkDbExists
    lastBackup=$(ls -1t "$BACKUP" | head -n 1)
    if [ -n "$lastBackup" ]; then
        cp "$BACKUP/$lastBackup" "$USERS"
        echo "database restored from: $lastBackup"
    else
        echo "no backup file found"
    fi
}

findUser() {
    checkDbExists
    read -p "enter username: " searchUsername
    grep -i "^$searchUsername," "$USERS"
    if [ $? -ne 0 ]; then
        echo "user not found"
    fi
}

list() {
    checkDbExists
    if [ "$1" = "--inverse" ]; then
        tac "$USERS" | awk '{print NR". "$0}'
    else
        awk '{print NR". "$0}' "$USERS"
    fi
}

if [ $# -eq 0 ] || [ "$1" = "help" ]; then
    menu
elif [ "$1" = "add" ]; then
    addUser
elif [ "$1" = "backup" ]; then
    backup
elif [ "$1" = "restore" ]; then
    restore
elif [ "$1" = "find" ]; then
    findUser
elif [ "$1" = "list" ]; then
    list "$2"
else
    echo "invalid command. use '$0 help' for usage instructions"
fi
