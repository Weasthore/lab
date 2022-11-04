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
      -- ADD X11, X9, X10           
         ImemBytes(0) <= "10001011";       
         ImemBytes(1) <= "00001010";      
         ImemBytes(2) <= "00000001";       
         ImemBytes(3) <= "00101011";  
	-- STUR  X11, [XZR,0]         
         ImemBytes(4) <= "11111000";       
         ImemBytes(5) <= "00000000";      
         ImemBytes(6) <= "00000000";       
         ImemBytes(7) <= "00001011";  
    -- SUB X12, X9, X10         
         ImemBytes(8) <= "11001011";       
         ImemBytes(9) <= "00001010";      
         ImemBytes(10) <= "00000001";       
        ImemBytes(11) <= "00101100";  
	-- STUR X11, [XZR,0]         
         ImemBytes(12) <= "11111000";       
         ImemBytes(13) <= "00000000";      
         ImemBytes(14) <= "00000000";       
         ImemBytes(15) <= "00001011";  
    -- STUR X12, [X12,8]          
         ImemBytes(16) <= "11111000";       
         ImemBytes(17) <= "00000000";      
         ImemBytes(18) <= "00100001";       
         ImemBytes(19) <= "10001100";  
    -- ORR X21, X19, X20    
         ImemBytes(20) <= "01000100";       
         ImemBytes(21) <= "11010100";      
         ImemBytes(22) <= "00000010";       
         ImemBytes(23) <= "01110101";  
    -- nop            
         ImemBytes(24) <= "00000000";       
         ImemBytes(25) <= "00000000";      
         ImemBytes(26) <= "00000000";       
         ImemBytes(27) <= "00000000";  	 
    -- nop            
         ImemBytes(28) <= "00000000";       
         ImemBytes(29) <= "00000000";      
         ImemBytes(30) <= "00000000";       
         ImemBytes(31) <= "00000000";    		
	 -- STUR X21, [XZR,16]          
         ImemBytes(32) <= "11111000";       
         ImemBytes(33) <= "00000000";      
         ImemBytes(34) <= "01000000";       
         ImemBytes(35) <= "00010101";  
    -- nop            
         ImemBytes(36) <= "00000000";       
         ImemBytes(37) <= "00000000";      
         ImemBytes(38) <= "00000000";       
         ImemBytes(39) <= "00000000";    
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
