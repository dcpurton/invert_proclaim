# invert_proclaim.ps1
#
# Invert colours of dark slides in PDFs printed from Proclaim and output 6 per
# page
#
# Dependencies:
#
# - pdfimages.exe
#     - Download the Xpdf command line tools from
#       https://www.xpdfreader.com/download.html
#     - Unzip it somewhere and update the path of $PdfImagesExePath below to
#       point to pdfimages.exe
# - magick.exe
#     - Download the x64 Q16 portable version of ImageMagick from
#       https://imagemagick.org/script/download.php
#     - Unzip it somewhere and update the path of $MagickExePath below to point
#       to magick.exe
#
# Usage:
#
# - Print a Proclaim presentation from the web view as PDF and download it to
#   your computer.
# - Right click on invert_proclaim.ps1 and select "Run with PowerShell".
# - A file selection dialog will open and allow you to select the PDF file.
#     - The default directory is Downloads, but this can be set with
#       $InitialDirectory below.
# - The inverted PDF is opened and placed in the same directory as the PDF to
#   be converted.
# 
#
# Copyright (c) 2022-2024, David Purton <dcpurton@marshwiggle.net>
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

$PdfImagesExePath = "C:\Path\To\xpdf-tools-win-4.04\bin64\pdfimages.exe"
$MagickExePath = "C:\Path\To\ImageMagick-7.1.0-58-portable-Q16-x64\magick.exe"
$InitialDirectory = "$env:USERPROFILE\Downloads"
$6up = $false

if (-not(Test-Path $PdfImagesExePath -Pathtype leaf))
{
  Write-Host "Error: Cannot find '$PdfImagesExePath'. File does not exist."
  Read-Host "Press any key to exit"
  exit
}
if (-not(Test-Path $MagickePath -Pathtype leaf))
{
  Write-Host "Error: Cannot find '$MagickExePath'. File does not exist."
  Read-Host "Press any key to exit"
  exit
}

function Open-File([string] $initialDirectory)
{
  [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

  $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $OpenFileDialog.initialDirectory = $initialDirectory
  $OpenFileDialog.filter = "PDF files (*.pdf)| *.pdf"
  $OpenFileDialog.ShowDialog() |  Out-Null

  return $OpenFileDialog.filename
}

$pdf = Open-File $InitialDirectory
if ($pdf -eq "")
{
  exit
}

Write-Host "Inverting colours in" $pdf "..."

# set up file and directory variables
$pdfquoted = '"' + $pdf + '"'
$pdfbase = (Split-Path (Get-Item $pdf).Basename -Leaf)
$pdfbasequoted = '"' + $pdfbase + '"'
$invertedpdf = $pdfbase + "-inverted.pdf"
$invertedpdfquoted = '"' + $invertedpdf + '"'
$curdir = Split-Path -Path $pdf
$tmpdir = New-TemporaryFile | % { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
$tmpimageroot = New-TemporaryFile
$imageroot = Split-Path (Get-Item $tmpimageroot) -Leaf
Remove-Item (Get-Item $tmpimageroot)

Copy-Item $pdf -Destination $tmpdir
Set-Location -Path $tmpdir

# extract images from pdf
$arguments = "-j", $pdfquoted, $imageroot
& $PdfImagesExePath $arguments

# invert images
$images = Get-ChildItem $tmpdir -Filter $imageroot*
ForEach($image in $images)
{
  $arguments = "convert", $image, "-resize", "1x1", "-threshold", "50%", "txt:-"
  $colour = & $MagickExePath $arguments
  if ($colour -match "#000000")
  {
    $arguments = "mogrify", "-resize", "800x800", "-channel", "RGB", "-negate", $image
    & $MagickExePath $arguments
  }
  else
  {
    $arguments = "mogrify", "-resize", "800x800", $image
    & $MagickExePath $arguments
  }
}

# Create new pdf
if ($6up)
{
  $arguments = "montage", "-title", $pdfbase, "-tile", "2x3", "-geometry", "+100+150", "-page", "A4", "tmp*", "-set", "label", "%[fx:t+1]", "-pointsize", "24", "-frame", "5", $invertedpdfquoted
  & $MagickExePath $arguments
}
else
{
  $arguments = "convert", "tmp*", "-gravity", "SouthEast", "-pointsize", "24", "-fill", "black", "-annotate", "+10+10", "Page %[fx:t+1]", $invertedpdfquoted
  & $MagickExePath $arguments
}

# cleanup
Copy-Item $invertedpdf -Destination $curdir
Set-Location -Path $curdir
Remove-Item (Get-Item $tmpdir) -Recurse

# open new pdf
Invoke-Item (Get-Item $invertedpdf)

