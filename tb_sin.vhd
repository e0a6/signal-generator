library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sin is
--  Port ( );
end tb_sin;

architecture Behavioral of tb_sin is
	signal amp : std_logic_vector(32-1 downto 0) := x"000000FF"; 				-- logicalVale = 1, OO = amp
	signal frq : std_logic_vector(32-1 downto 0) := x"00030D40"; 				-- frquency of of the logicalValue
	signal pwm_Val : std_logic_vector(32-1 downto 0) := x"00002710"; 				-- frquency of of the logicalValue

	signal clk: std_logic;
	--	x"00002710"  == 10 000
	--	Seeing 10000 cycle of 10ns takes 100000ns -> 10KHz
	--	x"00989680"  == 10 000 000
	--  Seeing 10 000 000 cycles of 10ns takes 100 000 000ns  ->  10 Hz
	--	x"05F5E100"  == 100 000 000
	--  Seeing 100 000 000 cycles of 10ns takes 1 000 000 000ns  ->  1 Hz

	component sin
		port (
			clk:		in	std_logic;
			amp:		in	std_logic_vector(32-1 downto 0);
			frq:		in	std_logic_vector(32-1 downto 0);
			pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
		);
	end component sin;

begin

	UUT: sin port map (clk, amp, frq, pwm_Val);

	-- Clock process definitions

	process
		variable clk_period : time := 10ns;
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

end Behavioral;
