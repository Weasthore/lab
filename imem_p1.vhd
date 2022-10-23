library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IMEM is
-- The instruction memory is a byte addressable, big-endian, read-only memory
-- Reads occur continuously
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
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
      -- ADDI X9, X9, 1           
         ImemBytes(0) <= "10010001";       
         ImemBytes(1) <= "00000000";      
         ImemBytes(2) <= "00000101";       
         ImemBytes(3) <= "00101001";  
	-- ADD X10, X9, X11           
         ImemBytes(4) <= "10001011";       
         ImemBytes(5) <= "00001011";      
         ImemBytes(6) <= "00000001";       
         ImemBytes(7) <= "00101010";  
    -- STUR X10, X9, 0           
         ImemBytes(8) <= "11111000";       
         ImemBytes(9) <= "00000000";      
         ImemBytes(10) <= "00000001";       
        ImemBytes(11) <= "00101010";  
	-- LDUR X10, X11, 0           
         ImemBytes(12) <= "11111000";       
         ImemBytes(13) <= "01000000";      
         ImemBytes(14) <= "00000001";       
         ImemBytes(15) <= "01101010";  
    -- CBZ X9, 4           
         ImemBytes(16) <= "10110100";       
         ImemBytes(17) <= "00000000";      
         ImemBytes(18) <= "00000000";       
         ImemBytes(19) <= "10001001";  
    -- b 2           
         ImemBytes(20) <= "00010100";       
         ImemBytes(21) <= "00000000";      
         ImemBytes(22) <= "00000000";       
         ImemBytes(23) <= "00000010";  
    -- ADD X10, X9, X11           
         ImemBytes(24) <= "10001011";       
         ImemBytes(25) <= "00001011";      
         ImemBytes(26) <= "00000001";       
         ImemBytes(27) <= "01001001";  	 
    -- CBZ X21, 2           
         ImemBytes(28) <= "10110100";       
         ImemBytes(29) <= "00000000";      
         ImemBytes(30) <= "00000000";       
         ImemBytes(31) <= "01010101";    		
	 -- ADDI X9, X9, 1           
         ImemBytes(32) <= "10010001";       
         ImemBytes(33) <= "00000000";      
         ImemBytes(34) <= "00000101";       
         ImemBytes(35) <= "00101001";  
    -- ADD X21, X10, X9           
         ImemBytes(36) <= "10001011";       
         ImemBytes(37) <= "00001001";      
         ImemBytes(38) <= "00000001";       
         ImemBytes(39) <= "01010101";  	 
	

		 
      first:=false;
 end if;
   addr:=to_integer(unsigned(Address));
   if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
      ReadData<=imemBytes(addr) & imemBytes(addr+1) & imemBytes(addr+2) & imemBytes(addr+3);
   else report "Invalid IMEM addr. Attempted to read 4-bytes starting at address " &
      integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
      severity error;
   end if;

end process;

end behavioral;
