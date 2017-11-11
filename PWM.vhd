library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity PWM is
  generic (
    quantas:  integer := 1000                     -- period(i_CLK)*quantas = period(o_PWM)
  );
  port (
    i_CLK:  in  std_logic;                        -- Main input clock signal
    i_PWM:  in  std_logic_vector(31 downto 0);    -- [(i_PWM / quantas) * period(o_PWM)] / [ quantas * period(i_CLK) ]  = duty cycle
    o_PWM:  out std_logic := '1'                  --The Pulse Width Modulated output signal
  );
end PWM;

architecture PWM_arch of PWM is
  signal  PWM_acc : std_logic_vector(31 downto 0) := x"00000000"; 
begin
  
--ACCUMULATOR PROCESS
--Generates the accumlation variable PWM_acc
--This variable is used in the PWM as a means to determine
--when the PWM signal should switch.
  accumulate: process(i_CLK)
  begin
    if falling_edge(i_CLK) then
      if PWM_acc >= std_logic_vector(to_unsigned(quantas - 1, PWM_acc'length)) then
        PWM_acc <= x"00000000";
      else
        PWM_acc  <=  PWM_acc + 1;
      end if;
    end if;
  end process;
  
--PWM PROCESS
--Generates the PWM output signal, o_PWM
--i_PWM controls the output and specifies how many Time Quantas
--out of a Total Quanta the output must be set HIGH
  modulate: process(i_CLK, i_PWM)
  begin
    if rising_edge(i_CLK) then
      if PWM_acc >= i_PWM then
        o_PWM <= '0';
      elsif PWM_acc = x"00000000" then
        o_PWM <= '1';
      end if;
    end if;
  end process;
end PWM_arch;
