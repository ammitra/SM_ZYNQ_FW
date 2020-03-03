library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;
use work.AXIRegPKG.all;
use work.SGMII_MONITOR.all;
use work.CM_package.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity top is
  port (
    DDR_addr          : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba            : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n         : inout STD_LOGIC;
    DDR_ck_n          : inout STD_LOGIC;
    DDR_ck_p          : inout STD_LOGIC;
    DDR_cke           : inout STD_LOGIC;
    DDR_cs_n          : inout STD_LOGIC;
    DDR_dm            : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq            : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n         : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p         : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt           : inout STD_LOGIC;
    DDR_ras_n         : inout STD_LOGIC;
    DDR_reset_n       : inout STD_LOGIC;
    DDR_we_n          : inout STD_LOGIC;
    FIXED_IO_ddr_vrn  : inout STD_LOGIC;
    FIXED_IO_ddr_vrp  : inout STD_LOGIC;
    FIXED_IO_mio      : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk   : inout STD_LOGIC;
    FIXED_IO_ps_porb  : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;

    I2C_SCL           : inout std_logic;
    I2C_SDA           : inout std_logic;
    
    onboard_CLK_P     : in  std_logic;
    onboard_CLK_N     : in  std_logic;

    SI_INT            : in  std_logic;
    SI_LOL            : in  std_logic;
    SI_LOS            : in  std_logic;
    SI_OUT_DIS        : out std_logic;
    SI_ENABLE         : out std_logic;
                      
    TTC_SRC_SEL       : out std_logic;
                      
    LHC_CLK_CMS_LOS   : in  std_logic;
    LHC_CLK_OSC_LOS   : in  std_logic;
    LHC_SRC_SEL       : out std_logic;
    HQ_CLK_CMS_LOS    : in  std_logic;
    HQ_CLK_OSC_LOS    : in  std_logic;
    HQ_SRC_SEL        : out std_logic;
    FP_LED_RST        : out std_logic;
    FP_LED_CLK        : out std_logic;
    FP_LED_SDA        : out std_logic;
    FP_switch         : in  std_logic;
                      
    ESM_LED_CLK       : in std_logic;
    ESM_LED_SDA       : in std_logic;


    -----------------------------------------------------------------------------
    -- CM interface
    -----------------------------------------------------------------------------

    -------------------------------------
    --Enable
    CM1_enable : out std_logic;         
    CM2_enable : out std_logic;

    -------------------------------------
    --PWR Enable
    CM1_PWR_enable : out std_logic;         
    CM2_PWR_enable : out std_logic;

    -------------------------------------
    --CM power good
    CM1_PWR_good : in std_logic;         
    CM2_PWR_good : in std_logic;

    -------------------------------------
    --GPIO
    CM1_GPIO   : in std_logic_vector(1 downto 0);         
    CM2_GPIO   : in std_logic_vector(1 downto 0);

    -------------------------------------
    --UART
    CM1_UART_TX   : out std_logic;
    CM1_UART_RX   : in  std_logic;         
    CM2_UART_TX   : out std_logic;
    CM2_UART_RX   : in  std_logic;         
    ESM_UART_RX   : in  STD_LOGIC;
    ESM_UART_TX   : out STD_LOGIC;


    
    -------------------------------------
    --XVC
    CM1_tck          : out   STD_LOGIC;
    CM1_tdi          : out   STD_LOGIC;
    CM1_tdo          : in    STD_LOGIC;
    CM1_tms          : out   STD_LOGIC;
    CM2_tck          : out   STD_LOGIC;
    CM2_tdi          : out   STD_LOGIC;
    CM2_tdo          : in    STD_LOGIC;
    CM2_tms          : out   STD_LOGIC;




    -------------------------------------------------------------------------------------------
    -- MGBT 1
    -------------------------------------------------------------------------------------------
    AXI_C2C_CM1_Rx_P      : in    std_logic_vector(0 to 0);
    AXI_C2C_CM1_Rx_N      : in    std_logic_vector(0 to 0);
    AXI_C2C_CM1_Tx_P      : out   std_logic_vector(0 to 0);
    AXI_C2C_CM1_Tx_N      : out   std_logic_vector(0 to 0);

    AXI_C2C_CM2_Rx_P      : in    std_logic_vector(0 to 0);
    AXI_C2C_CM2_Rx_N      : in    std_logic_vector(0 to 0);
    AXI_C2C_CM2_Tx_P      : out   std_logic_vector(0 to 0);
    AXI_C2C_CM2_Tx_N      : out   std_logic_vector(0 to 0);

    refclk_C2C_P      : in    std_logic_vector(0 downto 0);
    refclk_C2C_N      : in    std_logic_vector(0 downto 0);

    
--    -------------------------------------------------------------------------------------------
--    -- MGBT 2
--    -------------------------------------------------------------------------------------------
    refclk_125Mhz_P   : in    std_logic; 
    refclk_125Mhz_N   : in    std_logic; 
    refclk_TCDS_P     : in    std_logic; 
    refclk_TCDS_N     : in    std_logic; 
--                              
    sgmii_tx_P        : out   std_logic; 
    sgmii_tx_N        : out   std_logic; 
    sgmii_rx_P        : in    std_logic; 
    sgmii_rx_N        : in    std_logic;
--                              
    tts_P             : out   std_logic; 
    tts_N             : out   std_logic; 
    ttc_P             : in    std_logic; 
    ttc_N             : in    std_logic; 
--                              
    fake_ttc_P        : out   std_logic; 
    fake_ttc_N        : out   std_logic; 
    m1_tts_P          : in    std_logic; 
    m1_tts_N          : in    std_logic;                       
    m2_tts_P          : in    std_logic; 
    m2_tts_N          : in    std_logic;
    IPMC_SDA : inout STD_LOGIC;
    IPMC_SCL : in    STD_LOGIC;
    SI_scl : inout STD_LOGIC;
    SI_sda : inout STD_LOGIC
    );    
end entity top;

architecture structure of top is

  signal pl_clk : std_logic;
  signal axi_reset_n : std_logic;
  signal axi_reset : std_logic;

  signal pl_reset_n : std_logic;
  

------- SGMII
  signal ENET1_EXT_INTIN_0     : STD_LOGIC;
  signal GMII_ETHERNET_col     : STD_LOGIC;
  signal GMII_ETHERNET_crs     : STD_LOGIC;
  signal GMII_ETHERNET_rx_clk  : STD_LOGIC;
  signal GMII_ETHERNET_rx_dv   : STD_LOGIC;
  signal GMII_ETHERNET_rx_er   : STD_LOGIC;
  signal GMII_ETHERNET_rxd     : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal GMII_ETHERNET_tx_clk  : STD_LOGIC;
  signal GMII_ETHERNET_tx_en   : STD_LOGIC_VECTOR ( 0 to 0 );
  signal GMII_ETHERNET_tx_er   : STD_LOGIC_VECTOR ( 0 to 0 );
  signal GMII_ETHERNET_txd     : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal MDIO_ETHERNET_mdc     : std_logic;
  signal MDIO_ETHERNET_mdio_i  : std_logic;
  signal MDIO_ETHERNET_mdio_o  : std_logic;
  signal QPLL_CLK              : std_logic;
  signal QPLL_REF_CLK          : std_logic;

  
------- TCDS
  signal refclk_TCDS : std_logic;
  signal ttc_data : std_logic_vector(35 downto 0); 
  signal tts_data : std_logic_vector(35 downto 0); 
  signal fake_ttc_data : std_logic_vector(35 downto 0);
  signal m1_tts_data : std_logic_vector(35 downto 0);
  signal m2_tts_data : std_logic_vector(35 downto 0);
  signal ttc_dv : std_logic; 
  signal tts_dv : std_logic; 
  signal fake_ttc_dv : std_logic;
  signal m1_tts_dv : std_logic;
  signal m2_tts_dv : std_logic;


  -- AXI C2C
  signal AXI_C2CM1_RX_data              : STD_LOGIC_VECTOR(63 downto 0 ); -- (127 downto 0 );
  signal AXI_C2CM1_RX_dv                : STD_LOGIC;                          
  signal AXI_C2CM1_TX_data              : STD_LOGIC_VECTOR(63 downto 0 ); -- (127 downto 0 );
  signal AXI_C2CM1_TX_ready             : STD_LOGIC;                       
  signal AXI_C2CM1_TX_dv                : STD_LOGIC;                         
  signal AXI_C2C_aurora_init_clk        : STD_LOGIC;                  
  signal AXI_C2C_aurora_mmcm_not_locked : STD_LOGIC;           
  signal AXI_C2C_aurora_pma_init_out    : STD_LOGIC;             
  signal AXI_C2C_reset                  : STD_LOGIC;                           
  signal AXI_C2CM1_channel_up           : STD_LOGIC;                     
  signal AXI_C2CM1_phy_clk              : STD_LOGIC;                        
  signal AXI_C2CM1_phy_clk_raw          : std_logic;
  
  signal refclk_C2C        : std_logic;
  
  signal AXI_C2C_ReadMOSI  : AXIReadMOSI_array_t (1 downto 0);
  signal AXI_C2C_ReadMISO  : AXIReadMISO_array_t (1 downto 0);
  signal AXI_C2C_WriteMOSI : AXIWriteMOSI_array_t(1 downto 0);
  signal AXI_C2C_WriteMISO : AXIWriteMISO_array_t(1 downto 0);
  

  signal C2C_gt_qpllclk_quad4 : std_logic;
  signal C2C_gt_qpllrefclk_quad4 : std_logic;

  signal AXI_C2C_powerdown : std_logic_vector(1 downto 0);
  
  
-- AXI BUS
  signal AXI_clk : std_logic;
  constant PL_AXI_SLAVE_COUNT : integer := 6;
  signal AXI_BUS_RMOSI :  AXIReadMOSI_array_t(0 to PL_AXI_SLAVE_COUNT-1) := (others => DefaultAXIReadMOSI);
  signal AXI_BUS_RMISO :  AXIReadMISO_array_t(0 to PL_AXI_SLAVE_COUNT-1) := (others => DefaultAXIReadMISO);
  signal AXI_BUS_WMOSI : AXIWriteMOSI_array_t(0 to PL_AXI_SLAVE_COUNT-1) := (others => DefaultAXIWriteMOSI);
  signal AXI_BUS_WMISO : AXIWriteMISO_array_t(0 to PL_AXI_SLAVE_COUNT-1) := (others => DefaultAXIWriteMISO);

  signal AXI_MSTR_RMOSI : AXIReadMOSI;
  signal AXI_MSTR_RMISO : AXIReadMISO;
  signal AXI_MSTR_WMOSI : AXIWriteMOSI;
  signal AXI_MSTR_WMISO : AXIWriteMISO;
  

  --Monitoring
  signal SGMII_MON : SGMII_MONITOR_t;
  signal SGMII_MON_CDC : SGMII_MONITOR_t;
  signal SGMII_CTRL : SGMII_CONTROL_t;

  
  signal onbloard_clk_n : std_logic;
  signal onbloard_clk_p : std_logic;
  signal clk_200Mhz : std_logic;
  signal reset_200Mhz : std_logic;
  signal clk_200Mhz_locked : std_logic;

  signal SDA_i_phy : std_logic;
  signal SDA_o_phy : std_logic;
  signal SDA_t_phy : std_logic;
  signal SCL_i_phy : std_logic;
  signal SCL_o_phy : std_logic;
  signal SCL_t_phy : std_logic;
  signal SDA_i_normal : std_logic;
  signal SDA_o_normal : std_logic;
  signal SDA_t_normal : std_logic;
  signal SCL_i_normal : std_logic;
  signal SCL_o_normal : std_logic;
  signal SCL_t_normal : std_logic;

  signal SI_OE_normal : std_logic;
  signal SI_EN_normal : std_logic;
  
  signal IPMC_SDA_o : std_logic;
  signal IPMC_SDA_t : std_logic;
  signal IPMC_SDA_i : std_logic;

  signal  SI_init_reset : std_logic;


  signal XVC0_tck          : STD_LOGIC;
  signal XVC0_tdi          : STD_LOGIC;
  signal XVC0_tdo          : STD_LOGIC;
  signal XVC0_tms          : STD_LOGIC;
  signal XVC1_tck          : STD_LOGIC;
  signal XVC1_tdi          : STD_LOGIC;
  signal XVC1_tdo          : STD_LOGIC;
  signal XVC1_tms          : STD_LOGIC;



  signal CM1_UART_Tx_internal : std_logic;
  signal CM2_UART_Tx_internal : std_logic;
  signal CM1_C2C_Mon : C2C_Monitor_t;
  signal CM2_C2C_Mon : C2C_Monitor_t;
  
  signal CM_enable_IOs   : std_logic_vector(1 downto 0);
  signal CM1_C2C_Ctrl : C2C_Control_t;
  signal CM2_C2C_Ctrl : C2C_Control_t;
  signal C2C1_phy_gt_refclk1_out : std_logic;

  signal linux_booted : std_logic;

  signal clk_TCDS : std_logic;
  signal clk_TCDS_reset_n : std_logic;
begin  -- architecture structure

  pl_reset_n <= axi_reset_n ;
  pl_clk <= axi_clk;
  AXI_C2C_powerdown(0) <= not CM_enable_IOs(0);
  AXI_C2C_powerdown(1) <= not CM_enable_IOs(0); -- since we have one CM
  CM2_C2C_Mon.phy_mmcm_not_locked_out  <= '0';
  CM2_C2C_Mon.cplllock <= '0';
  zynq_bd_wrapper_1: entity work.zynq_bd_wrapper
    port map (
      AXI_RST_N(0)         => axi_reset_n,
      AXI_CLK              => AXI_clk,
      DDR_addr             => DDR_addr,
      DDR_ba               => DDR_ba,
      DDR_cas_n            => DDR_cas_n,
      DDR_ck_n             => DDR_ck_n,
      DDR_ck_p             => DDR_ck_p,
      DDR_cke              => DDR_cke,
      DDR_cs_n             => DDR_cs_n,
      DDR_dm               => DDR_dm,
      DDR_dq               => DDR_dq,
      DDR_dqs_n            => DDR_dqs_n,
      DDR_dqs_p            => DDR_dqs_p,
      DDR_odt              => DDR_odt,
      DDR_ras_n            => DDR_ras_n,
      DDR_reset_n          => DDR_reset_n,
      DDR_we_n             => DDR_we_n,
      FIXED_IO_ddr_vrn     => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp     => FIXED_IO_ddr_vrp,
      FIXED_IO_mio         => FIXED_IO_mio,
      FIXED_IO_ps_clk      => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb     => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb    => FIXED_IO_ps_srstb,
      ENET1_EXT_INTIN_0         => ENET1_EXT_INTIN_0         ,
      GMII_ETHERNET_1_0_col     => GMII_ETHERNET_col     ,
      GMII_ETHERNET_1_0_crs     => GMII_ETHERNET_crs     ,
      GMII_ETHERNET_1_0_rx_clk  => GMII_ETHERNET_rx_clk  ,
      GMII_ETHERNET_1_0_rx_dv   => GMII_ETHERNET_rx_dv   ,
      GMII_ETHERNET_1_0_rx_er   => GMII_ETHERNET_rx_er   ,
      GMII_ETHERNET_1_0_rxd     => GMII_ETHERNET_rxd     ,
      GMII_ETHERNET_1_0_tx_clk  => GMII_ETHERNET_tx_clk  ,
      GMII_ETHERNET_1_0_tx_en   => GMII_ETHERNET_tx_en   ,
      GMII_ETHERNET_1_0_tx_er   => GMII_ETHERNET_tx_er   ,
      GMII_ETHERNET_1_0_txd     => GMII_ETHERNET_txd     ,
      ENET1_MDIO_MDC_0          => MDIO_ETHERNET_mdc     ,
      ENET1_MDIO_I_0            => MDIO_ETHERNET_mdio_i  ,
      ENET1_MDIO_O_0            => MDIO_ETHERNET_mdio_o  ,
      IIC_0_0_scl_io            => I2C_SCL,
      IIC_0_0_sda_io            => I2C_SDA,
      SI_scl_i                  => SCL_i_phy,--SCL_i_normal,
      SI_scl_o                  => SCL_o_phy,--SCL_o_normal,
      SI_scl_t                  => SCL_t_phy,--SCL_t_normal,
      SI_sda_i                  => SDA_i_phy,--SDA_i_normal,
      SI_sda_o                  => SDA_o_phy,--SDA_o_normal,
      SI_sda_t                  => SDA_t_phy,--SDA_t_normal,
      AXI_CLK_PL                => pl_clk,
      AXI_RSTN_PL               => pl_reset_n,
      AXIM_PL_awaddr            => AXI_MSTR_WMOSI.address,
      AXIM_PL_awprot            => AXI_MSTR_WMOSI.protection_type,
      AXIM_PL_awvalid           => AXI_MSTR_WMOSI.address_valid,
      AXIM_PL_awready           => AXI_MSTR_WMISO.ready_for_address,
      AXIM_PL_wdata             => AXI_MSTR_WMOSI.data,
      AXIM_PL_wstrb             => AXI_MSTR_WMOSI.data_write_strobe,
      AXIM_PL_wvalid            => AXI_MSTR_WMOSI.data_valid,
      AXIM_PL_wready            => AXI_MSTR_WMISO.ready_for_data,
      AXIM_PL_bresp             => AXI_MSTR_WMISO.response,
      AXIM_PL_bvalid            => AXI_MSTR_WMISO.response_valid,
      AXIM_PL_bready            => AXI_MSTR_WMOSI.ready_for_response,
      AXIM_PL_araddr            => AXI_MSTR_RMOSI.address,
      AXIM_PL_arprot            => AXI_MSTR_RMOSI.protection_type,
      AXIM_PL_arvalid           => AXI_MSTR_RMOSI.address_valid,
      AXIM_PL_arready           => AXI_MSTR_RMISO.ready_for_address,
      AXIM_PL_rdata             => AXI_MSTR_RMISO.data,
      AXIM_PL_rresp             => AXI_MSTR_RMISO.response,
      AXIM_PL_rvalid            => AXI_MSTR_RMISO.data_valid,
      AXIM_PL_rready            => AXI_MSTR_RMOSI.ready_for_data,
      PL_CLK                    => pl_clk,
      PL_RESET_N                => pl_reset_n,
      SERV_araddr               => AXI_BUS_RMOSI(0).address,
      SERV_arprot               => AXI_BUS_RMOSI(0).protection_type,
      SERV_arready              => AXI_BUS_RMISO(0).ready_for_address,
      SERV_arvalid              => AXI_BUS_RMOSI(0).address_valid,
      SERV_awaddr               => AXI_BUS_WMOSI(0).address,
      SERV_awprot               => AXI_BUS_WMOSI(0).protection_type,
      SERV_awready              => AXI_BUS_WMISO(0).ready_for_address,
      SERV_awvalid              => AXI_BUS_WMOSI(0).address_valid,
      SERV_bready               => AXI_BUS_WMOSI(0).ready_for_response,
      SERV_bresp                => AXI_BUS_WMISO(0).response,
      SERV_bvalid               => AXI_BUS_WMISO(0).response_valid,
      SERV_rdata                => AXI_BUS_RMISO(0).data,
      SERV_rready               => AXI_BUS_RMOSI(0).ready_for_data,
      SERV_rresp                => AXI_BUS_RMISO(0).response,
      SERV_rvalid               => AXI_BUS_RMISO(0).data_valid,
      SERV_wdata                => AXI_BUS_WMOSI(0).data,
      SERV_wready               => AXI_BUS_WMISO(0).ready_for_data,
      SERV_wstrb                => AXI_BUS_WMOSI(0).data_write_strobe,
      SERV_wvalid               => AXI_BUS_WMOSI(0).data_valid,

      SLAVE_I2C_araddr               => AXI_BUS_RMOSI(1).address,
      SLAVE_I2C_arprot               => AXI_BUS_RMOSI(1).protection_type,
      SLAVE_I2C_arready              => AXI_BUS_RMISO(1).ready_for_address,
      SLAVE_I2C_arvalid              => AXI_BUS_RMOSI(1).address_valid,
      SLAVE_I2C_awaddr               => AXI_BUS_WMOSI(1).address,
      SLAVE_I2C_awprot               => AXI_BUS_WMOSI(1).protection_type,
      SLAVE_I2C_awready              => AXI_BUS_WMISO(1).ready_for_address,
      SLAVE_I2C_awvalid              => AXI_BUS_WMOSI(1).address_valid,
      SLAVE_I2C_bready               => AXI_BUS_WMOSI(1).ready_for_response,
      SLAVE_I2C_bresp                => AXI_BUS_WMISO(1).response,
      SLAVE_I2C_bvalid               => AXI_BUS_WMISO(1).response_valid,
      SLAVE_I2C_rdata                => AXI_BUS_RMISO(1).data,
      SLAVE_I2C_rready               => AXI_BUS_RMOSI(1).ready_for_data,
      SLAVE_I2C_rresp                => AXI_BUS_RMISO(1).response,
      SLAVE_I2C_rvalid               => AXI_BUS_RMISO(1).data_valid,
      SLAVE_I2C_wdata                => AXI_BUS_WMOSI(1).data,
      SLAVE_I2C_wready               => AXI_BUS_WMISO(1).ready_for_data,
      SLAVE_I2C_wstrb                => AXI_BUS_WMOSI(1).data_write_strobe,
      SLAVE_I2C_wvalid               => AXI_BUS_WMOSI(1).data_valid,

      CM_araddr               => AXI_BUS_RMOSI(2).address,
      CM_arprot               => AXI_BUS_RMOSI(2).protection_type,
      CM_arready              => AXI_BUS_RMISO(2).ready_for_address,
      CM_arvalid              => AXI_BUS_RMOSI(2).address_valid,
      CM_awaddr               => AXI_BUS_WMOSI(2).address,
      CM_awprot               => AXI_BUS_WMOSI(2).protection_type,
      CM_awready              => AXI_BUS_WMISO(2).ready_for_address,
      CM_awvalid              => AXI_BUS_WMOSI(2).address_valid,
      CM_bready               => AXI_BUS_WMOSI(2).ready_for_response,
      CM_bresp                => AXI_BUS_WMISO(2).response,
      CM_bvalid               => AXI_BUS_WMISO(2).response_valid,
      CM_rdata                => AXI_BUS_RMISO(2).data,
      CM_rready               => AXI_BUS_RMOSI(2).ready_for_data,
      CM_rresp                => AXI_BUS_RMISO(2).response,
      CM_rvalid               => AXI_BUS_RMISO(2).data_valid,
      CM_wdata                => AXI_BUS_WMOSI(2).data,
      CM_wready               => AXI_BUS_WMISO(2).ready_for_data,
      CM_wstrb                => AXI_BUS_WMOSI(2).data_write_strobe,
      CM_wvalid               => AXI_BUS_WMOSI(2).data_valid,

      SM_INFO_araddr          => AXI_BUS_RMOSI(3).address,
      SM_INFO_arprot          => AXI_BUS_RMOSI(3).protection_type,
      SM_INFO_arready         => AXI_BUS_RMISO(3).ready_for_address,
      SM_INFO_arvalid         => AXI_BUS_RMOSI(3).address_valid,
      SM_INFO_awaddr          => AXI_BUS_WMOSI(3).address,
      SM_INFO_awprot          => AXI_BUS_WMOSI(3).protection_type,
      SM_INFO_awready         => AXI_BUS_WMISO(3).ready_for_address,
      SM_INFO_awvalid         => AXI_BUS_WMOSI(3).address_valid,
      SM_INFO_bready          => AXI_BUS_WMOSI(3).ready_for_response,
      SM_INFO_bresp           => AXI_BUS_WMISO(3).response,
      SM_INFO_bvalid          => AXI_BUS_WMISO(3).response_valid,
      SM_INFO_rdata           => AXI_BUS_RMISO(3).data,
      SM_INFO_rready          => AXI_BUS_RMOSI(3).ready_for_data,
      SM_INFO_rresp           => AXI_BUS_RMISO(3).response,
      SM_INFO_rvalid          => AXI_BUS_RMISO(3).data_valid,
      SM_INFO_wdata           => AXI_BUS_WMOSI(3).data,
      SM_INFO_wready          => AXI_BUS_WMISO(3).ready_for_data,
      SM_INFO_wstrb           => AXI_BUS_WMOSI(3).data_write_strobe,
      SM_INFO_wvalid          => AXI_BUS_WMOSI(3).data_valid,

      TCDS_DRP_araddr          => AXI_BUS_RMOSI(4).address,
      TCDS_DRP_arprot          => AXI_BUS_RMOSI(4).protection_type,
      TCDS_DRP_arready         => AXI_BUS_RMISO(4).ready_for_address,
      TCDS_DRP_arvalid         => AXI_BUS_RMOSI(4).address_valid,
      TCDS_DRP_awaddr          => AXI_BUS_WMOSI(4).address,
      TCDS_DRP_awprot          => AXI_BUS_WMOSI(4).protection_type,
      TCDS_DRP_awready         => AXI_BUS_WMISO(4).ready_for_address,
      TCDS_DRP_awvalid         => AXI_BUS_WMOSI(4).address_valid,
      TCDS_DRP_bready          => AXI_BUS_WMOSI(4).ready_for_response,
      TCDS_DRP_bresp           => AXI_BUS_WMISO(4).response,
      TCDS_DRP_bvalid          => AXI_BUS_WMISO(4).response_valid,
      TCDS_DRP_rdata           => AXI_BUS_RMISO(4).data,
      TCDS_DRP_rready          => AXI_BUS_RMOSI(4).ready_for_data,
      TCDS_DRP_rresp           => AXI_BUS_RMISO(4).response,
      TCDS_DRP_rvalid          => AXI_BUS_RMISO(4).data_valid,
      TCDS_DRP_wdata           => AXI_BUS_WMOSI(4).data,
      TCDS_DRP_wready          => AXI_BUS_WMISO(4).ready_for_data,
      TCDS_DRP_wstrb           => AXI_BUS_WMOSI(4).data_write_strobe,
      TCDS_DRP_wvalid          => AXI_BUS_WMOSI(4).data_valid,

      TCDS_araddr              => AXI_BUS_RMOSI(5).address,
      TCDS_arprot              => AXI_BUS_RMOSI(5).protection_type,
      TCDS_arready             => AXI_BUS_RMISO(5).ready_for_address,
      TCDS_arvalid             => AXI_BUS_RMOSI(5).address_valid,
      TCDS_awaddr              => AXI_BUS_WMOSI(5).address,
      TCDS_awprot              => AXI_BUS_WMOSI(5).protection_type,
      TCDS_awready             => AXI_BUS_WMISO(5).ready_for_address,
      TCDS_awvalid             => AXI_BUS_WMOSI(5).address_valid,
      TCDS_bready              => AXI_BUS_WMOSI(5).ready_for_response,
      TCDS_bresp               => AXI_BUS_WMISO(5).response,
      TCDS_bvalid              => AXI_BUS_WMISO(5).response_valid,
      TCDS_rdata               => AXI_BUS_RMISO(5).data,
      TCDS_rready              => AXI_BUS_RMOSI(5).ready_for_data,
      TCDS_rresp               => AXI_BUS_RMISO(5).response,
      TCDS_rvalid              => AXI_BUS_RMISO(5).data_valid,
      TCDS_wdata               => AXI_BUS_WMOSI(5).data,
      TCDS_wready              => AXI_BUS_WMISO(5).ready_for_data,
      TCDS_wstrb               => AXI_BUS_WMOSI(5).data_write_strobe,
      TCDS_wvalid              => AXI_BUS_WMOSI(5).data_valid,


      

      tap_tck_0                 => XVC0_tck,
      tap_tdi_0                 => XVC0_tdi,
      tap_tdo_0                 => XVC0_tdo,
      tap_tms_0                 => XVC0_tms,
      tap_tck_1                 => XVC1_tck,
      tap_tdi_1                 => XVC1_tdi,
      tap_tdo_1                 => XVC1_tdo,
      tap_tms_1                 => XVC1_tms,

      init_clk        =>  AXI_C2C_aurora_init_clk,
      C2C1_phy_Rx_rxn =>  AXI_C2C_CM1_Rx_N(0 to 0),
      C2C1_phy_Rx_rxp =>  AXI_C2C_CM1_Rx_P(0 to 0),
      C2C1_phy_Tx_txn =>  AXI_C2C_CM1_Tx_N(0 to 0),
      C2C1_phy_Tx_txp =>  AXI_C2C_CM1_Tx_P(0 to 0),
      C2C1_phy_refclk_clk_n => refclk_C2C_N(0),
      C2C1_phy_refclk_clk_p => refclk_C2C_P(0),
      C2C1_phy_power_down   => AXI_C2C_powerdown(0),
      C2C1_aurora_do_cc                 => CM1_C2C_Mon.aurora_do_cc                ,
      C2C1_aurora_pma_init_in           => CM1_C2C_Ctrl.aurora_pma_init_in,
      C2C1_axi_c2c_config_error_out     => CM1_C2C_Mon.axi_c2c_config_error_out    ,
      C2C1_axi_c2c_link_error_out       => CM1_C2C_Mon.axi_c2c_link_error_out      ,
      C2C1_axi_c2c_link_status_out      => CM1_C2C_Mon.axi_c2c_link_status_out     ,
      C2C1_axi_c2c_multi_bit_error_out  => CM1_C2C_Mon.axi_c2c_multi_bit_error_out ,
      C2C1_phy_gt_pll_lock              => CM1_C2C_Mon.phy_gt_pll_lock             ,
      C2C1_phy_hard_err                 => CM1_C2C_Mon.phy_hard_err                ,
      C2C1_phy_lane_up                  => CM1_C2C_Mon.phy_lane_up                 ,
      C2C1_phy_link_reset_out           => CM1_C2C_Mon.phy_link_reset_out          ,
      C2C1_phy_gt_refclk1_out           => C2C1_phy_gt_refclk1_out          ,
      C2C1_phy_mmcm_not_locked_out      => CM1_C2C_Mon.phy_mmcm_not_locked_out     ,
      C2C1_phy_soft_err                 => CM1_C2C_Mon.phy_soft_err                ,
      C2C1_PHY_DEBUG_cplllock         => CM1_C2C_Mon.cplllock,
      C2C1_PHY_DEBUG_dmonitorout      => CM1_C2C_Mon.dmonitorout,
      C2C1_PHY_DEBUG_eyescandataerror => CM1_C2C_Mon.eyescandataerror,
      C2C1_PHY_DEBUG_eyescanreset     => CM1_C2C_Ctrl.eyescanreset,
      C2C1_PHY_DEBUG_eyescantrigger   => CM1_C2C_Ctrl.eyescantrigger,
      C2C1_PHY_DEBUG_rxbufreset       => CM1_C2C_Ctrl.rxbufreset,
      C2C1_PHY_DEBUG_rxbufstatus      => CM1_C2C_Mon.rxbufstatus,
      C2C1_PHY_DEBUG_rxcdrhold        => CM1_C2C_Ctrl.rxcdrhold,
      C2C1_PHY_DEBUG_rxdfeagchold     => CM1_C2C_Ctrl.rxdfeagchold,
      C2C1_PHY_DEBUG_rxdfeagcovrden   => CM1_C2C_Ctrl.rxdfeagcovrden,
      C2C1_PHY_DEBUG_rxdfelfhold      => CM1_C2C_Ctrl.rxdfelfhold,
      C2C1_PHY_DEBUG_rxdfelpmreset    => CM1_C2C_Ctrl.rxdfelpmreset,
      C2C1_PHY_DEBUG_rxlpmen          => CM1_C2C_Ctrl.rxlpmen,
      C2C1_PHY_DEBUG_rxlpmhfovrden    => CM1_C2C_Ctrl.rxlpmhfovrden,
      C2C1_PHY_DEBUG_rxlpmlfklovrden  => CM1_C2C_Ctrl.rxlpmlfklovrden,
      C2C1_PHY_DEBUG_rxmonitorout     => CM1_C2C_Mon.rxmonitorout,
      C2C1_PHY_DEBUG_rxmonitorsel     => CM1_C2C_Ctrl.rxmonitorsel,
      C2C1_PHY_DEBUG_rxpcsreset       => CM1_C2C_Ctrl.rxpcsreset,    
      C2C1_PHY_DEBUG_rxpmareset       => CM1_C2C_Ctrl.rxpmareset,    
      C2C1_PHY_DEBUG_rxprbscntreset   => CM1_C2C_Ctrl.rxprbscntreset,
      C2C1_PHY_DEBUG_rxprbserr        => CM1_C2C_Mon.rxprbserr,
      C2C1_PHY_DEBUG_rxprbssel        => CM1_C2C_Ctrl.rxprbssel,
      C2C1_PHY_DEBUG_rxresetdone      => CM1_C2C_Mon.rxresetdone,
      C2C1_PHY_DEBUG_txbufstatus      => CM1_C2C_Mon.txbufstatus,
      C2C1_PHY_DEBUG_txdiffctrl       => CM1_C2C_Ctrl.txdiffctrl,      
      C2C1_PHY_DEBUG_txinhibit        => CM1_C2C_Ctrl.txinhibit,       
      C2C1_PHY_DEBUG_txmaincursor     => CM1_C2C_Ctrl.txmaincursor,    
      C2C1_PHY_DEBUG_txpcsreset       => CM1_C2C_Ctrl.txpcsreset,      
      C2C1_PHY_DEBUG_txpmareset       => CM1_C2C_Ctrl.txpmareset,      
      C2C1_PHY_DEBUG_txpolarity       => CM1_C2C_Ctrl.txpolarity,      
      C2C1_PHY_DEBUG_txpostcursor     => CM1_C2C_Ctrl.txpostcursor,    
      C2C1_PHY_DEBUG_txprbsforceerr   => CM1_C2C_Ctrl.txprbsforceerr,  
      C2C1_PHY_DEBUG_txprbssel        => CM1_C2C_Ctrl.txprbssel,       
      C2C1_PHY_DEBUG_txprecursor      => CM1_C2C_Ctrl.txprecursor,     
      C2C1_PHY_DEBUG_txresetdone      => CM1_C2C_Mon.txresetdone,

      C2C2_phy_Rx_rxn =>  AXI_C2C_CM2_Rx_N(0 to 0),
      C2C2_phy_Rx_rxp =>  AXI_C2C_CM2_Rx_P(0 to 0),
      C2C2_phy_Tx_txn =>  AXI_C2C_CM2_Tx_N(0 to 0),
      C2C2_phy_Tx_txp =>  AXI_C2C_CM2_Tx_P(0 to 0),
      C2C2_phy_power_down   => AXI_C2C_powerdown(1),
      C2C2_aurora_do_cc                 => CM2_C2C_Mon.aurora_do_cc                ,
      C2C2_aurora_pma_init_in           => CM2_C2C_Ctrl.aurora_pma_init_in,
      C2C2_axi_c2c_config_error_out     => CM2_C2C_Mon.axi_c2c_config_error_out    ,
      C2C2_axi_c2c_link_error_out       => CM2_C2C_Mon.axi_c2c_link_error_out      ,
      C2C2_axi_c2c_link_status_out      => CM2_C2C_Mon.axi_c2c_link_status_out     ,
      C2C2_axi_c2c_multi_bit_error_out  => CM2_C2C_Mon.axi_c2c_multi_bit_error_out ,
      C2C2_phy_gt_pll_lock              => CM2_C2C_Mon.phy_gt_pll_lock             ,
      C2C2_phy_hard_err                 => CM2_C2C_Mon.phy_hard_err                ,
      C2C2_phy_lane_up                  => CM2_C2C_Mon.phy_lane_up                 ,
      C2C2_phy_link_reset_out           => CM2_C2C_Mon.phy_link_reset_out          ,
--      C2C2_phy_mmcm_not_locked_out      => CM2_C2C_Mon.phy_mmcm_not_locked_out     ,
      C2C2_phy_soft_err                 => CM2_C2C_Mon.phy_soft_err                ,
--      C2C2_PHY_DEBUG_cplllock         => CM2_C2C_Mon.cplllock,
      C2C2_PHY_DEBUG_dmonitorout      => CM2_C2C_Mon.dmonitorout,
      C2C2_PHY_DEBUG_eyescandataerror => CM2_C2C_Mon.eyescandataerror,
      C2C2_PHY_DEBUG_eyescanreset     => CM2_C2C_Ctrl.eyescanreset,
      C2C2_PHY_DEBUG_eyescantrigger   => CM2_C2C_Ctrl.eyescantrigger,
      C2C2_PHY_DEBUG_rxbufreset       => CM2_C2C_Ctrl.rxbufreset,
      C2C2_PHY_DEBUG_rxbufstatus      => CM2_C2C_Mon.rxbufstatus,
      C2C2_PHY_DEBUG_rxcdrhold        => CM2_C2C_Ctrl.rxcdrhold,
      C2C2_PHY_DEBUG_rxdfeagchold     => CM2_C2C_Ctrl.rxdfeagchold,
      C2C2_PHY_DEBUG_rxdfeagcovrden   => CM2_C2C_Ctrl.rxdfeagcovrden,
      C2C2_PHY_DEBUG_rxdfelfhold      => CM2_C2C_Ctrl.rxdfelfhold,
      C2C2_PHY_DEBUG_rxdfelpmreset    => CM2_C2C_Ctrl.rxdfelpmreset,
      C2C2_PHY_DEBUG_rxlpmen          => CM2_C2C_Ctrl.rxlpmen,
      C2C2_PHY_DEBUG_rxlpmhfovrden    => CM2_C2C_Ctrl.rxlpmhfovrden,
      C2C2_PHY_DEBUG_rxlpmlfklovrden  => CM2_C2C_Ctrl.rxlpmlfklovrden,
      C2C2_PHY_DEBUG_rxmonitorout     => CM2_C2C_Mon.rxmonitorout,
      C2C2_PHY_DEBUG_rxmonitorsel     => CM2_C2C_Ctrl.rxmonitorsel,
      C2C2_PHY_DEBUG_rxpcsreset       => CM2_C2C_Ctrl.rxpcsreset,    
      C2C2_PHY_DEBUG_rxpmareset       => CM2_C2C_Ctrl.rxpmareset,    
      C2C2_PHY_DEBUG_rxprbscntreset   => CM2_C2C_Ctrl.rxprbscntreset,
      C2C2_PHY_DEBUG_rxprbserr        => CM2_C2C_Mon.rxprbserr,
      C2C2_PHY_DEBUG_rxprbssel        => CM2_C2C_Ctrl.rxprbssel,
      C2C2_PHY_DEBUG_rxresetdone      => CM2_C2C_Mon.rxresetdone,
      C2C2_PHY_DEBUG_txbufstatus      => CM2_C2C_Mon.txbufstatus,
      C2C2_PHY_DEBUG_txdiffctrl       => CM2_C2C_Ctrl.txdiffctrl,      
      C2C2_PHY_DEBUG_txinhibit        => CM2_C2C_Ctrl.txinhibit,       
      C2C2_PHY_DEBUG_txmaincursor     => CM2_C2C_Ctrl.txmaincursor,    
      C2C2_PHY_DEBUG_txpcsreset       => CM2_C2C_Ctrl.txpcsreset,      
      C2C2_PHY_DEBUG_txpmareset       => CM2_C2C_Ctrl.txpmareset,      
      C2C2_PHY_DEBUG_txpolarity       => CM2_C2C_Ctrl.txpolarity,      
      C2C2_PHY_DEBUG_txpostcursor     => CM2_C2C_Ctrl.txpostcursor,    
      C2C2_PHY_DEBUG_txprbsforceerr   => CM2_C2C_Ctrl.txprbsforceerr,  
      C2C2_PHY_DEBUG_txprbssel        => CM2_C2C_Ctrl.txprbssel,       
      C2C2_PHY_DEBUG_txprecursor      => CM2_C2C_Ctrl.txprecursor,     
      C2C2_PHY_DEBUG_txresetdone      => CM2_C2C_Mon.txresetdone,
      CM1_UART_rxd => CM1_UART_rx,
      CM1_UART_txd => CM1_UART_Tx_internal,
      CM2_UART_rxd => CM2_UART_rx,
      CM2_UART_txd => CM2_UART_Tx_internal,
      ESM_UART_rxd => ESM_UART_rx,
      ESM_UART_txd => ESM_UART_tx,
      BRAM_PORTB_0_addr => x"00000000",
      BRAM_PORTB_0_clk  => AXI_clk,
      BRAM_PORTB_0_din  => x"00000000",
      BRAM_PORTB_0_dout => open,
      BRAM_PORTB_0_en   => '0',
      BRAM_PORTB_0_rst  => '0',
      BRAM_PORTB_0_we   => x"0",

      TCDS_CLK          => clk_TCDS,
      TCDS_reset_n      => clk_TCDS_reset_n
      );




  pass_std_logic_vector_1: entity work.pass_std_logic_vector
    generic map (
      DATA_WIDTH => 22)
    port map (
      clk_in   => GMII_ETHERNET_tx_clk,--clk_user2_SGMII,--clk_SGMII_tx,
      clk_out  => axi_clk,
      reset    => '0',
      pass_in(0)  => SGMII_MON.reset_done,   
      pass_in(1)  => SGMII_MON.cpll_lock,    
      pass_in(2)  => SGMII_MON.mmcm_reset,   
      pass_in(3)  => SGMII_MON.pma_reset,    
      pass_in(4)  => SGMII_MON.mmcm_locked,  
      pass_in(20 downto 5)  => SGMII_MON.status_vector,
      pass_in(21)  => SGMII_MON.reset,              
      pass_out(0)   => SGMII_MON_CDC.reset_done,   
      pass_out(1)  => SGMII_MON_CDC.cpll_lock,    
      pass_out(2)  => SGMII_MON_CDC.mmcm_reset,   
      pass_out(3)  => SGMII_MON_CDC.pma_reset,    
      pass_out(4)  => SGMII_MON_CDC.mmcm_locked,  
      pass_out(20 downto 5)  => SGMII_MON_CDC.status_vector,
      pass_out(21)  => SGMII_MON_CDC.reset              
);


--  SGMII_MON_CDC <= SGMII_MON;
  SGMII_1: entity work.SGMII
    port map (
      sys_clk               => axi_clk,
      refclk_125Mhz_P       => refclk_125Mhz_P,
      refclk_125Mhz_N       => refclk_125Mhz_N,
      sgmii_tx_P            => sgmii_tx_P,
      sgmii_tx_N            => sgmii_tx_N,
      sgmii_rx_P            => sgmii_rx_P,
      sgmii_rx_N            => sgmii_rx_N,
      QPLL_CLK              => QPLL_CLK,              
      QPLL_REF_CLK          => QPLL_REF_CLK,         
      ENET1_EXT_INTIN_0     => ENET1_EXT_INTIN_0,
      GMII_ETHERNET_col     => GMII_ETHERNET_col,
      GMII_ETHERNET_crs     => GMII_ETHERNET_crs,
      GMII_ETHERNET_rx_clk  => GMII_ETHERNET_rx_clk,
      GMII_ETHERNET_rx_dv   => GMII_ETHERNET_rx_dv,
      GMII_ETHERNET_rx_er   => GMII_ETHERNET_rx_er,
      GMII_ETHERNET_rxd     => GMII_ETHERNET_rxd,
      GMII_ETHERNET_tx_clk  => GMII_ETHERNET_tx_clk,
      GMII_ETHERNET_tx_en   => GMII_ETHERNET_tx_en,
      GMII_ETHERNET_tx_er   => GMII_ETHERNET_tx_er,
      GMII_ETHERNET_txd     => GMII_ETHERNET_txd,
      MDIO_ETHERNET_mdc     => MDIO_ETHERNET_mdc,
      MDIO_ETHERNET_mdio_i  => MDIO_ETHERNET_mdio_i,
      MDIO_ETHERNET_mdio_o  => MDIO_ETHERNET_mdio_o,  
      SGMII_MON             => SGMII_MON,
      SGMII_CTRL            => SGMII_CTRL);


  axi_reset <= not axi_reset_n;

  pass_std_logic_vector_2: entity work.pass_std_logic_vector
    generic map (
      DATA_WIDTH => 1)
    port map (
      clk_in   => axi_clk,
      clk_out  => clk_TCDS,
      reset    => axi_reset_n,
      pass_in(0)  => axi_reset_n,
      pass_out(0) => clk_TCDS_reset_n);
  
    
  TCDS_2: entity work.TCDS
    port map (
      clk_axi            => clk_TCDS,
      reset_axi_n        => clk_TCDS_reset_n,--pl_reset_n,
      clk_axi_DRP        => axi_clk,
      reset_axi_DRP_n    => pl_reset_n,
      readMOSI           => AXI_BUS_RMOSI(5),
      readMISO           => AXI_BUS_RMISO(5),
      writeMOSI          => AXI_BUS_WMOSI(5),
      writeMISO          => AXI_BUS_WMISO(5),
      DRP_readMOSI       => AXI_BUS_RMOSI(4),
      DRP_readMISO       => AXI_BUS_RMISO(4),
      DRP_writeMOSI      => AXI_BUS_WMOSI(4),
      DRP_writeMISO      => AXI_BUS_WMISO(4),
--      sysclk        => pl_clk,
      refclk_p      => refclk_TCDS_P,
      refclk_n      => refclk_TCDS_N,
      QPLL_CLK        => QPLL_CLK,    
      QPLL_REF_CLK    => QPLL_REF_CLK,        
--      reset         => axi_reset,
      clk_TCDS    => clk_TCDS,
      clk_TCDS_reset_n => open,--clk_TCDS_reset_n,
      tx_P(0)     => tts_P,
      tx_P(1)     => fake_ttc_P,  
      tx_P(2)     => open, 
      tx_N(0)     => tts_N,
      tx_N(1)     => fake_ttc_N,  
      tx_N(2)     => open, 
      rx_P(0)     => ttc_P,
      rx_P(1)     => m1_tts_P,    
      rx_P(2)     => m2_tts_P,    
      rx_N(0)     => ttc_N,
      rx_N(1)     => m1_tts_N,    
      rx_N(2)     => m2_tts_N);



  SI_i2c_SDA : IOBUF
    port map (
      IO => SI_sda,
      I  => SDA_o_phy,
      T  => SDA_t_phy,
      O  => SDA_i_phy);
  SI_i2c_SCL : IOBUF
    port map (
      IO => SI_scl,
      I  => SCL_o_phy,
      T  => SCL_t_phy,
      O  => SCL_i_phy);

  onboard_CLK_1: entity work.onboard_CLK
    port map (
      clk_200Mhz => clk_200Mhz,
      clk_50Mhz  => AXI_C2C_aurora_init_clk,
      reset      =>  SI_init_reset,--'0',
      locked     => clk_200Mhz_locked,
      clk_in1_n     => onboard_clk_n,
      clk_in1_p     => onboard_clk_p);
  reset_200Mhz <= not clk_200Mhz_locked ;

  SI_OUT_DIS <= not SI_OE_normal;
  SI_ENABLE  <= SI_EN_normal;

  services_1: entity work.services
    port map (
      clk_axi         => axi_clk,
      reset_axi_n     => pl_reset_n,
      readMOSI        => AXI_BUS_RMOSI(0),
      readMISO        => AXI_BUS_RMISO(0),
      writeMOSI       => AXI_BUS_WMOSI(0),
      writeMISO       => AXI_BUS_WMISO(0),
      SGMII_MON       => SGMII_MON_CDC,
      SGMII_CTRL      => SGMII_CTRL,
      SI_INT          => SI_INT,
      SI_LOL          => SI_LOL,
      SI_LOS          => SI_LOS,
      SI_OUT_EN       => SI_OE_normal,
      SI_ENABLE       => SI_EN_normal,
      SI_init_reset   => SI_init_reset,
      TTC_SRC_SEL     => TTC_SRC_SEL,
      LHC_CLK_CMS_LOS => LHC_CLK_CMS_LOS,
      LHC_CLK_OSC_LOS => LHC_CLK_OSC_LOS,
      LHC_SRC_SEL     => LHC_SRC_SEL,
      HQ_CLK_CMS_LOS  => HQ_CLK_CMS_LOS,
      HQ_CLK_OSC_LOS  => HQ_CLK_OSC_LOS,
      HQ_SRC_SEL      => HQ_SRC_SEL,
      FP_LED_RST      => FP_LED_RST,
      FP_LED_CLK      => FP_LED_CLK,
      FP_LED_SDA      => FP_LED_SDA,
      FP_switch       => FP_switch,
      linux_booted    => linux_booted,
      ESM_LED_CLK     => ESM_LED_CLK,
      ESM_LED_SDA     => ESM_LED_SDA,
      CM1_C2C_Mon     => CM1_C2C_Mon,
      CM2_C2C_Mon     => CM2_C2C_Mon
      );

  SM_info_1: entity work.SM_info
    port map (
      clk_axi     => axi_clk,
      reset_axi_n => pl_reset_n,
      readMOSI    => AXI_BUS_RMOSI(3),
      readMISO    => AXI_BUS_RMISO(3),
      writeMOSI   => AXI_BUS_WMOSI(3),
      writeMISO   => AXI_BUS_WMISO(3));
  
  IPMC_i2c_slave_1: entity work.IPMC_i2c_slave
    port map (
      clk_axi     => axi_clk,
      reset_axi_n => pl_reset_n,
      readMOSI        => AXI_BUS_RMOSI(1),
      readMISO        => AXI_BUS_RMISO(1),
      writeMOSI       => AXI_BUS_WMOSI(1),
      writeMISO       => AXI_BUS_WMISO(1),
      linux_booted    => linux_booted,
      SDA_o       => IPMC_SDA_o,
      SDA_t       => IPMC_SDA_t,
      SDA_i       => IPMC_SDA_i,
      SCL         => IPMC_SCL);
  IPMC_i2c_SDA : IOBUF
    port map (
      IO => IPMC_SDA,
      I  => IPMC_SDA_o,
      T  => IPMC_SDA_t,
      O  => IPMC_SDA_i);


  XVC0_TDO <= CM1_TDO;
  XVC1_TDO <= CM2_TDO;
  CM_interface_1: entity work.CM_intf
    port map (
      clk_axi              => axi_clk,
      reset_axi_n          => pl_reset_n,
      slave_readMOSI       => AXI_BUS_RMOSI(2),
      slave_readMISO       => AXI_BUS_RMISO(2),
      slave_writeMOSI      => AXI_BUS_WMOSI(2),
      slave_writeMISO      => AXI_BUS_WMISO(2),
      master_readMOSI      => AXI_MSTR_RMOSI,
      master_readMISO      => AXI_MSTR_RMISO,
      master_writeMOSI     => AXI_MSTR_WMOSI,
      master_writeMISO     => AXI_MSTR_WMISO,
      CM_mon_uart          => CM1_GPIO(0),
      enableCM1            => CM1_enable,
      enableCM2            => CM2_enable,
      enableCM1_PWR        => CM1_PWR_enable,
      enableCM2_PWR        => CM2_PWR_enable,
      enableCM1_IOs        => CM_enable_IOs(0),
      enableCM2_IOs        => CM_enable_IOs(1),
      from_CM1.PWR_good    => CM1_PWR_good,
      from_CM1.TDO         => '0',
      from_CM1.GPIO        => CM1_GPIO,
      from_CM1.UART_Rx     => '0',--CM1_UART_rx,     
      from_CM2.PWR_good    => CM2_PWR_good,
      from_CM2.TDO         => '0',
      from_CM2.GPIO        => CM2_GPIO,
      from_CM2.UART_Rx     => CM2_UART_rx,
      to_CM1_in.UART_Tx    => CM1_UART_Tx_internal,
      to_CM1_in.TMS        => XVC0_TMS,
      to_CM1_in.TDI        => XVC0_TDI,
      to_CM1_in.TCK        => XVC0_TCK,
      to_CM2_in.UART_Tx    => '0',--CM2_UART_Tx_internal,
      to_CM2_in.TMS        => XVC1_TMS,
      to_CM2_in.TDI        => XVC1_TDI,
      to_CM2_in.TCK        => XVC1_TCK,
      to_CM1_out.UART_Tx   => CM1_UART_Tx,
      to_CM1_out.TMS       => CM1_TMS,
      to_CM1_out.TDI       => CM1_TDI,
      to_CM1_out.TCK       => CM1_TCK,
      to_CM2_out.UART_Tx   => CM2_UART_Tx,
      to_CM2_out.TMS       => CM2_TMS,
      to_CM2_out.TDI       => CM2_TDI,
      to_CM2_out.TCK       => CM2_TCK,
      CM1_C2C_Mon          => CM1_C2C_Mon,
      CM2_C2C_Mon          => CM2_C2C_Mon,
      CM1_C2C_Ctrl         => CM1_C2C_Ctrl,
      CM2_C2C_Ctrl         => CM2_C2C_Ctrl);



  


  

  
end architecture structure;
