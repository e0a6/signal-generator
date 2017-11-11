library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sig_generator is
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
        TR: in std_logic;
        SI: in std_logic
    );
end entity sig_generator;


architecture behav of sig_generator is
    -- SIGNALS
    signal frq: std_logic_vector(32-1 downto 0);
    signal amp: std_logic_vector(32-1 downto 0);
    signal Hz: std_logic;
    
    signal square_pwm: std_logic_vector(32-1 downto 0);
    signal saw_tooth_pwm: std_logic_vector(32-1 downto 0);
    signal triangle_pwm: std_logic_vector(32-1 downto 0);
    signal sin_pwm: std_logic_vector(32-1 downto 0);

	signal pwm_in_singal: std_logic_vector(32-1 downto 0);    

    -- COMPONENTS
    component clock_divider
    	port (
			clk:				in 	STD_LOGIC;
			reset:				in 	STD_LOGIC;
			enable:				in 	STD_LOGIC;
			kHz:				out	STD_LOGIC;
			seconds_port:		out	STD_LOGIC_VECTOR(4-1 downto 0);
			ten_seconds_port:	out	STD_LOGIC_VECTOR(3-1 downto 0);
			minutes_port:		out	STD_LOGIC_VECTOR(4-1 downto 0);
			ten_minutes_port:	out	STD_LOGIC_VECTOR(3-1 downto 0);
			twentyfive_MHz:		out	STD_LOGIC;
			hHz:				out	STD_LOGIC
    	);
    end component clock_divider;
    component up_down_counter
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
    end component up_down_counter;
    component square_wave
		port (
			clk:		in	std_logic;
			amp:		in	std_logic_vector(32-1 downto 0);
			frq:		in	std_logic_vector(32-1 downto 0);
			pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
		);
    end component square_wave;
    component saw_tooth
		port (
			clk:		in	std_logic;
			amp:		in	std_logic_vector(32-1 downto 0);
			frq:		in	std_logic_vector(32-1 downto 0);
			pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
		);
    end component saw_tooth;
    component triangle
    	port (
			clk:		in	std_logic;
			amp:		in	std_logic_vector(32-1 downto 0);
			frq:		in	std_logic_vector(32-1 downto 0);
			pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
		);
    end component triangle;
    component sin
    	port (
			clk:		in	std_logic;
			amp:		in	std_logic_vector(32-1 downto 0);
			frq:		in	std_logic_vector(32-1 downto 0);
			pwm_ctrl:	out	std_logic_vector(32-1 downto 0)
    	);
    end component sin;
    component PWM
		generic (
			quantas:  integer := 1000                     -- period(i_CLK)*quantas = period(o_PWM)
		);
		port (
			i_CLK:  in  std_logic;                        -- Main input clock signal
			i_PWM:  in  std_logic_vector(31 downto 0);    -- [(i_PWM / quantas) * period(o_PWM)] / [ quantas * period(i_CLK) ]  = duty cycle
			o_PWM:  out std_logic := '1'                  --The Pulse Width Modulated output signal
		);
    end component PWM;

begin
	CLK_GENTOR: clock_divider port map (clk, reset, '1', open, open, open, open, open, open, Hz);
    FRQ_HOLDER: up_down_counter generic map(32, 100000000, 100000) port map (frq_i, frq_d, clk, reset, '1', frq);
    AMP_HOLDER: up_down_counter generic map(32, 100, 1) port map (amp_i, amp_d, Hz, reset, '1', amp);

    SQUARE_WAV:	square_wave port map (clk, amp, frq, square_pwm);
    SAW_TOOTH_WAV: saw_tooth port map (clk, amp, frq, saw_tooth_pwm);
    TRIANGLE_WAV: triangle port map (clk, amp, frq, triangle_pwm);
    SIN_WAV: sin port map (clk, amp, frq, sin_pwm);
    	-- if (logicalVal = 1)
    	-- 		square_pwm = amp
    	-- else
    	--		square_pwm = 1
    --PWM_GENTOR: PWM generic map (100) port map (clk, square_pwm, sig_o);			-- 1 cycle of PWM happens in 100*perid(clk) = 1000ns



    PWM_GENTOR: PWM generic map (100) port map (clk, pwm_in_singal, sig_o);			-- 1 cycle of PWM happens in 100*perid(clk) = 1000ns
    	-- loop every (100*perid(clk) = 1000ns)
    	-- 		sig = 1 for square_pwm * 10ns
    	-- 		sig = 0 for ( (100*perid(clk) = 1000ns) - (square_pwm * 10ns) )

    --sig_o <= '1';

    process(clk)
	begin
		if ((SQ = '1') and (SW = '0') and (TR = '0') and (SI = '0')) then
			pwm_in_singal <= square_pwm;
		end if;
		if ((SQ = '0') and (SW = '1') and (TR = '0') and (SI = '0')) then
			pwm_in_singal <= saw_tooth_pwm;
		end if;
		if ((SQ = '0') and (SW = '0') and (TR = '1') and (SI = '0')) then
			pwm_in_singal <= triangle_pwm;
		end if;
		if ((SQ = '0') and (SW = '0') and (TR = '0') and (SI = '1')) then
			pwm_in_singal <= sin_pwm;
		end if;
	end process;

end architecture behav;
