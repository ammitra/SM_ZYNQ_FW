
#################################################################################
# Clean
#################################################################################
clean_addrtable:
	@echo "Cleaning up address table autogenerated and downloaded files"
	@rm -f os/*.yaml
	@rm -f kernel/*.yaml
	@rm -rf $(shell find ./kernel/ -maxdepth 1 | grep "hw_" | grep -v "hw_user" | xargs)	

#################################################################################
# address tables
#################################################################################
#prebuild: $(SLAVE_DEF_FILE)
#	LD_LIBRARY_PATH=$(CACTUS_LD_PATH) ./scripts/preBuild.py \
#			                     -s $(SLAVE_DEF_FILE) \
#				             -t $(ADDSLAVE_TCL_PATH) \
#				             -a $(ADDRESS_TABLE_CREATION_PATH) \
#				             -d $(SLAVE_DTSI_PATH)
#
#$(ADDSLAVE_TCL_PATH)/AddSlaves.tcl $(ADDRESS_TABLE_CREATION_PATH)/slaves.yaml $(SLAVE_DTSI_PATH)/slaves.yaml: prebuild

