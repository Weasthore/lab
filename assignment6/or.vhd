library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  


entity ORgate is

port(
     in0    : in  STD_LOGIC;
     in1    : in  STD_LOGIC;
     output : out STD_LOGIC
);
end ORgate;

architecture behavioral of ORgate is
begin

output <=(in0 or in1);

end behavioral;

