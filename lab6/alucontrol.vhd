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

architecture Behv of ALUControl is

begin
	process(ALUOp, Opcode)
	begin
	if(ALUOp = "01") then 
    	 	Operation(3 downto 0) <= "0111";
	elsif(ALUOp = "00") then 
      		Operation(3 downto 0) <= "0010";
   
    	elsif(ALUOp = "11" or ALUOp = "10") then
       	if(Opcode(9)='1') then 
	Operation(3 downto 0) <= "0110";
	elsif(Opcode(8)='1') 
	then Operation(3 downto 0) <= "0001";
	elsif(Opcode(3)='1') 
	then Operation(3 downto 0) <= "0010";
 
       	elsif(Opcode(3)='0') 
	then Operation(3 downto 0) <= "0000";
       
      	end if;  
    	end if;
	end process;
end Behv;
