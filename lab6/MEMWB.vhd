library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity MemWb is 
port(
		  clk              : in std_logic;
          MemWb_MemWtoReg_in : in STD_LOGIC;
          MemWb_RegWrite_in : in STD_LOGIC; 
          MemWb_Aluresult_in       : in std_logic_vector(63 downto 0);   
          MemWb_RD_in       : in std_logic_vector(63 downto 0);         
          MemWb_instruction5_in       : in std_logic_vector(4 downto 0); 
          MemWb_Rd_in1       : in std_logic_vector(4 downto 0); 

          MemWb_MemWtoReg : out STD_LOGIC;
          MemWb_RegWrite : out STD_LOGIC; 
          MemWb_Aluresult       : out std_logic_vector(63 downto 0);   
          MemWb_RD       : out std_logic_vector(63 downto 0);  
          MemWb_Rd_out       : out std_logic_vector(4 downto 0); 
          MemWb_instruction5       : out std_logic_vector(4 downto 0)
		  );      		  
          
end MemWb;

architecture behavioral of MemWb is

begin
process(clk)
        begin
            if( clk'event and clk = '1') then
                MemWb_MemWtoReg <= MemWb_MemWtoReg_in;
                MemWb_RegWrite <= MemWb_RegWrite_in;
                MemWb_Aluresult <= MemWb_Aluresult_in;
                MemWb_RD <= MemWb_RD_in;
                MemWb_instruction5 <= MemWb_instruction5_in;
                MemWb_Rd_out <= MemWb_Rd_in1;
            end if;
        end process;
end behavioral;

