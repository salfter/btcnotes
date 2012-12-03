#!/bin/bash

# Bitcoin Note Generator v0.2
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

/draw_cover % (privkey) x y
{
  3 copy
  .25 setlinewidth
  moveto 54 0 rlineto 0 54 rlineto -54 0 rlineto 0 -54 rlineto stroke
  pop 
  /Courier-New findfont 6.5 scalefont setfont
  3 copy 3 copy 3 copy 3 copy
  2 1 roll 5 add 2 1 roll 43 add moveto 0 11 getinterval show
  2 1 roll 5 add 2 1 roll 35 add moveto 11 11 getinterval show
  2 1 roll 5 add 2 1 roll 27 add moveto 22 11 getinterval show
  2 1 roll 5 add 2 1 roll 19 add moveto 33 11 getinterval show
  2 1 roll 5 add 2 1 roll 11 add moveto 44 7 getinterval show
} bind def

% cut lines

.25 setlinewidth
0 33 moveto 612 33 lineto stroke
0 400 moveto 612 400 lineto stroke
0 768 moveto 612 768 lineto stroke
53 0 moveto 53 792 lineto stroke
250 0 moveto 250 792 lineto stroke
446 0 moveto 446 792 lineto stroke

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

EOF
echo \($Privkey\) 504 684 draw_cover

cat <<EOF
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

EOF
echo \($Privkey\) 504 630 draw_cover

cat <<EOF
% third note

save
447 32 translate 90 rotate
EOF

pick=$3
picknote
makeaddr
echo "($3)"
picktext

cat <<EOF
draw_note
restore

EOF
echo \($Privkey\) 504 576 draw_cover

cat <<EOF
% fourth note

save
447 400 translate 90 rotate
EOF

pick=$4
picknote
makeaddr
echo "($4)"
picktext

cat <<EOF
draw_note
restore

EOF
echo \($Privkey\) 504 522 draw_cover

cat <<EOF
showpage

save 

/showpage {} bind def 
save
8.5 72 mul 0 translate
90 rotate
11 8.5 div dup scale
(billback.eps) run 
restore

398 301 moveto 80 0 rlineto 0 80 rlineto -80 0 rlineto 0 -80 rlineto fill
398 669 moveto 80 0 rlineto 0 80 rlineto -80 0 rlineto 0 -80 rlineto fill
201 301 moveto 80 0 rlineto 0 80 rlineto -80 0 rlineto 0 -80 rlineto fill
201 669 moveto 80 0 rlineto 0 80 rlineto -80 0 rlineto 0 -80 rlineto fill

restore 
showpage
EOF
) | gs -sDEVICE=pdfwrite -dNOPAUSE -sOutputFile=job$$.pdf -q 2>&1 >/dev/null
#pdftk A=job$$_tmp.pdf B=billback.pdf cat A1 B1 output job$$.pdf
rm [15]*.eps #job$$_tmp.pdf

