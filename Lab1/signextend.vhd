library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture behv4 of SignExtend is
	
begin 
	y <= std_logic_vector(resize(signed(x),y'length));
end behv4;
	 