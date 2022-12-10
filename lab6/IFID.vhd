

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  


entity IfId is 
port(
          IfId_instruction_in        : in std_logic_vector(31 downto 0);
          IfId_pc_in           : in std_logic_vector(63 downto 0);
	  IfIdWrite            : in std_logic; 
          clk                  : in std_logic;   
          ifflush              : in std_logic;  
          IfId_instruction_out   : out std_logic_vector(31 downto 0);
          IfId_pc_out      : out std_logic_vector(63 downto 0));

end IfId;

architecture behavioral of IfId is

begin
process(clk)
        begin
            if( clk'event and clk = '1') then
		if(ifflush='1') then
			IfId_instruction_out <=(others=>'0');
			IfId_pc_out <= (others=>'0');
			end if;

		if(IfIdWrite='1') then
                 	IfId_instruction_out <= IfId_instruction_in;
	                IfId_pc_out <= IfId_pc_in ;
	            end if;
            end if;
        end process;
end behavioral;