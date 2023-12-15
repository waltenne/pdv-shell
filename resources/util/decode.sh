#!/bin/bash

echo $1 | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'T4b3rn4404p4ss' -d
