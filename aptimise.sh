#!/bin/bash
set -euo pipefail #safety line

#aptimise.sh - written by bpm
#Generated by mkscript: 2018-02-28 14:51:46 GMT

VERSION=0.1.0

#installed=$(dpkg-query -W -f '${Package}\t${Status}\n' | awk '$NF=="installed"{print $1}')
installed=${*:-$(apt-mark showmanual)}
#installed=$(apt list --manually-installed)

declare -A list

for i in $installed; do
    list["$i"]=0;
done

for i in $installed; do
    if [ ${list["$i"]} > 0 ]; then continue; fi
    deps=$(apt-cache depends -i --implicit --recurse "$i" | grep -oP "Depends:\\s<?\K.*") || true

    for j in $deps; do
        #echo "  $i:$j"
        if [ "${list["$j"]:-"false"}" ]; then
            list["$i"]++;
            continue;
        fi
    done
done

for i in $installed; do
    if ${list["$i"]} == "true"; then echo $i; fi
    printf '\t%s: %s\n' $i ${list["$i"]}
done
