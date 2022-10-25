library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity PC is -- 32-bit rising-edge triggered register with write-enable and synchronous reset
-- For more information on what the PC does, see page 251 in the textbook
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     write_enable : in  STD_LOGIC; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0); -- Current PC address
     addrbuffer   : buffer STD_LOGIC_VECTOR(63 downto 0) 
);
end PC;

architecture behavioral of PC is



begin
process(clk,rst,write_enable) 

variable first:boolean:=true;
begin
   if(rst = '1') then 
     addrbuffer(63 downto 0)<=(others=>'0');
	 first:=true;
   elsif(clk'event and clk='1')then
     if(write_enable = '1') then
	         if(first)then 
			 AddressOut <= addrbuffer;
                           first:=false;
			 else
             AddressOut <= AddressIn;
			 end if;
     end if;        
    end if;
end process;
end behavioral;