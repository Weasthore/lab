library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- You only need to consider the cases where ALUOp = "00", "01", and "10". ALUOp = "11" is not
--    a valid input and need not be considered; its output can be anything, including "0110",
--    "0010", "XXXX", etc.
-- To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
-- Check Figure 4.4.1 COD 4.12        
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opecode    : in   STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end ALUControl;

ARCHITECTURE behavioral of ALUControl is
BEGIN
process(ALUOp,Opecode)
begin
if(ALUOp = "00") then 
      Operation(3 downto 0) <= "0010";
    elsif(ALUOp = "01") then 
      Operation(3 downto 0) <= "0111";
    elsif(ALUOp = "11" or ALUOp = "10") then
       if(Opecode(9)='1') then Operation(3 downto 0) <= "0110";
       elsif(Opecode(8)='1') then Operation(3 downto 0) <= "0001";
       elsif(Opecode(3)='0') then Operation(3 downto 0) <= "0000";
       elsif(Opecode(3)='1') then Operation(3 downto 0) <= "0010";
       end if;  
    end if;
end process;
end behavioral;

