#================================================================================
#  Configure and add AXI slaves
#  Auto-generated by 
#================================================================================
#CM2_UART
[AXI_IP_UART 115200 ${IRQ_ORR}/in1 CM2_UART   ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40150000 8K]

#SLAVE_I2C
[AXI_PL_DEV_CONNECT SLAVE_I2C ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40008000 8K]

#CM
[AXI_PL_DEV_CONNECT CM        ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x4000A000 8K]

#SM_INFO
[AXI_PL_DEV_CONNECT SM_INFO   ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x4000C000 8K]

#TCDS_DRP
[AXI_PL_DEV_CONNECT TCDS_DRP ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x4000E000 8K]

#AXI_MON
[AXI_IP_AXI_MONITOR [list processing_system7_0/M_AXI_GP0 processing_system7_0/M_AXI_GP1] [list ${AXI_MASTER_CLK} ${AXI_MASTER_CLK}] [list ${AXI_MASTER_RSTN} ${AXI_MASTER_RSTN}] ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} AXI_MON ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} ]

#XVC_LOCAL
[AXI_IP_LOCAL_XVC XVC_LOCAL   ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40030000 64K]

#ESM_UART
[AXI_IP_UART 115200 ${IRQ_ORR}/in2 ESM_UART   ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40160000 8K]

#CM1_UART
[AXI_IP_UART 115200 ${IRQ_ORR}/in0 CM1_UART   ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40140000 8K]

#MONITOR
[AXI_IP_XADC MONITOR          ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40040000 64K]

#SERV
[AXI_PL_DEV_CONNECT SERV      ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x43C20000 8K]

#PL_MEM
[AXI_IP_BRAM PL_MEM ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40000000 8K]

#PLXVC
[AXI_PL_DEV_CONNECT PLXVC     ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40010000 64K]

#C2C
[AXI_C2C_MASTER C2C1          ${AXI_C2C_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 1        ${INIT_CLK} 100.000 0x8A000000 32M 0x83c40000 64K]

#C2C2
[AXI_C2C_MASTER C2C2          ${AXI_C2C_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} C2C1_PHY ${INIT_CLK} 100.000 0x8C000000 32M 0x83d40000 64K]

#SI
[AXI_IP_I2C SI                ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x41600000 8K]

#TCDS
[AXI_PL_DEV_CONNECT TCDS     ${AXI_INTERCONNECT_NAME} ${AXI_MASTER_CLK} ${AXI_MASTER_RSTN} ${AXI_MASTER_CLK_FREQ} 0x40002000 8K]

