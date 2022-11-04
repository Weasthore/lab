
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registers is
generic(NUM_BYTES : integer := 32);
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (63 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (63 downto 0);
     RD2      : out STD_LOGIC_VECTOR (63 downto 0);
	 test9      : buffer STD_LOGIC_VECTOR (63 downto 0);--
	 test10      : buffer STD_LOGIC_VECTOR (63 downto 0);--
     test11      : buffer STD_LOGIC_VECTOR (63 downto 0);--
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end registers;

ARCHITECTURE behavioral of registers IS
type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(63 downto 0);   
signal registersByte:ByteArray;
begin
process(Clock,WR,RegWrite,WD,RR2,RR1,registersByte) --
variable in_addr1:integer;
variable in_addr2:integer;
variable write_addr:integer;
variable first:boolean := true; 
begin
  if(first) then
        registersByte(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
        registersByte(9) <= "0000000000000000000000000000000000000000000000000000000000010000";
        registersByte(10)<= "0000000000000000000000000000000000000000000000000000000000001000";
        registersByte(11)<= "0000000000000000000000000000000000000000000000000000000000000010";  
        registersByte(12)<= "0000000000000000000000000000000000000000000000000000000000001000";  
        registersByte(19)<= "0000000000000000000000000000000011001110101001000001001001101100";  
		registersByte(20)<= "0000000000000000000000000000000000010000000010011010110010000011";  
        registersByte(21)<= "0000000000000000000000000000000000000000000000000000000000000000";  
        registersByte(22)<= "0000000000000000000000000000000000000000000000000000000000000000";  

        first := false; 
end if;


in_addr1:=to_integer(unsigned(RR1));
in_addr2:=to_integer(unsigned(RR2));
write_addr:=to_integer(unsigned(WR));

if (in_addr1 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
      RD1<=registersByte(in_addr1);
	 
else report "Invalid Registers addr. Attempted to read 4-bytes starting at address "
      severity error;
end if;

if (in_addr2 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
      RD2<=registersByte(in_addr2);

else report "Invalid Registers addr. Attempted to read 4-bytes starting at address "
      severity error;
end if;

if (RegWrite = '1') then 
      registersByte(write_addr)<=WD;
       test9<= registersByte(9);
	   test10<=registersByte(10);   
       test11<=registersByte(11);	

end if;
end process;

end behavioral;
