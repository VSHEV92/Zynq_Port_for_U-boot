------

## Добавление новых устройств в U-Boot

------

Требуемые переменные оболочки:

- **UBOOT_DIR** -  директория, в которой расположен U-Boot;
- **XSA_FILE** - файл, содержащий описание платформы;
- **DTSI_FILE** - include-файл, содержащий дополнительные узлы device tree (не обязательно).

------

Команды Makefile:

- **create_dt** - создать device tree из xsa-файла;
- **complie_dt** - компиляция device tree;
- **patch_uboot** - создание  defconfig для uboot;
- **all** - выполнить все действия;
- **clean** - очистка директории;
- **clean_full** - очистка директории с удалением скачанных репозиториев.

После запуска **make all** в директории **dt** появится созданное дерево устройств. В U-Boot будет добавлен конфигурационный файл **"имя xsa файла"_defconfig**. 

------

#### Пример для Zynq.

В папке **zynq_example** расположены файл **pynq_z1.xsa** с описанием платформы для платы PYNQ-Z1 и файл **usb_phy.dtsi**, добавляющий в дерево устройств физику usb-контроллера. 

Для запуска примера требуется:

1.  Задать переменные оболочки:
   - **export XSA_FILE=zynq_example/pynq_zq.xsa**
   - **export DTSI_FILE=zynq_example/usb_phy.dtsi**
   - **export XSA_FILE="директория с U-Boot"**

2. Выполнить команды **make**.
3. Задать переменные оболочки для U-Boot:
   - **export CROSS_COMPILE=arm-linux-gnueabihf-**
   - **export ARCH=arm**

4. Перейти в директорию U-Boot и выполнить следующие команды:

   **make pynq_z1_defconfig**

   **make**

------

