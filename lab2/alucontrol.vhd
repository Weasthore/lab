library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- Check table on page2 of Green Card.pdf on canvas. Pay attention to opcode of operations and type of operations. 
-- If an operation doesn't use ALU, you don't need to check for its case in the ALU control implemenetation.	
--  To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALUControl;

architecture BehvALUC of ALUControl is

begin
	process(ALUOp)
	begin
	case ALUOp is
		when "00" => Operation <= "0010";
		when "01" => Operation <= "0111";
		when "1X" =>
			case Opcode is
				when "10001011000" => Operation <= "0010";
				when "11001011000" => Operation <= "0110";
				when "10001010000" => Operation <= "0000";
				when "10101010000" => Operation <= "0001";
				when others => Operation <= "1111";
			end case;
		when others =>	 Operation <= "1111";
	end case;
	end process;
end BehvALUC;
