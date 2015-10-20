#!/bin/bash
# Launch process_radtags on all the lanes
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)

# Copy script as it was run
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98-log_files"
INFO_FILES_FOLDER="01-info_files"
SAMPLE_INFO="sample_information.csv"

cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"
cp $INFO_FILES_FOLDER/$SAMPLE_INFO $LOG_FOLDER/"$TIMESTAMP"_"$SAMPLE_INFO"

### Global variable
INFO_FILES="01-info_files"
TRIM_LENGTH=$1 # Length to cut reads after process_radtags
ENZYME=$2  # Name of the enzyme (run 'process_radtags' without options for list)


# Write command to file
echo -e "process_radtags commande used:\n\n\
    $(echo process_radtags.sh $TRIM_LENGTH $ENZYME1 $ENZYME2)" \
> 98-log_files/process_radtags_command.log

# Extract reads
cat $INFO_FILES/lane_info.txt |
while read f
do
    grep -vE "^$" $INFO_FILES/sample_information.csv  | \
        grep "$f" | \
        grep -v "Barcode" | \
        cut -f 2 > $INFO_FILES/barcodes.txt

    # Extract the barcodes of all different lengths at once, STACKS 1.23+
    mkdir 03-samples/$f 2> /dev/null
    process_radtags \
        -i gzfastq \
        -f 02-raw/trimmed/$f".fastq.gz" \
        -o 03-samples/$f \
        -b $INFO_FILES/barcodes.txt \
        -c -q -r -t $TRIM_LENGTH \
        --barcode_dist_1 2 \
        -E phred33 \
        -e $ENZYME


    # Copy log files to ./98_log_files/
    cp 03-samples/$f/process_radtags.log 98-log_files/"$TIMESTAMP"_02_process_radtags_"$f".log
done

