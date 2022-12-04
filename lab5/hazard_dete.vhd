library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Hazard is
port(
	Hazard_Rn        : in  STD_LOGIC_VECTOR(4 downto 0);
	Hazard_Rm  	 : in  STD_LOGIC_VECTOR(4 downto 0);
	Hazard_idex_Rd   : in  STD_LOGIC_VECTOR(4 downto 0);
	Hazard_idex_MemRead   : in STD_LOGIC;
	PCWrite  		: out STD_LOGIC;
     	IFIDWrite	 	: out STD_LOGIC;
    	Selection    		: out STD_LOGIC

);
end Hazard;


ARCHITECTURE behav_hazard of Hazard is
BEGIN
process(Hazard_idex_Rd, Hazard_Rn, Hazard_Rm, Hazard_idex_MemRead)
begin
        PCWrite <= '1'; 
        IFIDWrite <= '1'; 
        Selection <= '1'; 
	if(Hazard_idex_MemRead='1') then
		if((Hazard_idex_Rd = Hazard_Rn) or (Hazard_idex_Rd = Hazard_Rm) ) then 
       			PCWrite <= '0'; 
        		IFIDWrite <= '0'; 
        		Selection <= '0'; 
        end if; 
    end if;
end process;
end behav_hazard;
