# UUID-with-bash
generate UUID with bash scripting V1 and V4 are currently supported.  The only requirment on the system is tr, date, /dev/urandom and dd.

## background
I needed a UUID generator for a Raspian based device and I could not rely on uuidgen being present on the system.  

## Not Implemented Yet
V1 UUID generation does not support clock sequence yet, for now its fixed to 0000.   There is a framwork to store the time stamp in /etc/uuid/ts.txt and the clock sequence in /etc/uuid/cs.txt but no initializtion or storage is currently implemented.  Be aware if this is important to you.

## License
MIT License
