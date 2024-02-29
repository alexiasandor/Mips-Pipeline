----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 05:45:29 PM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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

entity RegisterFile is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           WA : in STD_LOGIC_VECTOR (2 downto 0);
           Wd : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           en1 : in STD_LOGIC;
           regwr : in STD_LOGIC);
end RegisterFile;

architecture Behavioral of RegisterFile is

signal aux1 :STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal aux2 :STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
type memorie is array(0 to 15) of std_logic_vector(15 downto 0);
signal memorie1: memorie:=(X"0000", X"0001",X"0002",X"0003",X"0004",X"0005",X"0006",X"0007",X"0008",X"0009",X"000A",X"000B",X"000C",X"000D",X"000E",others=>X"000F");

begin
RD1<=memorie1(conv_integer(ra1));
RD2<=memorie1(conv_integer(ra2));
process(clk,Wd,regwr,en1)
begin
 if rising_edge(clk) then
  if regwr ='1' then
   if en1= '1' then
    memorie1(conv_integer(WA))<=Wd;
   end if;
  end if;
 end if;
end process;

end Behavioral;
