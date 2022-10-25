library ieee;
use ieee.std_logic_1164.all;
entity MUX64_tb is
end MUX64_tb;

architecture MUX64_behv of MUX64_tb is

	component MUX64
	port(
		in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
		in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
		sel    : in STD_LOGIC; -- selects in0 or in1
		output : out STD_LOGIC_VECTOR(63 downto 0)
	);
	end component;
	
	signal in0,in1 : std_logic_vector(63 downto 0) :="0000000000000000000000000000000000000000000000000000000000000000";
	signal sel : std_logic := '0';
	signal output : std_logic_vector(63 downto 0);
begin
	uut : MUX64 port map(sel => sel, in0 => in0, in1 => in1, output => output);
	
	process
	begin 
		sel <= '0';
		in0 <= "1111111111111111111111111111111111111111111111111111111111111111";
		in1 <= "0000000000000000000000000000000000000000000000000000000000000000";
		wait for 10 ns;

		sel <= '1';
		in0 <= "0000000000000000000000000000000000000000000000000000000000000000";
		in1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		wait for 10 ns;
		
		sel <= '0';
		in0 <= "0000000000000000000000000000000000000000000000000000000000000000";
		in1 <= "1111111111111111111111111111111111111111111111111111111111111111";
		wait for 10 ns;
		wait;
	end process;
end MUX64_behv;



