library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
entity AND2_tb is
end AND2_tb;

ARCHITECTURE and2_behv of AND2_tb is
	COMPONENT AND2
	port(
		in0	: IN std_logic;
		in1	: IN std_logic;
		output	: OUT std_logic);
	end COMPONENT;

	signal in00 	: 	std_logic := '0';
	signal in11 	: 	std_logic := '0';
	signal output 	: 	std_logic;

BEGIN
	uut: AND2 PORT MAP(
		in0 => in00,
		in1 => in11,
		output =>output
	);
	stim_proc: process
	begin
		in00 <= '0';
		in11 <= '0';
		wait for 50 ns;
		in00 <= '0';
		in11 <= '1';
		wait for 50 ns;
		in00 <= '1';
		in11 <= '0';
		wait for 50 ns;
		in00 <= '1';
		in11 <= '1';
		wait for 50 ns;
		wait;
	end process;
END; 
