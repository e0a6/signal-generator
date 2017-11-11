library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity tb_PWM is
	
end entity tb_PWM;

architecture behav of tb_PWM is
	-- signals
	signal o_PWM: std_logic;
	signal clk: std_logic;

	-- declare PWM component
	component PWM
		generic (
			quantas:  integer := 8
		);
		port (
			i_CLK: in  std_logic;
			i_PWM: in  std_logic_vector(31 downto 0);
			o_PWM: out std_logic
		);
	end component PWM;

begin
	-- instantiate a PWM
	myPWM: PWM generic map(10) port map (clk, x"00000001", o_PWM);

	
	-- simulatory clock process
    process
		variable clk_period : time := 10ns;
    begin
         clk <= '0';
         wait for clk_period/2;  --for 0.5 ms signal is '0'.
         clk <= '1';
         wait for clk_period/2;  --for next 0.5 ms signal is '1'.
    end process;

end architecture behav;
