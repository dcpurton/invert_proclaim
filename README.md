# invert_proclaim — Invert dark themed Proclaim slides

The `invert_proclaim` script takes a PDF of
[Proclaim](https://faithlife.com/products/proclaim) slides the colours in each
slide if it's more dark than light. I new PDF is created from the inverted
slides with six slides per page.

A Shell script is available for Linux and Mac OS and a PowerShell script for
Windows.

## Dependencies

`invert_proclaim` depends on:

- `pdfimages` from either [Poppler](https://poppler.freedesktop.org/) or the
  [Xpdf command line tools](https://www.xpdfreader.com/)
- [ImageMagick](https://imagemagick.org/)

## Installation

Just download either `invert_proclaim.sh` (Linux or Mac OS) or
`invert_proclaim.ps1` (Windows). No special Edit the Script file and ensure
the dependency paths are set correctly.

## Usage

- Print the Proclaim slides from the web interface as a PDF, which will
  give you lots of slides per page.
- Under Linux or Mac OS:
    - Run `./invert_proclaim.sh <proclaimslides.pdf>`
- Under Windows
    - Right click on `invert_proclaim.ps1` and select "Run with PowerShell".
    - A file selection dialog box will open so you can choose your PDF file
      that you just made.
- The conversion can take a little while, so just wait a bit.
- Slides are inverted if they are more dark than light, otherwise they
  that you just made.
- The conversion can take a little while, so just wait a bit.
- Slides are inverted if they are more dark than light, otherwise they
  are left the same.
- Once finished the inverted PDF will have 6 slides per page and be
  placed in the same directory as the original PDF.
- The PowerShell script opens the new PDFfor you.

## Licence

```
Copyright (c) 2022, David Purton <dcpurton@marshwiggle.net>
 
Permission to use, copy, modify, and/or distribute this software for  
any purpose with or without fee is hereby granted, provided that the  
above copyright notice and this permission notice appear in all copies.  
 
THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL  
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED  
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR  
BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES  
OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,  
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,  
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS  
SOFTWARE.  
```

