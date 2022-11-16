library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity MemWb is 
port(
          clk              : in std_logic;
          MemWb_MemtoReg_in : in STD_LOGIC;
          MemWb_RegWrite_in : in STD_LOGIC; 
          MemWb_Aluresult_in       : in std_logic_vector(63 downto 0);   
          MemWb_RD_in       : in std_logic_vector(63 downto 0);         
          MemWb_instr5_in       : in std_logic_vector(4 downto 0);      
		 
          MemWb_MemtoReg : out STD_LOGIC;
          MemWb_RegWrite : out STD_LOGIC; 
          MemWb_Aluresult       : out std_logic_vector(63 downto 0);   
          MemWb_RD       : out std_logic_vector(63 downto 0);  
          MemWb_instr5       : out std_logic_vector(4 downto 0)
);      		  
end MemWb;

architecture behav_MemWb of MemWb is

begin
process(clk)
        begin
            if rising_edge(clk) then
                MemWb_MemtoReg <= MemWb_MemtoReg_in;
                MemWb_RegWrite <= MemWb_RegWrite_in;
                MemWb_Aluresult <= MemWb_Aluresult_in;
                MemWb_RD <= MemWb_RD_in;
                MemWb_instr5 <= MemWb_instr5_in;
            end if;
        end process;
end behav_MemWb;
