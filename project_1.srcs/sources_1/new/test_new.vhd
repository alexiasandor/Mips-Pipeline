----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 12:20:31 PM
-- Design Name: 
-- Module Name: test_new - Behavioral
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

entity test_new is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_new;


architecture Behavioral of test_new is

component Instr_Fetch is
 Port (jump : in STD_LOGIC;
       pcsrc : in STD_LOGIC;
       clk : in STD_LOGIC;
       ba : in STD_LOGIC_VECTOR(15 downto 0);
       ja : in STD_LOGIC_VECTOR(15 downto 0);
       en: in STD_LOGIC;
       reset:in STD_LOGIC;
       pcPlusUnu: out STD_LOGIC_VECTOR(15 downto 0);
       instruction: out STD_LOGIC_VECTOR(15 downto 0));
end component Instr_Fetch;
--MPG
component MPG_debouncer is
    Port ( en : out STD_LOGIC;
         btn : in STD_LOGIC;
         clk : in STD_LOGIC);
end component MPG_debouncer;

--SEVEN SEGM
component P7segment is
 Port (  digit0 : STD_LOGIC_VECTOR(3 downto 0);
         digit1 : STD_LOGIC_VECTOR(3 downto 0);
         digit2 : STD_LOGIC_VECTOR(3 downto 0);
         digit3 : STD_LOGIC_VECTOR(3 downto 0);
         clk : in STD_LOGIC;
         cat :out STD_LOGIC_VECTOR(6 downto 0);
         an : out STD_LOGIC_VECTOR (3 downto 0));
end component P7segment;

--ID
component ID is
 Port (clk: in std_logic;
        enable: in std_logic;
        RegWrite: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        RegDst: in std_logic;
        WD: in std_logic_vector(15 downto 0);
        WA: in std_logic_vector(2 downto 0);
        ExtOp: in std_logic;
        RD1:out std_logic_vector(15 downto 0);
        RD2:out std_logic_vector(15 downto 0);
        Ext_Imm:out std_logic_vector(15 downto 0);
        sa:out std_logic;
        func:out std_logic_vector(2 downto 0));
       -- rt:out std_logic_vector(2 downto 0);
        --rd:out std_logic_vector(2 downto 0));
end component ID;

--UC
 component UC is
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
end component UC;

--UE
component UE is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUsrc : in STD_LOGIC;
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUop : in STD_LOGIC_VECTOR (1 downto 0);
           PCNext : in STD_LOGIC_VECTOR (15 downto 0);
           BranchAddr : out STD_LOGIC_VECTOR (15 downto 0);
           ALUres : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           greater : out STD_LOGIC;
           rt:in STD_LOGIC_VECTOR(2 downto 0);
           rd:in STD_LOGIC_VECTOR(2 downto 0);
           wa:out STD_LOGIC_VECTOR(2 downto 0);
           regdst: in std_logic
           );
end component UE;

--memorie
component Memorie is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           memWrite : in STD_LOGIC;
           aluResIn : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           aluResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component Memorie;

-------declarare semnale----------------------------------------------------------------------------------------------
signal en : STD_LOGIC:='0';
signal reset : STD_LOGIC:='0';
signal sa: STD_LOGIC:='0';
signal regWrite : STD_LOGIC:='0';
signal regDst : STD_LOGIC:='0';
signal extOp : STD_LOGIC:='0';
signal aluSrc : STD_LOGIC:='0';
signal branch : STD_LOGIC:='0';
signal bgt : STD_LOGIC:='0';
signal jump : STD_LOGIC:='0';
signal memWrite : STD_LOGIC:='0';
signal memReg : STD_LOGIC:='0';
signal zero : STD_LOGIC:='0';
signal zeroBranchBgt : STD_LOGIC:='0';
signal zeroBranchBgz : STD_LOGIC:='0';
signal PcSrc : STD_LOGIC:='0';
--
signal SSD_in:STD_LOGIC_VECTOR(15 downto 0):=X"0000";
signal instruction:STD_LOGIC_VECTOR(15 downto 0):=X"0000";
signal pcplusunu:STD_LOGIC_VECTOR(15 downto 0):=X"0000";
--
signal rdata1:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal rdata2:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal wdata:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal memdata:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal func:STD_LOGIC_VECTOR(2 downto 0):=(others=>'0');
signal alures:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal alures1:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal extImm:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal jumpAdress:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal branchAdress:STD_LOGIC_VECTOR(15 downto 0):=(others=>'0');
signal aluOp:STD_LOGIC_VECTOR(1 downto 0):="00";

-----semnale pipeline-----
signal wa: STD_LOGIC_VECTOR(2 downto 0);
signal rt: STD_LOGIC_VECTOR(2 downto 0);
signal rd: STD_LOGIC_VECTOR(2 downto 0); 

----semnale IF/ID
signal ifidIn:std_logic_vector(31 downto 0);
signal ifidOut:std_logic_vector(31 downto 0);


signal IF_ID: STD_LOGIC_VECTOR(31 downto 0);
signal ID_EX: STD_LOGIC_VECTOR(83 downto 0);
signal EX_MEM: STD_LOGIC_VECTOR(57 downto 0);
signal MEM_WB: STD_LOGIC_VECTOR(31 downto 0);
begin
--avem 2 mpg-uri
mpg1 : MPG_debouncer port map(en,btn(0),clk);
mpg2 : MPG_debouncer port map(reset,btn(2),clk);
--SSD_in<=instruction when sw(3)='0' else pcplusunu;
SSDa : P7segment port map(SSD_in(3 downto 0),SSD_in(7 downto 4),SSD_in(11 downto 8),SSD_in(15 downto 12),clk,cat,an);
Instr : Instr_Fetch port map(jump,pcsrc,clk,branchAdress,jumpAdress,en,reset,pcplusunu,instruction);
--wdata=rdata1+rdata2;
instr_d :ID port map(clk,en,MEM_WB(1),IF_ID(15 downto 0),
                 RegDst,wdata,wa,extOp,rdata1,rdata2,ExtImm,
                 sa,func);
Uc_comp : UC port map(IF_ID(15 downto 13),regDst,regWrite,aluSrc,extOp,
                       aluOp,memWrite,memReg,branch,jump,bgt);
ue_comp : UE port map( ID_EX(50 downto 35), ID_EX(66 downto 51),ID_EX(1),
                       ID_EX(34 downto 19), ID_EX(15), ID_EX(18 downto 16), ID_EX(3 downto 2),
                       ID_EX(82 downto 67), branchAdress, alures,
                       zero, zeroBranchBgt,ID_EX(14 downto 12),ID_EX(11 downto 9),wa,ID_EX(0));

mem_comp : Memorie port map(clk,en,EX_MEM(1),EX_MEM(41 downto 26), EX_MEM(25 downto 10),memdata,alures1);


PcSrc<=(EX_MEM(3) and EX_MEM(5)) or (EX_MEM(4)and EX_MEM(6));
jumpAdress<=IF_ID(31 downto 29)& IF_ID(12 downto 0);
wdata<=MEM_WB(20 downto 5) when MEM_WB(1)='0' else MEM_WB(36 downto 21);

--process(sw,IF_ID,EX_MEM,ID_EX,MEM_WB,wdata)
--begin
--if sw(7 downto 5)="000" then 
--    ssd_in<=IF_ID(15 downto 0);
-- elsif sw(7 downto 5)="001" then 
-- ssd_in<=ID_EX(82 downto 67);
-- elsif sw(7 downto 5)="010" then 
-- ssd_in<=ID_EX(50 downto 35);
--  elsif sw(7 downto 5)="011" then 
--  ssd_in<=EX_MEM(25 downto 10);
--  elsif sw(7 downto 5)="100" then 
-- ssd_in<=ID_EX(34 downto 19);
--  elsif sw(7 downto 5)="101" then 
-- ssd_in<=MEM_WB(20 downto 5);
--  elsif sw(7 downto 5)="110" then 
-- ssd_in<=MEM_WB(36 downto 21);
-- else
-- ssd_in<=wdata;
-- end if;
--end process;

process(sw,instruction,pcplusunu,rdata1,rdata2,extImm,memdata,wdata,alures)
begin
if sw(7 downto 5)="000" then 
    ssd_in<=instruction;
 elsif sw(7 downto 5)="001" then 
 ssd_in<=pcplusunu;
 elsif sw(7 downto 5)="010" then 
 ssd_in<=rdata1;
  elsif sw(7 downto 5)="011" then 
  ssd_in<=rdata2;
  elsif sw(7 downto 5)="100" then 
 ssd_in<=extImm;
  elsif sw(7 downto 5)="101" then 
 ssd_in<=alures;
  elsif sw(7 downto 5)="110" then 
 ssd_in<=memdata;
 else
 ssd_in<=wdata;
 end if;
end process;
--led<=instruction(15 downto 13) & RegDst & RegWrite & ExtOp & AluSrc & AluOp &  MemWrite & MemReg & Jump & Branch &bgez &bgt& pcsrc;
-- conectare la leduri 
--led<=instruction(15 downto 13) & RegDst & RegWrite & ExtOp & AluSrc & AluOp & MemWrite & MemReg & Jump &Branch &bgez &bgt & pcsrc;


led(2 downto 0) <= instruction(15 downto 13);
led(3)<=regDst;
led(4)<=regWrite;
led(5)<=extOp;
led(6)<=aluSrc;
led(8 downto 7)<=aluOp;
led(9)<=memwrite;
led(10)<=memReg;
led(11)<=jump;
led(12)<=branch;
led(13)<=bgt;
led(14)<=PcSrc;
led(15)<=zeroBranchBgt;

process(clk, en)
begin
if en ='1' then
if rising_edge(clk)then
IF_ID(31 downto 16)<=pcplusunu;
IF_ID(15 downto 0)<= instruction;
end if;
end if;
end process;

--intre id si ex 
processIdEx: process(clk,en)
begin
if(en='1')then 
if rising_edge(clk)then
ID_EX(0)<=RegDst;
ID_EX(1)<=Alusrc;
ID_EX(3 downto 2)<=aluop;
ID_EX(4)<=branch;
ID_EX(5)<=bgt;
ID_EX(6)<= RegWrite;
ID_EX(7)<=memWrite;
ID_EX(8)<=memReg; 
ID_EX(11 downto 9)<=IF_ID(6 downto 4);
ID_EX(14 downto 12)<=IF_ID(9 downto 7);
ID_EX(15)<=sa;
ID_EX(18 downto 16)<=func;
ID_EX(34 downto 19)<=ExtImm;
ID_EX(50 downto 35)<=rdata1;
ID_EX(66 downto 51)<=rdata2;
ID_EX(82 downto 67)<=IF_ID(31 downto 16);
end if;
end if;
end process;

-- intre ex si mem
processExMem: process(clk,en)
begin 
if(en='1') then
if rising_edge(clk) then
EX_MEM(0)<=ID_EX(6); --REGWRITE
EX_MEM(1)<=ID_EX(7); -- MEMWRITE
EX_MEM(2)<=ID_EX(8); -- MEMREG                         
EX_MEM(3)<=ID_EX(4); --BRANCH
EX_MEM(4)<=ID_EX(5); --BGT
EX_MEM(5)<=zero; --ZERO
EX_MEM(6)<=zeroBranchBgt; --ZEROBGT
EX_MEM(9 downto 7)<=wa;
EX_MEM(25 downto 10)<=ID_EX(66 downto 51); --rdata2
EX_MEM(41 downto 26)<=alures;
EX_MEM(57 downto 42)<=branchAdress;                                      
end if;
end if;
end process;



processMemWb: process(clk,en)
begin 
if(en='1') then
if rising_edge(clk) then
MEM_WB(0)<=EX_MEM(0); --REGWRITE
MEM_WB(1)<=EX_MEM(2); --MEMREG
MEM_WB(4 downto 2)<=EX_MEM(9 downto 7); --wa
MEM_WB(20 downto 5)<=EX_MEM(41 downto 26); --alures
MEM_WB(36 downto 21)<=memdata;
end if;
end if;
end process;

end Behavioral;
