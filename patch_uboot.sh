#bin/bash

# --------------------------------------------------------------------
# Скрипт для добавления новых конфигураций в U-Boot

# Параметры:
# $1 - Vivado xsa-файл
# $2 - директория U-Boot

# --------------------------------------------------------------------

# --------------------------------------------------------------------
# проверяем, что правильно ли указан путь к xsa-файлу
# --------------------------------------------------------------------
if [ -z "`ls $1`" ] || [ -z "$1" ]; then
    echo "Bad Vivado xsa-file"
    exit 1
fi
xsa_file=`echo $1 | sed -r "s/.+\/(.+)\..+/\1/"`

# --------------------------------------------------------------------
# проверяем, что правильно ли указана директория U-Boot
# --------------------------------------------------------------------
cd $2
if [ -z "`git tag | grep xlnx`" ]; then
    echo "$2 not contain u-boot repository"
    exit 2
fi
cd -
uboot_dir=$2

# --------------------------------------------------------------------
# находим для какой платформы будет патч, Zynq или ZynqMP
# --------------------------------------------------------------------
if [ -n "`ls dt/zynq-7000.dtsi`" ]; then
    mp=0
    echo "Port for Zynq"
else
    mp=1
    echo "Port for ZynqMP"
fi

# --------------------------------------------------------------------
# модифицируем исходники U-Boot
# --------------------------------------------------------------------
cp dt/${xsa_file}.dtb $uboot_dir/arch/arm/dts

len=`expr length $uboot_dir`
lastchar=`expr substr $uboot_dir $len 1`
if [ $lastchar = "/" ]; then
    uboot_dir=${uboot_dir::-1}
fi

# копируем device tree
if [ $mp = "0" ]; then
    cp $uboot_dir/configs/xilinx_zynq_virt_defconfig $uboot_dir/configs/${xsa_file}_defconfig   
    old_dt=CONFIG_DEFAULT_DEVICE_TREE=\"zynq-zc706\"
else
    cp $uboot_dir/configs/xilinx_zynqmp_virt_defconfig $uboot_dir/configs/${xsa_file}_defconfig
    old_dt=CONFIG_DEFAULT_DEVICE_TREE=\"zynqmp-zcu100-revC\"
fi

# создаем defconfig
new_dt=CONFIG_DEFAULT_DEVICE_TREE=\"${xsa_file}\"
sed -i "s/$old_dt/$new_dt/" $uboot_dir/configs/${xsa_file}_defconfig