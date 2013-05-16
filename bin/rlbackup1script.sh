 #!/bin/bash

 # rlbackup
 # (Rsync Local Backup or RLB)
 # by brian wonders 20/08/2008
 # Based on 4 lines of code from "Time Machine for every Unix out there"
 # <http://blog.interlinked.org/tutorials/rsync_time_machine.html>
 # 
 # Just fill in the next 3 configuration values - that's it :)

 SOURCE=/home/matt/
 DESTPATH=/media/E65CE4405CE40D5D/13mar2013
 EXCLUDEFILE=/home/matt/excludes

 # === Usage ===
 #
 #   0. Do not use spaces in any of the configuration values!
 # 	e.g 
 #	This is OK:  DESTPATH=/media/medion1/disasterrecovery/Backups
 #
 # 	This is NOT: DESTPATH=/media/medion1/disaster recovery/Back ups
 #                                                   ^             ^
 # 	This is NOT: DESTPATH="/media/medion1/disasterrecovery/Back ups"
 #                                                                 ^
 #   1. The source path (SOURCE)
 #	e.g
 #	/
 #	what do you want to backup?
 #	This example would backup the whole system.
 #
 #   2. The destination path (DESTPATH)
 #	e.g
 #	/media/medion1/Backups
 #	Where do you want the backup to be saved to?
 #	This example would backup to my external USB hard drive.
 #
 #   3. The exclude file path (EXCLUDEFILE)
 #	e.g
 #	/media/medion1/Backups/rlbackup1exclude.txt
 #	A file listing directories I don't want backed up (1 line per item).
 #	/home/*/.gvfs /home/*/.mozilla/firefox/*/Cache home/*/.thumbnails
 #	/home2 /home3 /backup /backup2 /windows /lib/modules/*/volatile/*
 #	/lost+found /media /mnt /proc /sys /tmp/ /var/run /var/lock 

 # === Preferences ===
 # You can leave these set to the defaults.
 #
 # If set to "0" this will list Apparent size of backup and actual usage.
 # If set to "4" this will list Actual usage for the last 4 backups.
 # If set to "9" this will list Actual usage for all backups.
 PREF_DISKUSAGE=4

 # If set to "1" this will list the size of each directory.
 # Does not add much time but adds a long list to the RLBLOG.
 PREF_DIRLIST=0

 # If set to "1" then open log in editor
 # Open Editor once backup complete, but continue processing the log.
 # NOTE: If you are using this script with crontab you may wish to set both to "0".
 PREF_POPUP1=0
 PREF_POPUP2=1

 # Set your text editor
 PREF_EDIT="gedit"

 
 # === Notes ===
 # This script is the result of wanting a simple backup solution.
 # For this I needed an efficient way of running rsync for local backups.
 #
 # My idea was to keep it simple, hence using only bash & rsync.
 # But also to log useful information so I could easily verify success.
 #
 # Logs:
 # Most of the useful information is written to RLBLOG which is quite small.
 # LOGFILE is rsync's own built in log (10x smaller than OUTPUTLOG). 
 # OUTPUTLOG is just that.
 # rlberror.log is only created if there are validation errors.
 #
 # Deleting Backups:
 # You can delete any backup without affecting others.
 # If you delete the newest backup you will need to:
 # Create a symbolic link to it called "current-0"
 # If this isn't done rsync does a full backup - no hard-linking.
 #
 # Troubleshooting:
 # Check the start of the log this gives the rsync command you ran.
 # Investigate and see if the options and arguments are correct.
 # Check how many files were transferred & which directories hidden.
 # Check how much Free Space is detailed in the log.
 # Run from a terminal to see any error messages (I run from a root terminal).
 #
 # While researching rsync and hard-linking I came across this article:
 # "Time Machine for every Unix out there" 
 # <http://blog.interlinked.org/tutorials/rsync_time_machine.html>
 # Like so many brilliant ideas it was deceptively simple, just 4 lines of code!
 # The key insight was the way a link was created to point to the new backup.
 # This link saved the previous directory name between runs of the script.
 # This is essential to make backups efficiently by hard-linking.
 #
 # Also interesting is this article by mike rubel:
 # "Easy Automated Snapshot-Style Backups with Linux and Rsync"
 # <http://www.mikerubel.org/computers/rsync_snapshots/>
 # 
 # Also see rsnapshot <http://www.rsnapshot.org/>
 # A business strength snapshot solution (depends on perl, logrotate & rsync).



 # ===> No need to alter anything below this point <===



 # User input validation
 # Check if string is zero length and that directory or file exits.
 if [ -z $DESTPATH ] || [ ! -d $DESTPATH ] ; then
	echo -n "DESTPATH ERROR - "
	echo "Backup destination does not exist or you don't have permission!"
	date -R >> rlberror.log
	echo -n "DESTPATH ERROR - "
	echo "Backup destination does not exist or you don't have permission!" >> rlberror.log
	echo "Exiting..."
	exit 2
 fi


 if [ -z $SOURCE ] || [ ! -d $SOURCE ]; then
	echo -n "SOURCE ERROR - "
	echo "Backup source does not exist or you don't have permission!"
	date -R >> rlberror.log
	echo -n "SOURCE ERROR - "
	echo "Backup source does not exist or you don't have permission!" >> rlberror.log
	echo "Exiting..."
	exit 2
 fi
 

 if [ -z $EXCLUDEFILE ] || [ ! -r $EXCLUDEFILE ]; then
	echo -n "EXCLUDEFILE ERROR - "
	echo "Backup exclude file does not exist or you don't have permission!"
	date -R >> rlberror.log
	echo -n "EXCLUDEFILE ERROR - "
	echo "Backup exclude file does not exist or you don't have permission!" >> rlberror.log
	echo "Exiting..."
	exit 2
 fi

 # Build Backup Strings
 DATE=`date "+%Y-%m-%d_%H-%M-%S"`
 BACKUPNAME=$DESTPATH/back-$DATE
 OUTPUTLOG=$BACKUPNAME-OUTPUT.txt
 RLBLOG=$BACKUPNAME-RLBLOG.txt
 LOGFILE=$BACKUPNAME-LOGFILE.txt
 LINE="============================================================"
 

 # Build Options String.
 OPT_FLAGS=-ahvv
 OPT_LOGFILE=--log-file=$LOGFILE
 #OPT_DEL=--delete
 OPT_LINKDEST=--link-dest=$DESTPATH/current-0
 OPT_EXCLUDE=--exclude-from=$EXCLUDEFILE
 OPT_STATS=--stats
 
 OPT="$OPT_FLAGS $OPT_LOGFILE $OPT_DEL $OPT_LINKDEST $OPT_EXCLUDE $OPT_STATS"

 # Functions.
 print_dat()
 {
 	echo >> $RLBLOG
 	date -R >> $RLBLOG
 	echo >> $RLBLOG
 }

 print_s()
 {
	info="$1"
 	echo $info >> $RLBLOG
 }

 print_sn()
 {
	info="$1"
 	echo -n $info >> $RLBLOG
 }

 getlinkinfo()
 {
	linfo="$1"
	LINKINFO="Nothing"
	TEMP_EXTRACT="Nothing"
	# could use readlink
	LINKINFO=$(stat $DESTPATH/$linfo | grep "$linfo")
	print_sn "LINK: -"
 	print_s "$LINKINFO"
	TEMP_EXTRACT=`expr match "$LINKINFO" '.*\(back-....-..-.._..-..-..\)'`
 }

 # cd to main directory (mainly redundant).
 print_s $DESTPATH
 cd $DESTPATH
 pwd >> $RLBLOG
 
 # Save to RLBLOG the arguments and options you are running.
 print_s
 print_s "rsync $OPT $SOURCE $BACKUPNAME"
 print_s

 # Find last backup directory fron link.
 getlinkinfo "current-0"
 EXTRACT0=$DESTPATH/$TEMP_EXTRACT
 print_sn "EXTRACT0: -"
 print_s $EXTRACT0

 getlinkinfo "current-1"
 EXTRACT1=$DESTPATH/$TEMP_EXTRACT
 print_sn "EXTRACT1: -"
 print_s $EXTRACT1

 getlinkinfo "current-2"
 EXTRACT2=$DESTPATH/$TEMP_EXTRACT
 print_sn "EXTRACT2: -"
 print_s $EXTRACT2

 print_s $LINE

 # Save to RLBLOG the disk space before the backup.
 print_s
 print_s "Free Space on $DESTPATH"
 df -h $DESTPATH >> $RLBLOG
 print_s
 print_s $LINE
 
 print_s
 print_s "Backup started:"
 print_dat

 # The main rsync command
 rsync $OPT $SOURCE $BACKUPNAME > $OUTPUTLOG
 rm $DESTPATH/current-2
 mv $DESTPATH/current-1 $DESTPATH/current-2
 mv $DESTPATH/current-0 $DESTPATH/current-1
 ln -s back-$DATE $DESTPATH/current-0

 # Save to RLBLOG the time and disk space after the backup.
 print_s "Backup finished:"
 print_dat
 print_s $LINE

 print_s
 print_s "Free Space on $DESTPATH"
 df -h $DESTPATH >> $RLBLOG
 print_s
 print_s $LINE

 # Save to RLBLOG the tail of OUTPUTLOG & LOGFILE.
 print_s
 print_s "Statistics"
 tail -n15 $OUTPUTLOG >> $RLBLOG
 print_s

 #print_s
 #tail -v -n50 $LOGFILE >> $RLBLOG
 #print_s

 # Save to RLBLOG a grep of LOGFILE showing the files transferred.
 print_s
 print_sn "Number of files transferred:"
 grep -c '] >f' $LOGFILE >> $RLBLOG
 print_s
 grep '] >f' $LOGFILE >> $RLBLOG
 print_s

 # Save to RLBLOG a grep of OUTPUTLOG showing hidden directories.
 print_s
 print_sn "Number of Excludes:"
 grep -c '] hiding' $OUTPUTLOG >> $RLBLOG
 print_s
 grep '] hiding' $OUTPUTLOG >> $RLBLOG
 print_s
 print_s $LINE

 print_dat

 # View backup results but continue processing the rest of the log.
 if [ $PREF_POPUP1 -eq 1 ]; then
	print_s
 	print_s "<======> backup has completed so view the results <======>"
	print_s "<======> ......continuing to process the log..... <======>"
	print_s
 	$PREF_EDIT $RLBLOG &
 fi


 	# Save to RLBLOG the Total size of 4 backups.
 if [ $PREF_DISKUSAGE -eq 4 ]; then
 	print_s "Actual usage for the last 4 backups:"
 	du -shc $EXTRACT2 $EXTRACT2 $EXTRACT1 $EXTRACT0 $BACKUPNAME >> $RLBLOG
 	print_dat

 	# Save to RLBLOG the Total size of all backups.
 elif [ $PREF_DISKUSAGE -eq 9 ]; then
 	print_s "Actual usage for all backups:"
 	du -shc back-* >> $RLBLOG
 	print_dat
 else
	# Save to RLBLOG the Total size of this backup.
 	print_s
 	print_s "Apparent size of backup and actual usage:"
 	du -shc $BACKUPNAME $BACKUPNAME >> $RLBLOG
 	print_dat
 fi
 print_s $LINE

 # Save to RLBLOG the usage for each directory.
 if [ $PREF_DIRLIST -eq 1 ]; then
	print_dat
 	print_s "Directory List"
 	du -h $BACKUPNAME >> $RLBLOG
	print_dat
 fi

 # gzip the logs and move them into the backup folder (to keep things tidy).
 gzip -c $OUTPUTLOG > $OUTPUTLOG.gz
 gzip -c $LOGFILE > $LOGFILE.gz
 mv $OUTPUTLOG.gz $BACKUPNAME
 mv $LOGFILE.gz $BACKUPNAME
 
 # delete the original, uncompressed logs
 rm $OUTPUTLOG
 rm $LOGFILE

 print_s
 print_s "Done."
 mv $RLBLOG $BACKUPNAME

 # View backup results.
 if [ $PREF_POPUP2 -eq 1 ]; then
 	$PREF_EDIT $BACKUPNAME/back-$DATE-RLBLOG.txt &
 fi



