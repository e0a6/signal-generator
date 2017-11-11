library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use ieee.numeric_std;

entity square_wave is
	port (
		clk:		in	std_logic;
		amp:		in	std_logic_vector(32-1 downto 0);
		frq:		in	std_logic_vector(32-1 downto 0);
		pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
	);
end entity square_wave;

architecture behav of square_wave is
-- 100 000 <= frq <= 100 000 000;
-- clk is 100Mhz
-- 100M / frq  =  period to wait for  (low and ) (Number of clk cycles to make one period of square wave) = period
-- 
-- 1 <= amp <= 1000;
-- 
	signal logicValue: std_logic;
	signal frq_half: std_logic_vector(32-1 downto 0);
begin
    frq_half <= "0" & frq(31 downto 1);
	
	process (clk)
		variable clkSeen:	std_logic_vector(32-1 downto 0) := (others => '0');
	begin
		if (rising_edge(clk)) then
			-- reset the number of clk seen
			if (clkSeen > frq) then
				clkSeen := (others => '0');
			end if;
			
			-- decide logical value
			if (clkSeen < (frq_half)) then
				logicValue <= '0';
			else
				logicValue <= '1';
			end if;

			clkSeen := clkSeen + 1;
		end if;
	end process;

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (logicValue = '1') then
				pwm_ctrl <= amp;
			else
				--pwm_ctrl <= (others => '0');
				pwm_ctrl <= x"00000001";
			end if;
		end if;
	end process;

end architecture behav;
