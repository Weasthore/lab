library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'ARM Reference Data' sheet at the
--    front of the textbook (or the Green Card pdf on Canvas).
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end ALU;

architecture BehvALU of ALU is

	component ADD
	port(
    		 in0    : in  STD_LOGIC_VECTOR(63 downto 0);
   		 in1    : in  STD_LOGIC_VECTOR(63 downto 0);
  		 output : out STD_LOGIC_VECTOR(63 downto 0)
	    );
	end component;

	signal result_v, sum : STD_LOGIC_VECTOR(63 downto 0);
	signal zero_v, overflow_v : STD_LOGIC;
begin
	add64: ADD port map(in0 => in0, in1 => in1, output => sum);

	process(operation, in0, in1,sum,zero_v, overflow_v)
	begin 
	case operation is
		when "0000" =>  result_v <= in0 and in1; 
		when "0001" =>  result_v <= in0 or in1; 
		when "0010" =>  result_v <= sum; 
			if result_v < in0 then
				overflow_v <= '1';
			else
				if result_v < in1 then
					overflow_v <= '1';
				else
					overflow_v <= '0';
				end if;
			end if;
			if result_v(63 downto 0)= x"0000000000000000" then
		  		zero_v <= '1';
			else
		 		zero_v <= '0';
			end if;
		when "0110" =>  result_v  <= std_logic_vector(signed(in0) - signed(in1));
			if result_v < in0 then
				overflow_v <= '1';
			else
				if result_v < in1 then
					overflow_v <= '1';
				else
					overflow_v <= '0';
				end if;
			end if;
			if result_v(63 downto 0)= x"0000000000000000" then
				 zero_v <= '1';
			else
		  		 zero_v <= '0';
			end if;
		when others =>
			result_v <= x"0000000000000000";
			zero_v <= '0';
			overflow_v <= '0';
	end case;
	end process;

result <= result_v;
zero <= zero_v;
overflow <= overflow_v;
end BehvALU;
			






