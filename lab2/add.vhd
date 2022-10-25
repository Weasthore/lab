library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
entity ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
);
end ADD;

architecture Behvadd of ADD is

	component RCA
	port(
	     in0      : in  STD_LOGIC_VECTOR(63 downto 0);
	     in1      : in  STD_LOGIC_VECTOR(63 downto 0);
	     c_in     : in  STD_LOGIC;
       	     sum      : out STD_LOGIC_VECTOR(63 downto 0);
	     c_out    : out  STD_LOGIC
	);
	end component;
	signal c_in : STD_LOGIC :='0';
	signal c_out : STD_LOGIC;
	
begin
	u1_add64: RCA port map(in0=>in0, in1=>in1, c_in=>c_in, sum=>output, c_out=>c_out);
		
end Behvadd;