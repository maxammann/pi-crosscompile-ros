#!/bin/bash

sudo mount -o ro,loop,offset=50331648 -t auto $1 $2
