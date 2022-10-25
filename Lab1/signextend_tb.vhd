library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity SignExtend_tb is
end SignExtend_tb;

architecture SignExtend_behv of SignExtend_tb is

	component SignExtend
	port(
		x : in  STD_LOGIC_VECTOR(31 downto 0);
   		y : out STD_LOGIC_VECTOR(63 downto 0)
	);
	end component;
	
	signal x : std_logic_vector(31 downto 0) :="00000000000000000000000000000000";
	signal y : std_logic_vector(63 downto 0);
begin
	uut : SignExtend port map(x => x, y => y);
	
	process
	begin 
		x <= "00000000000000000000000000000000";
		wait for 10 ns;

		x <= "11111111111111111111111111111111";
		wait for 10 ns;

		x <= "01111111111111111111111111111111";
		wait for 10 ns;
		wait;
	end process;
end SignExtend_behv;



