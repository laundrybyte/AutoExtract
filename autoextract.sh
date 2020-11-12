#!/bin/bash

# Checks for lack of arguments or help method
if [ -z "$1" ] ||  [ "$1" == "--help" ]; then
        echo ""
        echo "Usage: autoextract {FILE} [DESTINATION]"
        echo "Extract contents of an archived FILE (into the current directory by default)."
        echo "Supplying the DESTINATION is optional."
        echo ""
        exit
fi

FILE=$1
ABSOLUTEFILE=`realpath $FILE`
DESTINATION=$2
FILERESPONSE=`file $FILE`


# Checks to see if destination was provided; If so, verifies its existence
function changedir {
       if [ -z "$DESTINATION" ]; then
               DESTINATION="current directory"
               return
       else
               if [ -d "$DESTINATION" ]; then
                       cd "$DESTINATION"
                       echo "Changing to directory $DESTINATION..."
               elif [ ! -d $DESTINATION ]; then
                       mkdir "$DESTINATION"
                       echo "Directory doesn't exist yet. Making directory $DESTINATION..."
                       cd "$DESTINATION"
                       echo "Changing to directory $DESTINATION..."
               else
                       echo "Unknown error. Please select a different destination."
                       exit
               fi
       fi
}

# Extracts contents of the compressed file
function extraction {
        tar x"${TARARG}"f "$ABSOLUTEFILE"
}


case "$FILERESPONSE" in
        *"gzip compressed"*)
                FILETYPE="gzip"
                TARARG="z"
                changedir
                extraction
                echo "Extracted $FILE to $DESTINATION"
                ;;
        *"bzip2 compressed"*)
                FILETYPE="bzip2"
                TARARG="j"
                changedir
                extraction
                echo "Extracted $FILE to $DESTINATION"
                ;;
        *"XZ compressed"*)
                FILETYPE="xz"
                TARARG="J"
                changedir
                extraction
                echo "Extracted $FILE to $DESTINATION"
                ;;
        *"Zip archive"*)
                FILETYPE="zip"
                changedir
                unzip "$FILE"
                ;;
        *"POSIX tar archive"*)
                FILETYPE="tar"
                TARARG=""
                changedir
                extraction
                echo "Extracted $FILE to $DESTINATION"
                ;;
        *)
                echo "Unknown filetype selected."
esac
        
