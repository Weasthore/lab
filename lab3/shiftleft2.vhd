library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end ShiftLeft2;

architecture behv5 of ShiftLeft2 is

begin
	
	y <= std_logic_vector(unsigned(x) sll 2);

end behv5;