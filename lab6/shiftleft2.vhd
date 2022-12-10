library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;  

entity ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end ShiftLeft2;

architecture behavioral of ShiftLeft2 is
begin

y <=std_logic_vector (unsigned(x) SLL 2 );

end behavioral;
