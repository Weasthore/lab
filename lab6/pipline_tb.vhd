library ieee;  
use ieee.std_logic_1164.all;  
use ieee.std_logic_signed.all;  

entity Pipeline_tb is   
end Pipeline_tb; 

architecture behv_pip of Pipeline_tb is  
component PipelinedCPU2 is
port(
     clk :in std_logic;
     rst :in std_logic;
     --Probe ports used for testing
     DEBUG_IF_FLUSH : out std_logic;
     DEBUG_REG_EQUAL : out std_logic;
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
  
  signal clk :STD_LOGIC;
  signal rst :STD_LOGIC;
  signal DEBUG_IF_FLUSH : STD_LOGIC;
  signal DEBUG_REG_EQUAL :STD_LOGIC;
  signal DEBUG_FORWARDA: std_logic_vector(1 downto 0);
  signal DEBUG_FORWARDB: std_logic_vector(1 downto 0);
  signal DEBUG_PC_WRITE_ENABLE: STD_LOGIC;
  signal DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0);
  signal DEBUG_INSTRUCTION :  STD_LOGIC_VECTOR(31 downto 0);
  signal DEBUG_TMP_REGS :  STD_LOGIC_VECTOR(64*4 - 1 downto 0);
  signal DEBUG_SAVED_REGS :  STD_LOGIC_VECTOR(64*4 - 1 downto 0);
  signal DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);    
  constant clk_period: time := 200 ns;    
    
  begin  
    uut: PipelinedCPU2 port map  
    (  
      	clk => clk,
      	rst => rst,
	DEBUG_IF_FLUSH =>  DEBUG_IF_FLUSH,
	DEBUG_REG_EQUAL => DEBUG_REG_EQUAL,
	DEBUG_FORWARDA => DEBUG_FORWARDA,
	DEBUG_FORWARDB => DEBUG_FORWARDB,
	DEBUG_PC_WRITE_ENABLE => DEBUG_PC_WRITE_ENABLE,
      	DEBUG_PC => DEBUG_PC,
      	DEBUG_INSTRUCTION  => DEBUG_INSTRUCTION,
     	DEBUG_TMP_REGS     => DEBUG_TMP_REGS,
     	DEBUG_SAVED_REGS   => DEBUG_SAVED_REGS,
     	DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS
      );  
      
  clk_process : process  
  begin      
	
	clk <= '1';
	wait for clk_period/2;
	clk <= '0';
	wait for clk_period/2;
	if now > 4000 ns then
		wait;
	end if;
  end process; 
  
  stim_proc:process
  begin      
  	rst <= '1';
 	wait for 60 ns;
  	rst<='0'; 
	wait for 4000 ns;
 	wait;

  end process;  
end;
