#!/bin/bash

flutter test --coverage test/polkadot_dart_test.dart
genhtml -o coverage coverage/lcov.info

SYSTEM=`uname -s`
if [ "$SYSTEM" = "Darwin" ] 
  then
    echo "Opened coverage/index-sort-l.html"
    open coverage/index-sort-l.html
else
    xdg-open "coverage/index-sort-l.html"
fi