----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 11:14:46 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--unitate de control---------------------------------------
entity UC is
    Port ( opCode : in STD_LOGIC_VECTOR (2 downto 0);
           regDst : out STD_LOGIC;
           regWr : out STD_LOGIC;
           aluSrc : out STD_LOGIC;
           extOp : out STD_LOGIC;
           aluOp : out STD_LOGIC_VECTOR (1 downto 0);
           memWrite : out STD_LOGIC;
           memReg : out STD_LOGIC;
           branch : out STD_LOGIC;
           jump : out STD_LOGIC;
           bgt : out STD_LOGIC);
end UC;

architecture Behavioral of UC is
begin
process(opCode)
begin
-- setam pe 0
    regDst<='0';
    regWr<='0';
    aluSrc<='0';
    extOp<='0';
    aluOp<="00";
    memWrite<='0';
    memReg<='0';
    branch<='0';
    jump<='0';
    bgt<='0';
-- opCode e pe 3 biti, verificam toate cele 8 
case opCode is
-- pentru opCode=000
 when "000"=>
  regDst<='1'; -- instructiune de tipul R
  regWr<='1';
  aluSrc<='0';
  extOp<='0';
  aluOp<="00";
  memWrite<='0';
  memReg<='0';
  branch<='0';
  jump<='0';
  bgt<='0';
-- pentru opCode=001
when "001"=>
   regDst<='0'; -- addi
   regWr<='1';
   aluSrc<='1';
   extOp<='1';
   aluOp<="01";
   memWrite<='0';
   memReg<='0';
   branch<='0';
   jump<='0';
   bgt<='0';
-- pentru opCode=010
when "010"=> -- load word
   regDst<='0';
   regWr<='1';
   aluSrc<='1';
   extOp<='1';
   aluOp<="01";
   memWrite<='0';
   memReg<='1';
   branch<='0';
   jump<='0';
   bgt<='0';
-- pentru opCode=011
when "011"=> -- store word  
   regDst<='0';
   regWr<='0';
   aluSrc<='1';
   extOp<='1';
   aluOp<="00";
   memWrite<='1';
   memReg<='0';
   branch<='0';
   jump<='0';
   bgt<='0';
--pentru opCode=100
when "100"=> --beq
   regDst<='0';
   regWr<='0';
   aluSrc<='0';
   extOp<='1';
   aluOp<="10";
   memWrite<='0';
   memReg<='0';
   branch<='1';
   jump<='0';
   bgt<='0';
-- pentru opCode=101
when "101"=> --bgt, instructiune de tip I
   regDst<='0';
   regWr<='0';
   aluSrc<='0';
   extOp<='1';
   aluOp<="10";
   memWrite<='0';
   memReg<='0';
   branch<='0';
   jump<='0';
   bgt<='1';
-- pentru opCode=110 
when "110"=> -- ori , instructiune de tip I
   regDst<='0';
   regWr<='1';
   aluSrc<='1';
   extOp<='1';
   aluOp<="11";
   memWrite<='0';
   memReg<='0';
   branch<='0';
   jump<='0';
   bgt<='0'; 
-- pentru opCode=111 
when "111" => -- jump 
   regDst<='X';
   regWr<='X';
   aluSrc<='X';
   extOp<='X';
   aluOp<="XX";
   memWrite<='X';
   memReg<='X';
   branch<='X';
   jump<='1';
   bgt<='X';
--cazul in care opCode are alta valoare
when others=>
   regDst<='X';
   regWr<='X';
   aluSrc<='X';
   extOp<='X';
   aluOp<="XX";
   memWrite<='X';
   memReg<='X';
   branch<='X';
   jump<='1';
   bgt<='X';
end case;
end process;
end Behavioral;
