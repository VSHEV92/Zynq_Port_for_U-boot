SHELL := /bin/bash

all:
	make create_dt
	make compile_dt
	make patch_uboot
	
create_dt:
	source create_dt.sh $(XSA_FILE) $(DTSI_FILE)

compile_dt:
	source compile_dt.sh $(XSA_FILE)

patch_uboot:
	source patch_uboot.sh $(XSA_FILE) $(UBOOT_DIR)

clean:
	rm -Rf xsa dt .Xil 

clean_full:
	make clean
	rm -Rf device-tree-xlnx dtc   

