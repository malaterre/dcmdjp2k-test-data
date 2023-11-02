#!/bin/bash -x

set -e

# see download.sh

mkdir -p valids
# YBR_RCT (qmfbid=1)
cp template/IMAGES/J2KR/US1_J2KR valids/US1_REV_MCT1.dcm
# YBR_ICT (qmfbid=0)
cp template/IMAGES/J2KI/US1_J2KI valids/US1_IRR_MCT1.dcm

gdcmraw template/IMAGES/J2KR/US1_J2KR /tmp/template.rgb.j2k
opj_decompress -quiet -i /tmp/template.rgb.j2k -o /tmp/template.rgb.pnm

gdcmconv --raw template/IMAGES/J2KR/US1_J2KR /tmp/rgb.dcm
gdcmconv --photometric-interpretation YBR_FULL /tmp/raw.dcm /tmp/ybr.dcm
gdcmconv --j2k /tmp/ybr.dcm /tmp/ybr.j2k.dcm
gdcmraw /tmp/ybr.j2k.dcm /tmp/template.ybr.j2k
opj_decompress -quiet -i /tmp/template.ybr.j2k -o /tmp/template.ybr.pnm

for irr in 'R' 'I'; do
  case $irr in
    R)
     irropt=
     irrext=
     acro=REV
     ;;
   I)
     irropt=-I
     irrext=.I
     acro=IRR
     ;;
  esac
  for mct in '0' '1'; do
    for color in 'rgb' 'ybr'; do
      # define an empty COM:
      opj_compress -C '' $irropt -mct "$mct" -i /tmp/template.$color.pnm -o "/tmp/template.$color$irrext.mct$mct.j2k" > /dev/null
      case $color in
        rgb)
         pi=
         ;;
       ybr)
         pi="--pi YBR_FULL"
         ;;
      esac
      gdcmimg $pi --template /tmp/$color.dcm -i "/tmp/template.$color$irrext.mct$mct.j2k" -o "valids/US1_GDCM_${color}_${acro}_MCT$mct.dcm"
    done
  done
done

md5sum /tmp/template.*.j2k

mkdir -p invalids
sed -e 's/1.2.840.10008.1.2.4.91/1.2.840.10008.1.2.4.90/' template/IMAGES/J2KI/US1_J2KI > invalids/US1_IRR_MCT1_Lossless.dcm


