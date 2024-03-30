#! /bin/bash

# mydisks() {

#     find $* -type l -printf "%f %l\n" | grep -Pv '^md|-part\d|^wwn-|^nvme-eui|^nvme-nvme' | egrep '^ata|^nvme' | sed -e 's#.*/##g'| tr '\n' ' '
# }

# This is really important, because we use shell globbing for creating the list of disks
# cd /dev/disk/by-id || echo Cannot get disk information
fastestdisk() {
    DISKS=$(all_disks_and_size | sort -n  -k2 | checkdisk $FAI_BOOTSTICK)
    SORTED_DISKS=""
    for disk in $DISKS; do
        if [ "nvme" = "${disk:0:4}" ]; then
            SORTED_DISKS="$disk
$SORTED_DISKS"
        elif [ "sd" = "${disk:0:2}" ]; then
            SORTED_DISKS="$SORTED_DISKS
$disk"
        fi
    done

    echo "$SORTED_DISKS" | sed '/^$/d' | head -1
}



# case $HOSTNAME in
#       server1) newlist=$(mydisks *WD3000FYYZ* *0F400HGN* ) ;;
#         bier*) newlist=$(mydisks *WDC_WD320* *ST31000* *SAMSUNG_HD502* ) ;;
#       server2) newlist=$(mydisks *_SSD_* *TOSHIBA* ) ;;
#     *)         newlist=$(mydisks nvme* ) ;;
# esac
newlist=$(fastestdisk)
if [ -n "$newlist" ]; then
    echo New disklist: $newlist
    echo disklist=\"$newlist\" >> $LOGDIR/additional.var
fi
