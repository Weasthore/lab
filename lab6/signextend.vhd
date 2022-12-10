library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtend is
port(
	x : in STD_LOGIC_VECTOR(31 downto 0);
	y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture SignExtend_example of SignExtend is

begin
	process(x)
	begin
		if (x(31)='1' AND x(28 downto 26)="100" AND x(23 downto 22)="00") then 
			y(63 downto 12) <= X"0000000000000";
			y(11 downto 0)<= x(21 downto 10);
		
		elsif (x(31 downto 26)="000101") then --branch
 			y(63 downto 26) <=(others=>'0');
  			y(25 downto 0) <= x(25 downto 0);
		elsif (x(31 downto 21)="11111000010" or x(31 downto 21)="11111000000") then 
			y(63 downto 9) <="0000000000000000000000000000000000000000000000000000000";
			y(8 downto 0) <=x(20 downto 12);
		elsif (x(31 downto 25)="1011010") then --c
  			y(63 downto 19)<=(others=>'0');
  			y(18 downto 0) <= x(23 downto 5);
		else
			y(31 downto 0) <= x;
			y(63 downto 32) <=X"00000000";
		end if;
	end process;

end SignExtend_example;
