----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 10:58:33 AM
-- Design Name: 
-- Module Name: Memorie - Behavioral
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

entity Memorie is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           memWrite : in STD_LOGIC; -- scrie sau nu scrie in memoria de date
           aluResIn : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memData : out STD_LOGIC_VECTOR (15 downto 0);--date port citire
           aluResOut : out STD_LOGIC_VECTOR (15 downto 0));--rezultatul operatiilor aritmetice care trebuie salvat si afisat
end Memorie;

architecture Behavioral of Memorie is
    type ram_array is array(0 to 31) of std_logic_vector (15 downto 0); 
    signal RAM: ram_array:=(
            X"0008",
            X"0009",
            X"000B",
            X"0003",
            X"000C",
            others=>X"1111"
    );
    signal read_address: std_logic_vector(15 downto 0);
begin
-- proces pentru 
process(memWrite,clk,enable)is
 begin
  if enable = '1' then 
    if rising_edge(clk) AND memWrite='1' then 
    ram(conv_integer(aluResIn))<=rd2;
    end if;
  end if;
 end process;
 read_address<=aluResIn;
 memData<=ram(conv_integer(aluResIn));
end Behavioral;
