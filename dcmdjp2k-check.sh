#!/bin/sh
#set -x

for i in template/IMAGES/*/* valids/*.dcm; do 
  dcmdjp2k $i /tmp/tmp.dcm
  if ! test "$?" = "0"; then
    echo "dcmdjp2k fails to accept $i"
    exit 1
  fi
done

for i in invalids/*.dcm; do 
  dcmdjp2k $i /tmp/tmp.dcm
  if ! test "$?" = "1"; then
    echo "dcmdjp2k fails to reject $i"
    exit 1
  fi
done
