library ieee;
use ieee.std_logic_1164.all;
entity MUX5_tb is
end MUX5_tb;

architecture MUX5_behv of MUX5_tb is

	component MUX5
	port(
		in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
		in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
		sel    : in STD_LOGIC; -- selects in0 or in1
		output : out STD_LOGIC_VECTOR(4 downto 0)
	);
	end component;
	
	signal in0,in1 : std_logic_vector(4 downto 0) :="00000";
	signal sel : std_logic := '0';
	signal output : std_logic_vector(4 downto 0);
begin
	uut : MUX5 port map(sel => sel, in0 => in0, in1 => in1, output => output);
	
	process
	begin 
		sel <= '0';
		in0 <= "11111";
		in1 <= "00000";
		wait for 10 ns;

		sel <= '1';
		in0 <= "00000";
		in1 <= "11111";
		wait for 10 ns;
		
		sel <= '0';
		in0 <= "00000";
		in1 <= "11111";
		wait for 10 ns;
		wait;
	end process;
end MUX5_behv;



