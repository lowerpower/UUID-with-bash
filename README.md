# UUID-with-bash
generate UUID with bash scripting V1 and V4 are currently supported.  The only requirement on the system is tr, date, /dev/urandom and dd.

## background
I needed a UUID generator for a Raspian based device and I could not rely on uuidgen being present on the system.  Uses /dev/urandom so should be
crypto secure.

## Usage Examples

* Generate a nil UUID (all zeros)
```
dood:~/$ ./uuid.sh 0
00000000-0000-0000-0000-000000000000dood:~/$
```
With linefeed
```
dood:~/$ ./uuid.sh -l 0
00000000-0000-0000-0000-000000000000
dood:~/$
```

* Generate a Version 1 UUID with MAC
```
./uuid.sh -l 1 01:02:03:04:05:06
a308ee93-d1a5-11f1-a0b0-010203040506
```
Without Colons 
```
./uuid.sh -l 1 010203040506
a310b2f5-d1a5-11f1-9f81-010203040506
```

* Generate a Version 1 UUID without MAC (Random)
```
./uuid.sh -l 1 
af7f613c-ca05-11eb-aa29-15043316f21e
```
* Generate a Version 4 UUID
```
./uuid.sh -l 4
6a8b307d-82f6-4c66-8a58-0073b8941ff7
```

## Verifying UUIDs
This is a great site to verify UUIDs
https://www.uuidtools.com/decode

## Not Implemented Yet
V1 UUID generation does not support clock sequence , for now its fixed to random.  At one time there was a framework to use a file to increment the clock sequence, but this has been abandoned
for just a random generated clock sequence.

## versions
--0.0.3--10/26/2026
A MAC must now be exactly 6 bytes (12 hex digits, colons or dashes optional); anything else is an error
instead of an invalid UUID. Fixed random-MAC V1 UUIDs coming out one digit short when the first nibble was 0.

--0.0.2--6/9/2021
I had done some extensive modifications that were never checked in, I just realized it and here it is.

--0.0.1 Initial Version


## License
MIT License

## License
MIT. See [LICENSE](LICENSE).
