library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC_VECTOR(63 downto 0);
      output : out STD_LOGIC; -- in0 and in1
      debug_equal: out STD_LOGIC
);
end AND2;

architecture behavioral of AND2 is

begin 
process(in0, in1)
begin
if (in1="0000000000000000000000000000000000000000000000000000000000000000") then
     output<= in0 ; 
	debug_equal<='1';
else
	output <= '0';
	debug_equal<='0';
end if;
end process;
     
end behavioral; 