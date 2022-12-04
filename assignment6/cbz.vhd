library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity cbz is

port(
     in0    : in std_logic_vector(63 downto 0);
	 iscbz  : in STD_LOGIC; 
     iscontrol  : in STD_LOGIC;  

     output : out STD_LOGIC
);
end cbz;

architecture behavioral of cbz is
begin
process(in0,iscontrol)
begin
output <='0';
if(iscbz='1'and iscontrol='1')then
if(in0="0000000000000000000000000000000000000000000000000000000000000000") then
output <='1';
else
output <='0';
end if;
end if;
end process;
end behavioral;

