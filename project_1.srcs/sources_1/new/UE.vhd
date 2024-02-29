----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 12:04:03 PM
-- Design Name: 
-- Module Name: UE - Behavioral
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
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- execution unit--------------------------
entity UE is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0); --valoarea reg la adresa rs
           RD2 : in STD_LOGIC_VECTOR (15 downto 0); ------------------------rt
           ALUsrc : in STD_LOGIC;--selectie intre read data 2 si ext imm pt intrarea a doua din alu
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0); --imediat extins
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);--codul pentru operatia alu furnizat de catre unitatea principala de control
           PCNext : in STD_LOGIC_VECTOR (15 downto 0);
           BranchAddr : out STD_LOGIC_VECTOR (15 downto 0);
           ALUres : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           greater : out STD_LOGIC;
        ---adaugate pentru pipeline
           rt:in std_logic_vector(2 downto 0);
           rd:in STD_LOGIC_VECTOR(2 downto 0);
           wa:out STD_LOGIC_VECTOR(2 downto 0);
           regdst:in std_logic);
       
           
end UE;

architecture Behavioral of UE is
-- semnal 
signal Aluctrl:STD_LOGIC_VECTOR(2 downto 0);
--SEMNAL PENTRU IESIREA MUXULUI
signal iesireMUX:STD_LOGIC_VECTOR(15 downto 0);
--SEMNAL PENTRU
signal AluResAux:STD_LOGIC_VECTOR(15 downto 0);
begin
-- PROCCES PENTRU PRIMUL
primul:process(ALUop,func)
begin
case ALUop is 
when"00"=> Aluctrl<=func;
when"01"=> Aluctrl<="000";
when"10"=> Aluctrl<="001";
when"11"=> Aluctrl<="110";
when others => Aluctrl<= "XXX";
end case;
end process;

iesireMUX<=RD2 when ALUsrc='0' else Ext_Imm;
--PROCES PENTRU AL DOILEA 
al_doilea:process(RD1,iesireMUX, Aluctrl,sa)
begin 
case Aluctrl is 
when "000" =>AluResAux<=RD1+iesireMUX; --adunare

when "001" =>AluResAux<=RD1-iesireMUX; --scadere
when "010"=>
    if sa='1' then 
      AluResAux <= iesireMUX(14 downto 0)& '0'; --shiftare stanga
    else 
      AluResAux<=iesireMUX;  
    end if;
when "011"=>
        if sa='1' then 
          AluResAux<= '0' & iesireMUX(14 downto 0); --shiftare la dreapta
        else 
          AluResAux<=iesireMUX;  
        end if;   
when "100" => AluResAux <=RD1 or iesireMUX; --and 
when "101" => AluResAux <=RD1 and iesireMUX; --or
when "110" => AluResAux <=RD1 xor iesireMUX; --xor
when "111" =>
    if RD1 < iesireMUX then
       AluResAux <=   X"0001"   ;
    else
        AluResAux <=  X"0000" ;
    end if;
end case;
end process;

Zero <= '1'when AluResAux = X"0000" else '0';
greater<='1' when RD1>iesireMUX else '0';
BranchAddr <= PCNext + Ext_Imm;
ALUres<=AluResAux;
--pipeline
wa<=rt when regdst='0' else rd;
end Behavioral;
