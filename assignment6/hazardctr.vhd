library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazardctr is
port(
	 hazard_idex_Rd   : in  STD_LOGIC_VECTOR(4 downto 0);
	 hazard_Rn        : in  STD_LOGIC_VECTOR(4 downto 0);
	 hazard_Rm  	  : in  STD_LOGIC_VECTOR(4 downto 0);
     hazard_idex_Memread   : in STD_LOGIC;
	 hazard_Rd   : in  STD_LOGIC_VECTOR(4 downto 0);
	 hazard_Cbranch   : in STD_LOGIC;
	 hazard_cbzresult   : in STD_LOGIC;

     PCWrite  	: out STD_LOGIC;
     IfIdwrite  : out STD_LOGIC;
     Choice	    : out STD_LOGIC

);
end Hazardctr;


ARCHITECTURE behavioral of Hazardctr is
BEGIN
process(hazard_idex_Rd,hazard_Rn,hazard_Rm,hazard_idex_Memread,hazard_cbzresult,hazard_Rd)
begin
        PCWrite <= '1'; 
        IfIdwrite <= '1'; 
        Choice <= '1'; 
    if(hazard_idex_Memread='1') then --load
   	if(((hazard_idex_Rd=hazard_Rn) or (hazard_idex_Rd=hazard_Rm)) or ((hazard_idex_Rd=hazard_Rd) and (hazard_Cbranch='1'))or hazard_cbzresult='1') then 
        PCWrite <= '0'; 
        IfIdwrite <= '0'; 
        Choice <= '0'; 
        end if; 
	if((hazard_idex_Rd=hazard_Rd)) then 
        PCWrite <= '0'; 
        IfIdwrite <= '0'; 
        Choice <= '0'; 
        end if; 
	if(hazard_cbzresult='1') then 
        PCWrite <= '0'; 
        IfIdwrite <= '0'; 
        Choice <= '0'; 
        end if; 
    end if;
	
end process;
end behavioral;
