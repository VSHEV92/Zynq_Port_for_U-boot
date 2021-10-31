#bin/bash

# --------------------------------------------------------------------
# Скрипт для добавления новый плат Zynq и ZynqMP в U-Boot

# Параметры:
# $1 - путь к директории с U-Boot
# $2 - Vivado xsa-файл
# $3 - dtsi-фвйл с дополнительными узлами device tree (не обязательно)

# Опции:
# --mp - добавления платы с ZynqMP, без опции - для Zynq 7000
# --------------------------------------------------------------------

# --------------------------------------------------------------------
# разбор параметров
# --------------------------------------------------------------------
# проверяем, что правильно ли указана дирректория с U-Boot
cd $1
if [ -z "`git tag | grep xlnx`" ]; then
    echo "$1 not contain u-boot repository"
    exit 1
fi
cd -
uboot_dir=$1

# проверяем, что правильно ли указан путь к xsa-файлу
if [ -z "`ls $2`" ] || [ -z "$2" ]; then
    echo "Bad Vivado xsa-file"
    exit 2
fi
xsa_file=$2

# проверяем, правильно ли указан путь к dtsi-файлу
if [ -z "$3" ] || [ "$3" = "--mp" ]; then
    echo "User dtsi not set"
    dtsi_file=""
else 
    if [ -z "`ls $3`" ]; then
        echo "Bad dtsi-file"
        exit 3
    else
        dtsi_file=$3 
    fi
fi

# определяем указана ли опция для ZynqMP
mp_opt=0
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --mp)
            mp_opt=1; shift
        ;;
        --*|-*)
            echo "Bad option $key"; shift
            exit 4
        ;;
        *)
            shift
        ;;
  esac
done

echo "U-Boot directory: $uboot_dir"
echo "xsa file: $xsa_file"

if [ -n "$dtsi_file" ]; then
    echo "user dtsi file: $dtsi_file"   
fi

if [ "$mp_opt" = "0" ]; then
    echo "Port for Zynq"
else
    echo "Port for ZynqMP"
fi
# --------------------------------------------------------------------

# --------------------------------------------------------------------
# клонирование репозиториев xlnx-dt и dtc
# --------------------------------------------------------------------
# далее все файлы будут помещены в дирректорию с xsa-файлом
xsa_dir="$(dirname "${xsa_file}")"
cd $xsa_dir

# клонирование Device Tree generator plugin for xsdk 
if [ -z "`ls device-tree-xlnx`" ]; then
    git clone https://github.com/Xilinx/device-tree-xlnx.git
fi

# клонирование Device Tree compiler
if [ -z "`ls dtc`" ]; then
    git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
fi

# генерация дерева устройств
rm -Rf dt
mkdir dt
cd -

# сгенерировать дерево устройств
echo "Start device tree generation"
xsct -eval "source build_dts.tcl; build_dts $xsa_file $xsa_dir"
echo "Device device tree generation done"

# добавить в дерево узлы из dtsi-файла
if [ -n "$dtsi_file" ]; then
    echo "Adding user dtsi"
    xsct -eval "source build_dts.tcl; include_dtsi $dtsi_file $xsa_dir"
    echo "Add user dtsi done"
fi
