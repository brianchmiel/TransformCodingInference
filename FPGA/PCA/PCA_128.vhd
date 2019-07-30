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

entity PCA_128 is
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
           d33_in    : in std_logic_vector (N-1 downto 0);
           d34_in    : in std_logic_vector (N-1 downto 0);
           d35_in    : in std_logic_vector (N-1 downto 0);
           d36_in    : in std_logic_vector (N-1 downto 0);
           d37_in    : in std_logic_vector (N-1 downto 0);
           d38_in    : in std_logic_vector (N-1 downto 0);
           d39_in    : in std_logic_vector (N-1 downto 0);
           d40_in    : in std_logic_vector (N-1 downto 0);
           d41_in    : in std_logic_vector (N-1 downto 0);
           d42_in    : in std_logic_vector (N-1 downto 0);
           d43_in    : in std_logic_vector (N-1 downto 0);
           d44_in    : in std_logic_vector (N-1 downto 0);
           d45_in    : in std_logic_vector (N-1 downto 0);
           d46_in    : in std_logic_vector (N-1 downto 0);
           d47_in    : in std_logic_vector (N-1 downto 0);
           d48_in    : in std_logic_vector (N-1 downto 0);
           d49_in    : in std_logic_vector (N-1 downto 0);
           d50_in    : in std_logic_vector (N-1 downto 0);
           d51_in    : in std_logic_vector (N-1 downto 0);
           d52_in    : in std_logic_vector (N-1 downto 0);
           d53_in    : in std_logic_vector (N-1 downto 0);
           d54_in    : in std_logic_vector (N-1 downto 0);
           d55_in    : in std_logic_vector (N-1 downto 0);
           d56_in    : in std_logic_vector (N-1 downto 0);
           d57_in    : in std_logic_vector (N-1 downto 0);
           d58_in    : in std_logic_vector (N-1 downto 0);
           d59_in    : in std_logic_vector (N-1 downto 0);
           d60_in    : in std_logic_vector (N-1 downto 0);
           d61_in    : in std_logic_vector (N-1 downto 0);
           d62_in    : in std_logic_vector (N-1 downto 0);
           d63_in    : in std_logic_vector (N-1 downto 0);
           d64_in    : in std_logic_vector (N-1 downto 0);

           d65_in    : in std_logic_vector (N-1 downto 0);
           d66_in    : in std_logic_vector (N-1 downto 0);
           d67_in    : in std_logic_vector (N-1 downto 0);
           d68_in    : in std_logic_vector (N-1 downto 0);
           d69_in    : in std_logic_vector (N-1 downto 0);
           d70_in    : in std_logic_vector (N-1 downto 0);
           d71_in    : in std_logic_vector (N-1 downto 0);
           d72_in    : in std_logic_vector (N-1 downto 0);
           d73_in    : in std_logic_vector (N-1 downto 0);
           d74_in    : in std_logic_vector (N-1 downto 0);
           d75_in    : in std_logic_vector (N-1 downto 0);
           d76_in    : in std_logic_vector (N-1 downto 0);
           d77_in    : in std_logic_vector (N-1 downto 0);
           d78_in    : in std_logic_vector (N-1 downto 0);
           d79_in    : in std_logic_vector (N-1 downto 0);
           d80_in    : in std_logic_vector (N-1 downto 0);
           d81_in    : in std_logic_vector (N-1 downto 0);
           d82_in    : in std_logic_vector (N-1 downto 0);
           d83_in    : in std_logic_vector (N-1 downto 0);
           d84_in    : in std_logic_vector (N-1 downto 0);
           d85_in    : in std_logic_vector (N-1 downto 0);
           d86_in    : in std_logic_vector (N-1 downto 0);
           d87_in    : in std_logic_vector (N-1 downto 0);
           d88_in    : in std_logic_vector (N-1 downto 0);
           d89_in    : in std_logic_vector (N-1 downto 0);
           d90_in    : in std_logic_vector (N-1 downto 0);
           d91_in    : in std_logic_vector (N-1 downto 0);
           d92_in    : in std_logic_vector (N-1 downto 0);
           d93_in    : in std_logic_vector (N-1 downto 0);
           d94_in    : in std_logic_vector (N-1 downto 0);
           d95_in    : in std_logic_vector (N-1 downto 0);
           d96_in    : in std_logic_vector (N-1 downto 0);
           d97_in    : in std_logic_vector (N-1 downto 0);
           d98_in    : in std_logic_vector (N-1 downto 0);
           d99_in    : in std_logic_vector (N-1 downto 0);
           d100_in    : in std_logic_vector (N-1 downto 0);
           d101_in    : in std_logic_vector (N-1 downto 0);
           d102_in    : in std_logic_vector (N-1 downto 0);
           d103_in    : in std_logic_vector (N-1 downto 0);
           d104_in    : in std_logic_vector (N-1 downto 0);
           d105_in    : in std_logic_vector (N-1 downto 0);
           d106_in    : in std_logic_vector (N-1 downto 0);
           d107_in    : in std_logic_vector (N-1 downto 0);
           d108_in    : in std_logic_vector (N-1 downto 0);
           d109_in    : in std_logic_vector (N-1 downto 0);
           d110_in    : in std_logic_vector (N-1 downto 0);
           d111_in    : in std_logic_vector (N-1 downto 0);
           d112_in    : in std_logic_vector (N-1 downto 0);
           d113_in    : in std_logic_vector (N-1 downto 0);
           d114_in    : in std_logic_vector (N-1 downto 0);
           d115_in    : in std_logic_vector (N-1 downto 0);
           d116_in    : in std_logic_vector (N-1 downto 0);
           d117_in    : in std_logic_vector (N-1 downto 0);
           d118_in    : in std_logic_vector (N-1 downto 0);
           d119_in    : in std_logic_vector (N-1 downto 0);
           d120_in    : in std_logic_vector (N-1 downto 0);
           d121_in    : in std_logic_vector (N-1 downto 0);
           d122_in    : in std_logic_vector (N-1 downto 0);
           d123_in    : in std_logic_vector (N-1 downto 0);
           d124_in    : in std_logic_vector (N-1 downto 0);
           d125_in    : in std_logic_vector (N-1 downto 0);
           d126_in    : in std_logic_vector (N-1 downto 0);
           d127_in    : in std_logic_vector (N-1 downto 0);
           d128_in    : in std_logic_vector (N-1 downto 0);

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
           w33      : in std_logic_vector(M-1 downto 0); 
           w34      : in std_logic_vector(M-1 downto 0); 
           w35      : in std_logic_vector(M-1 downto 0); 
           w36      : in std_logic_vector(M-1 downto 0); 
           w37      : in std_logic_vector(M-1 downto 0); 
           w38      : in std_logic_vector(M-1 downto 0); 
           w39      : in std_logic_vector(M-1 downto 0); 
           w40      : in std_logic_vector(M-1 downto 0); 
           w41      : in std_logic_vector(M-1 downto 0); 
           w42      : in std_logic_vector(M-1 downto 0); 
           w43      : in std_logic_vector(M-1 downto 0); 
           w44      : in std_logic_vector(M-1 downto 0); 
           w45      : in std_logic_vector(M-1 downto 0); 
           w46      : in std_logic_vector(M-1 downto 0); 
           w47      : in std_logic_vector(M-1 downto 0); 
           w48      : in std_logic_vector(M-1 downto 0); 
           w49      : in std_logic_vector(M-1 downto 0); 
           w50      : in std_logic_vector(M-1 downto 0); 
           w51      : in std_logic_vector(M-1 downto 0); 
           w52      : in std_logic_vector(M-1 downto 0); 
           w53      : in std_logic_vector(M-1 downto 0); 
           w54      : in std_logic_vector(M-1 downto 0); 
           w55      : in std_logic_vector(M-1 downto 0); 
           w56      : in std_logic_vector(M-1 downto 0); 
           w57      : in std_logic_vector(M-1 downto 0); 
           w58      : in std_logic_vector(M-1 downto 0); 
           w59      : in std_logic_vector(M-1 downto 0); 
           w60      : in std_logic_vector(M-1 downto 0); 
           w61      : in std_logic_vector(M-1 downto 0); 
           w62      : in std_logic_vector(M-1 downto 0); 
           w63      : in std_logic_vector(M-1 downto 0); 
           w64      : in std_logic_vector(M-1 downto 0); 


           w65      : in std_logic_vector(M-1 downto 0); 
           w66      : in std_logic_vector(M-1 downto 0); 
           w67      : in std_logic_vector(M-1 downto 0); 
           w68      : in std_logic_vector(M-1 downto 0); 
           w69      : in std_logic_vector(M-1 downto 0); 
           w70      : in std_logic_vector(M-1 downto 0); 
           w71      : in std_logic_vector(M-1 downto 0); 
           w72      : in std_logic_vector(M-1 downto 0); 
           w73      : in std_logic_vector(M-1 downto 0); 
           w74      : in std_logic_vector(M-1 downto 0); 
           w75      : in std_logic_vector(M-1 downto 0); 
           w76      : in std_logic_vector(M-1 downto 0); 
           w77      : in std_logic_vector(M-1 downto 0); 
           w78      : in std_logic_vector(M-1 downto 0); 
           w79      : in std_logic_vector(M-1 downto 0); 
           w80      : in std_logic_vector(M-1 downto 0); 
           w81      : in std_logic_vector(M-1 downto 0); 
           w82      : in std_logic_vector(M-1 downto 0); 
           w83      : in std_logic_vector(M-1 downto 0); 
           w84      : in std_logic_vector(M-1 downto 0); 
           w85      : in std_logic_vector(M-1 downto 0); 
           w86      : in std_logic_vector(M-1 downto 0); 
           w87      : in std_logic_vector(M-1 downto 0); 
           w88      : in std_logic_vector(M-1 downto 0); 
           w89      : in std_logic_vector(M-1 downto 0); 
           w90      : in std_logic_vector(M-1 downto 0); 
           w91      : in std_logic_vector(M-1 downto 0); 
           w92      : in std_logic_vector(M-1 downto 0); 
           w93      : in std_logic_vector(M-1 downto 0); 
           w94      : in std_logic_vector(M-1 downto 0); 
           w95      : in std_logic_vector(M-1 downto 0); 
           w96      : in std_logic_vector(M-1 downto 0); 
           w97      : in std_logic_vector(M-1 downto 0); 
           w98      : in std_logic_vector(M-1 downto 0); 
           w99      : in std_logic_vector(M-1 downto 0); 
           w100      : in std_logic_vector(M-1 downto 0); 
           w101      : in std_logic_vector(M-1 downto 0); 
           w102      : in std_logic_vector(M-1 downto 0); 
           w103      : in std_logic_vector(M-1 downto 0); 
           w104      : in std_logic_vector(M-1 downto 0); 
           w105      : in std_logic_vector(M-1 downto 0); 
           w106      : in std_logic_vector(M-1 downto 0); 
           w107      : in std_logic_vector(M-1 downto 0); 
           w108      : in std_logic_vector(M-1 downto 0); 
           w109      : in std_logic_vector(M-1 downto 0); 
           w110      : in std_logic_vector(M-1 downto 0); 
           w111      : in std_logic_vector(M-1 downto 0); 
           w112      : in std_logic_vector(M-1 downto 0); 
           w113      : in std_logic_vector(M-1 downto 0); 
           w114      : in std_logic_vector(M-1 downto 0); 
           w115      : in std_logic_vector(M-1 downto 0); 
           w116      : in std_logic_vector(M-1 downto 0); 
           w117      : in std_logic_vector(M-1 downto 0); 
           w118      : in std_logic_vector(M-1 downto 0); 
           w119      : in std_logic_vector(M-1 downto 0); 
           w120      : in std_logic_vector(M-1 downto 0); 
           w121      : in std_logic_vector(M-1 downto 0); 
           w122      : in std_logic_vector(M-1 downto 0); 
           w123      : in std_logic_vector(M-1 downto 0); 
           w124      : in std_logic_vector(M-1 downto 0); 
           w125      : in std_logic_vector(M-1 downto 0); 
           w126      : in std_logic_vector(M-1 downto 0); 
           w127      : in std_logic_vector(M-1 downto 0); 
           w128      : in std_logic_vector(M-1 downto 0); 
           d_out   : out std_logic_vector (N + M + 5 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end PCA_128;

architecture a of PCA_128 is

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

signal mult_res    : std_logic_vector (N + M - 1 downto 0);
signal accumulator : std_logic_vector (N + M + 5 downto 0);

type t_acc is array (0 to 128-1) of std_logic_vector(N + M + 5  downto 0);
signal accumulator_vec  : t_acc;


signal en_mult, en_add1, en_add2, en_add3, en_add4, en_add5 : std_logic;
signal sof_mult, sof_add1, sof_add2, sof_add3, sof_add4, sof_add5 : std_logic;

signal d_active           : std_logic_vector (N-1 downto 0);
signal w_active           : std_logic_vector (M-1 downto 0); 
signal feature_sw         : std_logic_vector (  6 downto 0);
signal feature_sw_int     : integer;

begin

feature_sw_int <= conv_integer('0' & feature_sw);

  switch : process (clk,rst)
  begin
    if rst = '1' then
       feature_sw  <= (others => '0');
       d_active    <= (others => '0');
       w_active    <= (others => '0');
    elsif rising_edge(clk) then
       if en_in = '1' then
          feature_sw <= feature_sw + 1;
        case feature_sw_int is
          when   0 => d_active <= d01_in ; w_active <= w01 ;
          when   1 => d_active <= d02_in ; w_active <= w02 ;
          when   2 => d_active <= d03_in ; w_active <= w03 ;
          when   3 => d_active <= d04_in ; w_active <= w04 ;
          when   4 => d_active <= d05_in ; w_active <= w05 ;
          when   5 => d_active <= d06_in ; w_active <= w06 ;
          when   6 => d_active <= d07_in ; w_active <= w07 ;
          when   7 => d_active <= d08_in ; w_active <= w08 ;
          when   8 => d_active <= d09_in ; w_active <= w09 ;
          when   9 => d_active <= d10_in ; w_active <= w10 ;
          when  10 => d_active <= d11_in ; w_active <= w11 ;
          when  11 => d_active <= d12_in ; w_active <= w12 ;
          when  12 => d_active <= d13_in ; w_active <= w13 ;
          when  13 => d_active <= d14_in ; w_active <= w14 ;
          when  14 => d_active <= d15_in ; w_active <= w15 ;
          when  15 => d_active <= d16_in ; w_active <= w16 ;
          when  16 => d_active <= d17_in ; w_active <= w17 ;
          when  17 => d_active <= d18_in ; w_active <= w18 ;
          when  18 => d_active <= d19_in ; w_active <= w19 ;
          when  19 => d_active <= d20_in ; w_active <= w20 ;
          when  20 => d_active <= d21_in ; w_active <= w21 ;
          when  21 => d_active <= d22_in ; w_active <= w22 ;
          when  22 => d_active <= d23_in ; w_active <= w23 ;
          when  23 => d_active <= d24_in ; w_active <= w24 ;
          when  24 => d_active <= d25_in ; w_active <= w25 ;
          when  25 => d_active <= d26_in ; w_active <= w26 ;
          when  26 => d_active <= d27_in ; w_active <= w27 ;
          when  27 => d_active <= d28_in ; w_active <= w28 ;
          when  28 => d_active <= d29_in ; w_active <= w29 ;
          when  29 => d_active <= d30_in ; w_active <= w30 ;
          when  30 => d_active <= d31_in ; w_active <= w31 ;
          when  31 => d_active <= d32_in ; w_active <= w32 ;
          when  32 => d_active <= d33_in ; w_active <= w33 ;
          when  33 => d_active <= d34_in ; w_active <= w34 ;
          when  34 => d_active <= d35_in ; w_active <= w35 ;
          when  35 => d_active <= d36_in ; w_active <= w36 ;
          when  36 => d_active <= d37_in ; w_active <= w37 ;
          when  37 => d_active <= d38_in ; w_active <= w38 ;
          when  38 => d_active <= d39_in ; w_active <= w39 ;
          when  39 => d_active <= d40_in ; w_active <= w40 ;
          when  40 => d_active <= d41_in ; w_active <= w41 ;
          when  41 => d_active <= d42_in ; w_active <= w42 ;
          when  42 => d_active <= d43_in ; w_active <= w43 ;
          when  43 => d_active <= d44_in ; w_active <= w44 ;
          when  44 => d_active <= d45_in ; w_active <= w45 ;
          when  45 => d_active <= d46_in ; w_active <= w46 ;
          when  46 => d_active <= d47_in ; w_active <= w47 ;
          when  47 => d_active <= d48_in ; w_active <= w48 ;
          when  48 => d_active <= d49_in ; w_active <= w49 ;
          when  49 => d_active <= d50_in ; w_active <= w50 ;
          when  50 => d_active <= d51_in ; w_active <= w51 ;
          when  51 => d_active <= d52_in ; w_active <= w52 ;
          when  52 => d_active <= d53_in ; w_active <= w53 ;
          when  53 => d_active <= d54_in ; w_active <= w54 ;
          when  54 => d_active <= d55_in ; w_active <= w55 ;
          when  55 => d_active <= d56_in ; w_active <= w56 ;
          when  56 => d_active <= d57_in ; w_active <= w57 ;
          when  57 => d_active <= d58_in ; w_active <= w58 ;
          when  58 => d_active <= d59_in ; w_active <= w59 ;
          when  59 => d_active <= d60_in ; w_active <= w60 ;
          when  60 => d_active <= d61_in ; w_active <= w61 ;
          when  61 => d_active <= d62_in ; w_active <= w62 ;
          when  62 => d_active <= d63_in ; w_active <= w63 ;
          when  63 => d_active <= d64_in ; w_active <= w64 ;
          when  64 => d_active <= d65_in ; w_active <= w65 ;
          when  65 => d_active <= d66_in ; w_active <= w66 ;
          when  66 => d_active <= d67_in ; w_active <= w67 ;
          when  67 => d_active <= d68_in ; w_active <= w68 ;
          when  68 => d_active <= d69_in ; w_active <= w69 ;
          when  69 => d_active <= d70_in ; w_active <= w70 ;
          when  70 => d_active <= d71_in ; w_active <= w71 ;
          when  71 => d_active <= d72_in ; w_active <= w72 ;
          when  72 => d_active <= d73_in ; w_active <= w73 ;
          when  73 => d_active <= d74_in ; w_active <= w74 ;
          when  74 => d_active <= d75_in ; w_active <= w75 ;
          when  75 => d_active <= d76_in ; w_active <= w76 ;
          when  76 => d_active <= d77_in ; w_active <= w77 ;
          when  77 => d_active <= d78_in ; w_active <= w78 ;
          when  78 => d_active <= d79_in ; w_active <= w79 ;
          when  79 => d_active <= d80_in ; w_active <= w80 ;
          when  80 => d_active <= d81_in ; w_active <= w81 ;
          when  81 => d_active <= d82_in ; w_active <= w82 ;
          when  82 => d_active <= d83_in ; w_active <= w83 ;
          when  83 => d_active <= d84_in ; w_active <= w84 ;
          when  84 => d_active <= d85_in ; w_active <= w85 ;
          when  85 => d_active <= d86_in ; w_active <= w86 ;
          when  86 => d_active <= d87_in ; w_active <= w87 ;
          when  87 => d_active <= d88_in ; w_active <= w88 ;
          when  88 => d_active <= d89_in ; w_active <= w89 ;
          when  89 => d_active <= d90_in ; w_active <= w90 ;
          when  90 => d_active <= d91_in ; w_active <= w91 ;
          when  91 => d_active <= d92_in ; w_active <= w92 ;
          when  92 => d_active <= d93_in ; w_active <= w93 ;
          when  93 => d_active <= d94_in ; w_active <= w94 ;
          when  94 => d_active <= d95_in ; w_active <= w95 ;
          when  95 => d_active <= d96_in ; w_active <= w96 ;
          when  96 => d_active <= d97_in ; w_active <= w97 ;
          when  97 => d_active <= d98_in ; w_active <= w98 ;
          when  98 => d_active <= d99_in ; w_active <= w99 ;
          when  99 => d_active <= d100_in; w_active <= w100;
          when 100 => d_active <= d101_in; w_active <= w101;
          when 101 => d_active <= d102_in; w_active <= w102;
          when 102 => d_active <= d103_in; w_active <= w103;
          when 103 => d_active <= d104_in; w_active <= w104;
          when 104 => d_active <= d105_in; w_active <= w105;
          when 105 => d_active <= d106_in; w_active <= w106;
          when 106 => d_active <= d107_in; w_active <= w107;
          when 107 => d_active <= d108_in; w_active <= w108;
          when 108 => d_active <= d109_in; w_active <= w109;
          when 109 => d_active <= d110_in; w_active <= w110;
          when 110 => d_active <= d111_in; w_active <= w111;
          when 111 => d_active <= d112_in; w_active <= w112;
          when 112 => d_active <= d113_in; w_active <= w113;
          when 113 => d_active <= d114_in; w_active <= w114;
          when 114 => d_active <= d115_in; w_active <= w115;
          when 115 => d_active <= d116_in; w_active <= w116;
          when 116 => d_active <= d117_in; w_active <= w117;
          when 117 => d_active <= d118_in; w_active <= w118;
          when 118 => d_active <= d119_in; w_active <= w119;
          when 119 => d_active <= d120_in; w_active <= w120;
          when 120 => d_active <= d121_in; w_active <= w121;
          when 121 => d_active <= d122_in; w_active <= w122;
          when 122 => d_active <= d123_in; w_active <= w123;
          when 123 => d_active <= d124_in; w_active <= w124;
          when 124 => d_active <= d125_in; w_active <= w125;
          when 125 => d_active <= d126_in; w_active <= w126;
          when 126 => d_active <= d127_in; w_active <= w127;
          when 127 => d_active <= d128_in; w_active <= w128;
          when others => null;
          end case;
       end if;
    end if; 
 end process switch;

gen_Mults: if mult_sum = "mult" generate 
-- multiplication
  p_mul1 : process (clk)
  begin
    if rising_edge(clk) then
         mult_res <=  d_active * w_active;
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
A01: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => en_in, Multiplier => d_active, Multiplicand => w_active,d_out => mult_res, en_out => en_mult);
end generate;

    p_acc : process (clk,rst)
  begin
    if rst = '1' then
       --accumulator_vec <= (others => (others => '0'));
       accumulator    <= (others => '0');
       d_out          <= (others => '0');
    elsif rising_edge(clk) then
          --accumulator_vec(conv_integer('0' & feature_sw))  <= accumulator_vec(conv_integer('0' & feature_sw))  + ("000000" & mult_res);
          --d_out        <= accumulator_vec(conv_integer('0' & feature_sw));
          en_out      <= '1'; 
          accumulator <= accumulator  + ("000000" & mult_res);
          d_out       <= accumulator;
    end if;
  end process p_acc;


-- enable propagation

--  p_en_prop : process (clk,rst)
--  begin
--    if rst = '1' then
--      en_add1  <= '0';
--      en_add2  <= '0';
--      en_add3  <= '0';
--      en_add4  <= '0';
--      en_add5  <= '0';
--      en_out   <= '0';
--      sof_mult <= '0';
--      sof_add1 <= '0';
--      sof_add2 <= '0';
--      sof_add3 <= '0';
--      sof_add4 <= '0';
--      sof_add5 <= '0';
--      sof_out  <= '0';
--    elsif rising_edge(clk) then
--      en_add1 <= en_mult;
--      en_add2 <= en_add1;
--      en_add3 <= en_add2;
--      en_add4 <= en_add3;
--      en_add5 <= en_add4;
--      en_out  <= en_add5;
--      sof_mult <= sof_in     ;
--      sof_add1 <= sof_mult;
--      sof_add2 <= sof_add1;
--      sof_add3 <= sof_add2;
--      sof_add4 <= sof_add3;
--      sof_add5 <= sof_add4;
--      sof_out  <= sof_add5;
--    end if;
--  end process p_en_prop;

end a;