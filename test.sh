#! /bin/bash

(cd simplewindow-test && lix dev kiss-flixel ../ && lix run lime test cpp -debug)
(cd dragtoselect-test && lix dev kiss-flixel ../ && lix run lime test cpp -debug)