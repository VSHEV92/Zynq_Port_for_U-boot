#bin/bash

# --------------------------------------------------------------------
# Скрипт для компиляции device tree для новых плат Zynq и ZynqMP в U-Boot

# Параметры:
# $1 - Vivado xsa-файл

# --------------------------------------------------------------------
# проверяем, что правильно ли указан путь к xsa-файлу
if [ -z "`ls $1`" ] || [ -z "$1" ]; then
    echo "Bad Vivado xsa-file"
    exit 1
fi

# объединения всех файлов в один
gcc -I my_dts -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o dt/system-top-full.dts dt/system-top.dts

# компиляция
xsa_file=`echo $1 | sed -r "s/.+\/(.+)\..+/\1/"`
cd dtc
dtc -I dts -O dtb -o ../dt/${xsa_file}.dtb ../dt/system-top-full.dts
cd -