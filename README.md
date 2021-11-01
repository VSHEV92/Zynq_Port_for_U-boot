------

## Добавление новых устройств в U-Boot

------

Требуемые переменные оболочки:

- **UBOOT_DIR** -  директория, в которой расположен U-Boot;
- **XSA_FILE** - файл, содержащий описание платформы;
- **DTSI_FILE** - include-файл, содержащий дополнительные узлы device tree (не обязательно).

------

Команды Makefile:

- **create_dt** - создание device tree из xsa-файла;
- **complie_dt** - компиляция device tree;
- **patch_uboot** - создание  defconfig для uboot;
- **all** - добавление устройства в U-Boot;
- **clean** - очистка директории;
- **clean_full** - очистка директории с удалением скачанных репозиториев.

После запуска **make all** в директории **dt** появится созданное дерево устройств. В U-Boot будет добавлен конфигурационный файл **"имя xsa файла"_defconfig**. 

------

#### Пример для Zynq.

В папке **zynq_example** расположен файл **pynq_z1.xsa** с описанием платформы для платы PYNQ-Z1 и файл **usb_phy.dtsi**, добавляющий в дерево устройств физику usb-контроллера. 

Для запуска примера требуется:

1.  Задать переменные оболочки:
   - **export XSA_FILE=zynq_example/pynq_z1.xsa**
   - **export DTSI_FILE=zynq_example/usb_phy.dtsi**
   - **export UBOOT_DIR="директория с U-Boot"**

2. Выполнить команду **make**.
3. Задать переменные оболочки для U-Boot:
   - **export CROSS_COMPILE=arm-linux-gnueabihf-**
   - **export ARCH=arm**

4. Перейти в директорию U-Boot и выполнить следующие команды:

   **make pynq_z1_defconfig**

   **make**

------

#### Пример для Zynq MP.

В папке **zynqmp_example** расположен файл **zcu_102.xsa** с описанием платформы для платы ZCU102 и файл **gpio_led.dtsi**, который добавляет в дерево устройств узел, указывающий на светодиод на ножке ps gpio. 

Для запуска примера требуется:

1.  Задать переменные оболочки:
   - **export XSA_FILE=zynqmp_example/zcu_102.xsa**
   - **export DTSI_FILE=zynqmp_example/gpio_led.dtsi**
   - **export UBOOT_DIR="директория с U-Boot"**

2. Выполнить команду **make**.
3. Задать переменные оболочки для U-Boot:
   - **export CROSS_COMPILE=aarch64-linux-gnu-**
   - **export ARCH=aarch64**

4. Перейти в директорию U-Boot и выполнить следующие команды:

   **make zcu_102_defconfig**

   **make**

------

