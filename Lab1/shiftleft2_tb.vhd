library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ShiftLeft2_tb is
end ShiftLeft2_tb;

architecture ShiftLeft2_behv of ShiftLeft2_tb is

	component ShiftLeft2
	port(
		x : in  STD_LOGIC_VECTOR(63 downto 0);
   		y : out STD_LOGIC_VECTOR(63 downto 0)
	);
	end component;
	
	signal x : std_logic_vector(63 downto 0) :="0000000000000000000000000000000000000000000000000000000000000000";
	signal y : std_logic_vector(63 downto 0);
begin
	uut : ShiftLeft2 port map(x => x, y => y);
	
	process
	begin 
		x <= "0000000000000000000000000000000000000000000000000000000000000001";
		wait for 10 ns;

		x <= "0000000000000000000000000000000000000000000000000000000000000010";
		wait for 10 ns;
		wait;
	end process;
end ShiftLeft2_behv;



