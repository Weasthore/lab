library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.ALL; 

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'ARM Reference Data' sheet at the
--    front of the textbook (or the Green Card pdf on Canvas).
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end ALU;


architecture ALU_example of ALU is

signal temp : STD_LOGIC_VECTOR(64 downto 0);
begin
	process(in0, in1, operation)
	begin
		case(operation) is
			when "0000" => -- and
				result <= in0 and in1;
				temp(64) <= '0';
				temp(63)<= '0';
			when "0001" => -- or
				result <= in0 or in1 ;
				temp(64) <= '0';
				temp(63)<= '0';
			when "0010" => -- add
				result <= std_logic_vector(signed(in0) + signed(in1));
				temp <= ('0'&in0) + ('0'&in1);
			when "0110" => 
				result <= std_logic_vector(signed(in0) - signed(in1));
				temp <= ('0'&in0) - ('0'&in1);
			
			when others =>
				result <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				temp(64) <= '0';
				temp(63)<= '0';
		end case;
	overflow <= temp(64) xor temp(63);
	if (result=X"0000000000000000") then
		zero <='1';
	else
		zero <='0';
	end if;
	end process;
end ALU_example;

