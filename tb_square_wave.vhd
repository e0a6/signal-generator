library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_square_wave is

end entity tb_square_wave;

architecture behav of tb_square_wave is
	signal amp : std_logic_vector(32-1 downto 0) := x"000000FF"; 				-- logicalVale = 1, OO = amp
	signal frq : std_logic_vector(32-1 downto 0) := x"00002710"; 				-- frquency of of the logicalValue


	--	x"00002710"  == 10 000
	--	Seeing 10000 cycle of 10ns takes 100000ns -> 10KHz
	--	x"00989680"  == 10 000 000
	--  Seeing 10 000 000 cycles of 10ns takes 100 000 000ns  ->  10 Hz
	--	x"05F5E100"  == 100 000 000
	--  Seeing 100 000 000 cycles of 10ns takes 1 000 000 000ns  ->  1 Hz

	-- Sginals
	signal OO: std_logic_vector(32-1 downto 0);
	signal logic: std_logic;
	signal clk: std_logic;


	component square_wave
		port (
			clk:		in	std_logic;
			amp:		in	std_logic_vector(32-1 downto 0);
			frq:		in	std_logic_vector(32-1 downto 0);
			pwm_ctrl:	out	std_logic_vector(32-1 downto 0);
			logicVal_o: out std_logic
		);
	end component square_wave;

begin

	UUT: square_wave port map (clk, amp, frq, OO, logic);

	process
	begin
		wait for 75000ns;
		amp <= x"000001FF";
		wait for 10000ns;
		amp <= x"0000000F";
	end process;

	process
	begin
		wait for 750000ns;
		frq <= x"00004E20";
		wait;
	end process;


	-- Clock process definitions
	process
		variable clk_period : time := 10ns;
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

end architecture behav;
