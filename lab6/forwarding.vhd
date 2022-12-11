library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forwarding is
port(
	 Forwarding_Rn    : in  STD_LOGIC_VECTOR(4 downto 0);
	 Forwarding_Rm	  : in  STD_LOGIC_VECTOR(4 downto 0);
	 Forwarding_exmem_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);
	 Forwarding_memwb_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);
     	 Forwarding_exmem_regwrite   : in STD_LOGIC;
     	 Forwarding_memwb_regwrite   : in STD_LOGIC;
    	 ForwardA  	: out STD_LOGIC_VECTOR(1 downto 0);
     	 ForwardB       : out STD_LOGIC_VECTOR(1 downto 0)
);
end Forwarding;

ARCHITECTURE behav_forward of Forwarding is
BEGIN

	process(Forwarding_exmem_regwrite, Forwarding_memwb_regwrite, Forwarding_Rn, Forwarding_Rm, Forwarding_exmem_Rd, Forwarding_memwb_Rd)
	
	begin
		ForwardA <= "00"; 
 		ForwardB <= "00";
		if(Forwarding_exmem_regwrite='1' and not (Forwarding_exmem_Rd="11111") ) then
   			if(Forwarding_exmem_Rd=Forwarding_Rn) then
   				ForwardA <= "10";
   			end if;
   			if(Forwarding_exmem_Rd=Forwarding_Rm) then
   				ForwardB <= "10"; 
   			end if;
		end if;
		if (Forwarding_memwb_regwrite='1' and not (Forwarding_memwb_Rd="11111")) then
  			 if(Forwarding_memwb_Rd=Forwarding_Rn) then
   				ForwardA <= "01"; 
   			end if;
  			if(Forwarding_memwb_Rd=Forwarding_Rm) then
  				ForwardB <= "01"; 
  			end if;
 		end if;
	end process;

end behav_forward;
