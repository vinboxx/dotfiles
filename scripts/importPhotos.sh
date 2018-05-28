
#!/bin/bash
# Bash Menu Script Example
# This command moves all images originally in directory "$source"
# into a $destination directory hierarchy organized by year/year-month-day

options=( $(df | grep -o '/Volumes/.*') )
PS3='Please select source drive: '
select source in "${options[@]}"
do
    PS3='Please select destination drive: '
    select destination in "${options[@]}"
    do
        echo "Importing photos from $source/DCIM/100MSDCF/ to $destination/Pictures ..."
        echo `mkdir $destination/Pictures/tmp-for-import`
        echo `rsync -Pr $source/DCIM/100MSDCF/. $destination/Pictures/tmp-for-import/.`
        echo `exiftool "-Directory<DateTimeOriginal" -d "$destination/Pictures/%Y/%Y-%m-%d" $destination/Pictures/tmp-for-import`
        echo `rm -rf $destination/Pictures/tmp-for-import`
        break
    done
    break
done
