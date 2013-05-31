#!/bin/bash

# This script get the last naruto chapter from mangafox
# Require : curl, wget, zip

SCAN='naruto'
CHAPTER=${1}
RSSURL="http://mangafox.me/rss/${SCAN}.xml"
DOWNLOADDIR='/tmp/scans'
LASTFILE="/tmp/${SCAN}_last.txt"
ZIPFILE=1 #1, if I want to create a zip instead of having a directory

if [[ -z ${CHAPTER} ]]; then
    echo "Usage: $0 <chapter>"
    exit 
fi

function main {
    chap=$1
    downloadTo="${DOWNLOADDIR}/${SCAN}/c${chap}"
    mkdir -p $downloadTo
    
    startUrl=$(curl -s ${RSSURL} |grep '<link>' | sed 's/<link>//g' | sed 's/<\/link>//g' |grep -F "/c${chap}/")
    baseUrl=$(echo ${startUrl} |grep -Eo '.*/')
    startPage=$(curl -s ${startUrl} |grep -Eo 'var current_page=[0-9]+;' |grep -Eo '[0-9]+')
    endPage=$(curl -s ${startUrl} |grep -Eo 'var total_pages=[0-9]+;'|grep -Eo '[0-9]+')
    echo "$chap [${startPage}/${endPage}]"
    
    i=${startPage}
    while [ ${i} -lt ${endPage} ]; do
        htmlUrl="${baseUrl}${i}.html" 
        #echo "htmlUrl : $htmlUrl" #Debug
        imgUrl=$(curl -s ${htmlUrl} |grep '<img src' |grep -Eo 'src=".*"' |awk -F'"' '{print $2}' |head -n1)
        echo "imgUrl  : $imgUrl"
        wget -qP ${downloadTo}/ "$imgUrl"
        let i=i+1
    done
    if [[ $ZIPFILE == 1 && ! -f ${downloadTo}.zip ]];then
        zip -jr ${downloadTo}.zip ${downloadTo}/*
        rm -rf ${downloadTo}
    fi
    echo $chap > $LASTFILE 
}

if [[ ${CHAPTER} == last ]]; then
    if [[ -f $LASTFILE ]]; then
        current=$(cat $LASTFILE)
        last=$(curl -s  ${RSSURL} |grep -F '<link>' |grep -F "${SCAN}" |head -n1 |grep -Eo '/c[0-9]+' |sed 's/\/c//g')
        echo ${current}/${last}
        j=${current}
        while [ ${j} -lt ${last} ]; do
            let j=j+1
            main $j
        done
    else
        echo "[ERROR] Last file ($LASTFILE) doesn't exist"
        mayBeLast=$(curl -s  http://mangafox.me/rss/naruto.xml |grep -Eo 'title.*[0-9]{3,4}' |head -n1)
        echo "Last may be: $mayBeLast"
        exit
    fi
fi

## Syntax changed since 100
if [[ ${CHAPTER}  =~ ^[0-9]+$ ]];then
    if [[ ${CHAPTER} -lt 100 ]]; then
        echo "chapter: $CHAPTER must be higher than 100" 
        exit
    fi
    main $CHAPTER
fi

