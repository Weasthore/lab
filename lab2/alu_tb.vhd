library ieee;
use ieee.std_logic_1164.all;

entity ALU_tb is
end ALU_tb;

architecture BehvALU_tb of ALU_tb is
	component ALU 
	port(
     		in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     		in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     		operation : in     STD_LOGIC_VECTOR(3 downto 0);
     		result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     		zero      : buffer STD_LOGIC;
     		overflow  : buffer STD_LOGIC
    		);
	end component;
	signal in0, in1, result:STD_LOGIC_VECTOR(63 downto 0);
	signal operation:STD_LOGIC_VECTOR(3 downto 0);
	signal zero,overflow:STD_LOGIC;
begin
	UUT: ALU port map(in0=>in0,in1=>in1,operation=>operation,result=>result,zero=>zero,overflow=>overflow);
	process
	begin
	
		operation <= "0000";	
		in1 <= x"0B0B0B0B0B0B0B0B";
		in0 <= x"AAAAAAAAAAAAAAAA";
		wait for 50 ns;
		assert (result = x"0A0A0A0A0A0A0A0A")
		report "Error of and." severity error;

		operation <= "0001";	
		in0 <= x"AAAAAAAA00000000";
		in1 <= x"00000000BBBBBBBB";
		wait for 50 ns;
		assert (result = x"AAAAAAAABBBBBBBB")
		report "Error of or." severity error;

		operation <= "0010";	
		in0 <= x"0FFFFFFFFFFFFFFF";
		in1 <= x"0000000000000001";
		wait for 50 ns;
		assert (overflow = '1')
		report "Error of add." severity error;

		operation <= "0110";	
		in0 <= x"0AAAAAAAAAAAAAAA";
		in1 <= x"0AAAAAAAAAAAAAAA";
		wait for 50 ns;
		assert (zero = '1')
		report "Error of sub." severity error;

		operation <= "1010";
		in0 <= x"1111111111111111";
		in1 <= x"1111111111111111";
		wait;
	end process;
end BehvALU_tb;

