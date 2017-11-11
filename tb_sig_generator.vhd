library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_sig_generator is
	
end entity tb_sig_generator;


architecture behav of tb_sig_generator is
	signal clk: std_logic;
	signal Z: std_logic;

	component sig_generator
		port (
	        clk: in std_logic;
	        reset: in std_logic;
	        amp_i: in std_logic;
	        amp_d: in std_logic;
	        frq_i: in std_logic;
	        frq_d: in std_logic;
	        sig_o: out std_logic;

	        SQ: in std_logic;
	        SW: in std_logic;
	        TR: in std_logic
		);
	end component sig_generator;
begin
	SG0: sig_generator port map (clk, '0', '0', '0', '0', '0', Z, '0', '0', '0');

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
