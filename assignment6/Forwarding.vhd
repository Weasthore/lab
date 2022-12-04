library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Forwarding is
port(
	 forwarding_Rn    : in  STD_LOGIC_VECTOR(4 downto 0);
	 forwarding_Rm	  : in  STD_LOGIC_VECTOR(4 downto 0);
	 forwarding_exmem_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);
	 forwarding_memwb_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);
     forwarding_exmem_regwrite   : in STD_LOGIC;
     forwarding_memwb_regwrite   : in STD_LOGIC;
	 forwarding_sturins   : in  STD_LOGIC_VECTOR(10 downto 0);
	 forwarding_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);

     ForwardA  	: out STD_LOGIC_VECTOR(1 downto 0);
	 ForwardC  	: out STD_LOGIC;
     ForwardB   : out STD_LOGIC_VECTOR(1 downto 0)


);
end Forwarding;

ARCHITECTURE behav of Forwarding is
BEGIN

process(forwarding_exmem_regwrite, forwarding_Rn, forwarding_Rm, forwarding_exmem_Rd, forwarding_memwb_Rd,forwarding_memwb_regwrite)
begin
 ForwardA <= "00"; 
 ForwardB <= "00";
 ForwardC <= '0';

 if(forwarding_exmem_regwrite='1' and not (forwarding_exmem_Rd="11111") ) then
   if(forwarding_exmem_Rd=forwarding_Rn) then
   ForwardA <= "10";
   end if;
   if(forwarding_exmem_Rd=forwarding_Rm) then
   ForwardB <= "10"; 
   end if;

end if;
if (forwarding_memwb_regwrite='1' and not (forwarding_memwb_Rd="11111")) then
   if(forwarding_memwb_Rd=forwarding_Rn) then
   ForwardA <= "01"; 
   end if;
  if(forwarding_memwb_Rd=forwarding_Rm) then
   ForwardB <= "01"; 
   end if;

 end if;
 if (forwarding_sturins="11111000000" ) then
   if(forwarding_exmem_Rd=forwarding_Rd) then
   ForwardB <= "10"; 
   end if;
  if(forwarding_memwb_Rd=forwarding_Rd) then
   ForwardB <= "01"; 
   end if;
 end if;
  if (forwarding_sturins(10 downto 3)="10110100" ) then
  if(forwarding_exmem_Rd=forwarding_Rd) then
   ForwardC <= '1'; 
   end if;
  if(forwarding_memwb_Rd=forwarding_Rd) then
   ForwardC <= '1'; 
   end if;
 end if;
 

end process;
end behav;