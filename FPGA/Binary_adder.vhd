library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Binary_adder is
  generic (
           N             : integer := 8;                  -- input #1 data width. Note N > M !!
           M             : integer := 4;                  -- input #2 data width
           samples       : std_logic_vector(15 downto 0):= (others => '1') -- vector of sample lines 
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           en_in         : in  std_logic;                         
           Multiplier    : in  std_logic_vector(N-1 downto 0);    
           Multiplicand  : in  std_logic_vector(M-1 downto 0);    

           d_out         : out std_logic_vector (N + M - 1 downto 0);
           en_out        : out std_logic);                        
end Binary_adder;

architecture a of Binary_adder is

constant add_operations : integer := M - 1;
type t_connect  is array (0 to add_operations+1) of std_logic_vector(N + M -1 downto 0);
signal sums         : t_connect;
signal data_s       : t_connect;
signal mult_shift   : t_connect;

type t_Multiplicand  is array (0 to add_operations+1) of std_logic_vector(M -1 downto 0);
signal Multiplicand_s : t_Multiplicand;

constant zeros  : std_logic_vector (N + M - 1 downto 0) := (others => '0');
constant ones   : std_logic_vector (N + M - 1 downto 0) := (others => '1');
-----------------

signal MultiplierSift1   : std_logic_vector(N + M -1 downto 0);
signal MultiplierSift2   : std_logic_vector(N + M -1 downto 0);
signal MultiplierSift3   : std_logic_vector(N + M -1 downto 0);
--signal MultiplierSift4   : std_logic_vector(N + M -1 downto 0);
signal MultiplicandSift1 : std_logic_vector(M -1 downto 0);
signal MultiplicandSift2 : std_logic_vector(M -1 downto 0);
signal MultiplicandSift3 : std_logic_vector(M -1 downto 0);
signal MultiplicandSift4 : std_logic_vector(M -1 downto 0);
signal SumPipe1          : std_logic_vector(N + M -1 downto 0);
signal SumPipe2          : std_logic_vector(N + M -1 downto 0);
signal SumPipe3          : std_logic_vector(N + M -1 downto 0);
signal SumPipe4          : std_logic_vector(N + M -1 downto 0);

 
begin

p_adder2 : process (clk)
--variable vparity           : std_logic;
begin
  if rising_edge(clk) then
    MultiplicandSift1 <= Multiplicand     ;
    MultiplicandSift2 <= MultiplicandSift1;
    MultiplicandSift3 <= MultiplicandSift2;
    MultiplicandSift4 <= MultiplicandSift3;
    MultiplierSift1   <= zeros(zeros'left     downto N + 1 ) & Multiplier & '0'; 
    MultiplierSift2   <= MultiplierSift1(MultiplierSift1'left - 1 downto 0) & '0';
    MultiplierSift3   <= MultiplierSift2(MultiplierSift2'left - 1 downto 0) & '0';
    --MultiplierSift4   <= MultiplierSift3(MultiplierSift3'left - 1 downto 0) & '0';
    if Multiplicand(0) = '1' then
      if Multiplier(Multiplier'left) = '0' then                             
        SumPipe1        <= (zeros(zeros'left     downto N    ) & Multiplier); -- positive number bit extention
      else
        SumPipe1        <= (ones(ones'left     downto N    ) & Multiplier)  ; -- negative number bit extention
    end if;
    else
      SumPipe1        <= (others => '0');
    end if;
    if MultiplicandSift1(1) = '1' then
      SumPipe2        <= MultiplierSift1 + SumPipe1;
    else
      SumPipe2        <= SumPipe1;
    end if;
    if MultiplicandSift2(2) = '1' then
      SumPipe3        <= MultiplierSift2 + SumPipe2;
    else
      SumPipe3        <= SumPipe2;
    end if;
    if MultiplicandSift3(3) = '1' then
      SumPipe4        <= MultiplierSift3 + SumPipe3;
    else
      SumPipe4        <= SumPipe3;
    end if;
  end if;
end process p_adder2;


--p_adder : process (Multiplier, Multiplicand)
p_adder : process (clk)
--variable vparity           : std_logic;
begin
  if rising_edge(clk) then
    g_parity1 : for k in 0 to Multiplicand'length-1 loop
      if k = 0 then
         if Multiplicand(0) = '1' then
            sums(0) <= zeros(N + M - 1 downto N  ) & Multiplier;
         else
            sums(0) <= (others => '0');
         end if;
         mult_shift(1) <= zeros(zeros'left downto N ) & Multiplier;
         Multiplicand_s(0) <= Multiplicand;
      else
         if Multiplicand_s(k-1)(k) = '1' then
            sums(k) <=  (mult_shift(k)(zeros'left-1 downto 0) & '0') + sums(k-1); -- + data_s(k-1);
         else
            sums(k) <= sums(k-1);
         end if;
         mult_shift(k+1)<=mult_shift(k)(zeros'left-1 downto 0) & '0';
         Multiplicand_s(k) <= Multiplicand_s(k-1);
      end if;
    end loop g_parity1;
  end if;
end process p_adder;


---- adders with sampling
--  p_samp1 : process (clk)
--  begin
--    if rising_edge(clk) then
--    --g_parity2 : for k in 0 to Multiplicand'length-1 loop
--      --g_samp1 : if samples(k) = '1' then
--         data_s <= sums;
--      --end if g_samp1;
--    --end loop g_parity2;
--    end if;
--  end process p_samp1;

---- adders w/o sampling
--  p_samp2 : process (sums)
--  begin
--    g_parity3 : for k in 0 to Multiplicand'length-1 loop
--      g_samp2 : if samples(k) = '0' then
--         data_s(k) <= sums(k);
--      end if g_samp2;
--    end loop g_parity3;
--  end process p_samp2;

end a;