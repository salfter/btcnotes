Bitcoin Note Generator
======================

This is an offline Bitcoin note generator based on the work here:
https://bitcointalk.org/index.php?topic=92969.0

It produces notes in five denominations: 0.5, 1, 2, 5, and 10 BTC.  Each is
printed in its own distinctive color.  Adding more denominations is a simple
matter of generating a differently-colored note (or reusing one of the
existing colors) and adding a couple of lines to the main shell script.

Internally, the script renders four notes at a time to PostScript, which is
then immediately converted to PDF.  The note design started as SVG, so this 
will allow you to print notes at as high a quality as your printer can
deliver.  Unique addresses and private keys are generated and rendered as
both QR codes and text; text is wrapped around the QR codes to minimize 
space used.  The private keys can be covered with 1.125" tamper-evident
labels to protect them until they are redeemed.

I chose to use the design within https://casascius.com/graphnote.zip.  The
SVG file from this archive is included in this project.  I've also included
the back pattern from https://casascius.com/billback.pdf.  This is appended
to the generated notes; if your printer supports duplexing, you can crank 
out notes in one step.

Prerequisites
-------------

* Ghostscript
  http://www.ghostscript.com/
* Vanity Address Generator
  https://github.com/samr7/vanitygen/
* QREncode
  http://fukuchi.org/works/qrencode/
* NetPBM
  http://netpbm.sourceforge.net/
* Pdftk
  http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/

This should run anywhere you can get all the tools above running.  The program
itself is a bash shell script.  I tested and debugged it on one of my Gentoo
Linux boxen; anything vaguely similar should work as well.  

I've also done some debugging work on Windows with Cygwin.  Ghostscript and
NetPBM are provided by Cygwin; the other prerequisites are native Win32
command-line apps that need to be somewhere in your PATH.  Binaries are
available at the following locations:

Cygwin: http://www.cygwin.com/
  (make sure these packages are installed: ghostscript,
   ghostscript-fonts-other, ghostscript-fonts-std, netpbm)
Vanitygen: https://github.com/samr7/vanitygen/downloads
QREncode: http://code.google.com/p/qrencode-win32/downloads/list
  (copy qrcode.exe to qrencode.exe somewhere in your PATH)
Pdftk: http://www.pdflabs.com/docs/install-pdftk/
  
Usage
-----

./makenotes.sh denom1 denom2 denom3 denom4
denom[1-4] = 0.5|1|2|5|10

This produces a PDF named job#.pdf, where # is the pid of the script when it
ran.  Load into the PDF viewer of your choice and print.  If desired, apply
tamper-evident labels on both sides of the private key; make sure you protect
the private key with a 1" square of paper.

Customization
-------------

The top part of notes.txt describes how I produced note designs in different
colors from one master design.  Load graphnote-original-colors.png into the 
GIMP, tweak the hue, lightness, and saturation to produce the colors you want 
(the numeric values I used are in colors.txt), then follow steps 3 and 4 from
notes.txt.

If you want to use a different note design, the PostScript code within the
script is modular enough that you should be able to adjust the placement of
design elements without too much difficulty.  Note that the note design needs
to be in Encapsulated PostScript (EPS) format.  NetPBM can convert most bitmap
formats; to convert SVG, I used the svg2pdf tool provided with svglib
(http://pypi.python.org/pypi/svglib/) and then ran the output of that
through Ghostscript.
