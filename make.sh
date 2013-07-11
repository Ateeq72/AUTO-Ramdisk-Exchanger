#! /bin/bash

# AUTO-Ramdisk-Exchanger 	
# Author: Russell Dias
# Version: 1.1.0
# Date: July 11, 2013
# Contact: russell.dias98@gmail.com

#Cleaning Output Folder(If Any)
clear
echo
echo "Cleaning Output Folder(if Any)"
sleep 1
if test -e output
  then
   rm -rf output
echo
echo "Removed"
else
  echo
  echo "There is no output folder. Good to go."
fi
#Removing Existing Ramdisk Folder
echo
echo "Removing Existine Ramdisk Folder"
sleep 1
if test -e ramdisk-stock
  then
   rm -rf ramdisk-stock
echo
echo "Removed"
else
  echo
  echo "There is no Ramdisk folder. Good to go."
fi
#Removing Existing zImage Folder
echo
echo "Removing Existing zImage Folder"
sleep 1
if test -e zImage-stock
  then
   rm -rf zImage-stock
echo
echo "Removed"
else
  echo
  echo "There is no zImage folder. Good to go."
fi
#Removing Existing Ramdisk Folder
echo
echo "Removing Existine Ramdisk Folder"
sleep 1
if test -e ramdisk-target
  then
   rm -rf ramdisk-target
echo
echo "Removed"
else
  echo
  echo "There is no Ramdisk folder. Good to go."
fi
#Removing Existing zImage Folder
echo
echo "Removing Existing zImage Folder"
sleep 1
if test -e zImage-target
  then
   rm -rf zImage-target
echo
echo "Removed"
else
  echo
  echo "There is no zImage folder. Good to go."
fi
#Finding your boot.img (Using This kernels Ramdisk for exchange)
echo
echo "Finding your boot.img(Stock)"
sleep 1
if test -e boot_img_stock/boot.img ; then
  echo
  echo "Found boot.img"
else
  echo "Could not Find boot.img"
  echo
  echo "Quitting"
  exit
fi
#Finding your boot.img (This is the boot.img which will recieve the Ramdisk) 
echo
echo "Finding your boot.img (Target)"
sleep 1
if test -e boot_img_target/boot.img ; then
  echo
  echo "Found boot.img"
  echo
else
  echo "Could not Find boot.img"
  echo
  echo "Quitting"
  exit
fi
#Making Needed Folders
echo "Making Needed Folders"
echo
sleep 1
mkdir -p ramdisk-stock
mkdir -p zImage-stock
mkdir -p ramdisk-target
mkdir -p zImage-target
mkdir -p tempo
mkdir -p tempo-1
echo "Done"
echo
#Getting Ready to unpack both boot.img(s)
echo "Getting Ready to unpack both boot.img(s)"
echo
sleep 1
echo "Unpacking boot.img Stock"
echo
sleep .4
   ./tools/unpackbootimg -i boot_img_stock/boot.img -o tempo
   cp tempo/boot.img-zImage zImage-stock/zImage
   rm -rf tempo/boot.img-zImage
   cd ramdisk-stock
sleep .4
   echo
   echo "Unpacking Ramdisk"
   echo
   gzip -dc ../tempo/boot.img-ramdisk.gz | cpio -i
   cd ..
   rm -rf tempo
echo "Unpacking boot.img Target"
echo
sleep .4
   ./tools/unpackbootimg -i boot_img_target/boot.img -o tempo-1
   cp tempo-1/boot.img-zImage zImage-target/zImage
   rm -rf tempo-1/boot.img-zImage
   cd ramdisk-target
sleep .4
   echo
   echo "Unpacking Ramdisk"
   echo
   gzip -dc ../tempo-1/boot.img-ramdisk.gz | cpio -i
   cd ..
   rm -rf tempo-1
#Exchanging Ramdisk(s)
echo "Modify ramdisk Now. After that press [Enter]"
echo
read ANS
./tools/mkbootfs ramdisk-stock | gzip > ramdisk.gz
sleep 1
echo "Done"
echo
sleep 1
echo "Exchange is Done. Making boot.img"
echo
sleep 1
mkdir -p output
./tools/mkbootimg --kernel zImage-target/zImage --ramdisk ramdisk.gz -o output/boot.img --base 10000000
rm ramdisk.gz
echo "Done Making boot.img"
echo
sleep 1
#making Flashable zip
echo "Going to make a flashable zip"
echo
echo "Please Add the modules to /tools/system/lib/modules and press enter"
read ANS
echo
echo "All Good"
echo
echo "Making Zip"
cd output
cp -r ../tools/META-INF META-INF
cp -r ../tools/system system
cp ../tools/signapk.jar signapk.jar 
cp ../tools/testkey.x509.pem testkey.x509.pem
cp ../tools/testkey.pk8 testkey.pk8
echo
zip -r AUTO-Ramdisk-Exchanger.zip META-INF system boot.img 
echo
echo "ZIP Ready, signing it"
java -jar signapk.jar testkey.x509.pem testkey.pk8 AUTO-Ramdisk-Exchanger.zip AUTO-Ramdisk-Exchanger-SIGNED.zip
rm AUTO-Ramdisk-Exchanger.zip
rm *.jar
rm *.pk8
rm *.pem
rm -r META-INF 
rm -r system
rm -r boot.img
s1=`ls -lh AUTO-Ramdisk-Exchanger-SIGNED.zip | sed -e 's/.* [ ]*\([0-9]*\.[0-9]*[MK]\) .*/\1/g'`
echo
echo "Size of Zip is = $s1"
echo 
echo "AUTO-Ramdisk-Exchanger by russelldias"
echo
sleep 1
echo "Thanks for using AUTO-Ramdisk-Exchanger"
echo
sleep 1
echo "Please press [Enter] to exit."
read ANS
