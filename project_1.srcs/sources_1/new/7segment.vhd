----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 06:53:58 PM
-- Design Name: 
-- Module Name: 7segment - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity P7segment is
 Port (  digit0 : STD_LOGIC_VECTOR(3 downto 0);
         digit1 : STD_LOGIC_VECTOR(3 downto 0);
         digit2 : STD_LOGIC_VECTOR(3 downto 0);
         digit3 : STD_LOGIC_VECTOR(3 downto 0);
         clk : in STD_LOGIC;
         cat :out STD_LOGIC_VECTOR(6 downto 0);
         an : out STD_LOGIC_VECTOR (3 downto 0));
end P7segment;

architecture Behavioral of P7segment is
--semnal care iese din counter 
signal counter : STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');

-- semnale de la counter la mux-uri
signal signal_to_mux1 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');
signal signal_to_mux2 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0') ;
begin
--proces pentru al doilea mux
mux2:process(digit0, digit1,digit2,digit3,counter)
begin 
case counter(15 downto 14) is 
  when "00"=>
        signal_to_mux1<=digit0; 
   when "01"=>
        signal_to_mux1<=digit1; 
   when "10"=>
        signal_to_mux1<=digit2; 
   when "11"=>
         signal_to_mux1<=digit3; 
  end case; 
end process;

-- proces pentru primul mux
mux1:process(counter)
begin 
case counter(15 downto 14) is 
  when "00"=>
         an<="1110"; 
   when "01"=>
         an<="1101"; 
   when "10"=>
         an<="1011"; 
   when "11"=>
         an<="0111"; 
   when others => an<="ZZZZ";
   end case;
end process;

--proces pentru counter
cnt :process(clk)
begin
if rising_edge(clk) then 
counter<=counter+1;
end if;

end process;
--proces pentru 7 segment
seven_segm:process(signal_to_mux1)
begin
case signal_to_mux1 is
 when "0001" =>  --1
      cat<= "1111001";
 when "0010" =>   --2
      cat<="0100100";
 when "0011"=> --3
       cat<= "0110000" ;
 when "0100"=>   --4
      cat<=  "0011001";
 when "0101"=>   --5
       cat<= "0010010";
 when "0110"=>   --6
       cat<="0000010";
 when "0111"=>   --7
       cat<="1111000" ;
 when "1000"=>   --8
       cat<="0000000";
 when "1001"=>   --9
      cat<="0010000"; 
 when "1010"=>   --A
      cat<="0001000";
 when "1011"=>   --b
       cat<= "0000011";
 when "1100"=>  --C
      cat<= "1000110";
 when "1101"=>   --d
      cat<="0100001";
 when "1110"=>   --E
       cat<="0000110";
 when "1111"=>   --F
       cat<="0001110";
 when others => --0
       cat<="1000000";
     end case;
end process;


end Behavioral;
