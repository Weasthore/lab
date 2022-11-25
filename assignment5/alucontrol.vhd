library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is    
port(
     ALUOp1     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opecode    : in   STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end ALUControl;

ARCHITECTURE behavioral of ALUControl is
BEGIN
process(ALUOp1,Opecode)
begin
if(ALUOp1 = "00") then 
      Operation(3 downto 0) <= "0010";
    elsif(ALUOp1 = "01") then 
      Operation(3 downto 0) <= "0111";
    elsif(ALUOp1 = "11" or ALUOp1 = "10") then
       if(Opecode(9)='1') then Operation(3 downto 0) <= "0110";
       elsif(Opecode(8)='1') then Operation(3 downto 0) <= "0001";
       elsif(Opecode(3)='0') then Operation(3 downto 0) <= "0000";
       elsif(Opecode(3)='1') then Operation(3 downto 0) <= "0010";
       end if;  
    end if;
end process;
end behavioral;

