library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end AND2;

architecture behavioral of AND2 is

begin 
     output<= in0 and in1; 
     
end behavioral; 