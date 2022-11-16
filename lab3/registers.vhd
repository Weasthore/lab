library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
entity registers is
generic(NUM_BYTES : integer := 32);
-- This component is described in the textbook, starting on section 4.3 
-- The indices of each of the registers can be found on the LEGv8 Green Card
-- Keep in mind that register 31 (XZR) has a constant value of 0 and cannot be overwritten
-- This should only write on the negative edge of Clock when RegWrite is asserted.
-- Reads should be purely combinatorial, i.e. they don't depend on Clock
-- HINT: Use the provided dmem.vhd as a starting point
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (63 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (63 downto 0);
     RD2      : out STD_LOGIC_VECTOR (63 downto 0);
     --Probe ports used for testing.
     -- Notice the width of the port means that you are 
     --      reading only part of the register file. 
     -- This is only for debugging
     -- You are debugging a sebset of registers here
     -- Temp registers: $X9 & $X10 & X11 & X12 
     -- 4 refers to number of registers you are debugging
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     -- Saved Registers X19 & $X20 & X21 & X22 
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end registers;

architecture Behvregi of registers is

type regi_type is array (0 to 31) of STD_LOGIC_VECTOR(63 downto 0);
signal regi_array : regi_type;
begin
	process(Clock,RR1,RR2,WR,WD,RegWrite)
     	variable addr : integer;
     	variable first : boolean := true;	
	begin
		if(first) then
			regi_array(9) <= X"0000000000000000";
             		regi_array(10) <= X"0000000000000001";
               		regi_array(11) <= X"0000000000000004";
               		regi_array(12) <= X"0000000000000008";
               		
               		regi_array(19) <= X"0000000000000015";
			regi_array(20) <= X"0000000000000007";
             		regi_array(21) <= X"0000000000000000";
               		regi_array(22) <= X"0000000000000016";
               		
			first := false;
        	end if;
		if falling_edge(Clock) and RegWrite = '1' then 
      			addr := to_integer(unsigned(WR)); 
			if addr = 31 then
                   		regi_array(addr) <= X"0000000000000000";
               		else
                    		regi_array(addr) <= WD;
               		end if;
		end if;

	RD1<= regi_array(to_integer(unsigned(RR1)));
	RD2<= regi_array(to_integer(unsigned(RR2)));

	DEBUG_TMP_REGS <= regi_array(9) & regi_array(10) & regi_array(11) & regi_array(12);
    	DEBUG_SAVED_REGS <= regi_array(19) & regi_array(20) & regi_array(21) & regi_array(22);

end process;
end Behvregi;












