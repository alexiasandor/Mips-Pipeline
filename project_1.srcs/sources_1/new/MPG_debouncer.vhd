----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 05:27:36 PM
-- Design Name: 
-- Module Name: MPG_debouncer - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG_debouncer is
    Port ( en : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end MPG_debouncer;

architecture Behavioral of MPG_debouncer is

signal count_int : STD_LOGIC_VECTOR(15 downto 0);
signal Q1 : STD_LOGIC:='0';
signal Q2 : STD_LOGIC:='0';
signal Q3 : STD_LOGIC:='0';
begin

-- proces pentru primul registru
reg1:process(clk, count_int)
begin 
if rising_edge(clk) then 
 if count_int="1111111111111111" then 
  Q1<=btn;
 end if;
end if;
end process;

-- proces pentru al doilea registru
reg2: process(clk)
begin
if rising_edge(clk) then 
  Q2<=Q1;
  Q3<=Q2;
end if;
end process;

-- proces pentru counter
counter: process(clk)
begin 
if rising_edge(clk) then 
  count_int<=count_int+1;
end if;
end process;

en<=(NOT Q3) AND Q2;
end Behavioral;
