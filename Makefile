SHELL := /bin/bash

create_dt:
	source create_dt.sh $(XSA_FILE) $(DTSI_FILE)

compile_dt:
	source compile_dt.sh $(XSA_FILE)

clean:
	rm -Rf xsa dt .Xil 

clean_full:
	make clean
	rm -Rf device-tree-xlnx dtc   

