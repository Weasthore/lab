library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX64 is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end MUX64;

architecture behavioral of MUX64 is
begin

process(in0,in1,sel) begin
  if(sel = '1') then 
    output(63 downto 0) <= in1(63 downto 0); else
    output(63 downto 0) <= in0(63 downto 0);
    end if;
  end process;
end behavioral; 
