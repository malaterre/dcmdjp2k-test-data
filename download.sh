#!/bin/sh -x

set -e

url="ftp://medical.nema.org/MEDICAL/Dicom/DataSets/WG04/compsamples_j2k.tar"

curl -L -O -C - "$url"

mkdir -p template
tar -xf compsamples_j2k.tar -C template
