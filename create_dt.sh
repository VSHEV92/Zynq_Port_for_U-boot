#bin/bash

# --------------------------------------------------------------------
# Скрипт для создания device tree для новых плат Zynq и ZynqMP в U-Boot

# Параметры:
# $1 - Vivado xsa-файл
# $2 - dtsi-фвйл с дополнительными узлами device tree (не обязательно)

# --------------------------------------------------------------------

# --------------------------------------------------------------------
# разбор параметров
# --------------------------------------------------------------------

# проверяем, что правильно ли указан путь к xsa-файлу
if [ -z "`ls $1`" ] || [ -z "$1" ]; then
    echo "Bad Vivado xsa-file"
    exit 1
fi
xsa_dir="$(dirname "${1}")"
xsa_file="$(basename "${1}")"
rm -Rf xsa
mkdir xsa
cp $1 xsa

# проверяем, правильно ли указан путь к dtsi-файлу
if [ -z "$2" ]; then
    echo "User dtsi not set"
    dtsi_file=""
else 
    if [ -z "`ls $2`" ]; then
        echo "Bad dtsi-file"
        exit 2
    else
        dtsi_file=$2
    fi
fi

echo "xsa file: $xsa_file"
if [ -n "$dtsi_file" ]; then
    echo "user dtsi file: $dtsi_file"   
fi
# --------------------------------------------------------------------

# --------------------------------------------------------------------
# клонирование репозиториев xlnx-dt и dtc
# --------------------------------------------------------------------
# клонирование Device Tree generator plugin for xsdk 
if [ -z "`ls device-tree-xlnx`" ]; then
    git clone https://github.com/Xilinx/device-tree-xlnx.git
    version=`vivado -version | head -1 | cut -c8-14`
    cd device-tree-xlnx
    git checkout "xilinx-$version"
    cd -
fi

# клонирование Device Tree compiler
if [ -z "`ls dtc`" ]; then
    git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
    cd dtc
    make -j `nproc`
    cd -
fi

# # --------------------------------------------------------------------
# # генерация дерева устройств
# # --------------------------------------------------------------------
rm -Rf dt
mkdir dt

# сгенерировать дерево устройств
echo "Start device tree generation"
xsct -eval "source build_dts.tcl; build_dts $xsa_file"
echo "Device device tree generation done"

# добавить в дерево узлы из dtsi-файла
if [ -n "$dtsi_file" ]; then
    echo "Adding user dtsi"
    xsct -eval "source build_dts.tcl; include_dtsi $dtsi_file"
    echo "Add user dtsi done"
fi