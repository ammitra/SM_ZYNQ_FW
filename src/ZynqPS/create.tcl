#create a block design called "zynq_bd"
create_bd_design -dir ./ "zynq_bd"


#helpers for building AXI things
source ../bd/axi_helpers.tcl
source ../bd/Xilinx_AXI_slaves.tcl

#================================================================================
#  Create and configure the basic zynq processing system.
#  build_CPU contains CPU parameters includeing the MIO and peripheral configs
#================================================================================
puts "Building CPU"
source ../src/ZynqPS/build_CPU.tcl

#================================================================================
#  Create an AXI interconnect
#================================================================================
set AXI_INTERCONNECT_NAME AXI_INTERCONNECT
set AXI_C2C_INTERCONNECT_NAME AXI_C2C_INTERCONNECT

set PL_MASTER PL
set PL_M      AXIM_${PL_MASTER}
set PL_M_CLK  AXI_CLK_${PL_MASTER}
set PL_M_RSTN AXI_RSTN_${PL_MASTER}
set PL_M_FREQ 50000000
[AXI_PL_MASTER_PORT ${PL_M} ${PL_M_CLK} ${PL_M_RSTN} ${PL_M_FREQ}]

set AXI_MASTER_CLK_FREQ 50000000
[BUILD_AXI_INTERCONNECT ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} [list processing_system7_0/M_AXI_GP0 ${PL_M}] [list ${AXI_MASTER_CLK} ${PL_M_CLK}] [list ${AXI_MASTER_RSTN} ${PL_M_RSTN}]]
[BUILD_AXI_INTERCONNECT ${AXI_C2C_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} [list processing_system7_0/M_AXI_GP1] [list ${AXI_MASTER_CLK}] [list ${AXI_MASTER_RSTN}]]
set_property CONFIG.STRATEGY {1} [get_bd_cells ${AXI_C2C_INTERCONNECT_NAME}]



#tcds CLOCKS
set TCDS_CLK TCDS_CLK
set TCDS_RSTN TCDS_reset_n
create_bd_port -dir I -type clk ${TCDS_CLK}
set_property CONFIG.FREQ_HZ 160308000 [get_bd_ports ${TCDS_CLK}]
create_bd_port -dir I -type reset ${TCDS_RSTN}

#add interrupts
set IRQ_ORR interrupt_or_reduce
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 ${IRQ_ORR}
set_property -dict [list CONFIG.NUM_PORTS {3}] [get_bd_cells ${IRQ_ORR}]
connect_bd_net [get_bd_pins ${IRQ_ORR}/dout] [get_bd_pins processing_system7_0/IRQ_F2P]

set INIT_CLK init_clk
create_bd_port -dir I -type clk ${INIT_CLK}
set_property CONFIG.FREQ_HZ ${AXI_MASTER_CLK_FREQ} [get_bd_ports ${INIT_CLK}]

#================================================================================
#  Configure and add AXI slaves
#================================================================================
source ../src/ZynqPS/AddSlaves.tcl


#========================================
#  Finish up
#========================================
set_property CONFIG.STRATEGY {1} [get_bd_cells ${AXI_C2C_INTERCONNECT_NAME}]
validate_bd_design

write_bd_layout -force -format pdf -orientation portrait ../doc/zynq_bd.pdf

make_wrapper -files [get_files zynq_bd.bd] -top -import -force
save_bd_design

close_bd_design "zynq_bd"

