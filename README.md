# UUID-with-bash
generate UUID with bash scripting V1 and V4 are currently supported.  The only requirment on the system is tr, date, /dev/urandom and dd.

## background
I needed a UUID generator for a Raspian based device and I could not rely on uuidgen being present on the system.  


## Not Implemented Yet
V1 UUID generation does not support clock sequence , for now its fixed to random.  At one time there was a framework to use a file to increment the clock sequence, but this has been abandon
for just a random generated clock sequence.

## verson 0.0.2 6/9/2021
I had done some extensive modifications that were never checked in, I just realized it and here it is.

## License
MIT License
