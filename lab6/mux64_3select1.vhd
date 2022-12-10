library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX64_3select1 is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 00
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 01
    in2    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 10
    sel    : in STD_LOGIC_VECTOR(1 downto 0);
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end MUX64_3select1;

architecture behavioral of MUX64_3select1 is
begin

process(in0,in1,in2,sel) begin
if(sel = "00") then 
   output <= in0; 
elsif(sel = "01") then 
   output <= in1; 
elsif(sel = "10") then 
   output <= in2; 
end if;

  end process;
end behavioral; 

