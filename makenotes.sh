#!/bin/bash

# Bitcoin Note Generator v0.1
# Scott Alfter
# scott@alfter.us
# Donations: 1TipSAXbE6owdU24bcBDJKmL8JRxQe5Yu

function picknote()
{
  case "$pick" in
    0.5) echo "(graphnote.eps)";;
    1) echo "(graphnote-green.eps)";;
    2) echo "(graphnote-blue.eps)";;
    5) echo "(graphnote-red.eps)";;
    10) echo "(graphnote-aqua.eps)";;
    *) echo "Invalid note selection"; exit 1;;
  esac
}

function picktext()
{
  case "$pick" in
    0.5) echo "(One-Half Bitcoin)";;
    1) echo "(One Bitcoin)";;
    2) echo "(Two Bitcoins)";;
    5) echo "(Five Bitcoins)";;
    10) echo "(Ten Bitcoins)";;
    *) echo "Invalid note selection"; exit 1;;
  esac
}

function makeaddr()
{
  Address=""
  Privkey=""
  while [ \( ${#Address} != 34 \) -o \( ${#Privkey} != 51 \) ]
  do
    eval `vanitygen 1 2>/dev/null | egrep "Address|Privkey" | sed "s/: /=/"`
  done
  for i in $Address $Privkey
  do
    qrencode -s 1 -l M -o - $i | pngtopnm | pnmtops -noshowpage -nocenter >$i.eps
  done
  echo "($Address)"
  echo "($Privkey)"
}

(
cat <<EOF 
% functions we need

/strcat % (a) (b) -> (ab) 
{
  exch dup length 
  2 index length add string 
  dup dup 4 2 roll copy length 
  4 -1 roll putinterval
} bind def

/place % (filename) scale x y
{
  save 5 1 roll
  /showpage {} bind def
  translate dup scale run
  restore
} bind def

/place_addr % (addr) x y
{
  3 copy 3 copy 3 copy 
  3 2 roll (.eps) strcat 3 1 roll 1.25 3 1 roll place
  /Courier findfont 6.5 scalefont setfont
  save 4 1 roll 2 add 3 1 roll -4 add 3 1 roll 0 11 getinterval 3 1 roll moveto 90 rotate show restore
  save 4 1 roll 47 add 3 1 roll -2 add 3 1 roll 11 12 getinterval 3 1 roll moveto show restore
  save 4 1 roll 46 add 3 1 roll 47 add 3 1 roll 23 11 getinterval 3 1 roll moveto 270 rotate show restore
} bind def

/place_privkey % (addr) x y
{
  3 copy
  3 copy 3 copy 3 copy 3 copy
  3 2 roll (.eps) strcat 3 1 roll 1.25 3 1 roll place
  /Courier findfont 6.5 scalefont setfont
  save 4 1 roll 3 1 roll -3 add 3 1 roll 0 13 getinterval 3 1 roll moveto 90 rotate show restore
  save 4 1 roll 52 add 3 1 roll -1 add 3 1 roll 13 13 getinterval 3 1 roll moveto show restore
  save 4 1 roll 50 add 3 1 roll 52 add 3 1 roll 26 13 getinterval 3 1 roll moveto 270 rotate show restore
  save 4 1 roll -3 add 3 1 roll 50 add 3 1 roll 39 12 getinterval 3 1 roll moveto 180 rotate show restore
  3 2 roll pop -15 add 2 1 roll -15 add 2 1 roll moveto 0 80 rlineto 80 0 rlineto 0 -80 rlineto -80 0 rlineto .25 setlinewidth stroke
} bind def

/draw_note % (base_note.eps) (addr) (privkey) (amt) (amt_text)
{
  5 4 roll .75 0 0 place
  4 3 roll 35 75 place_addr
  3 2 roll 285 50 place_privkey
  /Helvetica-Narrow findfont 40 scalefont setfont
  2 1 roll 65 17 moveto show
  /Helvetica-Narrow findfont 10 scalefont setfont
  190 7 moveto show
} bind def

% cut lines

0 400 moveto 8.5 72 mul 400 lineto .25 setlinewidth stroke
250 0 moveto 250 11 72 mul lineto .25 setlinewidth stroke

% first note

save
250 32 translate 90 rotate
EOF

pick=$1
picknote
makeaddr
echo "($1)"
picktext

cat <<EOF
draw_note
restore

% second note

save
250 400 translate 90 rotate
EOF

pick=$2
picknote
makeaddr
echo "($2)"
picktext

cat <<EOF
draw_note
restore

% third note

save
448 32 translate 90 rotate
EOF

pick=$3
picknote
makeaddr
echo "($3)"
picktext

cat <<EOF
draw_note
restore

% fourth note

save
448 400 translate 90 rotate
EOF

pick=$4
picknote
makeaddr
echo "($4)"
picktext

cat <<EOF
draw_note
restore

showpage
EOF
) | gs -sDEVICE=pdfwrite -dNOPAUSE -sOutputFile=job$$_tmp.pdf -q 2>&1 >/dev/null
pdftk job$$_tmp.pdf billback.pdf output job$$.pdf
rm [15]*.eps job$$_tmp.pdf

