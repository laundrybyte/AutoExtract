#!/bin/bash

FILE=$1
FILERESPONSE=`file $FILE`

function extraction {
        tar x${TARARG}f $FILE
}

case $FILERESPONSE in
        *"gzip compressed"*)
                FILETYPE="gzip"
                TARARG="z"
                extraction
                echo "Extracted $FILE"
                ;;
        *"bzip2 compressed"*)
                FILETYPE="bzip2"
                TARARG="j"
                extraction
                echo "Extracted $FILE"
                ;;
        *"XZ compressed"*)
                FILETYPE="xz"
                TARARG="J"
                extraction
                echo "Extracted $FILE"
                ;;
        *)
                echo "Unknown filetype selected"
esac
