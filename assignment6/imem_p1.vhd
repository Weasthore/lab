library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IMEM is

generic(NUM_BYTES : integer := 64);
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData1 : out STD_LOGIC_VECTOR(31 downto 0)
);
end IMEM;

architecture behavioral of IMEM is
type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal imemBytes:ByteArray;
-- add and load has been updated
begin
process(Address)
variable addr:integer;
variable first:boolean:=true;
begin
   if(first) then
  	-- SUB   X11, X10, X9              
         ImemBytes(0) <= "11001011";       
         ImemBytes(1) <= "00010011";      
         ImemBytes(2) <= "00000010";       
         ImemBytes(3) <= "10010111";  
	-- CBZ   X23, 5        
         ImemBytes(4) <= "10110100";       
         ImemBytes(5) <= "00000000";      
         ImemBytes(6) <= "00000000";       
         ImemBytes(7) <= "10110111";  
    -- ADD   X10, X9, X9         
         ImemBytes(8) <= "10001011";       
         ImemBytes(9) <= "00001001";      
         ImemBytes(10) <= "00000001";       
        ImemBytes(11) <= "00101010";  
	-- SUB   X24, X22, X21         
         ImemBytes(12) <= "11001011";       
         ImemBytes(13) <= "00010101";      
         ImemBytes(14) <= "00000010";       
         ImemBytes(15) <= "11011000";  
	-- CBZ   X24, 3      
         ImemBytes(16) <= "10110100";       
         ImemBytes(17) <= "00000000";      
         ImemBytes(18) <= "00000000";       
         ImemBytes(19) <= "01111000";  
    -- ADD   X10, X10, X10 
         ImemBytes(20) <= "10001011";       
         ImemBytes(21) <= "00000000";      
         ImemBytes(22) <= "00000000";       
         ImemBytes(23) <= "00001011";  
    -- ADD   X10, X10, X10           
         ImemBytes(24) <= "00000000";       
         ImemBytes(25) <= "00000000";      
         ImemBytes(26) <= "00000000";       
         ImemBytes(27) <= "00000000";  	 
    -- ADD   X10, X10, X10           
         ImemBytes(28) <= "00000000";       
         ImemBytes(29) <= "00000000";      
         ImemBytes(30) <= "00000000";       
         ImemBytes(31) <= "00000000";    		
    -- B   2        
         ImemBytes(36) <= "10001011";       
         ImemBytes(37) <= "00010011";      
         ImemBytes(38) <= "00000010";       
         ImemBytes(39) <= "01110011";    
    -- nop            
         ImemBytes(40) <= "00000000";       
         ImemBytes(41) <= "00000000";      
         ImemBytes(42) <= "00000000";       
         ImemBytes(43) <= "00000000";    
	-- nop            
         ImemBytes(44) <= "00000000";       
         ImemBytes(45) <= "00000000";      
         ImemBytes(46) <= "00000000";       
         ImemBytes(47) <= "00000000";    
	-- nop            
         ImemBytes(48) <= "00000000";       
         ImemBytes(49) <= "00000000";      
         ImemBytes(50) <= "00000000";       
         ImemBytes(51) <= "00000000";    
	-- nop            
         ImemBytes(52) <= "00000000";       
         ImemBytes(53) <= "00000000";      
         ImemBytes(54) <= "00000000";       
         ImemBytes(55) <= "00000000";    
    -- nop            
         ImemBytes(56) <= "00000000";       
         ImemBytes(57) <= "00000000";      
         ImemBytes(58) <= "00000000";       
         ImemBytes(59) <= "00000000";  
		 
      first:=false;
 end if;
   addr:=to_integer(unsigned(Address));
   if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
      ReadData1<=imemBytes(addr) & imemBytes(addr+1) & imemBytes(addr+2) & imemBytes(addr+3);
   else report "Invalid IMEM addr. Attempted to read 4-bytes starting at address " &
      integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
      severity error;
   end if;

end process;

end behavioral;
