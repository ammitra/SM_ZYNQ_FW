library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--use work.types.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity CM_phy_lane_control is
  generic (
    CLKFREQ          : integer := 50000000;  --Frequency of clk (hz)
    DATA_WIDTH       : integer := 32;        --Data width for error counter
    ERROR_WAIT_TIME  : integer := 50000000); --Wait time for error checking state
  port (
    clk              : in  std_logic;
    reset            : in  std_logic;
    reset_counter    : in  std_logic;
    enable           : in  std_logic;
    phy_lane_up      : in  std_logic;
    initialize_out   : out std_logic;
    lock             : out std_logic;
    state_out        : out std_logic_vector(2 downto 0);
    count_error_wait : out std_logic_vector(DATA_WIDTH-1 downto 0);
    count_alltime    : out std_logic_vector(DATA_WIDTH-1 downto 0);
    count_shortterm  : out std_logic_vector(DATA_WIDTH-1 downto 0));
end entity CM_phy_lane_control;
architecture behavioral of CM_phy_lane_control is

  --- *** TIMING *** ---
  constant READ_TIME   : integer := CLKFREQ/100; --10ms
  signal   counter     : unsigned(4 downto 0);
  signal   timer_read  : integer range 0 to READ_TIME;
  signal   timer_error : integer range 0 to ERROR_WAIT_TIME;

  
  --- *** STATE_MACINE *** ---
  type state_t is (IDLE, WAITING, INITIALIZING, READING, LOCKED, ERROR_WAIT);
  signal state     : state_t;
  
  --- *** COUNTER *** ---
  signal event       : std_logic;
  signal event_error : std_logic;
  signal reset_c     : std_logic;
  
begin
-----------------------------------------------------------------------------------------
--  
--                                                            +-----------+
--                                                          |           |
--                                                          |  LOCKED   |
--                                    +-------------------->+  111      |
--                                    |    phylaneup = 1    +-------+---+
--                                    |                             |
--  ALL STATES                        |                             |
--       +                            |                             |phylaneup = 0
--       | enable = 0                 |                             |
--       v                            |      timer = 1ms            v
--   +---+----+             +---------+-+   phylaneup = 0   +-------+--------+
--   |        |             |           +------------------>+                |
--   |  IDLE  +------------>+   WAIT    |                   |  INITIALIZING  +-------+
--   |  000   | enable = 1  |   010     +<------------------+  001           |       |
--   +--------+             +-+--------++   COUNTER = 32    +-----------+----+       |
--                            ^        |                                ^            |
--                            |        |                                |            |
--                            +--------+                                +------------+
--                           Timer /= 1ms                                 COUNTER /= 32
--                         
-----------------------------------------------------------------------------------------
  
--process for managing state
  STATE_MACHINE: process (clk, reset) is
  begin
    if reset = '1' then --async reset
      state <= IDLE;
      state_out <= "000";
      event_error <= '0';
      
    elsif clk'event and clk='1' then --rising clk edge
      case state is
        when IDLE => --move to INITIALIZE on enable
          state_out <= "000";
          event_error <= '0';
          if enable = '1' then
            state <= WAITING;
          else
            state <= IDLE;
          end if;
        -----------------------------------------------------  
        when INITIALIZING => --move to WAITING after 32 clk's
          state_out <= "001";
          event_error <= '0';
          if enable = '0' then
            state <= IDLE;
          else
            if counter = "11111" then
              state <= WAITING;
            else
              state <= INITIALIZING;
            end if;
          end if;
        -----------------------------------------------------  
        when WAITING => --read phy_lane_up for 1ms
          state_out <= "010";
          event_error <= '0';
          if enable = '0' then
            state <= IDLE;
          else
            if phy_lane_up = '1' then
              state <= LOCKED;
            else
              if timer_read = READ_TIME then
                state <= INITIALIZING;
              else
                state <= WAITING;
              end if;
            end if;
          end if;
        -----------------------------------------------------  
        when LOCKED =>
          state_out <= "111";
          if enable = '0' then
            state <= IDLE;
            event_error <= '0';
          else
            if phy_lane_up = '0' then
              state <= ERROR_WAIT;
              event_error <= '1';
            else
              state <= LOCKED;
              event_error <= '0';
            end if;
          end if;
        -----------------------------------------------------
        when ERROR_WAIT =>
          state_out <= "110";
          event_error <= '0';
          if enable = '0' then
            state <= IDLE;
          else
            if phy_lane_up = '1' then
              --if timer_read = (READ_TIME/2) then
              state <= LOCKED;
              --end if;
            else
              if timer_error = ERROR_WAIT_TIME then
                state <= INITIALIZING;
              else
                state <= ERROR_WAIT;
              end if;
            end if;
          end if;
        -----------------------------------------------------
        when others => --reset
          event_error <= '0';
          state       <= IDLE;
          state_out   <= "000";
      end case;
    end if;
  end process STATE_MACHINE;

  --Process for managing timing
  TIMING: process (reset, clk) is
  begin
    if reset = '1' then --async reset
      counter      <= "00000";
      timer_read   <= 0;
      timer_error  <= 0;
      event        <= '0';
      
    elsif clk'event and clk='1' then --rising clk edge
      case state is
        when IDLE => --no counting
          counter     <= "00000";
          timer_read  <= 0;
          timer_error <= 0;
          event       <= '0';
          
        when INITIALIZING => --count 32 clk's
          if counter = "11111" then
            counter <= "00000";
            event   <= '1';
          else
            counter <= counter + 1;
            event   <= '0';
          end if;
          timer_read  <= 0;
          timer_error <= 0;
          
        when WAITING => --count to 1 ms
          counter <= "00000";
          if timer_read = READ_TIME then
            timer_read <= timer_read;
          else
            timer_read <= timer_read + 1;
          end if;
          --if phy_lane_up = '1' then
           -- if timer_error = (READ_TIME/2) then
             -- timer_error <= timer_error;
           -- else
            --  timer_error <= timer_error + 1;
           -- end if;
          --else
            --timer_error <= timer_error;
          --end if;
          timer_error <= 0;
          event       <= '0';
          
        when LOCKED => --no counting
          counter     <= "00000";
          timer_read  <= 0;
          event       <= '0';
          timer_error <= 0;

        when ERROR_WAIT =>
          counter    <= "00000";
          timer_read <= 0;
          event      <= '0';
          --if phy_lane_up = '1' then
          --  if timer_read = (READ_TIME/2) then
            --  timer_read <= timer_read;
           -- else
            --  timer_read <= timer_read + 1;
           -- end if;
         -- else
           -- timer_read <= timer_read;
          --end if;
          if timer_error = ERROR_WAIT_TIME then
            timer_error <= timer_error;
          else
            timer_error <= timer_error + 1;
          end if;
          
        when others => --reset 
          counter     <= "00000";
          timer_read  <= 0;
          timer_error <= 0;
          event       <= '0';
      end case;
    end if;
  end process TIMING;

  --Process for managing output signals
  CONTROL: process (reset, clk) is
  begin
    if reset = '1' then --async reset
      initialize_out <= '0';
      lock           <= '0';
      reset_c        <= '1';
      
    elsif clk'event and clk='1' then --rising clk edge
      case state is
        when IDLE => --initialize is passed through
          initialize_out <= '0';
          lock           <= '0';
          reset_c        <= '1';
          
        when INITIALIZING => --force initialize
          initialize_out <= '1';
          lock           <='0';
          reset_c        <= '0';
          
        when WAITING => --hold at 0
          initialize_out <= '0';
          lock           <= '0';
          reset_c        <= '0';
          
        when LOCKED => --set locked, hold initialize low
          initialize_out <= '0';
          lock           <= '1';
          reset_c        <= '1';

        when ERROR_WAIT =>
          initialize_out <= '0';
          lock           <= '1';
          reset_c        <= '1';
          
        when others => --reset
          initialize_out <= '0';
          lock           <= '0';
          reset_c        <= '0';
      end case;
    end if;
  end process CONTROL;

  --Counter for monitoring
  Count_short: entity work.counter
    generic map (
      roll_over   => '0',
      end_value   => x"FFFFFFFF",
      start_value => x"00000000",
      A_RST_CNT   => x"00000000",
      DATA_WIDTH  => DATA_WIDTH)
    port map (
      clk         => clk,
      reset_async => reset_counter,
      reset_sync  => reset_c,
      enable      => enable,
      event       => event,
      count       => count_shortterm,
      at_max      => open);
  Count_all: entity work.counter
    generic map (
      roll_over   => '0',
      end_value   => x"FFFFFFFF",
      start_value => x"00000000",
      A_RST_CNT   => x"00000000",
      DATA_WIDTH  => DATA_WIDTH)
    port map (
      clk         => clk,
      reset_async => reset_counter,
      reset_sync  => '0',
      enable      => enable,
      event       => event,
      count       => count_alltime,
      at_max      => open);
  Count_error: entity work.counter
    generic map (
      roll_over   => '0',
      end_value   => x"FFFFFFFF",
      start_value => x"00000000",
      A_RST_CNT   => x"00000000",
      DATA_WIDTH  => DATA_WIDTH)
    port map (
      clk         => clk,
      reset_async => reset_counter,
      reset_sync  => '0',
      enable      => enable,
      event       => event_error,
      count       => count_error_wait,
      at_max      => open);
end architecture behavioral;
