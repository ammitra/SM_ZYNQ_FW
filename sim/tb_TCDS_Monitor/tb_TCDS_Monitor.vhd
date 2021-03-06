library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.types.all;

entity tb_TCDS_Monitor is
  port (
    clk_axi     : in std_logic;
    clk_TCDS    : in std_logic;
    reset       : in std_logic);

end entity tb_TCDS_Monitor;

architecture behavioral of tb_TCDS_Monitor is

  signal counter_axi : integer;
  signal counter_TCDS : integer;
  signal axi_reset_n    : std_logic;    
  signal counters_en    : std_logic;
  signal prbs_err_count : std_logic_vector(31 downto 0);
  signal bad_word_count : std_logic_vector(31 downto 0);
  signal disp_err_count : std_logic_vector(31 downto 0);
  signal prbs_error     : std_logic;
  signal bad_word       : std_logic;
  signal disp_error     : std_logic;

  
begin  -- architecture behavioral

  axi_reset_n <= not reset;
  
  tb: process (clk_axi, reset) is
  begin  -- process tb
    if reset = '1' then              -- asynchronous reset (active high)
      counter_axi <= 0;
      counters_en <= '0';
           
    elsif clk_axi'event and clk_axi = '1' then  -- rising clock edge
      counter_axi <= counter_axi + 1;

      case counter_axi is
        --test normal procedure
        when 20 =>
          counters_en <= '1';

        when others => null;
      end case;
    end if;
  end process tb;

  tb_TCDS: process (clk_TCDS, reset) is
  begin  -- process tb
    if reset = '1' then              -- asynchronous reset (active high)
      counter_TCDS <= 0;
      prbs_error     <= '0';
      bad_word       <= '0';
      disp_error     <= '0';
     
    elsif clk_TCDS'event and clk_TCDS = '1' then  -- rising clock edge
      counter_TCDS <= counter_TCDS + 1;
      prbs_error     <= '0';
      bad_word       <= '0';
      disp_error     <= '0';
      
      case counter_TCDS is
        --test normal procedure
        when 100   =>
          prbs_error <= '1';
        when 200 to 250 =>
          bad_word <= '1';
          disp_error <= '1';

        when 300 =>
          prbs_error <= '1';

        when others => null;
      end case;
    end if;
  end process tb_TCDS;

  
  UUT: entity work.TCDS_Monitor
    port map (
      clk_axi        => clk_axi,
      axi_reset_n    => axi_reset_n,
      counters_en    => counters_en,
      prbs_err_count => prbs_err_count,
      bad_word_count => bad_word_count,
      disp_err_count => disp_err_count,
      clk_txrx       => clk_TCDS,
      prbs_error     => prbs_error,
      bad_word       => bad_word,
      disp_error     => disp_error);
  
end architecture behavioral;
