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
process(x)
 	begin
	if (x(31 downto 22) = "1001000100" or x(31 downto 22) = "1001001000") then -- I-type 
  		y(63 downto 12) <= (others=>'0');
  		y(11 downto 0) <= x(21 downto 10);
	elsif (x(31 downto 22) = "1011001000" or x(31 downto 22) = "1101000100") then
		y(63 downto 12) <= (others=>'0');
  		y(11 downto 0) <= x(21 downto 10);
  		-- did not think of sign of plus/minus
     	elsif (x(31 downto 26) = "000101") then --b
  		y(63 downto 26) <= (others=>'0');
 		y(25 downto 0) <= x(25 downto 0);
 	elsif (x(31 downto 24) = "10110100" or x(31 downto 24) = "10110101") then --cb
  		y(63 downto 19) <= (others=>'0');
  		y(18 downto 0) <=x (23 downto 5);
 	elsif (x(31 downto 21) = "10111100000" or x(31 downto 21)="10111100010") then --load and store
  		y(63 downto 9) <=(others=>'0');
  		y(8 downto 0) <= x(20 downto 12);
 	else 
  		y(63 downto 0) <= (others =>'0');
 	end if;
	end process;
end behv4;
	 