function backup_file () {
  # Make sure the directory exists.
  if [ -d "$DIR" ] 
  then
    # Zipping up the directory
    tar cvfP BACKUP_HOME-`(date +%y-%m-%d:%H%M)`.cvf /home
    
  else
    echo "Directory may not exist."
    return 1
  fi
}

# Call the function
backup_file

