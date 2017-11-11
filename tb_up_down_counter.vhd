library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_up_down_counter is
end tb_up_down_counter;

architecture behavior of tb_up_down_counter is

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT up_down_counter
        Generic (
          WIDTH: integer:= 32;
          maxVal: in integer:= 100000;
          minVal: in integer:=1
        );
        Port (
          up: in STD_LOGIC;
          down: in STD_LOGIC;
          clk: in std_logic;
          reset: in std_logic;
          enable: in std_logic;
          val: out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
        );
    END COMPONENT;
    
    --Constants
    constant maxVal : integer := 1000; 
    constant minVal : integer := 1; 
    --Inputs
    signal clk: std_logic;
    signal reset: std_logic;
    signal enable: std_logic;
    signal up: std_logic := '0';
    signal down: std_logic := '0';
    
  --Outputs
    signal val: STD_LOGIC_VECTOR(32-1 downto 0);
    
   -- Clock period definitions
   constant clk_period : time := 10ns;
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
   uut: up_down_counter
        generic map (
            32, 100000000, 1
        )
        PORT MAP (
          up => up,
          down => down,
          clk => clk,
          reset => reset,
          enable => enable,
          val => val                       
        );

   -- Clock process 
   ClockProcess :process
   begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
   end process;

  -- Enable process
  EnableProcess :process
  begin
       enable <= '1';
       wait for clk_period*3;
       enable <= '1';
       wait for clk_period*6;
  end process;
  
   -- Stimulus process
   StimulusProcess: process
   begin   
      reset <= '0';
      up <= '1';
      wait;
      up <= '1';
      reset <= '0';
      wait for 5000 ns;
      up <= '0';
      down <= '1';
      wait for 2500 ns;
      up <= '1';
      down <= '0';
      wait for 10000 ns;
      up <= '0';
      down <= '1';
      wait for 109000 ns;
      up <= '0';
      down <= '0';
      reset <= '1';
      wait for 100 ns;
   end process;

END;