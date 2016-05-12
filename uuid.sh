#!/bin/bash
#
#  bash uuid Generator
#
#  generate_id.sh <version> <MAC> 
#
#  https://github.com/lowerpower
#
#  Generates UUID in the formate 00000000-0000-0000-0000-000000000000

#### Settings #####
VERSION=0.0.1
MODIFIED="May 11, 2016"
#
# Defaults
CLOCK_SEQ="/etc/uuid/cs.txt"
TIMESTAMP="/etc/uuid/ts.txt"
VERBOSE=0

# found at https://github.com/remind101/tugboat
julian=2299160          #Julian day of 15 Oct 1582
unix=2440587            #Julian day of 1 Jan 1970
epoch=$(expr $unix - $julian)
g1582=$(expr $epoch \* 86400)               # seconds between epochs
g1582ns100=$(expr $g1582 \* 10000000)     #100s of a nanoseconds between epochs

# Built in manpage
#
manpage()
{
#
# Put manpage text here
#
read -d '' man_text << EOF

This is a manpage

EOF
#
printf "\n%s\n\n\n" "$man_text"
}


#
# Print Usage
#
usage()
{
    echo "Usage: $0 <flags> command <uid>" >&2
    echo "  commands : types typesl status enable disable start stop restart create delete login logout" >&2
    echo "Version $VERSION Build $MODIFIED" >&2
    exit 1
}


dec2hex()
{
    printf "%x" $1
}

generate_uuid_null()
{
    echo "00000000-0000-0000-0000-000000000000"
}

# $1 is mac
generate_uuid_v1()
{
    # remove : if found
    inmac=$1
    #mac=$(echo "$1" | sed -e 's/://g')
    mac=$(echo "${inmac//:}")

    seconds=$(date -u +%s)
    snano100=$(expr $seconds \* 10000000)
    nano=$(date -u +%N)
    nano100=$(expr $nano / 100)

    now100=$(expr $snano100 + $nano100 + $g1582ns100)

    # appends the version "1" at beginning
    hex_time_100=1$(dec2hex $now100)

    # Print out UUID v1
    # first 32 bits then dash (time_low)
    printf "%s-" ${hex_time_100: -8}
    # next 16 bits then a dash (time_mid)
    printf "%s-" ${hex_time_100: -12: 4}
    #time_hi and version
    printf "%s-" ${hex_time_100: -16: 4}
    # clock seq_hi and reserved + clock_seq_low, for now we do not support, just zero
    # need to add this feature
    printf "0000-"
    # print MAC
    printf "%s" $mac

}


generate_uuid_v4()
{
    eight=$(tr -dc a-f0-9 < /dev/urandom | dd bs=8 count=1 2> /dev/null)
    four1=$(tr -dc a-f0-9 < /dev/urandom | dd bs=4 count=1 2> /dev/null)
    four2=$(tr -dc a-f0-9 < /dev/urandom | dd bs=4 count=1 2> /dev/null)
    four3=$(tr -dc a-f0-9 < /dev/urandom | dd bs=4 count=1 2> /dev/null)
    twelve=$(tr -dc a-f0-9 < /dev/urandom | dd bs=12 count=1 2> /dev/null)
    
    printf "${eight}-${four1}-${four2}-${four3}-${twelve}"
}



#---------------------------------------------------------------------------
# Main Program Starts Here
#---------------------------------------------------------------------------

################################################
# parse the flag options (and their arguments) #
################################################
while getopts vhm OPT; do
    case "$OPT" in
      m)
        manpage
        exit 0
        ;;
      v)
        VERBOSE=$((VERBOSE+1)) ;;
      h | [?])
        # got invalid option
        usage
        ;;
    esac
done

# get rid of the just-finished flag arguments
shift $(($OPTIND-1))


#switch on version
command=$1
shift

case "$command" in
    "0")
        generate_uuid_null
        ;;
    "1")
        # make sure we have a MAC
        generate_uuid_v1 $1
        ;;
    "2")
        #
        echo "uuid type 2, TBD"
        ;;
    "3")
        #
        echo "uuid type 3, TBD"
        ;;
    "4")
        #
        generate_uuid_v4
        ;;
    "5")
        #
        echo "uuid type 5, TBD"
        ;;
    *)
        usage
        exit 1
        ;;
esac

exit 0







id=$(generate_uuid_v4)
printf "$id\n"





