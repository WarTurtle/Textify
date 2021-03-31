textify(){

# make sure to create a directory for doing these ugly deletes in...
# make sure you have ghostscript, scantailor, and tesseract installed

# You will need to download dependencies: scantailor, tesseract, ...    

    startingDirectory=$(pwd)
fileName=$1
mkdir ~/Downloads/in
mkdir ~/Downloads/out
cp "${fileName}" ~/Downloads/in # I'm going to delete schtuff here ...
cd ~/Downloads/in

gs -sDEVICE=tiff24nc -sCompression=lzw -r300x300 -dBATCH -dNOPAUSE -sOutputFile="%04d.tif" "${fileName}"

for i in *.tif; do scantailor-cli $i ~/Downloads/out/; echo "unskew ${i}"; done
cd ~/Downloads/out/
for i in *.tif; do tesseract $i $i --oem1 -l eng ; done
tiffcp -c lzw *.tif "${fileName//.pdf}.tif"
tiff2pdf -o "${fileName//.pdf}-cleaned.pdf" "${fileName//.pdf}.tif"
cp "${fileName//.pdf}-cleaned.pdf" "${startingDirectory}"

cat *.txt > "${startingDirectory}/${fileName//.pdf}.txt"

rm -rf ~/Downloads/in/ ;# holy danger!
rm -rf ~/Downloads/out/ ; #watchout danger!
cd ${startingDirectory}
}
