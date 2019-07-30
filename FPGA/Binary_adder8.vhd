library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Binary_adder8 is
  generic (
           N             : integer := 8;                  -- input #1 data width, positive
           M             : integer := 8
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           en_in         : in  std_logic;                         
           Multiplier    : in  std_logic_vector(N-1 downto 0);    -- positive
           Multiplicand  : in  std_logic_vector(8-1 downto 0);    -- signed

           d_out         : out std_logic_vector (N + M - 1 downto 0);
           en_out        : out std_logic);                        
end Binary_adder8;

architecture a of Binary_adder8 is

constant zeros  : std_logic_vector (N + M - 1 downto 0) := (others => '0');
constant ones   : std_logic_vector (N + M - 1 downto 0) := (others => '1');

component multROM is
  port    (
           clk           : in  std_logic;

           ROM_addr      : in  std_logic_vector(15 downto 0);
           ROM_data      : out std_logic_vector( 7 downto 0)
           );                        
end component;

-----------------
signal MultiplicandS     : std_logic;
signal MultiplicandM     : std_logic_vector(M-1 downto 0);
signal MultiplierD       : std_logic_vector(N-1 downto 0); 

signal MultiplierAnd0       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd1       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd2       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd3       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd4       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd5       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd6       : std_logic_vector(N + M -1 downto 0); 
signal MultiplierAnd7       : std_logic_vector(N + M -1 downto 0); 
signal MultiplicandS2       : std_logic;

signal MultiplierAnd01      : std_logic_vector(N + M    downto 0); 
signal MultiplierAnd23      : std_logic_vector(N + M    downto 0); 
signal MultiplierAnd45      : std_logic_vector(N + M    downto 0); 
signal MultiplierAnd67      : std_logic_vector(N + M    downto 0);  
signal MultiplicandS3       : std_logic;

signal MultiplierAnd03      : std_logic_vector(N + M + 1 downto 0); 
signal MultiplierAnd47      : std_logic_vector(N + M + 1 downto 0);  
signal MultiplicandS4       : std_logic;

signal MultiplierAnd07      : std_logic_vector(N + M + 2 downto 0); 
signal MultiplicandS5       : std_logic;

signal en1, en2,en3,en4     :  std_logic; 

signal ROM_addr             : std_logic_vector(15 downto 0);

begin

--p_conv2magnitude : process (clk)
----variable vparity           : std_logic;
--begin
--  if rising_edge(clk) then
--    MultiplicandS <= Multiplicand(Multiplicand'left);
--    en1           <= en_in;
--    if Multiplicand(Multiplicand'left) = '1' then
--      MultiplicandM <= (not Multiplicand) + 1         ;
--    else
--      MultiplicandM <= Multiplicand;
--    end if;
--    MultiplierD   <= Multiplier                     ;
--  end if;
--end process p_conv2magnitude;

p_conv2magnitude : process (Multiplicand,en_in, Multiplier )
--variable vparity           : std_logic;
begin
    MultiplicandS <= Multiplicand(Multiplicand'left);
    en1           <= en_in;
    if Multiplicand(Multiplicand'left) = '1' then
      MultiplicandM <= (not Multiplicand) + 1         ;
    else
      MultiplicandM <= Multiplicand;
    end if;
    MultiplierD   <= Multiplier                     ;
end process p_conv2magnitude;

p_ands : process (MultiplierD,MultiplicandM)
begin
    for I in M-1 downto 0 loop
      MultiplierAnd0(I)  <=  MultiplierD(I) and MultiplicandM(0); 
      MultiplierAnd1(I)  <=  MultiplierD(I) and MultiplicandM(1); 
      MultiplierAnd2(I)  <=  MultiplierD(I) and MultiplicandM(2); 
      MultiplierAnd3(I)  <=  MultiplierD(I) and MultiplicandM(3); 
      MultiplierAnd4(I)  <=  MultiplierD(I) and MultiplicandM(4); 
      MultiplierAnd5(I)  <=  MultiplierD(I) and MultiplicandM(5); 
      MultiplierAnd6(I)  <=  MultiplierD(I) and MultiplicandM(6); 
      MultiplierAnd7(I)  <=  MultiplierD(I) and MultiplicandM(7);
    end loop;

    for I in N+M-1 downto M loop
      MultiplierAnd0(I)  <=  '0'; 
      MultiplierAnd1(I)  <=  '0'; 
      MultiplierAnd2(I)  <=  '0'; 
      MultiplierAnd3(I)  <=  '0'; 
      MultiplierAnd4(I)  <=  '0'; 
      MultiplierAnd5(I)  <=  '0'; 
      MultiplierAnd6(I)  <=  '0'; 
      MultiplierAnd7(I)  <=  '0';
    end loop;


end process p_ands;

--p_adds : process (clk)
----variable vparity           : std_logic;
--begin
--  if rising_edge(clk) then
--    MultiplierAnd01 <= ('0' & MultiplierAnd0)                                      + ( MultiplierAnd1                                 &       '0');
--    MultiplierAnd23 <= (MultiplierAnd2(MultiplierAnd2'left-1 downto 0) &     "00") + ( MultiplierAnd3(MultiplierAnd3'left-2 downto 0) &     "000");
--    MultiplierAnd45 <= (MultiplierAnd4(MultiplierAnd4'left-3 downto 0) &   "0000") + ( MultiplierAnd5(MultiplierAnd5'left-4 downto 0) &   "00000");
--    MultiplierAnd67 <= (MultiplierAnd6(MultiplierAnd6'left-5 downto 0) & "000000") + ( MultiplierAnd7(MultiplierAnd7'left-6 downto 0) & "0000000");
--    MultiplicandS2  <=  MultiplicandS;
--    en2             <= en1;
--
--    MultiplierAnd03 <= ('0' & MultiplierAnd01) + ('0' & MultiplierAnd23);
--    MultiplierAnd47 <= ('0' & MultiplierAnd45) + ('0' & MultiplierAnd67);
--    MultiplicandS3  <=  MultiplicandS2;
--    en3             <= en2;
--
--    MultiplierAnd07 <= ('0' & MultiplierAnd03) + ('0' & MultiplierAnd47);
--    MultiplicandS4  <= MultiplicandS3;
--    en4             <= en3;
--  end if;
--end process p_adds;

-------------------------- ------
-----  for 8 bit width -> Adder  |
-------------------------- ------
--
--p_adds : process (clk)
----variable vparity           : std_logic;
--begin
--  if rising_edge(clk) then
--    MultiplierAnd07 <=  ("00" & '0' & MultiplierAnd0)                                      + ( "00" & MultiplierAnd1                                 &       '0') 
--                      + ("00" & MultiplierAnd2(MultiplierAnd2'left-1 downto 0) &     "00") + ( "00" & MultiplierAnd3(MultiplierAnd3'left-2 downto 0) &     "000")
--                      + ("00" & MultiplierAnd4(MultiplierAnd4'left-3 downto 0) &   "0000") + ( "00" & MultiplierAnd5(MultiplierAnd5'left-4 downto 0) &   "00000")
--                      + ("00" & MultiplierAnd6(MultiplierAnd6'left-5 downto 0) & "000000") + ( "00" & MultiplierAnd7(MultiplierAnd7'left-6 downto 0) & "0000000");
--    MultiplicandS4  <= MultiplicandS;
--    en4             <= en1;
--  end if;
--end process p_adds;

-------------------------- ------
-- end of for 8 bit width -> Adder  |
-------------------------- ------

------------------------ ------
---  for 8 bit width ->  ROM   |
------------------------ ------
ROM_addr <= MultiplicandM(7 downto 0) & MultiplierAnd0(7 downto 0);

ROM_m: multROM
port map (     
      clk           => clk        ,
      ROM_addr      => ROM_addr    ,
      ROM_data      => MultiplierAnd07(7 downto 0)
    );

MultiplierAnd07(MultiplierAnd07'left downto 8) <= (others => '0');

-------------------------- ------
-- end of for 8 bit width -> ROM  |
-------------------------- ------

p_ram : process (clk)
--variable vparity           : std_logic;
begin
  if rising_edge(clk) then
    MultiplicandS4  <= MultiplicandS;
    en4             <= en1;
  end if;
end process p_ram;

--p_conv2signed : process (clk)
----variable vparity           : std_logic;
--begin
--  if rising_edge(clk) then
--    if MultiplicandS4 = '1' then
--      d_out <= (not MultiplierAnd07(d_out'left downto 0)) + 1         ;
--    else
--      d_out <=      MultiplierAnd07(d_out'left downto 0);
--    end if;
--    en_out  <=      en4;
--  end if;
--end process p_conv2signed;

p_conv2signed : process (MultiplierAnd07, en4, MultiplicandS4)
--variable vparity           : std_logic;
begin
--  if rising_edge(clk) then
    if MultiplicandS4 = '1' then
      d_out <= (not MultiplierAnd07(d_out'left downto 0)) + 1         ;
    else
      d_out <=      MultiplierAnd07(d_out'left downto 0);
    end if;
    en_out  <=      en4;
--  end if;
end process p_conv2signed;

end a;