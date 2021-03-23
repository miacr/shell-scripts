# Fetches and unzips a file

if [ $# != 1 ]; then
    echo "Usage: $0 [link to zip file]"
    exit
fi

url=$1
filename=$(basename $url)

wget $url && unzip $filename
