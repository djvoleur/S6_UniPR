#!/bin/bash
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
DATEFORMAT=$(date +"%m%d%y")
COMPILED_KERNEL=arch/arm64/boot/Image
ROOT=build_kernel
export ccache=ccache
export USE_SEC_FIPS_MODE=true
export KCONFIG_NOTIMESTAMP=true

clear
cd ..
echo -e "1 - 925P"
echo -e "2 - 925R4"
echo -e "3 - 920P"
echo -e "4 - 920R4"
echo -n "Which kernel would you like to compile? : "
read choice
case $choice in
1)
    VARIANT=925P
    defconfig=exynos7420-zerolte_defconfig
    ;;
2)
    VARIANT=925R4
    defconfig=exynos7420-zerolte_defconfig
    ;;
3) 
    VARIANT=920P
    defconfig=exynos7420-zeroflte_defconfig
    ;;
4)
    VARIANT=920R4
    defconfig=exynos7420-zeroflte_defconfig
    ;;
*)
    echo "${red}Invalid option!$(tput sgr0)"; exit
    ;;
esac

echo "${red}Setting up defconfig...$(tput sgr0)"
make ARCH=arm64 $defconfig -j4
DTB=G92XP_universal.dtb
RAMDISK=$VARIANT/ramdisk/
KERNEL=$VARIANT

make prepare
echo "${red}Setting up kernel configurations...$(tput sgr0)"
make ARCH=arm64 nconfig
echo "${red}Compiling kernel...$(tput sgr0)"
beginning=$(date +%s.%N)
make ARCH=arm64 -j5

if [ -e $COMPILED_KERNEL ];
then
    echo "${red}Getting kernel Image, dtb, and modules...$(tput sgr0)"
    cp arch/arm64/boot/Image $ROOT/$VARIANT/zImage
    cd $ROOT
    echo "${red}Creating dt.img...$(tput sgr0)"
    ./dtbtool -o ../build_kernel/$VARIANT/dt.img -s 2048 -p ../scripts/dtc/ ../arch/arm64/boot/dts/
    echo "${red}Compressing ramdisk...$(tput sgr0)"
    cd $RAMDISK
    find . | cpio -o -H newc | gzip > ../ramdisk.cpio.gz
    cd ../../
    ./mkbootimg --base 0x10000000 --kernel $VARIANT/zImage --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --pagesize 2048 --ramdisk $VARIANT/ramdisk.cpio.gz --dt $VARIANT/dt.img -o $VARIANT/boot.img 
    mv $VARIANT/boot.img boot.img
    cp boot.img zip/boot.img
    echo "${red}Making boot.img ODIN flashable...$(tput sgr0)"
    tar -c boot.img > UniKernel-v5-$VARIANT-$DATEFORMAT.tar
    mv boot.img UniKernel-v5-$VARIANT-$DATEFORMAT.img
    echo "${red}Making boot.img TWRP/Flashfire zip...$(tput sgr0)"
    cd zip
    zip -r V .
    mv V.zip ../UniKernel-v5-$VARIANT-$DATEFORMAT.zip
    echo "${red}Clean up...$(tput sgr0)"
    rm -rf ../fmp_hmac.bin
    rm -rf ../fips_fmp_utils
    rm -rf ../$VARIANT/dt.img
    rm -rf ../$VARIANT/ramdisk.cpio.gz
    rm -rf ../$VARIANT/zImage
    rm -rf ../$VARIANT/$DTB
    rm -rf ../zip/boot.img
    ending=$(date +%s.%N)
    echo "${grn}Total elapsed time: ${grn}$(echo "($ending - $beginning) / 60"|bc ) minutes ($(echo "$ending - $beginning"|bc ) seconds)$(tput sgr0)"
else
    echo "${red}Compilation failed!$(tput sgr0)"
fi;
