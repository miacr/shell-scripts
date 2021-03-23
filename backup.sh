#!/bin/sh

print_use()
{
    echo ' -- backup --'
    echo 'Creates a backup of a given file in the current directory'
    echo '\tbackup -s file --> Saves backup of the given file or directory'
    echo '\tbackup -l file --> Loads the given file or directory to saved backup'
    echo '\tbackup -i      --> Returns info of all backup files'
    echo '\tbackup -i file --> Returns info of specific backup file'
    echo '\tbackup -r file --> Removes backup of the file'
    echo '\tbackup -d      --> Wipes all backup data in a directory' 
}

backup_dir_exists()
{
    if ! [ -d .shell_backups ]; then
        echo 'There are no backups in this directory'
        exit
    fi    
}

backup_file_exists()
{
    if ! [ -f "$1" ]; then
        echo 'There is no backup for ' "$1"
        exit
    fi    
}

backup_file_info()
{
    echo "$1 backup information"
    type=$( stat -c %F $1 )
    last_editted=$( stat -c %y $1 | cut -d' ' -f1,2 )
    echo  "    Type: $type"
    echo  "   Saved: $last_editted"
}

if [ $# -eq 2 ]; then
    file="$2"
    # Checks if second argument is a valid file or directory
    if ! [ -f "$file" ] || [ -d "$file" ]; then
        echo \'$file\' 'is not a valid file or directory'
        exit 
    fi

    # -s signals saves file
    if [ $1 = '-s' ]; then 
        if ! [ -d .shell_backups ]; then
            mkdir ./.shell_backups
        fi
        cp "$file" ./.shell_backups/"$file" && echo $file 'backup saved'

    # -l attempts to load a file
    elif [ $1 = '-l' ]; then
        backup_dir_exists
        backup_file_exists "$file"
        cp -r ./.shell_backups/"$file" "$file" && echo $file 'backup loaded'

    # -i gets info on specific backup    
    elif [ $1 = '-i' ]; then
        backup_dir_exists
        backup_file_exists "$file"
        backup_file_info "$file"

    # -r removes a file backup
    elif [ $1 = '-r' ]; then 
        backup_dir_exists
        backup_file_exists "$file"
        rm ./.shell_backups/"$file" && echo $file 'backup removed'
    
    # Unknown flag given
    else    
        print_use
    fi   
elif [ $# -eq 1 ]; then
    if [ $1 = '-d' ]; then
        rm -r ./.shell_backups && echo 'Deleting all backup data in directory'
    elif [ $1 = '-i' ]; then
        echo 'Returning backup info' && ls -l ./.shell_backups
    else
        print_use
    fi
else
    print_use
fi



