library ieee;
use ieee.std_logic_1164.all;
entity AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC_VECTOR(63 downto 0);
      output : out STD_LOGIC;
      DEBUG_equal: out STD_LOGIC
);
end AND2;

architecture behv1 of AND2 is
begin
	process(in0, in1)
	begin
	if (in1 = X"0000000000000000") then
    		 output<= in0 ; 
		DEBUG_equal<='1';
	else
		output <= '0';
		DEBUG_equal<='0';
	end if;
	end process;
end behv1;	