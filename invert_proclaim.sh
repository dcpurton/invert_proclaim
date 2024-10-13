#! /bin/sh
#
# invert_proclaim.sh
#
# Invert colours of dark slides in PDFs printed from Proclaim and output 6 per page
#
# Dependencies:
#
# - pdfimages
# - convert, mogrify and montage from ImageMagick
#
# Usage:
#
# - Print a Proclaim presentation from the web view as PDF and download it to your computer.
# - Run invert_proclaim.sh <Proclaim PDF file>
# - The inverted PDF is placed in the same directory as the PDF to be converted.
# 
#
# Copyright (c) 2022, David Purton <dcpurton@marshwiggle.net>
#  
# Permission to use, copy, modify, and/or distribute this software for  
# any purpose with or without fee is hereby granted, provided that the  
# above copyright notice and this permission notice appear in all copies.  
#  
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL  
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED  
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR  
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES  
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,  
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,  
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS  
# SOFTWARE.  

PDFIMAGES=$(which pdfimages)
CONVERT=$(which convert)
MOGRIFY=$(which mogrify)
MONTAGE=$(which montage)

if [ ! -f "$PDFIMAGES" ]; then
  echo "Cannot find 'pdfimages' in path. Exiting."
  exit
fi
if [ ! -f "$CONVERT" ]; then
  echo "Cannot find ImageMagick 'convert' in path. Exiting."
  exit
fi
if [ ! -f "$MOGRIFY" ]; then
  echo "Cannot find ImageMagick 'mogrify' in path. Exiting."
  exit
fi
if [ ! -f "$MONTAGE" ]; then
  echo "Cannot find ImageMagick 'montage' in path. Exiting."
  exit
fi

if [ ! -f "$1" ]; then
  echo "Cannot find file '$1'. Exiting."
  exit
fi

PDFBASE=$(basename "$1" .pdf)
INVERTEDPDF="$PDFBASE-inverted.pdf"
PROCCURDIR=$(pwd)
PROCTEMPDIR=$(mktemp -d)
PROCIMAGEROOT=$(mktemp -p $PROCTEMPDIR -u)

cp "$1" $PROCTEMPDIR
cd $PROCTEMPDIR

$PDFIMAGES -all "$1" $PROCIMAGEROOT

for i in $PROCIMAGEROOT*; do
    if $CONVERT $i -resize 1x1 -threshold 50% txt:- | grep -q '#000000'; then
        $MOGRIFY -channel RGB -negate $i;
    fi
done

$MONTAGE -title "$PDFBASE" -tile 2x3 -geometry +100+150 -page A4 tmp.* -set label '%[fx:t+1]' -pointsize 24 -frame 5 "$INVERTEDPDF"

cp "$INVERTEDPDF" "$PROCCURDIR"

rm -rf $PROCTEMPDIR
