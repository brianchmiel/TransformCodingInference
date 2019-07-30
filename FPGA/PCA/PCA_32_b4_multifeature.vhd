library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
--use work.custom_types.all;

-- custom package
--library ieee;
--
--package custom_types is
--    use ieee.std_logic_1164.all;
--    --type std_logic_vector_vector is array (natural range <>) of std_logic_vector;
--    type std_logic_vector_vector is array (0 to 63) of std_logic_vector(8-1 downto 0);
--end package;

entity PCA_32 is
  generic (
  	       mult_sum      : string := "sum";
           N             : integer := 8;       -- input data width
           M             : integer := 8;       -- input weight width
  	       in_row        : integer := 256;
  	       in_col        : integer := 256
  	       );
  port    (
           clk     : in std_logic;
           rst     : in std_logic;
          -- d_in      : in std_logic_vector_vector(1 to 64)(N-1 downto 0);
  	       d01_in    : in std_logic_vector (N-1 downto 0);
           d02_in    : in std_logic_vector (N-1 downto 0);
           d03_in    : in std_logic_vector (N-1 downto 0);
           d04_in    : in std_logic_vector (N-1 downto 0);
           d05_in    : in std_logic_vector (N-1 downto 0);
           d06_in    : in std_logic_vector (N-1 downto 0);
           d07_in    : in std_logic_vector (N-1 downto 0);
           d08_in    : in std_logic_vector (N-1 downto 0);
           d09_in    : in std_logic_vector (N-1 downto 0);
           d10_in    : in std_logic_vector (N-1 downto 0);
           d11_in    : in std_logic_vector (N-1 downto 0);
           d12_in    : in std_logic_vector (N-1 downto 0);
           d13_in    : in std_logic_vector (N-1 downto 0);
           d14_in    : in std_logic_vector (N-1 downto 0);
           d15_in    : in std_logic_vector (N-1 downto 0);
           d16_in    : in std_logic_vector (N-1 downto 0);
           d17_in    : in std_logic_vector (N-1 downto 0);
           d18_in    : in std_logic_vector (N-1 downto 0);
           d19_in    : in std_logic_vector (N-1 downto 0);
           d20_in    : in std_logic_vector (N-1 downto 0);
           d21_in    : in std_logic_vector (N-1 downto 0);
           d22_in    : in std_logic_vector (N-1 downto 0);
           d23_in    : in std_logic_vector (N-1 downto 0);
           d24_in    : in std_logic_vector (N-1 downto 0);
           d25_in    : in std_logic_vector (N-1 downto 0);
           d26_in    : in std_logic_vector (N-1 downto 0);
           d27_in    : in std_logic_vector (N-1 downto 0);
           d28_in    : in std_logic_vector (N-1 downto 0);
           d29_in    : in std_logic_vector (N-1 downto 0);
           d30_in    : in std_logic_vector (N-1 downto 0);
           d31_in    : in std_logic_vector (N-1 downto 0);
           d32_in    : in std_logic_vector (N-1 downto 0);

  	       en_in     : in std_logic;
  	       sof_in    : in std_logic; -- start of frame

           w01      : in std_logic_vector(M-1 downto 0); 
           w02      : in std_logic_vector(M-1 downto 0); 
           w03      : in std_logic_vector(M-1 downto 0); 
           w04      : in std_logic_vector(M-1 downto 0); 
           w05      : in std_logic_vector(M-1 downto 0); 
           w06      : in std_logic_vector(M-1 downto 0); 
           w07      : in std_logic_vector(M-1 downto 0); 
           w08      : in std_logic_vector(M-1 downto 0); 
           w09      : in std_logic_vector(M-1 downto 0); 
           w10      : in std_logic_vector(M-1 downto 0); 
           w11      : in std_logic_vector(M-1 downto 0); 
           w12      : in std_logic_vector(M-1 downto 0); 
           w13      : in std_logic_vector(M-1 downto 0); 
           w14      : in std_logic_vector(M-1 downto 0); 
           w15      : in std_logic_vector(M-1 downto 0); 
           w16      : in std_logic_vector(M-1 downto 0); 
           w17      : in std_logic_vector(M-1 downto 0); 
           w18      : in std_logic_vector(M-1 downto 0); 
           w19      : in std_logic_vector(M-1 downto 0); 
           w20      : in std_logic_vector(M-1 downto 0); 
           w21      : in std_logic_vector(M-1 downto 0); 
           w22      : in std_logic_vector(M-1 downto 0); 
           w23      : in std_logic_vector(M-1 downto 0); 
           w24      : in std_logic_vector(M-1 downto 0); 
           w25      : in std_logic_vector(M-1 downto 0); 
           w26      : in std_logic_vector(M-1 downto 0); 
           w27      : in std_logic_vector(M-1 downto 0); 
           w28      : in std_logic_vector(M-1 downto 0); 
           w29      : in std_logic_vector(M-1 downto 0); 
           w30      : in std_logic_vector(M-1 downto 0); 
           w31      : in std_logic_vector(M-1 downto 0); 
           w32      : in std_logic_vector(M-1 downto 0);
 
           d_out   : out std_logic_vector (N + M + 5 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end PCA_32;

architecture a of PCA_32 is

component Binary_adder8 is
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
end component;

constant EN_BIT  : integer range 0 to 1 := 0;
constant SOF_BIT : integer range 0 to 1 := 1;



signal mult_res01 : std_logic_vector(N+M-1 downto 0);
signal mult_res02 : std_logic_vector(N+M-1 downto 0);
signal mult_res03 : std_logic_vector(N+M-1 downto 0);
signal mult_res04 : std_logic_vector(N+M-1 downto 0);
signal mult_res05 : std_logic_vector(N+M-1 downto 0);
signal mult_res06 : std_logic_vector(N+M-1 downto 0);
signal mult_res07 : std_logic_vector(N+M-1 downto 0);
signal mult_res08 : std_logic_vector(N+M-1 downto 0);
signal mult_res09 : std_logic_vector(N+M-1 downto 0);
signal mult_res10 : std_logic_vector(N+M-1 downto 0);
signal mult_res11 : std_logic_vector(N+M-1 downto 0);
signal mult_res12 : std_logic_vector(N+M-1 downto 0);
signal mult_res13 : std_logic_vector(N+M-1 downto 0);
signal mult_res14 : std_logic_vector(N+M-1 downto 0);
signal mult_res15 : std_logic_vector(N+M-1 downto 0);
signal mult_res16 : std_logic_vector(N+M-1 downto 0);
signal mult_res17 : std_logic_vector(N+M-1 downto 0);
signal mult_res18 : std_logic_vector(N+M-1 downto 0);
signal mult_res19 : std_logic_vector(N+M-1 downto 0);
signal mult_res20 : std_logic_vector(N+M-1 downto 0);
signal mult_res21 : std_logic_vector(N+M-1 downto 0);
signal mult_res22 : std_logic_vector(N+M-1 downto 0);
signal mult_res23 : std_logic_vector(N+M-1 downto 0);
signal mult_res24 : std_logic_vector(N+M-1 downto 0);
signal mult_res25 : std_logic_vector(N+M-1 downto 0);
signal mult_res26 : std_logic_vector(N+M-1 downto 0);
signal mult_res27 : std_logic_vector(N+M-1 downto 0);
signal mult_res28 : std_logic_vector(N+M-1 downto 0);
signal mult_res29 : std_logic_vector(N+M-1 downto 0);
signal mult_res30 : std_logic_vector(N+M-1 downto 0);
signal mult_res31 : std_logic_vector(N+M-1 downto 0);
signal mult_res32 : std_logic_vector(N+M-1 downto 0);
signal mult_res33 : std_logic_vector(N+M-1 downto 0);
signal mult_res34 : std_logic_vector(N+M-1 downto 0);
signal mult_res35 : std_logic_vector(N+M-1 downto 0);
signal mult_res36 : std_logic_vector(N+M-1 downto 0);
signal mult_res37 : std_logic_vector(N+M-1 downto 0);
signal mult_res38 : std_logic_vector(N+M-1 downto 0);
signal mult_res39 : std_logic_vector(N+M-1 downto 0);
signal mult_res40 : std_logic_vector(N+M-1 downto 0);
signal mult_res41 : std_logic_vector(N+M-1 downto 0);
signal mult_res42 : std_logic_vector(N+M-1 downto 0);
signal mult_res43 : std_logic_vector(N+M-1 downto 0);
signal mult_res44 : std_logic_vector(N+M-1 downto 0);
signal mult_res45 : std_logic_vector(N+M-1 downto 0);
signal mult_res46 : std_logic_vector(N+M-1 downto 0);
signal mult_res47 : std_logic_vector(N+M-1 downto 0);
signal mult_res48 : std_logic_vector(N+M-1 downto 0);
signal mult_res49 : std_logic_vector(N+M-1 downto 0);
signal mult_res50 : std_logic_vector(N+M-1 downto 0);
signal mult_res51 : std_logic_vector(N+M-1 downto 0);
signal mult_res52 : std_logic_vector(N+M-1 downto 0);
signal mult_res53 : std_logic_vector(N+M-1 downto 0);
signal mult_res54 : std_logic_vector(N+M-1 downto 0);
signal mult_res55 : std_logic_vector(N+M-1 downto 0);
signal mult_res56 : std_logic_vector(N+M-1 downto 0);
signal mult_res57 : std_logic_vector(N+M-1 downto 0);
signal mult_res58 : std_logic_vector(N+M-1 downto 0);
signal mult_res59 : std_logic_vector(N+M-1 downto 0);
signal mult_res60 : std_logic_vector(N+M-1 downto 0);
signal mult_res61 : std_logic_vector(N+M-1 downto 0);
signal mult_res62 : std_logic_vector(N+M-1 downto 0);
signal mult_res63 : std_logic_vector(N+M-1 downto 0);
signal mult_res64 : std_logic_vector(N+M-1 downto 0);

signal adder_1_01         : std_logic_vector (N + M downto 0);
signal adder_1_02         : std_logic_vector (N + M downto 0);
signal adder_1_03         : std_logic_vector (N + M downto 0);
signal adder_1_04         : std_logic_vector (N + M downto 0);
signal adder_1_05         : std_logic_vector (N + M downto 0);
signal adder_1_06         : std_logic_vector (N + M downto 0);
signal adder_1_07         : std_logic_vector (N + M downto 0);
signal adder_1_08         : std_logic_vector (N + M downto 0);
signal adder_1_09         : std_logic_vector (N + M downto 0);
signal adder_1_10         : std_logic_vector (N + M downto 0);
signal adder_1_11         : std_logic_vector (N + M downto 0);
signal adder_1_12         : std_logic_vector (N + M downto 0);
signal adder_1_13         : std_logic_vector (N + M downto 0);
signal adder_1_14         : std_logic_vector (N + M downto 0);
signal adder_1_15         : std_logic_vector (N + M downto 0);
signal adder_1_16         : std_logic_vector (N + M downto 0);
signal adder_1_17         : std_logic_vector (N + M downto 0);
signal adder_1_18         : std_logic_vector (N + M downto 0);
signal adder_1_19         : std_logic_vector (N + M downto 0);
signal adder_1_20         : std_logic_vector (N + M downto 0);
signal adder_1_21         : std_logic_vector (N + M downto 0);
signal adder_1_22         : std_logic_vector (N + M downto 0);
signal adder_1_23         : std_logic_vector (N + M downto 0);
signal adder_1_24         : std_logic_vector (N + M downto 0);
signal adder_1_25         : std_logic_vector (N + M downto 0);
signal adder_1_26         : std_logic_vector (N + M downto 0);
signal adder_1_27         : std_logic_vector (N + M downto 0);
signal adder_1_28         : std_logic_vector (N + M downto 0);
signal adder_1_29         : std_logic_vector (N + M downto 0);
signal adder_1_30         : std_logic_vector (N + M downto 0);
signal adder_1_31         : std_logic_vector (N + M downto 0);
signal adder_1_32         : std_logic_vector (N + M downto 0);

signal adder_2_01         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_02         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_03         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_04         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_05         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_06         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_07         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_08         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_09         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_10         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_11         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_12         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_13         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_14         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_15         : std_logic_vector (N + M + 1 downto 0);
signal adder_2_16         : std_logic_vector (N + M + 1 downto 0);

signal adder_3_01         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_02         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_03         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_04         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_05         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_06         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_07         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_08         : std_logic_vector (N + M + 2 downto 0);

signal adder_4_01         : std_logic_vector (N + M + 3 downto 0);
signal adder_4_02         : std_logic_vector (N + M + 3 downto 0);
signal adder_4_03         : std_logic_vector (N + M + 3 downto 0);
signal adder_4_04         : std_logic_vector (N + M + 3 downto 0);

signal adder_5_01         : std_logic_vector (N + M + 4 downto 0);
signal adder_5_02         : std_logic_vector (N + M + 4 downto 0);

signal en_mult, en_add1, en_add2, en_add3, en_add4, en_add5 : std_logic;
signal sof_mult, sof_add1, sof_add2, sof_add3, sof_add4, sof_add5 : std_logic;
begin

gen_Mults: if mult_sum = "mult" generate 
-- multiplication
  p_mul1 : process (clk)
  begin
    if rising_edge(clk) then
         mult_res01 <=  d01_in * w01;
         mult_res02 <=  d02_in * w02;
         mult_res03 <=  d03_in * w03;
         mult_res04 <=  d04_in * w04;
         mult_res05 <=  d05_in * w05;
         mult_res06 <=  d06_in * w06;
         mult_res07 <=  d07_in * w07;
         mult_res08 <=  d08_in * w08;
         mult_res09 <=  d09_in * w09;
         mult_res10 <=  d10_in * w10;
         mult_res11 <=  d11_in * w11;
         mult_res12 <=  d12_in * w12;
         mult_res13 <=  d13_in * w13;
         mult_res14 <=  d14_in * w14;
         mult_res15 <=  d15_in * w15;
         mult_res16 <=  d16_in * w16;
         mult_res17 <=  d17_in * w17;
         mult_res18 <=  d18_in * w18;
         mult_res19 <=  d19_in * w19;
         mult_res20 <=  d20_in * w20;
         mult_res21 <=  d21_in * w21;
         mult_res22 <=  d22_in * w22;
         mult_res23 <=  d23_in * w23;
         mult_res24 <=  d24_in * w24;
         mult_res25 <=  d25_in * w25;
         mult_res26 <=  d26_in * w26;
         mult_res27 <=  d27_in * w27;
         mult_res28 <=  d28_in * w28;
         mult_res29 <=  d29_in * w29;
         mult_res30 <=  d30_in * w30;
         mult_res31 <=  d31_in * w31;
    end if;
  end process p_mul1;


    p_en_mult : process (clk,rst)
  begin
    if rst = '1' then
        en_mult  <= '0';
    elsif rising_edge(clk) then
        en_mult <= en_in ;
    end if;
  end process p_en_mult;
end generate;

gen_Adds: if mult_sum = "sum" generate 
A01: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => en_in, Multiplier => d01_in, Multiplicand => w01,d_out => mult_res01, en_out => en_mult);
  A02: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d02_in, Multiplicand => w02,d_out => mult_res02, en_out => open);
  A03: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d03_in, Multiplicand => w03,d_out => mult_res03, en_out => open);
  A04: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d04_in, Multiplicand => w04,d_out => mult_res04, en_out => open);
  A05: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d05_in, Multiplicand => w05,d_out => mult_res05, en_out => open);
  A06: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d06_in, Multiplicand => w06,d_out => mult_res06, en_out => open);
  A07: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d07_in, Multiplicand => w07,d_out => mult_res07, en_out => open);
  A08: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d08_in, Multiplicand => w08,d_out => mult_res08, en_out => open);
  A09: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d09_in, Multiplicand => w09,d_out => mult_res09, en_out => open);
  A10: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d10_in, Multiplicand => w10,d_out => mult_res10, en_out => open);
  A11: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d11_in, Multiplicand => w11,d_out => mult_res11, en_out => open);
  A12: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d12_in, Multiplicand => w12,d_out => mult_res12, en_out => open);
  A13: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d13_in, Multiplicand => w13,d_out => mult_res13, en_out => open);
  A14: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d14_in, Multiplicand => w14,d_out => mult_res14, en_out => open);
  A15: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d15_in, Multiplicand => w15,d_out => mult_res15, en_out => open);
  A16: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d16_in, Multiplicand => w16,d_out => mult_res16, en_out => open);
  A17: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d17_in, Multiplicand => w17,d_out => mult_res17, en_out => open);
  A18: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d18_in, Multiplicand => w18,d_out => mult_res18, en_out => open);
  A19: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d19_in, Multiplicand => w19,d_out => mult_res19, en_out => open);
  A20: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d20_in, Multiplicand => w20,d_out => mult_res20, en_out => open);
  A21: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d21_in, Multiplicand => w21,d_out => mult_res21, en_out => open);
  A22: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d22_in, Multiplicand => w22,d_out => mult_res22, en_out => open);
  A23: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d23_in, Multiplicand => w23,d_out => mult_res23, en_out => open);
  A24: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d24_in, Multiplicand => w24,d_out => mult_res24, en_out => open);
  A25: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d25_in, Multiplicand => w25,d_out => mult_res25, en_out => open);
  A26: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d26_in, Multiplicand => w26,d_out => mult_res26, en_out => open);
  A27: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d27_in, Multiplicand => w27,d_out => mult_res27, en_out => open);
  A28: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d28_in, Multiplicand => w28,d_out => mult_res28, en_out => open);
  A29: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d29_in, Multiplicand => w29,d_out => mult_res29, en_out => open);
  A30: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d30_in, Multiplicand => w30,d_out => mult_res30, en_out => open);
  A31: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d31_in, Multiplicand => w31,d_out => mult_res31, en_out => open);
  A32: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d32_in, Multiplicand => w32,d_out => mult_res32, en_out => open);
end generate;

--  p_adders : process (clk)
--  begin
--    if rising_edge(clk) then
--      adder_1_01  <= (mult_res01(mult_res01'left) & mult_res01) + (mult_res33(mult_res33'left) & mult_res33);
--      adder_1_02  <= (mult_res02(mult_res02'left) & mult_res02) + (mult_res34(mult_res34'left) & mult_res34);
--      adder_1_03  <= (mult_res03(mult_res03'left) & mult_res03) + (mult_res35(mult_res35'left) & mult_res35);
--      adder_1_04  <= (mult_res04(mult_res04'left) & mult_res04) + (mult_res36(mult_res36'left) & mult_res36);
--      adder_1_05  <= (mult_res05(mult_res05'left) & mult_res05) + (mult_res37(mult_res37'left) & mult_res37);
--      adder_1_06  <= (mult_res06(mult_res06'left) & mult_res06) + (mult_res38(mult_res38'left) & mult_res38);
--      adder_1_07  <= (mult_res07(mult_res07'left) & mult_res07) + (mult_res39(mult_res39'left) & mult_res39);
--      adder_1_08  <= (mult_res08(mult_res08'left) & mult_res08) + (mult_res40(mult_res40'left) & mult_res40);
--      adder_1_09  <= (mult_res09(mult_res09'left) & mult_res09) + (mult_res41(mult_res41'left) & mult_res41);
--      adder_1_10  <= (mult_res10(mult_res10'left) & mult_res10) + (mult_res42(mult_res42'left) & mult_res42);
--      adder_1_11  <= (mult_res11(mult_res11'left) & mult_res11) + (mult_res43(mult_res43'left) & mult_res43);
--      adder_1_12  <= (mult_res12(mult_res12'left) & mult_res12) + (mult_res44(mult_res44'left) & mult_res44);
--      adder_1_13  <= (mult_res13(mult_res13'left) & mult_res13) + (mult_res45(mult_res45'left) & mult_res45);
--      adder_1_14  <= (mult_res14(mult_res14'left) & mult_res14) + (mult_res46(mult_res46'left) & mult_res46);
--      adder_1_15  <= (mult_res15(mult_res15'left) & mult_res15) + (mult_res47(mult_res47'left) & mult_res47);
--      adder_1_16  <= (mult_res16(mult_res16'left) & mult_res16) + (mult_res48(mult_res48'left) & mult_res48);
--      adder_1_17  <= (mult_res17(mult_res17'left) & mult_res17) + (mult_res49(mult_res49'left) & mult_res49);
--      adder_1_18  <= (mult_res18(mult_res18'left) & mult_res18) + (mult_res50(mult_res50'left) & mult_res50);
--      adder_1_19  <= (mult_res19(mult_res19'left) & mult_res19) + (mult_res51(mult_res51'left) & mult_res51);
--      adder_1_20  <= (mult_res20(mult_res20'left) & mult_res20) + (mult_res52(mult_res52'left) & mult_res52);
--      adder_1_21  <= (mult_res21(mult_res21'left) & mult_res21) + (mult_res53(mult_res53'left) & mult_res53);
--      adder_1_22  <= (mult_res22(mult_res22'left) & mult_res22) + (mult_res54(mult_res54'left) & mult_res54);
--      adder_1_23  <= (mult_res23(mult_res23'left) & mult_res23) + (mult_res55(mult_res55'left) & mult_res55);
--      adder_1_24  <= (mult_res24(mult_res24'left) & mult_res24) + (mult_res56(mult_res56'left) & mult_res56);
--      adder_1_25  <= (mult_res25(mult_res25'left) & mult_res25) + (mult_res57(mult_res57'left) & mult_res57);
--      adder_1_26  <= (mult_res26(mult_res26'left) & mult_res26) + (mult_res58(mult_res58'left) & mult_res58);
--      adder_1_27  <= (mult_res27(mult_res27'left) & mult_res27) + (mult_res59(mult_res59'left) & mult_res59);
--      adder_1_28  <= (mult_res28(mult_res28'left) & mult_res28) + (mult_res60(mult_res60'left) & mult_res60);
--      adder_1_29  <= (mult_res29(mult_res29'left) & mult_res29) + (mult_res61(mult_res61'left) & mult_res61);
--      adder_1_30  <= (mult_res30(mult_res30'left) & mult_res30) + (mult_res62(mult_res62'left) & mult_res62);
--      adder_1_31  <= (mult_res31(mult_res31'left) & mult_res31) + (mult_res63(mult_res63'left) & mult_res63);
--      adder_1_32  <= (mult_res32(mult_res32'left) & mult_res32) + (mult_res64(mult_res64'left) & mult_res64);
--
--      adder_2_01  <= (adder_1_01(adder_1_01'left) & adder_1_01) + (adder_1_17(adder_1_17'left) & adder_1_17);
--      adder_2_02  <= (adder_1_02(adder_1_02'left) & adder_1_02) + (adder_1_18(adder_1_18'left) & adder_1_18);
--      adder_2_03  <= (adder_1_03(adder_1_03'left) & adder_1_03) + (adder_1_19(adder_1_19'left) & adder_1_19);
--      adder_2_04  <= (adder_1_04(adder_1_04'left) & adder_1_04) + (adder_1_20(adder_1_20'left) & adder_1_20);
--      adder_2_05  <= (adder_1_05(adder_1_05'left) & adder_1_05) + (adder_1_21(adder_1_21'left) & adder_1_21);
--      adder_2_06  <= (adder_1_06(adder_1_06'left) & adder_1_06) + (adder_1_22(adder_1_22'left) & adder_1_22);
--      adder_2_07  <= (adder_1_07(adder_1_07'left) & adder_1_07) + (adder_1_23(adder_1_23'left) & adder_1_23);
--      adder_2_08  <= (adder_1_08(adder_1_08'left) & adder_1_08) + (adder_1_24(adder_1_24'left) & adder_1_24);
--      adder_2_09  <= (adder_1_09(adder_1_09'left) & adder_1_09) + (adder_1_25(adder_1_25'left) & adder_1_25);
--      adder_2_10  <= (adder_1_10(adder_1_10'left) & adder_1_10) + (adder_1_26(adder_1_26'left) & adder_1_26);
--      adder_2_11  <= (adder_1_11(adder_1_11'left) & adder_1_11) + (adder_1_27(adder_1_27'left) & adder_1_27);
--      adder_2_12  <= (adder_1_12(adder_1_12'left) & adder_1_12) + (adder_1_28(adder_1_28'left) & adder_1_28);
--      adder_2_13  <= (adder_1_13(adder_1_13'left) & adder_1_13) + (adder_1_29(adder_1_29'left) & adder_1_29);
--      adder_2_14  <= (adder_1_14(adder_1_14'left) & adder_1_14) + (adder_1_30(adder_1_30'left) & adder_1_30);
--      adder_2_15  <= (adder_1_15(adder_1_15'left) & adder_1_15) + (adder_1_31(adder_1_31'left) & adder_1_31);
--      adder_2_16  <= (adder_1_16(adder_1_16'left) & adder_1_16) + (adder_1_32(adder_1_32'left) & adder_1_32);
--
--      adder_3_01  <= (adder_2_01(adder_2_01'left) & adder_2_01) + (adder_2_09(adder_2_09'left) & adder_2_09);
--      adder_3_02  <= (adder_2_02(adder_2_02'left) & adder_2_02) + (adder_2_10(adder_2_10'left) & adder_2_10);
--      adder_3_03  <= (adder_2_03(adder_2_03'left) & adder_2_03) + (adder_2_11(adder_2_11'left) & adder_2_11);
--      adder_3_04  <= (adder_2_04(adder_2_04'left) & adder_2_04) + (adder_2_12(adder_2_12'left) & adder_2_12);
--      adder_3_05  <= (adder_2_05(adder_2_05'left) & adder_2_05) + (adder_2_13(adder_2_13'left) & adder_2_13);
--      adder_3_06  <= (adder_2_06(adder_2_06'left) & adder_2_06) + (adder_2_14(adder_2_14'left) & adder_2_14);
--      adder_3_07  <= (adder_2_07(adder_2_07'left) & adder_2_07) + (adder_2_15(adder_2_15'left) & adder_2_15);
--      adder_3_08  <= (adder_2_08(adder_2_08'left) & adder_2_08) + (adder_2_16(adder_2_16'left) & adder_2_16);
--
--      adder_4_01  <= (adder_3_01(adder_3_01'left) & adder_3_01) + (adder_3_05(adder_3_05'left) & adder_3_05);
--      adder_4_02  <= (adder_3_02(adder_3_02'left) & adder_3_02) + (adder_3_06(adder_3_06'left) & adder_3_06);
--      adder_4_03  <= (adder_3_03(adder_3_03'left) & adder_3_03) + (adder_3_07(adder_3_07'left) & adder_3_07);
--      adder_4_04  <= (adder_3_04(adder_3_04'left) & adder_3_04) + (adder_3_08(adder_3_08'left) & adder_3_08);
--
--      adder_5_01  <= (adder_4_01(adder_4_01'left) & adder_4_01) + (adder_4_03(adder_4_03'left) & adder_4_03);
--      adder_5_02  <= (adder_4_02(adder_4_02'left) & adder_4_02) + (adder_4_04(adder_4_04'left) & adder_4_04);
--
--      d_out       <= (adder_5_01(adder_5_01'left) & adder_5_01) + (adder_5_02(adder_5_02'left) & adder_5_02);
--    end if;
--  end process p_adders;

  p_adders : process (clk)
  begin
    if rising_edge(clk) then
      adder_1_01  <= (mult_res01(mult_res01'left) & mult_res01) 
                   + (mult_res02(mult_res02'left) & mult_res02) 
                   + (mult_res03(mult_res03'left) & mult_res03) 
                   + (mult_res04(mult_res04'left) & mult_res04) ;
      adder_1_05  <= (mult_res05(mult_res05'left) & mult_res05) 
                   + (mult_res06(mult_res06'left) & mult_res06) 
                   + (mult_res07(mult_res07'left) & mult_res07) 
                   + (mult_res08(mult_res08'left) & mult_res08) ;
      adder_1_09  <= (mult_res09(mult_res09'left) & mult_res09) 
                   + (mult_res10(mult_res10'left) & mult_res10) 
                   + (mult_res11(mult_res11'left) & mult_res11) 
                   + (mult_res12(mult_res12'left) & mult_res12) ;
      adder_1_13  <= (mult_res13(mult_res13'left) & mult_res13) 
                   + (mult_res14(mult_res14'left) & mult_res14) 
                   + (mult_res15(mult_res15'left) & mult_res15) 
                   + (mult_res16(mult_res16'left) & mult_res16) ;
      adder_1_17  <= (mult_res17(mult_res17'left) & mult_res17) 
                   + (mult_res18(mult_res18'left) & mult_res18) 
                   + (mult_res19(mult_res19'left) & mult_res19) 
                   + (mult_res20(mult_res20'left) & mult_res20) ;
      adder_1_21  <= (mult_res21(mult_res21'left) & mult_res21) 
                   + (mult_res22(mult_res22'left) & mult_res22) 
                   + (mult_res23(mult_res23'left) & mult_res23) 
                   + (mult_res24(mult_res24'left) & mult_res24) ;
      adder_1_25  <= (mult_res25(mult_res25'left) & mult_res25) 
                   + (mult_res26(mult_res26'left) & mult_res26) 
                   + (mult_res27(mult_res27'left) & mult_res27) 
                   + (mult_res28(mult_res28'left) & mult_res28) ;
      adder_1_29  <= (mult_res29(mult_res29'left) & mult_res29) 
                   + (mult_res30(mult_res30'left) & mult_res30) 
                   + (mult_res31(mult_res31'left) & mult_res31) 
                   + (mult_res32(mult_res32'left) & mult_res32) ;

      adder_2_01  <= (adder_1_01(adder_1_01'left) & adder_1_01) + (adder_1_17(adder_1_17'left) & adder_1_17)
      --adder_2_02  <= (adder_1_02(adder_1_02'left) & adder_1_02) + (adder_1_18(adder_1_18'left) & adder_1_18);
      --             + (adder_1_03(adder_1_03'left) & adder_1_03) + (adder_1_19(adder_1_19'left) & adder_1_19);
      --adder_2_04  <= (adder_1_04(adder_1_04'left) & adder_1_04) + (adder_1_20(adder_1_20'left) & adder_1_20);
                   + (adder_1_05(adder_1_05'left) & adder_1_05) + (adder_1_21(adder_1_21'left) & adder_1_21);
      --adder_2_06  <= (adder_1_06(adder_1_06'left) & adder_1_06) + (adder_1_22(adder_1_22'left) & adder_1_22);
       --            + (adder_1_07(adder_1_07'left) & adder_1_07) + (adder_1_23(adder_1_23'left) & adder_1_23);
      --adder_2_08  <= (adder_1_08(adder_1_08'left) & adder_1_08) + (adder_1_24(adder_1_24'left) & adder_1_24);
      adder_2_09  <= (adder_1_09(adder_1_09'left) & adder_1_09) + (adder_1_25(adder_1_25'left) & adder_1_25)
      --adder_2_10  <= (adder_1_10(adder_1_10'left) & adder_1_10) + (adder_1_26(adder_1_26'left) & adder_1_26);
      --             + (adder_1_11(adder_1_11'left) & adder_1_11) + (adder_1_27(adder_1_27'left) & adder_1_27);
      --adder_2_12  <= (adder_1_12(adder_1_12'left) & adder_1_12) + (adder_1_28(adder_1_28'left) & adder_1_28);
                   + (adder_1_13(adder_1_13'left) & adder_1_13) + (adder_1_29(adder_1_29'left) & adder_1_29);
      --adder_2_14  <= (adder_1_14(adder_1_14'left) & adder_1_14) + (adder_1_30(adder_1_30'left) & adder_1_30);
      --             + (adder_1_15(adder_1_15'left) & adder_1_15) + (adder_1_31(adder_1_31'left) & adder_1_31);
      --adder_2_16  <= (adder_1_16(adder_1_16'left) & adder_1_16) + (adder_1_32(adder_1_32'left) & adder_1_32);

      d_out(30 downto 0)       <= (adder_2_01(adder_2_01'left) & adder_2_01) + (adder_2_09(adder_2_09'left) & adder_2_09);
      --adder_3_02  <= (adder_2_02(adder_2_02'left) & adder_2_02) + (adder_2_10(adder_2_10'left) & adder_2_10);
      --adder_3_03  <= (adder_2_03(adder_2_03'left) & adder_2_03) + (adder_2_11(adder_2_11'left) & adder_2_11);
      --adder_3_04  <= (adder_2_04(adder_2_04'left) & adder_2_04) + (adder_2_12(adder_2_12'left) & adder_2_12);
      --             + (adder_2_05(adder_2_05'left) & adder_2_05) + (adder_2_13(adder_2_13'left) & adder_2_13);
      --adder_3_06  <= (adder_2_06(adder_2_06'left) & adder_2_06) + (adder_2_14(adder_2_14'left) & adder_2_14);
      --adder_3_07  <= (adder_2_07(adder_2_07'left) & adder_2_07) + (adder_2_15(adder_2_15'left) & adder_2_15);
      --adder_3_08  <= (adder_2_08(adder_2_08'left) & adder_2_08) + (adder_2_16(adder_2_16'left) & adder_2_16);

--      adder_4_01  <= (adder_3_01(adder_3_01'left) & adder_3_01) + (adder_3_05(adder_3_05'left) & adder_3_05);
--      adder_4_02  <= (adder_3_02(adder_3_02'left) & adder_3_02) + (adder_3_06(adder_3_06'left) & adder_3_06);
--      adder_4_03  <= (adder_3_03(adder_3_03'left) & adder_3_03) + (adder_3_07(adder_3_07'left) & adder_3_07);
--      adder_4_04  <= (adder_3_04(adder_3_04'left) & adder_3_04) + (adder_3_08(adder_3_08'left) & adder_3_08);
--
--      adder_5_01  <= (adder_4_01(adder_4_01'left) & adder_4_01) + (adder_4_03(adder_4_03'left) & adder_4_03);
--      adder_5_02  <= (adder_4_02(adder_4_02'left) & adder_4_02) + (adder_4_04(adder_4_04'left) & adder_4_04);
--
--      d_out       <= (adder_5_01(adder_5_01'left) & adder_5_01) + (adder_5_02(adder_5_02'left) & adder_5_02);
    end if;
  end process p_adders;


-- enable propagation

  p_en_prop : process (clk,rst)
  begin
    if rst = '1' then
      en_add1  <= '0';
      en_add2  <= '0';
      en_add3  <= '0';
      en_add4  <= '0';
      en_add5  <= '0';
      en_out   <= '0';
      sof_mult <= '0';
      sof_add1 <= '0';
      sof_add2 <= '0';
      sof_add3 <= '0';
      sof_add4 <= '0';
      sof_add5 <= '0';
      sof_out  <= '0';
    elsif rising_edge(clk) then
      en_add1 <= en_mult;
      en_add2 <= en_add1;
      en_add3 <= en_add2;
      en_add4 <= en_add3;
      en_add5 <= en_add4;
      en_out  <= en_add5;
      sof_mult <= sof_in     ;
      sof_add1 <= sof_mult;
      sof_add2 <= sof_add1;
      sof_add3 <= sof_add2;
      sof_add4 <= sof_add3;
      sof_add5 <= sof_add4;
      sof_out  <= sof_add5;
    end if;
  end process p_en_prop;

end a;