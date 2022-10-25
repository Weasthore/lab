library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
entity IMEM is
-- The instruction memory is a byte addressable, little-endian, read-only memory
-- Reads occur continuously
-- HINT: Use the provided dmem.vhd as a starting point
generic(NUM_BYTES : integer := 128);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end IMEM;

architecture BehvIMEM of IMEM is


type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal imemBytes:ByteArray;

begin
	process(Address)
	variable first : boolean:= true;
	variable addr : integer;
	begin
		if (first) then
		-- Example: MEM(0x0) = 0x0000000000000001 (Hex) 
			imemBytes(11) <= "00010001";
			imemBytes(12) <= "00100010";
			imemBytes(13) <= "00110011";
			imemBytes(14) <= "01000100";
			imemBytes(16) <= "10011001";
			imemBytes(17) <= "10001000";
			imemBytes(18) <= "01110111";
			imemBytes(19) <= "01010101";
			first := false;
		end if;
	
		addr := to_integer(unsigned(Address)); 
		if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
        	   ReadData <= imemBytes(addr+3) & imemBytes(addr+2) & imemBytes(addr+1) & imemBytes(addr);
		else report "error." severity error;
		end if;
	end process;
end BehvIMEM;





