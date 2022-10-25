library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA is
port(
	     in0      : in  STD_LOGIC_VECTOR(63 downto 0);
	     in1      : in  STD_LOGIC_VECTOR(63 downto 0);
	     c_in     : in  STD_LOGIC;
       	     sum      : out STD_LOGIC_VECTOR(63 downto 0);
             c_out    : out STD_LOGIC
);
end RCA;

architecture Behvrca of RCA is

	signal next_c : STD_LOGIC_VECTOR(64 downto 0);
begin
	next_c(0) <= c_in;
	
	for_in_c:
		for i in 0 to 63 generate
			sum(i) <= (in0(i) xor in1(i)) xor next_c(i);
			next_c(i+1) <= ((in0(i) xor in1(i)) and next_c(i)) or (in0(i) and in1(i));
		end generate;
	
	c_out <= next_c(64);
	
END Behvrca;