library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

-- operation: ainvert, binvert, ALUop
-- 0000 -> AND
-- 0001 -> OR
-- 0010 -> ADD
-- 0011 -> ?
-- 0100 -> ?
-- 0101 -> ?
-- 0110 -> SUB
-- 0111 -> SLT (not used)

-- ALUop 00->AND, 01->OR, 10->ADD, 11->SLT

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'MIPS Reference Data' sheet at the
--    front of the textbook.
port(
     a         : in     STD_LOGIC_VECTOR(63 downto 0);
     b         : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC;
     temp1     : buffer STD_LOGIC_VECTOR(63 downto 0);
     temp2     : buffer STD_LOGIC_VECTOR(63 downto 0)
);
end ALU;


ARCHITECTURE behavioral of ALU is
BEGIN
process(operation,a,b)
begin
    zero<='0';
	if(operation="0000")then
	result<=(a and b);
	elsif(operation="0001")then
	result<=(a OR b);
    elsif(operation="0111")then
      if(b="0000000000000000000000000000000000000000000000000000000000000000")then
	  result<=b;
      zero<='1';
	  end if;
	elsif(operation="0010")then
   -- temp1(63 downto 0)<=(others=>'0');
	--temp2(63 downto 0)<=(others=>'0');
	--temp1(62 downto 0)<=a(62 downto 0);
	--temp2(62 downto 0)<=b(62 downto 0);
--	result<=(temp1+temp2);
	--  if(result(63)='1') then
	--     overflow<='1';
	--  else
	     result<=(a+b);
	--  end if;
	elsif(operation="0110")then
--	temp1(63 downto 0)<=(others=>'0');
--	temp2(63 downto 0)<=(others=>'0');
--	temp1(62 downto 0)<=a(62 downto 0);
--	temp2(62 downto 0)<=b(62 downto 0);
--	result<=(temp1+temp2);
--	  if(result(63)='1') then
--	     overflow<='1';
--	  else
	    result<=(a-b);

	--  end if;

      
	end if;
end process;
end behavioral;

