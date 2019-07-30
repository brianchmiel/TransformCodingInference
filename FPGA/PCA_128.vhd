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


 
signal mult_res01, mult_res65   : std_logic_vector(N+M-1 downto 0);
signal mult_res02, mult_res66   : std_logic_vector(N+M-1 downto 0);
signal mult_res03, mult_res67   : std_logic_vector(N+M-1 downto 0);
signal mult_res04, mult_res68   : std_logic_vector(N+M-1 downto 0);
signal mult_res05, mult_res69   : std_logic_vector(N+M-1 downto 0);
signal mult_res06, mult_res70   : std_logic_vector(N+M-1 downto 0);
signal mult_res07, mult_res71   : std_logic_vector(N+M-1 downto 0);
signal mult_res08, mult_res72   : std_logic_vector(N+M-1 downto 0);
signal mult_res09, mult_res73   : std_logic_vector(N+M-1 downto 0);
signal mult_res10, mult_res74   : std_logic_vector(N+M-1 downto 0);
signal mult_res11, mult_res75   : std_logic_vector(N+M-1 downto 0);
signal mult_res12, mult_res76   : std_logic_vector(N+M-1 downto 0);
signal mult_res13, mult_res77   : std_logic_vector(N+M-1 downto 0);
signal mult_res14, mult_res78   : std_logic_vector(N+M-1 downto 0);
signal mult_res15, mult_res79   : std_logic_vector(N+M-1 downto 0);
signal mult_res16, mult_res80   : std_logic_vector(N+M-1 downto 0);
signal mult_res17, mult_res81   : std_logic_vector(N+M-1 downto 0);
signal mult_res18, mult_res82   : std_logic_vector(N+M-1 downto 0);
signal mult_res19, mult_res83   : std_logic_vector(N+M-1 downto 0);
signal mult_res20, mult_res84   : std_logic_vector(N+M-1 downto 0);
signal mult_res21, mult_res85   : std_logic_vector(N+M-1 downto 0);
signal mult_res22, mult_res86   : std_logic_vector(N+M-1 downto 0);
signal mult_res23, mult_res87   : std_logic_vector(N+M-1 downto 0);
signal mult_res24, mult_res88   : std_logic_vector(N+M-1 downto 0);
signal mult_res25, mult_res89   : std_logic_vector(N+M-1 downto 0);
signal mult_res26, mult_res90   : std_logic_vector(N+M-1 downto 0);
signal mult_res27, mult_res91   : std_logic_vector(N+M-1 downto 0);
signal mult_res28, mult_res92   : std_logic_vector(N+M-1 downto 0);
signal mult_res29, mult_res93   : std_logic_vector(N+M-1 downto 0);
signal mult_res30, mult_res94   : std_logic_vector(N+M-1 downto 0);
signal mult_res31, mult_res95   : std_logic_vector(N+M-1 downto 0);
signal mult_res32, mult_res96   : std_logic_vector(N+M-1 downto 0);
signal mult_res33, mult_res97   : std_logic_vector(N+M-1 downto 0);
signal mult_res34, mult_res98   : std_logic_vector(N+M-1 downto 0);
signal mult_res35, mult_res99   : std_logic_vector(N+M-1 downto 0);
signal mult_res36, mult_res100  : std_logic_vector(N+M-1 downto 0);
signal mult_res37, mult_res101  : std_logic_vector(N+M-1 downto 0);
signal mult_res38, mult_res102  : std_logic_vector(N+M-1 downto 0);
signal mult_res39, mult_res103  : std_logic_vector(N+M-1 downto 0);
signal mult_res40, mult_res104  : std_logic_vector(N+M-1 downto 0);
signal mult_res41, mult_res105  : std_logic_vector(N+M-1 downto 0);
signal mult_res42, mult_res106  : std_logic_vector(N+M-1 downto 0);
signal mult_res43, mult_res107  : std_logic_vector(N+M-1 downto 0);
signal mult_res44, mult_res108  : std_logic_vector(N+M-1 downto 0);
signal mult_res45, mult_res109  : std_logic_vector(N+M-1 downto 0);
signal mult_res46, mult_res110  : std_logic_vector(N+M-1 downto 0);
signal mult_res47, mult_res111  : std_logic_vector(N+M-1 downto 0);
signal mult_res48, mult_res112  : std_logic_vector(N+M-1 downto 0);
signal mult_res49, mult_res113  : std_logic_vector(N+M-1 downto 0);
signal mult_res50, mult_res114  : std_logic_vector(N+M-1 downto 0);
signal mult_res51, mult_res115  : std_logic_vector(N+M-1 downto 0);
signal mult_res52, mult_res116  : std_logic_vector(N+M-1 downto 0);
signal mult_res53, mult_res117  : std_logic_vector(N+M-1 downto 0);
signal mult_res54, mult_res118  : std_logic_vector(N+M-1 downto 0);
signal mult_res55, mult_res119  : std_logic_vector(N+M-1 downto 0);
signal mult_res56, mult_res120  : std_logic_vector(N+M-1 downto 0);
signal mult_res57, mult_res121  : std_logic_vector(N+M-1 downto 0);
signal mult_res58, mult_res122  : std_logic_vector(N+M-1 downto 0);
signal mult_res59, mult_res123  : std_logic_vector(N+M-1 downto 0);
signal mult_res60, mult_res124  : std_logic_vector(N+M-1 downto 0);
signal mult_res61, mult_res125  : std_logic_vector(N+M-1 downto 0);
signal mult_res62, mult_res126  : std_logic_vector(N+M-1 downto 0);
signal mult_res63, mult_res127  : std_logic_vector(N+M-1 downto 0);
signal mult_res64, mult_res128  : std_logic_vector(N+M-1 downto 0);

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

signal adder_1_33,  adder_1_34,  adder_1_35,  adder_1_36,  adder_1_37,  adder_1_38,  adder_1_39,  adder_1_40,  adder_1_41,  adder_1_42,  adder_1_43, adder_1_44, adder_1_45, adder_1_46, adder_1_47, adder_1_48 : std_logic_vector (N + M downto 0);


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

signal adder_2_17, adder_2_18, adder_2_19, adder_2_20 : std_logic_vector (N + M + 1 downto 0);


signal adder_3_01         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_02         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_03         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_04         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_05         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_06         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_07         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_08         : std_logic_vector (N + M + 2 downto 0);

signal adder_3_09         : std_logic_vector (N + M + 2 downto 0);

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
         mult_res32 <=  d32_in * w32;
         mult_res33 <=  d33_in * w33;
         mult_res34 <=  d34_in * w34;
         mult_res35 <=  d35_in * w35;
         mult_res36 <=  d36_in * w36;
         mult_res37 <=  d37_in * w37;
         mult_res38 <=  d38_in * w38;
         mult_res39 <=  d39_in * w39;
         mult_res40 <=  d40_in * w40;
         mult_res41 <=  d41_in * w41;
         mult_res42 <=  d42_in * w42;
         mult_res43 <=  d43_in * w43;
         mult_res44 <=  d44_in * w44;
         mult_res45 <=  d45_in * w45;
         mult_res46 <=  d46_in * w46;
         mult_res47 <=  d47_in * w47;
         mult_res48 <=  d48_in * w48;
         mult_res49 <=  d49_in * w49;
         mult_res50 <=  d50_in * w50;
         mult_res51 <=  d51_in * w51;
         mult_res52 <=  d52_in * w52;
         mult_res53 <=  d53_in * w53;
         mult_res54 <=  d54_in * w54;
         mult_res55 <=  d55_in * w55;
         mult_res56 <=  d56_in * w56;
         mult_res57 <=  d57_in * w57;
         mult_res58 <=  d58_in * w58;
         mult_res59 <=  d59_in * w59;
         mult_res60 <=  d60_in * w60;
         mult_res61 <=  d61_in * w61;
         mult_res62 <=  d62_in * w62;
         mult_res63 <=  d63_in * w63;
         mult_res64 <=  d64_in * w64;

         mult_res65  <=  d65_in  * w65 ;
         mult_res66  <=  d66_in  * w66 ;
         mult_res67  <=  d67_in  * w67 ;
         mult_res68  <=  d68_in  * w68 ;
         mult_res69  <=  d69_in  * w69 ;
         mult_res70  <=  d70_in  * w70 ;
         mult_res71  <=  d71_in  * w71 ;
         mult_res72  <=  d72_in  * w72 ;
         mult_res73  <=  d73_in  * w73 ;
         mult_res74  <=  d74_in  * w74 ;
         mult_res75  <=  d75_in  * w75 ;
         mult_res76  <=  d76_in  * w76 ;
         mult_res77  <=  d77_in  * w77 ;
         mult_res78  <=  d78_in  * w78 ;
         mult_res79  <=  d79_in  * w79 ;
         mult_res80  <=  d80_in  * w80 ;
         mult_res81  <=  d81_in  * w81 ;
         mult_res82  <=  d82_in  * w82 ;
         mult_res83  <=  d83_in  * w83 ;
         mult_res84  <=  d84_in  * w84 ;
         mult_res85  <=  d85_in  * w85 ;
         mult_res86  <=  d86_in  * w86 ;
         mult_res87  <=  d87_in  * w87 ;
         mult_res88  <=  d88_in  * w88 ;
         mult_res89  <=  d89_in  * w89 ;
         mult_res90  <=  d90_in  * w90 ;
         mult_res91  <=  d91_in  * w91 ;
         mult_res92  <=  d92_in  * w92 ;
         mult_res93  <=  d93_in  * w93 ;
         mult_res94  <=  d94_in  * w94 ;
         mult_res95  <=  d95_in  * w95 ;
         mult_res96  <=  d96_in  * w96 ;
         mult_res97  <=  d97_in  * w97 ;
         mult_res98  <=  d98_in  * w98 ;
         mult_res99  <=  d99_in  * w99 ;
         mult_res100 <=  d100_in * w100;
         mult_res101 <=  d101_in * w101;
         mult_res102 <=  d102_in * w102;
         mult_res103 <=  d103_in * w103;
         mult_res104 <=  d104_in * w104;
         mult_res105 <=  d105_in * w105;
         mult_res106 <=  d106_in * w106;
         mult_res107 <=  d107_in * w107;
         mult_res108 <=  d108_in * w108;
         mult_res109 <=  d109_in * w109;
         mult_res110 <=  d110_in * w110;
         mult_res111 <=  d111_in * w111;
         mult_res112 <=  d112_in * w112;
         mult_res113 <=  d113_in * w113;
         mult_res114 <=  d114_in * w114;
         mult_res115 <=  d115_in * w115;
         mult_res116 <=  d116_in * w116;
         mult_res117 <=  d117_in * w117;
         mult_res118 <=  d118_in * w118;
         mult_res119 <=  d119_in * w119;
         mult_res120 <=  d120_in * w120;
         mult_res121 <=  d121_in * w121;
         mult_res122 <=  d122_in * w122;
         mult_res123 <=  d123_in * w123;
         mult_res124 <=  d124_in * w124;
         mult_res125 <=  d125_in * w125;
         mult_res126 <=  d126_in * w126;
         mult_res127 <=  d127_in * w127;
         mult_res128 <=  d128_in * w128;
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
  A33: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d33_in, Multiplicand => w33,d_out => mult_res33, en_out => open);
  A34: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d34_in, Multiplicand => w34,d_out => mult_res34, en_out => open);
  A35: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d35_in, Multiplicand => w35,d_out => mult_res35, en_out => open);
  A36: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d36_in, Multiplicand => w36,d_out => mult_res36, en_out => open);
  A37: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d37_in, Multiplicand => w37,d_out => mult_res37, en_out => open);
  A38: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d38_in, Multiplicand => w38,d_out => mult_res38, en_out => open);
  A39: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d39_in, Multiplicand => w39,d_out => mult_res39, en_out => open);
  A40: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d40_in, Multiplicand => w40,d_out => mult_res40, en_out => open);
  A41: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d41_in, Multiplicand => w41,d_out => mult_res41, en_out => open);
  A42: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d42_in, Multiplicand => w42,d_out => mult_res42, en_out => open);
  A43: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d43_in, Multiplicand => w43,d_out => mult_res43, en_out => open);
  A44: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d44_in, Multiplicand => w44,d_out => mult_res44, en_out => open);
  A45: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d45_in, Multiplicand => w45,d_out => mult_res45, en_out => open);
  A46: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d46_in, Multiplicand => w46,d_out => mult_res46, en_out => open);
  A47: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d47_in, Multiplicand => w47,d_out => mult_res47, en_out => open);
  A48: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d48_in, Multiplicand => w48,d_out => mult_res48, en_out => open);
  A49: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d49_in, Multiplicand => w49,d_out => mult_res49, en_out => open);
  A50: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d50_in, Multiplicand => w50,d_out => mult_res50, en_out => open);
  A51: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d51_in, Multiplicand => w51,d_out => mult_res51, en_out => open);
  A52: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d52_in, Multiplicand => w52,d_out => mult_res52, en_out => open);
  A53: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d53_in, Multiplicand => w53,d_out => mult_res53, en_out => open);
  A54: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d54_in, Multiplicand => w54,d_out => mult_res54, en_out => open);
  A55: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d55_in, Multiplicand => w55,d_out => mult_res55, en_out => open);
  A56: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d56_in, Multiplicand => w56,d_out => mult_res56, en_out => open);
  A57: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d57_in, Multiplicand => w57,d_out => mult_res57, en_out => open);
  A58: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d58_in, Multiplicand => w58,d_out => mult_res58, en_out => open);
  A59: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d59_in, Multiplicand => w59,d_out => mult_res59, en_out => open);
  A60: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d60_in, Multiplicand => w60,d_out => mult_res60, en_out => open);
  A61: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d61_in, Multiplicand => w61,d_out => mult_res61, en_out => open);
  A62: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d62_in, Multiplicand => w62,d_out => mult_res62, en_out => open);
  A63: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d63_in, Multiplicand => w63,d_out => mult_res63, en_out => open);
  A64: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d64_in, Multiplicand => w64,d_out => mult_res64, en_out => open);


  A65 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d65_in,  Multiplicand => w65, d_out => mult_res65,  en_out => open);
  A66 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d66_in,  Multiplicand => w66, d_out => mult_res66,  en_out => open);
  A67 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d67_in,  Multiplicand => w67, d_out => mult_res67,  en_out => open);
  A68 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d68_in,  Multiplicand => w68, d_out => mult_res68,  en_out => open);
  A69 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d69_in,  Multiplicand => w69, d_out => mult_res69,  en_out => open);
  A70 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d70_in,  Multiplicand => w70, d_out => mult_res70,  en_out => open);
  A71 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d71_in,  Multiplicand => w71, d_out => mult_res71,  en_out => open);
  A72 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d72_in,  Multiplicand => w72, d_out => mult_res72,  en_out => open);
  A73 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d73_in,  Multiplicand => w73, d_out => mult_res73,  en_out => open);
  A74 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d74_in,  Multiplicand => w74, d_out => mult_res74,  en_out => open);
  A75 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d75_in,  Multiplicand => w75, d_out => mult_res75,  en_out => open);
  A76 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d76_in,  Multiplicand => w76, d_out => mult_res76,  en_out => open);
  A77 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d77_in,  Multiplicand => w77, d_out => mult_res77,  en_out => open);
  A78 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d78_in,  Multiplicand => w78, d_out => mult_res78,  en_out => open);
  A79 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d79_in,  Multiplicand => w79, d_out => mult_res79,  en_out => open);
  A80 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d80_in,  Multiplicand => w80, d_out => mult_res80,  en_out => open);
  A81 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d81_in,  Multiplicand => w81, d_out => mult_res81,  en_out => open);
  A82 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d82_in,  Multiplicand => w82, d_out => mult_res82,  en_out => open);
  A83 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d83_in,  Multiplicand => w83, d_out => mult_res83,  en_out => open);
  A84 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d84_in,  Multiplicand => w84, d_out => mult_res84,  en_out => open);
  A85 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d85_in,  Multiplicand => w85, d_out => mult_res85,  en_out => open);
  A86 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d86_in,  Multiplicand => w86, d_out => mult_res86,  en_out => open);
  A87 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d87_in,  Multiplicand => w87, d_out => mult_res87,  en_out => open);
  A88 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d88_in,  Multiplicand => w88, d_out => mult_res88,  en_out => open);
  A89 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d89_in,  Multiplicand => w89, d_out => mult_res89,  en_out => open);
  A90 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d90_in,  Multiplicand => w90, d_out => mult_res90,  en_out => open);
  A91 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d91_in,  Multiplicand => w91, d_out => mult_res91,  en_out => open);
  A92 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d92_in,  Multiplicand => w92, d_out => mult_res92,  en_out => open);
  A93 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d93_in,  Multiplicand => w93, d_out => mult_res93,  en_out => open);
  A94 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d94_in,  Multiplicand => w94, d_out => mult_res94,  en_out => open);
  A95 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d95_in,  Multiplicand => w95, d_out => mult_res95,  en_out => open);
  A96 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d96_in,  Multiplicand => w96, d_out => mult_res96,  en_out => open);
  A97 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d97_in,  Multiplicand => w97, d_out => mult_res97,  en_out => open);
  A98 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d98_in,  Multiplicand => w98, d_out => mult_res98,  en_out => open);
  A99 : Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d99_in,  Multiplicand => w99, d_out => mult_res99,  en_out => open);
  A100: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d100_in, Multiplicand => w100,d_out => mult_res100, en_out => open);
  A101: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d101_in, Multiplicand => w101,d_out => mult_res101, en_out => open);
  A102: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d102_in, Multiplicand => w102,d_out => mult_res102, en_out => open);
  A103: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d103_in, Multiplicand => w103,d_out => mult_res103, en_out => open);
  A104: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d104_in, Multiplicand => w104,d_out => mult_res104, en_out => open);
  A105: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d105_in, Multiplicand => w105,d_out => mult_res105, en_out => open);
  A106: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d106_in, Multiplicand => w106,d_out => mult_res106, en_out => open);
  A107: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d107_in, Multiplicand => w107,d_out => mult_res107, en_out => open);
  A108: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d108_in, Multiplicand => w108,d_out => mult_res108, en_out => open);
  A109: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d109_in, Multiplicand => w109,d_out => mult_res109, en_out => open);
  A110: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d110_in, Multiplicand => w110,d_out => mult_res110, en_out => open);
  A111: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d111_in, Multiplicand => w111,d_out => mult_res111, en_out => open);
  A112: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d112_in, Multiplicand => w112,d_out => mult_res112, en_out => open);
  A113: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d113_in, Multiplicand => w113,d_out => mult_res113, en_out => open);
  A114: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d114_in, Multiplicand => w114,d_out => mult_res114, en_out => open);
  A115: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d115_in, Multiplicand => w115,d_out => mult_res115, en_out => open);
  A116: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d116_in, Multiplicand => w116,d_out => mult_res116, en_out => open);
  A117: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d117_in, Multiplicand => w117,d_out => mult_res117, en_out => open);
  A118: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d118_in, Multiplicand => w118,d_out => mult_res118, en_out => open);
  A119: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d119_in, Multiplicand => w119,d_out => mult_res119, en_out => open);
  A120: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d120_in, Multiplicand => w120,d_out => mult_res120, en_out => open);
  A121: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d121_in, Multiplicand => w121,d_out => mult_res121, en_out => open);
  A122: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d122_in, Multiplicand => w122,d_out => mult_res122, en_out => open);
  A123: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d123_in, Multiplicand => w123,d_out => mult_res123, en_out => open);
  A124: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d124_in, Multiplicand => w124,d_out => mult_res124, en_out => open);
  A125: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d125_in, Multiplicand => w125,d_out => mult_res125, en_out => open);
  A126: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d126_in, Multiplicand => w126,d_out => mult_res126, en_out => open);
  A127: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d127_in, Multiplicand => w127,d_out => mult_res127, en_out => open);
  A128: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d128_in, Multiplicand => w128,d_out => mult_res128, en_out => open);
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
      adder_1_01  <= (mult_res01(mult_res01'left) & mult_res01) + (mult_res33(mult_res33'left) & mult_res33)
                   + (mult_res02(mult_res02'left) & mult_res02) + (mult_res34(mult_res34'left) & mult_res34);
      adder_1_03  <= (mult_res03(mult_res03'left) & mult_res03) + (mult_res35(mult_res35'left) & mult_res35)
                   + (mult_res04(mult_res04'left) & mult_res04) + (mult_res36(mult_res36'left) & mult_res36);
      adder_1_05  <= (mult_res05(mult_res05'left) & mult_res05) + (mult_res37(mult_res37'left) & mult_res37)
                   + (mult_res06(mult_res06'left) & mult_res06) + (mult_res38(mult_res38'left) & mult_res38);
      adder_1_07  <= (mult_res07(mult_res07'left) & mult_res07) + (mult_res39(mult_res39'left) & mult_res39)
                   + (mult_res08(mult_res08'left) & mult_res08) + (mult_res40(mult_res40'left) & mult_res40);
      adder_1_09  <= (mult_res09(mult_res09'left) & mult_res09) + (mult_res41(mult_res41'left) & mult_res41)
                   + (mult_res10(mult_res10'left) & mult_res10) + (mult_res42(mult_res42'left) & mult_res42);
      adder_1_11  <= (mult_res11(mult_res11'left) & mult_res11) + (mult_res43(mult_res43'left) & mult_res43)
                   + (mult_res12(mult_res12'left) & mult_res12) + (mult_res44(mult_res44'left) & mult_res44);
      adder_1_13  <= (mult_res13(mult_res13'left) & mult_res13) + (mult_res45(mult_res45'left) & mult_res45)
                   + (mult_res14(mult_res14'left) & mult_res14) + (mult_res46(mult_res46'left) & mult_res46);
      adder_1_15  <= (mult_res15(mult_res15'left) & mult_res15) + (mult_res47(mult_res47'left) & mult_res47)
                   + (mult_res16(mult_res16'left) & mult_res16) + (mult_res48(mult_res48'left) & mult_res48);
      adder_1_17  <= (mult_res17(mult_res17'left) & mult_res17) + (mult_res49(mult_res49'left) & mult_res49)
                   + (mult_res18(mult_res18'left) & mult_res18) + (mult_res50(mult_res50'left) & mult_res50);
      adder_1_19  <= (mult_res19(mult_res19'left) & mult_res19) + (mult_res51(mult_res51'left) & mult_res51)
                   + (mult_res20(mult_res20'left) & mult_res20) + (mult_res52(mult_res52'left) & mult_res52);
      adder_1_21  <= (mult_res21(mult_res21'left) & mult_res21) + (mult_res53(mult_res53'left) & mult_res53)
                   + (mult_res22(mult_res22'left) & mult_res22) + (mult_res54(mult_res54'left) & mult_res54);
      adder_1_23  <= (mult_res23(mult_res23'left) & mult_res23) + (mult_res55(mult_res55'left) & mult_res55)
                   + (mult_res24(mult_res24'left) & mult_res24) + (mult_res56(mult_res56'left) & mult_res56);
      adder_1_25  <= (mult_res25(mult_res25'left) & mult_res25) + (mult_res57(mult_res57'left) & mult_res57)
                   + (mult_res26(mult_res26'left) & mult_res26) + (mult_res58(mult_res58'left) & mult_res58);
      adder_1_27  <= (mult_res27(mult_res27'left) & mult_res27) + (mult_res59(mult_res59'left) & mult_res59)
                   + (mult_res28(mult_res28'left) & mult_res28) + (mult_res60(mult_res60'left) & mult_res60);
      adder_1_29  <= (mult_res29(mult_res29'left) & mult_res29) + (mult_res61(mult_res61'left) & mult_res61)
                   + (mult_res30(mult_res30'left) & mult_res30) + (mult_res62(mult_res62'left) & mult_res62);
      adder_1_31  <= (mult_res31(mult_res31'left) & mult_res31) + (mult_res63(mult_res63'left) & mult_res63)
                   + (mult_res32(mult_res32'left) & mult_res32) + (mult_res64(mult_res64'left) & mult_res64);

      adder_1_33  <= (mult_res65 (mult_res65 'left) & mult_res65 ) + (mult_res66 (mult_res66 'left) & mult_res66 ) + (mult_res67 (mult_res67 'left) & mult_res67 ) + (mult_res68 (mult_res68 'left) & mult_res68 ); 
      adder_1_34  <= (mult_res69 (mult_res69 'left) & mult_res69 ) + (mult_res70 (mult_res70 'left) & mult_res70 ) + (mult_res71 (mult_res71 'left) & mult_res71 ) + (mult_res72 (mult_res72 'left) & mult_res72 ); 
      adder_1_35  <= (mult_res73 (mult_res73 'left) & mult_res73 ) + (mult_res74 (mult_res74 'left) & mult_res74 ) + (mult_res75 (mult_res75 'left) & mult_res75 ) + (mult_res76 (mult_res76 'left) & mult_res76 ); 
      adder_1_36  <= (mult_res77 (mult_res77 'left) & mult_res77 ) + (mult_res78 (mult_res78 'left) & mult_res78 ) + (mult_res79 (mult_res79 'left) & mult_res79 ) + (mult_res80 (mult_res80 'left) & mult_res80 ); 
      adder_1_37  <= (mult_res81 (mult_res81 'left) & mult_res81 ) + (mult_res82 (mult_res82 'left) & mult_res82 ) + (mult_res83 (mult_res83 'left) & mult_res83 ) + (mult_res84 (mult_res84 'left) & mult_res84 ); 
      adder_1_38  <= (mult_res85 (mult_res85 'left) & mult_res85 ) + (mult_res86 (mult_res86 'left) & mult_res86 ) + (mult_res87 (mult_res87 'left) & mult_res87 ) + (mult_res88 (mult_res88 'left) & mult_res88 ); 
      adder_1_39  <= (mult_res89 (mult_res89 'left) & mult_res89 ) + (mult_res90 (mult_res90 'left) & mult_res90 ) + (mult_res91 (mult_res91 'left) & mult_res91 ) + (mult_res92 (mult_res92 'left) & mult_res92 ); 
      adder_1_40  <= (mult_res93 (mult_res93 'left) & mult_res93 ) + (mult_res94 (mult_res94 'left) & mult_res94 ) + (mult_res95 (mult_res95 'left) & mult_res95 ) + (mult_res96 (mult_res96 'left) & mult_res96 ); 
      adder_1_41  <= (mult_res97 (mult_res97 'left) & mult_res97 ) + (mult_res98 (mult_res98 'left) & mult_res98 ) + (mult_res99 (mult_res99 'left) & mult_res99 ) + (mult_res100(mult_res100'left) & mult_res100); 
      adder_1_42  <= (mult_res101(mult_res101'left) & mult_res101) + (mult_res102(mult_res102'left) & mult_res102) + (mult_res103(mult_res103'left) & mult_res103) + (mult_res104(mult_res104'left) & mult_res104); 
      adder_1_43  <= (mult_res105(mult_res105'left) & mult_res105) + (mult_res106(mult_res106'left) & mult_res106) + (mult_res107(mult_res107'left) & mult_res107) + (mult_res108(mult_res108'left) & mult_res108); 
      adder_1_44  <= (mult_res109(mult_res109'left) & mult_res109) + (mult_res110(mult_res110'left) & mult_res110) + (mult_res111(mult_res111'left) & mult_res111) + (mult_res112(mult_res112'left) & mult_res112); 
      adder_1_45  <= (mult_res113(mult_res113'left) & mult_res113) + (mult_res114(mult_res114'left) & mult_res114) + (mult_res115(mult_res115'left) & mult_res115) + (mult_res116(mult_res116'left) & mult_res116); 
      adder_1_46  <= (mult_res117(mult_res117'left) & mult_res117) + (mult_res118(mult_res118'left) & mult_res118) + (mult_res119(mult_res119'left) & mult_res119) + (mult_res120(mult_res120'left) & mult_res120); 
      adder_1_47  <= (mult_res121(mult_res121'left) & mult_res121) + (mult_res122(mult_res122'left) & mult_res122) + (mult_res123(mult_res123'left) & mult_res123) + (mult_res124(mult_res124'left) & mult_res124); 
      adder_1_48  <= (mult_res125(mult_res125'left) & mult_res125) + (mult_res126(mult_res126'left) & mult_res126) + (mult_res127(mult_res127'left) & mult_res127) + (mult_res128(mult_res128'left) & mult_res128); 

      adder_2_01  <= (adder_1_01(adder_1_01'left) & adder_1_01) + (adder_1_17(adder_1_17'left) & adder_1_17)
      --adder_2_02  <= (adder_1_02(adder_1_02'left) & adder_1_02) + (adder_1_18(adder_1_18'left) & adder_1_18);
                   + (adder_1_03(adder_1_03'left) & adder_1_03) + (adder_1_19(adder_1_19'left) & adder_1_19);
      --adder_2_04  <= (adder_1_04(adder_1_04'left) & adder_1_04) + (adder_1_20(adder_1_20'left) & adder_1_20);
      adder_2_05  <= (adder_1_05(adder_1_05'left) & adder_1_05) + (adder_1_21(adder_1_21'left) & adder_1_21)
      --adder_2_06  <= (adder_1_06(adder_1_06'left) & adder_1_06) + (adder_1_22(adder_1_22'left) & adder_1_22);
                   + (adder_1_07(adder_1_07'left) & adder_1_07) + (adder_1_23(adder_1_23'left) & adder_1_23);
      --adder_2_08  <= (adder_1_08(adder_1_08'left) & adder_1_08) + (adder_1_24(adder_1_24'left) & adder_1_24);
      adder_2_09  <= (adder_1_09(adder_1_09'left) & adder_1_09) + (adder_1_25(adder_1_25'left) & adder_1_25)
      --adder_2_10  <= (adder_1_10(adder_1_10'left) & adder_1_10) + (adder_1_26(adder_1_26'left) & adder_1_26);
                   + (adder_1_11(adder_1_11'left) & adder_1_11) + (adder_1_27(adder_1_27'left) & adder_1_27);
      --adder_2_12  <= (adder_1_12(adder_1_12'left) & adder_1_12) + (adder_1_28(adder_1_28'left) & adder_1_28);
      adder_2_13  <= (adder_1_13(adder_1_13'left) & adder_1_13) + (adder_1_29(adder_1_29'left) & adder_1_29)
      --adder_2_14  <= (adder_1_14(adder_1_14'left) & adder_1_14) + (adder_1_30(adder_1_30'left) & adder_1_30);
                   + (adder_1_15(adder_1_15'left) & adder_1_15) + (adder_1_31(adder_1_31'left) & adder_1_31);
      --adder_2_16  <= (adder_1_16(adder_1_16'left) & adder_1_16) + (adder_1_32(adder_1_32'left) & adder_1_32);

      adder_2_17  <= (adder_1_33(adder_1_33'left) & adder_1_33 ) + (adder_1_34(adder_1_34'left) & adder_1_34 ) + (adder_1_35(adder_1_35'left) & adder_1_35 ) + (adder_1_36(adder_1_36'left) & adder_1_36 );
      adder_2_18  <= (adder_1_37(adder_1_37'left) & adder_1_37 ) + (adder_1_38(adder_1_38'left) & adder_1_38 ) + (adder_1_39(adder_1_39'left) & adder_1_39 ) + (adder_1_40(adder_1_40'left) & adder_1_40 );
      adder_2_19  <= (adder_1_41(adder_1_41'left) & adder_1_41 ) + (adder_1_42(adder_1_42'left) & adder_1_42 ) + (adder_1_43(adder_1_43'left) & adder_1_43 ) + (adder_1_44(adder_1_44'left) & adder_1_44 );
      adder_2_20  <= (adder_1_45(adder_1_45'left) & adder_1_45 ) + (adder_1_46(adder_1_46'left) & adder_1_46 ) + (adder_1_47(adder_1_47'left) & adder_1_47 ) + (adder_1_48(adder_1_48'left) & adder_1_48 );

       adder_3_01     <= (adder_2_01(adder_2_01'left) & adder_2_01) + (adder_2_09(adder_2_09'left) & adder_2_09)
      --adder_3_02  <= (adder_2_02(adder_2_02'left) & adder_2_02) + (adder_2_10(adder_2_10'left) & adder_2_10);
      --adder_3_03  <= (adder_2_03(adder_2_03'left) & adder_2_03) + (adder_2_11(adder_2_11'left) & adder_2_11);
      --adder_3_04  <= (adder_2_04(adder_2_04'left) & adder_2_04) + (adder_2_12(adder_2_12'left) & adder_2_12);
                   + (adder_2_05(adder_2_05'left) & adder_2_05) + (adder_2_13(adder_2_13'left) & adder_2_13);
      --adder_3_06  <= (adder_2_06(adder_2_06'left) & adder_2_06) + (adder_2_14(adder_2_14'left) & adder_2_14);
      --adder_3_07  <= (adder_2_07(adder_2_07'left) & adder_2_07) + (adder_2_15(adder_2_15'left) & adder_2_15);
      --adder_3_08  <= (adder_2_08(adder_2_08'left) & adder_2_08) + (adder_2_16(adder_2_16'left) & adder_2_16);
       adder_3_09 <= (adder_2_17(adder_2_17'left) & adder_2_17) + (adder_2_18(adder_2_18'left) & adder_2_18) + (adder_2_19(adder_2_19'left) & adder_2_19) + (adder_2_20(adder_2_20'left) & adder_2_20);


 d_out(30 downto 0) <= (adder_3_01(adder_3_01'left) & adder_3_01(adder_3_01'left downto 1)) + (adder_3_09(adder_3_09'left) & adder_3_09(adder_3_09'left downto 1));
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