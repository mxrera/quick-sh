#! /bin/bash

dynamic_import(){
    search_dir=$(find packages -type f -not -path '*/\.*' | sed 's/^\.\///g' | sort)
    for entry in $search_dir;  do
        . $entry
    done
}