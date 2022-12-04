library ieee;  
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;  

entity Pipeline_tb is   
end Pipeline_tb; 

architecture Pipeline_tb of Pipeline_tb is  
component PipelinedCPU2 is
port(
     clk :in std_logic;
     rst :in std_logic;
     --Probe ports used for testing
     DEBUG_IF_FLUSH : out std_logic;
     DEBUG_ZERO_FLAG : out std_logic;
     -- Forwarding control signals
     DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
     DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
     --The current address (AddressOut from the PC)
     DEBUG_PC : out std_logic_vector(63 downto 0);
     --Value of PC.write_enable
     DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out std_logic_vector(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out std_logic_vector(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out std_logic_vector(64*4 - 1 downto 0)
);
end component;
  
  signal clk              :std_logic;
  signal rst              :std_logic:='1';
  constant clk_period :time :=200 ns;    
    
  begin  
    uut: PipelinedCPU1 port map  
    (  
      clk=>clk,
      rst=>rst
      );  
      
  time_gen_proc:process  
    begin      
    wait for clk_period/2;  
    clk<='1';    
    wait for clk_period/2;  
    clk<='0';  
  end process; 
  
  stim_proc:process
  begin      
  rst<='1';
  wait for 300ns;
  
  rst<='0'; 
  wait;

  end process;  
end;