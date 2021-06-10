# UUID-with-bash
generate UUID with bash scripting V1 and V4 are currently supported.  The only requirment on the system is tr, date, /dev/urandom and dd.

## background
I needed a UUID generator for a Raspian based device and I could not rely on uuidgen being present on the system.  Uses /dev/urandom so should be
cryoto secure.

## Usage Examples

* Generate a NULL UID (UUID V0)
>dood:~/$ ./uuid.sh 0
>00000000-0000-0000-0000-000000000000dood:~/$

With linefeed
>dood:~/$ ./uuid.sh -l 0
>00000000-0000-0000-0000-000000000000
>dood:~/$

* Generate a Version 1 UUID with MAC
>./uuid.sh -l 1 01:02:03:04:05:06:07
>5fbc369a-ca05-11eb-af04-01020304050607

Without Colons 
>./uuid.sh -l 1 010203040506
>941772b9-ca05-11eb-82cd-010203040506

* Generate a Version 1 UUID without MAC (Random)
>./uuid.sh -l 1 
>af7f613c-ca05-11eb-aa29-15043316f21e

* Generate a Version 4 UUID
>./uuid.sh -l 4
>6a8b307d-82f6-4c66-8a58-0073b8941ff7

## Verifing UUID's
This is a great site to verify UUID's
https://www.uuidtools.com/decode

## Not Implemented Yet
V1 UUID generation does not support clock sequence , for now its fixed to random.  At one time there was a framework to use a file to increment the clock sequence, but this has been abandon
for just a random generated clock sequence.

## versions
--0.0.2--6/9/2021
I had done some extensive modifications that were never checked in, I just realized it and here it is.

--0.0.1 Initial Version


## License
MIT License
