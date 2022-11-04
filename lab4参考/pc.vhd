library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity PC is 

port(
     clk          : in  STD_LOGIC; 
     write_enable : in  STD_LOGIC; 
     rst          : in  STD_LOGIC; 
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); 
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0); 
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