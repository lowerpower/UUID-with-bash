#!/bin/bash
#
#  bash uuid Generator
#
#  generate_id.sh <version> <MAC> 
#
#  https://github.com/lowerpower/UUID-with-bash
#
#  Generates UUID in the format 00000000-0000-0000-0000-000000000000
#  Octet Numbers				00112233-4455-6677-8899-AABBCCDDEEFF
#
#  
#Field                  Data Type     Octet  Note
#
#time_low               unsigned 32   0-3    The low field of the
#                       bit integer          timestamp
#
#time_mid               unsigned 16   4-5    The middle field of the
#                       bit integer          timestamp
#
#time_hi_and_version    unsigned 16   6-7    The high field of the
#                       bit integer          timestamp multiplexed
#                                            with the version number
#
#clock_seq_hi_and_rese  unsigned 8    8      The high field of the 
#rved                   bit integer          clock sequence
#                                            multiplexed with the
#                                            variant
#
#clock_seq_low          unsigned 8    9      The low field of the
#                       bit integer          clock sequence
#
#node                   unsigned 48   10-15  The spatially unique
#                       bit integer          node identifier
#
#
#0                   1                   2                   3
# 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#|                          time_lowi(0-3)                       |
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#|       time_mid(4-5)           |  time_hi_and_version(6-7)     |
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#|clk_seq_hi_res |clk_seq_low(9) |         node 0-1 (10-11)      |
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#|                         node (12-15)                          |
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#
#
# Version  xxxxxxxx-xxxx-Vxxx-xxxx-xxxxxxxxxxxx
#Msb0  Msb1  Msb2  Msb3   Version  Description
#
# 0     0     0     1        1     The time-based version
#                                  specified in this document.
#
# 0     0     1     0        2     DCE Security version, with
#                                  embedded POSIX UIDs.
#
# 0     0     1     1        3     The name-based version
#                                  specified in this document
#                                  that uses MD5 hashing.
#
# 0     1     0     0        4     The randomly or pseudo-
#                                  randomly generated version
#                                  specified in this document.
#
# 0     1     0     1        5     The name-based version
#                                  specified in this document
#                                  that uses SHA-1 hashing.
#
#
# Variant  xxxxxxxx-xxxx-xxxx-Vxxx-xxxxxxxxxxxx
#Msb0  Msb1  Msb2  Description
#
# 0     x     x    Reserved, NCS backward compatibility.
#
# 1     0     x    The variant specified in this document (RFC4122)
#
# 1     1     0    Reserved, Microsoft Corporation backward
#                  compatibility
#
# 1     1     1    Reserved for future definition.
#
#

#### Settings #####
VERSION=0.0.2
MODIFIED="June 9, 2021"
#
# Defaults
USE_CLOCK_SEQ=0
#CLOCK_SEQ="/etc/uuid/cs.txt"
#TIMESTAMP="/etc/uuid/ts.txt"
VERBOSE=0


# instead of hadcoding the 100's of nanoseconds to base on for 1 Jan 1970 offset
# lets caclulate it so it is clear what is going on.
# found at https://github.com/remind101/tugboat
julian=2299160                              #Julian day of 15 Oct 1582
unix=2440587                                #Julian day of 1 Jan 1970
epoch=$(expr $unix - $julian)               #differnce between epocs
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
    echo "Usage: $0 <flags> command <mac>" >&2
    echo "  flags -v=verbose -h=help -m=manpage ">&2
    echo "  commands : 0=null uuid, 1= version 1 uuid <mac optional> Random MAC if not specified, 4=version 4 uuid " >&2
    echo "Version $VERSION Build $MODIFIED" >&2
    exit 1
}


dec2hex()
{
    printf "%x" $1
}

setVariant()
{
    # set Variant  RFC 4122  01xx xxxx xxxx xxxx
	printf "%x" $(((0x$1 & 0x3fff) | 0x8000))
}

setVersion4()
{
	#set ver 4
    #Set the two most significant bits (bits 6 and 7) of the clock_seq_hi_and_reserved (8) to zero and one, respectively.	
	printf "%x" $(((0x$1 & 0x0fff) | 0x4000))
}

setMulticast()
{
    printf "%x" $((0x$1 | 0x010000000000))
}

generate_uuid_null()
{
    printf "00000000-0000-0000-0000-000000000000"
}

#
# Generate time and mac based UUID
#
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
    # clock seq_hi and reserved + clock_seq_low, for now we do not support, just randomize
    # re RFC4122 (If the previous value of the clock sequence is known, it can just be incremented; otherwise it should be set to a random or high-quality pseudo-random value.)
    # need to add this feature, we set variant to 10
    clock=$(tr -dc a-f0-9 < /dev/urandom | dd bs=8 count=1 2> /dev/null)
    clock=$(setVariant $clock)
   
    #if mac not set randomize :  For systems with no IEEE address, a randomly or pseudo-randomly generated value may be used.
    # The multicast bit must be set in such addresses, in order that they will never conflict with addresses obtained from network cards.
    #if $1 or mac is not set or zero we randomize
    if [ -z "${mac}" ]; then
        # mac is not set or set to an empty string, lets randomize it
        mac=$(tr -dc a-f0-9 < /dev/urandom | dd bs=12 count=1 2> /dev/null)
        #
        #force unicast bit on
        mac=$(setMulticast $mac)
    fi


    # print clock and MAC
    printf "%s-%s" $clock $mac
}


#
# Generate Compleatly Random UUID based on urandom
#
generate_uuid_v4()
{
	#first 4 octets (set1)  (XXXXXXXX-0000-0000-0000-000000000000)
    eight1=$(tr -dc a-f0-9 < /dev/urandom | dd bs=8 count=1 2> /dev/null)
    #next 2 octets   (00000000-XXXX-0000-0000-000000000000)
	four2=$(tr -dc a-f0-9 < /dev/urandom | dd bs=4 count=1 2> /dev/null)
    #next 2 octets less 4msb   (00000000-0000-XXXX-0000-000000000000)
    #Version  xxxxxxxx-xxxx-Vxxx-xxxx-xxxxxxxxxxxx
    three3=$(tr -dc a-f0-9 < /dev/urandom | dd bs=3 count=1 2> /dev/null)
    #next 2 octets less  (00000000-0000-0000-XXXX-000000000000)
    four4=$(tr -dc a-f0-9 < /dev/urandom | dd bs=4 count=1 2> /dev/null)
    four4=$(setVariant $four4)
    #last 6 octets   (00000000-0000-0000-0000-XXXXXXXXXXXX)
    twelve5=$(tr -dc a-f0-9 < /dev/urandom | dd bs=12 count=1 2> /dev/null)
   
    #we prepend the version 4 before the 3 nibbels of the 3rd set
    printf "${eight1}-${four2}-4${three3}-${four4}-${twelve5}"
}



#---------------------------------------------------------------------------
# Main Program Starts Here
#---------------------------------------------------------------------------
linefeed=0
################################################
# parse the flag options (and their arguments) #
################################################
while getopts vhlm OPT; do
    case "$OPT" in
      m)
        manpage
        exit 0
        ;;
      v)
        VERBOSE=$((VERBOSE+1)) 
        ;;
      l)
        linefeed=1
        ;;
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

# send a linefeed?
if [ 1 == $linefeed ]; then
    printf "\n"
fi

exit 0



id=$(generate_uuid_v4)
printf "$id\n"





