#!/bin/bash
last_tag=$1

all_tag=$(git tag)

tag_befor=`echo $all_tag |rev| cut -d " " -f2 | rev`

test_last=`echo $last_tag | cut -d '.' -f1`
test_befor=`echo $tag_befor | cut -d '.' -f1`
# if [ "$last_tag" -eq "$tag_befor" ];then
if [ "$test_last" -eq "$test_befor" ];then
    test_last=`echo $last_tag | cut -d '.' -f2`
    test_befor=`echo $tag_befor | cut -d '.' -f2`
    if [ "$test_last" -eq "$test_befor" ];then
    test_last=`echo $last_tag | cut -d '.' -f3`
    test_befor=`echo $tag_befor | cut -d '.' -f3`
        if [ "$test_last" -gt "$test_befor" ];then
        echo "$last_tag is good" 
        else
        echo "tag not good"
        exit 1
        fi
    elif [ "$test_last" -gt "$test_befor" ];then
    echo "$last_tag is good" 
    else
    echo "tag not good"
    exit 1 
    fi
elif [ "$test_last" -gt "$test_befor" ];then
echo "$last_tag is good" 
elif [ "$tag_befor" -eq "$last_tag" ]
echo "$last_tag is good" 
else
echo "tag not good"
exit 1
fi