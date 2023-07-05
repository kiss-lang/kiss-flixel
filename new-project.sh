#! /bin/bash

cp -r template $1
cd $1
lix scope create
lix install gh:kiss-lang/kiss-flixel