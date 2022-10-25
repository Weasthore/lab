library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtend is
port(
     a : in  STD_LOGIC_VECTOR(3 downto 0);  --original pc leftmost 4 bits 
     x : in  STD_LOGIC_VECTOR(31 downto 0);
	 z : out STD_LOGIC_VECTOR(63 downto 0); -- sign-extend(x)
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture behavioral of SignExtend is
begin
process(x) begin
if(x(31 downto 21)="10010001000" or x(31 downto 21)="11010001000") then--i
  y(63 downto 12)<=(others=>'0');
  y(11 downto 0) <= x(21 downto 10);
elsif(x(31 downto 26)="000101") then --b
  y(63 downto 60) <= a;
  y(59 downto 26) <=(others=>'0');
  y(25 downto 0) <= x(25 downto 0);
elsif(x(31 downto 24)="10110100") then --cb
  y(63 downto 19)<=(others=>'0');
  y(18 downto 0) <= x(23 downto 5);
elsif(x(31 downto 21)="11111000010" or x(31 downto 21)="11111000000") then --l and s
  y(63 downto 9)<=(others=>'0');
  y(8 downto 0) <= x(20 downto 12);
  else 
   y(63 downto 0)<=(others=>'0');
end if;
end process;
end behavioral; 

