library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR2 is
port (
in0 : in STD_LOGIC;
in1 : in STD_LOGIC;
output : out STD_LOGIC 
);
end OR2;

architecture structure of OR2 is 
begin 
    output <= in0 or in1; 
end structure;