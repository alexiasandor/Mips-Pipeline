----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2023 06:29:11 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
 Port (clk: in std_logic; -- folosit pt scrierea in register file
        enable: in std_logic;
        RegWrite: in std_logic; --validarea scrierii in reg file
        instruction: in std_logic_vector(15 downto 0);
        RegDst: in std_logic;-- selecteaza adresa de scriere in rf
        WD: in std_logic_vector(15 downto 0);
        ExtOp: in std_logic; -- selecteaza tipul de extensie pentru campul immediate: cu zero sau cu semn
        RD1:out std_logic_vector(15 downto 0); --valoarea registrului la adresa rs
        RD2:out std_logic_vector(15 downto 0); --valoarea registrului la adresa rt
        Ext_Imm:out std_logic_vector(15 downto 0); -- imediat extins 
        sa:out std_logic;
        func:out std_logic_vector(2 downto 0) ;
        rt: out std_logic_vector(2 downto 0);
        rd: out std_logic_vector(2 downto 0));
end ID;

architecture Behavioral of ID is
-- REG FILE 
component RegisterFile is 
 Port(  ra1: in STD_LOGIC_VECTOR(2 downto 0);
        ra2: in STD_LOGIC_VECTOR(2 downto 0);
        WA: in STD_LOGIC_VECTOR(2 downto 0);
        Wd: in STD_LOGIC_VECTOR(15 downto 0);
        clk:in STD_LOGIC ; 
        RD1: out STD_LOGIC_VECTOR(15 downto 0);
        RD2: out STD_LOGIC_VECTOR(15 downto 0);
        en1: in STD_LOGIC;
        regwr: in STD_LOGIC);
end component RegisterFile;
-- semnale
signal wrAddr: std_logic_vector(2 downto 0):=(others=>'0');
signal ExtImmS: std_logic_vector(15 downto 0);
begin

regFile : RegisterFile port map(instruction(12 downto 10), instruction(9 downto 7),wrAddr,WD,clk,RD1,RD2, enable,RegWrite);

--wrAddr<= instruction(9 downto 7) when RegDst='0' else instruction(6 downto 4);
func<= instruction(2 downto 0);
sa<=instruction(3);
Ext_Imm<="000000000" & instruction(6 downto 0) when ExtOp='0'
   else instruction(6)& instruction(6)& instruction(6)& instruction(6)& instruction(6)& instruction(6)& instruction(6)& instruction(6)& instruction(6)& instruction(6 downto 0);
   
rt<=instruction(9 downto 7);
rd<=instruction(6 downto 4);
   
end Behavioral;
