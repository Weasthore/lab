library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftLeft2UBranch is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : in  STD_LOGIC_VECTOR(3  downto 0);
     z : out STD_LOGIC_VECTOR(63 downto 0)
);
end ShiftLeft2UBranch;

architecture df of ShiftLeft2UBranch is
begin
process(x,y) begin
if(x(31 downto 26)="000101") then --b
  z(63 downto 60) <= y;
  z(59 downto 26) <=(others=>'0');
  z(25 downto 0) <= x(25 downto 0);
end if;
end process;
end df;
