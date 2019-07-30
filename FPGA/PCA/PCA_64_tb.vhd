library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity PCA_64_tb is
  generic (
           mult_sum      : string := "mult"; --sum";
           N             : integer := 20;       -- input data width
           M             : integer := 8;       -- input weight width
           in_row        : integer := 256;
           in_col        : integer := 256
           );
end entity PCA_64_tb;

architecture PCA_64_tb of PCA_64_tb is

component PCA_64 is
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
           --d_in      : in std_logic_vector_vector(0 to 63)(15 downto 0);
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
           en_in   : in std_logic;
           sof_in  : in std_logic; -- start of frame

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

           d_out   : out std_logic_vector (N + M + 5 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end component;

 signal          clk       : std_logic;
 signal          rst       : std_logic;
 --signal          d_in      : std_logic_vector_vector(0 to 63)(15 downto 0);
 signal          d01_in    : std_logic_vector (N-1 downto 0);
 signal          d02_in    : std_logic_vector (N-1 downto 0);
 signal          d03_in    : std_logic_vector (N-1 downto 0);
 signal          d04_in    : std_logic_vector (N-1 downto 0);
 signal          d05_in    : std_logic_vector (N-1 downto 0);
 signal          d06_in    : std_logic_vector (N-1 downto 0);
 signal          d07_in    : std_logic_vector (N-1 downto 0);
 signal          d08_in    : std_logic_vector (N-1 downto 0);
 signal          d09_in    : std_logic_vector (N-1 downto 0);
 signal          d10_in    : std_logic_vector (N-1 downto 0);
 signal          d11_in    : std_logic_vector (N-1 downto 0);
 signal          d12_in    : std_logic_vector (N-1 downto 0);
 signal          d13_in    : std_logic_vector (N-1 downto 0);
 signal          d14_in    : std_logic_vector (N-1 downto 0);
 signal          d15_in    : std_logic_vector (N-1 downto 0);
 signal          d16_in    : std_logic_vector (N-1 downto 0);
 signal          d17_in    : std_logic_vector (N-1 downto 0);
 signal          d18_in    : std_logic_vector (N-1 downto 0);
 signal          d19_in    : std_logic_vector (N-1 downto 0);
 signal          d20_in    : std_logic_vector (N-1 downto 0);
 signal          d21_in    : std_logic_vector (N-1 downto 0);
 signal          d22_in    : std_logic_vector (N-1 downto 0);
 signal          d23_in    : std_logic_vector (N-1 downto 0);
 signal          d24_in    : std_logic_vector (N-1 downto 0);
 signal          d25_in    : std_logic_vector (N-1 downto 0);
 signal          d26_in    : std_logic_vector (N-1 downto 0);
 signal          d27_in    : std_logic_vector (N-1 downto 0);
 signal          d28_in    : std_logic_vector (N-1 downto 0);
 signal          d29_in    : std_logic_vector (N-1 downto 0);
 signal          d30_in    : std_logic_vector (N-1 downto 0);
 signal          d31_in    : std_logic_vector (N-1 downto 0);
 signal          d32_in    : std_logic_vector (N-1 downto 0);
 signal          d33_in    : std_logic_vector (N-1 downto 0);
 signal          d34_in    : std_logic_vector (N-1 downto 0);
 signal          d35_in    : std_logic_vector (N-1 downto 0);
 signal          d36_in    : std_logic_vector (N-1 downto 0);
 signal          d37_in    : std_logic_vector (N-1 downto 0);
 signal          d38_in    : std_logic_vector (N-1 downto 0);
 signal          d39_in    : std_logic_vector (N-1 downto 0);
 signal          d40_in    : std_logic_vector (N-1 downto 0);
 signal          d41_in    : std_logic_vector (N-1 downto 0);
 signal          d42_in    : std_logic_vector (N-1 downto 0);
 signal          d43_in    : std_logic_vector (N-1 downto 0);
 signal          d44_in    : std_logic_vector (N-1 downto 0);
 signal          d45_in    : std_logic_vector (N-1 downto 0);
 signal          d46_in    : std_logic_vector (N-1 downto 0);
 signal          d47_in    : std_logic_vector (N-1 downto 0);
 signal          d48_in    : std_logic_vector (N-1 downto 0);
 signal          d49_in    : std_logic_vector (N-1 downto 0);
 signal          d50_in    : std_logic_vector (N-1 downto 0);
 signal          d51_in    : std_logic_vector (N-1 downto 0);
 signal          d52_in    : std_logic_vector (N-1 downto 0);
 signal          d53_in    : std_logic_vector (N-1 downto 0);
 signal          d54_in    : std_logic_vector (N-1 downto 0);
 signal          d55_in    : std_logic_vector (N-1 downto 0);
 signal          d56_in    : std_logic_vector (N-1 downto 0);
 signal          d57_in    : std_logic_vector (N-1 downto 0);
 signal          d58_in    : std_logic_vector (N-1 downto 0);
 signal          d59_in    : std_logic_vector (N-1 downto 0);
 signal          d60_in    : std_logic_vector (N-1 downto 0);
 signal          d61_in    : std_logic_vector (N-1 downto 0);
 signal          d62_in    : std_logic_vector (N-1 downto 0);
 signal          d63_in    : std_logic_vector (N-1 downto 0);
 signal          d64_in    : std_logic_vector (N-1 downto 0);
 signal          en_in     : std_logic;
 signal          sof_in    : std_logic; -- start of frame

signal           w01       : std_logic_vector(M-1 downto 0); 
signal           w02       : std_logic_vector(M-1 downto 0); 
signal           w03       : std_logic_vector(M-1 downto 0); 
signal           w04       : std_logic_vector(M-1 downto 0); 
signal           w05       : std_logic_vector(M-1 downto 0); 
signal           w06       : std_logic_vector(M-1 downto 0); 
signal           w07       : std_logic_vector(M-1 downto 0); 
signal           w08       : std_logic_vector(M-1 downto 0); 
signal           w09       : std_logic_vector(M-1 downto 0); 
signal           w10       : std_logic_vector(M-1 downto 0); 
signal           w11       : std_logic_vector(M-1 downto 0); 
signal           w12       : std_logic_vector(M-1 downto 0); 
signal           w13       : std_logic_vector(M-1 downto 0); 
signal           w14       : std_logic_vector(M-1 downto 0); 
signal           w15       : std_logic_vector(M-1 downto 0); 
signal           w16       : std_logic_vector(M-1 downto 0); 
signal           w17       : std_logic_vector(M-1 downto 0); 
signal           w18       : std_logic_vector(M-1 downto 0); 
signal           w19       : std_logic_vector(M-1 downto 0); 
signal           w20       : std_logic_vector(M-1 downto 0); 
signal           w21       : std_logic_vector(M-1 downto 0); 
signal           w22       : std_logic_vector(M-1 downto 0); 
signal           w23       : std_logic_vector(M-1 downto 0); 
signal           w24       : std_logic_vector(M-1 downto 0); 
signal           w25       : std_logic_vector(M-1 downto 0); 
signal           w26       : std_logic_vector(M-1 downto 0); 
signal           w27       : std_logic_vector(M-1 downto 0); 
signal           w28       : std_logic_vector(M-1 downto 0); 
signal           w29       : std_logic_vector(M-1 downto 0); 
signal           w30       : std_logic_vector(M-1 downto 0); 
signal           w31       : std_logic_vector(M-1 downto 0); 
signal           w32       : std_logic_vector(M-1 downto 0); 
signal           w33       : std_logic_vector(M-1 downto 0); 
signal           w34       : std_logic_vector(M-1 downto 0); 
signal           w35       : std_logic_vector(M-1 downto 0); 
signal           w36       : std_logic_vector(M-1 downto 0); 
signal           w37       : std_logic_vector(M-1 downto 0); 
signal           w38       : std_logic_vector(M-1 downto 0); 
signal           w39       : std_logic_vector(M-1 downto 0); 
signal           w40       : std_logic_vector(M-1 downto 0); 
signal           w41       : std_logic_vector(M-1 downto 0); 
signal           w42       : std_logic_vector(M-1 downto 0); 
signal           w43       : std_logic_vector(M-1 downto 0); 
signal           w44       : std_logic_vector(M-1 downto 0); 
signal           w45       : std_logic_vector(M-1 downto 0); 
signal           w46       : std_logic_vector(M-1 downto 0); 
signal           w47       : std_logic_vector(M-1 downto 0); 
signal           w48       : std_logic_vector(M-1 downto 0); 
signal           w49       : std_logic_vector(M-1 downto 0); 
signal           w50       : std_logic_vector(M-1 downto 0); 
signal           w51       : std_logic_vector(M-1 downto 0); 
signal           w52       : std_logic_vector(M-1 downto 0); 
signal           w53       : std_logic_vector(M-1 downto 0); 
signal           w54       : std_logic_vector(M-1 downto 0); 
signal           w55       : std_logic_vector(M-1 downto 0); 
signal           w56       : std_logic_vector(M-1 downto 0); 
signal           w57       : std_logic_vector(M-1 downto 0); 
signal           w58       : std_logic_vector(M-1 downto 0); 
signal           w59       : std_logic_vector(M-1 downto 0); 
signal           w60       : std_logic_vector(M-1 downto 0); 
signal           w61       : std_logic_vector(M-1 downto 0); 
signal           w62       : std_logic_vector(M-1 downto 0); 
signal           w63       : std_logic_vector(M-1 downto 0); 
signal           w64       : std_logic_vector(M-1 downto 0); 

signal           d_out     : std_logic_vector (N + M + 5 downto 0);
signal           en_out    : std_logic;
signal           sof_out   : std_logic;

begin




DUT: PCA_64 generic map (
      mult_sum => mult_sum,
      N        => N       , -- input data width
      M        => M       , -- input data width

      in_row   => in_row  ,
      in_col   => in_col
      )
port map (
      clk     => clk      ,
      rst     => rst      ,

       --d_in    => d_in      , 
       d01_in  => d01_in    ,
       d02_in  => d02_in    ,
       d03_in  => d03_in    ,
       d04_in  => d04_in    ,
       d05_in  => d05_in    ,
       d06_in  => d06_in    ,
       d07_in  => d07_in    ,
       d08_in  => d08_in    ,
       d09_in  => d09_in    ,
       d10_in  => d10_in    ,
       d11_in  => d11_in    ,
       d12_in  => d12_in    ,
       d13_in  => d13_in    ,
       d14_in  => d14_in    ,
       d15_in  => d15_in    ,
       d16_in  => d16_in    ,
       d17_in  => d17_in    ,
       d18_in  => d18_in    ,
       d19_in  => d19_in    ,
       d20_in  => d20_in    ,
       d21_in  => d21_in    ,
       d22_in  => d22_in    ,
       d23_in  => d23_in    ,
       d24_in  => d24_in    ,
       d25_in  => d25_in    ,
       d26_in  => d26_in    ,
       d27_in  => d27_in    ,
       d28_in  => d28_in    ,
       d29_in  => d29_in    ,
       d30_in  => d30_in    ,
       d31_in  => d31_in    ,
       d32_in  => d32_in    ,
       d33_in  => d33_in    ,
       d34_in  => d34_in    ,
       d35_in  => d35_in    ,
       d36_in  => d36_in    ,
       d37_in  => d37_in    ,
       d38_in  => d38_in    ,
       d39_in  => d39_in    ,
       d40_in  => d40_in    ,
       d41_in  => d41_in    ,
       d42_in  => d42_in    ,
       d43_in  => d43_in    ,
       d44_in  => d44_in    ,
       d45_in  => d45_in    ,
       d46_in  => d46_in    ,
       d47_in  => d47_in    ,
       d48_in  => d48_in    ,
       d49_in  => d49_in    ,
       d50_in  => d50_in    ,
       d51_in  => d51_in    ,
       d52_in  => d52_in    ,
       d53_in  => d53_in    ,
       d54_in  => d54_in    ,
       d55_in  => d55_in    ,
       d56_in  => d56_in    ,
       d57_in  => d57_in    ,
       d58_in  => d58_in    ,
       d59_in  => d59_in    ,
       d60_in  => d60_in    ,
       d61_in  => d61_in    ,
       d62_in  => d62_in    ,
       d63_in  => d63_in    ,
       d64_in  => d64_in    ,
       en_in   => en_in     ,
       sof_in  => sof_in    , 


       w01     => w01       , 
       w02     => w02       , 
       w03     => w03       , 
       w04     => w04       , 
       w05     => w05       , 
       w06     => w06       , 
       w07     => w07       , 
       w08     => w08       , 
       w09     => w09       , 
       w10     => w10       , 
       w11     => w11       , 
       w12     => w12       , 
       w13     => w13       , 
       w14     => w14       , 
       w15     => w15       , 
       w16     => w16       , 
       w17     => w17       , 
       w18     => w18       , 
       w19     => w19       , 
       w20     => w20       , 
       w21     => w21       , 
       w22     => w22       , 
       w23     => w23       , 
       w24     => w24       , 
       w25     => w25       , 
       w26     => w26       , 
       w27     => w27       , 
       w28     => w28       , 
       w29     => w29       , 
       w30     => w30       , 
       w31     => w31       , 
       w32     => w32       , 
       w33     => w33       , 
       w34     => w34       , 
       w35     => w35       , 
       w36     => w36       , 
       w37     => w37       , 
       w38     => w38       , 
       w39     => w39       , 
       w40     => w40       , 
       w41     => w41       , 
       w42     => w42       , 
       w43     => w43       , 
       w44     => w44       , 
       w45     => w45       , 
       w46     => w46       , 
       w47     => w47       , 
       w48     => w48       , 
       w49     => w49       , 
       w50     => w50       , 
       w51     => w51       , 
       w52     => w52       , 
       w53     => w53       , 
       w54     => w54       , 
       w55     => w55       , 
       w56     => w56       , 
       w57     => w57       , 
       w58     => w58       , 
       w59     => w59       , 
       w60     => w60       , 
       w61     => w61       , 
       w62     => w62       , 
       w63     => w63       , 
       w64     => w64       , 


      d_out   => d_out    ,
      en_out  => en_out   ,
      sof_out => sof_out             
    );

process        
   begin
     clk <= '0';    
     wait for 5 ns;
     clk <= '1';
     wait for 5 ns;
   end process;

rst <= '1', '0' after 10 ns;

w01  <= x"87";
w02  <= x"b8";
w03  <= x"0b";
w04  <= x"18";
w05  <= x"dc";
w06  <= x"33";
w07  <= x"c0";
w08  <= x"9c";
w09  <= x"0b";
w10  <= x"de";
w11  <= x"1c";
w12  <= x"4a";
w13  <= x"74";
w14  <= x"a1";
w15  <= x"12";
w16  <= x"a3";
w17  <= x"3b";
w18  <= x"2c";
w19  <= x"c4";
w20  <= x"a3";
w21  <= x"df";
w22  <= x"cd";
w23  <= x"77";
w24  <= x"d5";
w25  <= x"e3";
w26  <= x"4b";
w27  <= x"69";
w28  <= x"47";
w29  <= x"57";
w30  <= x"59";
w31  <= x"0e";
w32  <= x"8f";
w33  <= x"61";
w34  <= x"68";
w35  <= x"62";
w36  <= x"15";
w37  <= x"a1";
w38  <= x"b1";
w39  <= x"90";
w40  <= x"13";
w41  <= x"41";
w42  <= x"1f";
w43  <= x"9e";
w44  <= x"4f";
w45  <= x"88";
w46  <= x"01";
w47  <= x"cd";
w48  <= x"c5";
w49  <= x"67";
w50  <= x"08";
w51  <= x"6e";
w52  <= x"62";
w53  <= x"a1";
w54  <= x"d9";
w55  <= x"a4";
w56  <= x"e2";
w57  <= x"b9";
w58  <= x"fc";
w59  <= x"89";
w60  <= x"3a";
w61  <= x"c0";
w62  <= x"3a";
w63  <= x"ab";
w64  <= x"e9";

process
begin
  en_in <= '0';
  sof_in <= '0';
  wait until rst = '0';
  while true loop
    wait until rising_edge(clk);  -- Pixel #1
    sof_in <= '1';
    --for i in 0 to 255 loop
      en_in <= '1';
      d01_in  <= x"1bae3";
      d02_in  <= x"2225a";
      d03_in  <= x"53160";
      d04_in  <= x"38572";
      d05_in  <= x"12ec3";
      d06_in  <= x"558a3";
      d07_in  <= x"19aa2";
      d08_in  <= x"20f75";
      d09_in  <= x"54388";
      d10_in  <= x"55ef3";
      d11_in  <= x"08ec7";
      d12_in  <= x"7fd97";
      d13_in  <= x"0f698";
      d14_in  <= x"572d8";
      d15_in  <= x"628e3";
      d16_in  <= x"4e3dd";
      d17_in  <= x"61d27";
      d18_in  <= x"53d60";
      d19_in  <= x"7257b";
      d20_in  <= x"62594";
      d21_in  <= x"7b935";
      d22_in  <= x"18228";
      d23_in  <= x"7c4ac";
      d24_in  <= x"47bf6";
      d25_in  <= x"761a7";
      d26_in  <= x"3a374";
      d27_in  <= x"60830";
      d28_in  <= x"4c414";
      d29_in  <= x"013c6";
      d30_in  <= x"43b00";
      d31_in  <= x"24ab2";
      d32_in  <= x"1cf8a";
      d33_in  <= x"4959b";
      d34_in  <= x"5ffad";
      d35_in  <= x"1e7b0";
      d36_in  <= x"671ec";
      d37_in  <= x"05693";
      d38_in  <= x"279f8";
      d39_in  <= x"7a4d4";
      d40_in  <= x"62866";
      d41_in  <= x"42477";
      d42_in  <= x"121ad";
      d43_in  <= x"2a8f8";
      d44_in  <= x"56880";
      d45_in  <= x"072a0";
      d46_in  <= x"75093";
      d47_in  <= x"7b687";
      d48_in  <= x"51eca";
      d49_in  <= x"18784";
      d50_in  <= x"5120b";
      d51_in  <= x"7d055";
      d52_in  <= x"4f704";
      d53_in  <= x"2e93b";
      d54_in  <= x"3b291";
      d55_in  <= x"2fee7";
      d56_in  <= x"474c0";
      d57_in  <= x"5b332";
      d58_in  <= x"37ea4";
      d59_in  <= x"05667";
      d60_in  <= x"43896";
      d61_in  <= x"16179";
      d62_in  <= x"64496";
      d63_in  <= x"6a3ef";
      d64_in  <= x"6b151";
      wait until rising_edge(clk);  -- Pixel #2
      d01_in  <= x"5556E";
      d02_in  <= x"3C3A2";
      d03_in  <= x"1F8C2";
      d04_in  <= x"30D4D";
      d05_in  <= x"775F6";
      d06_in  <= x"01971";
      d07_in  <= x"3ACDC";
      d08_in  <= x"37329";
      d09_in  <= x"01CC7";
      d10_in  <= x"75039";
      d11_in  <= x"3D482";
      d12_in  <= x"5D831";
      d13_in  <= x"6FFB0";
      d14_in  <= x"54851";
      d15_in  <= x"32639";
      d16_in  <= x"746A8";
      d17_in  <= x"28D07";
      d18_in  <= x"5B5FD";
      d19_in  <= x"78385";
      d20_in  <= x"44FC9";
      d21_in  <= x"3778E";
      d22_in  <= x"36F94";
      d23_in  <= x"034DC";
      d24_in  <= x"28DD4";
      d25_in  <= x"5BB4C";
      d26_in  <= x"7D610";
      d27_in  <= x"6F574";
      d28_in  <= x"2B899";
      d29_in  <= x"21F56";
      d30_in  <= x"7F9A9";
      d31_in  <= x"026CF";
      d32_in  <= x"5228F";
      d33_in  <= x"14F6F";
      d34_in  <= x"1B6B5";
      d35_in  <= x"55BCF";
      d36_in  <= x"47959";
      d37_in  <= x"01328";
      d38_in  <= x"468FA";
      d39_in  <= x"49AE5";
      d40_in  <= x"1724F";
      d41_in  <= x"76261";
      d42_in  <= x"6CD40";
      d43_in  <= x"65C8F";
      d44_in  <= x"5B7C9";
      d45_in  <= x"55CD1";
      d46_in  <= x"1BAE0";
      d47_in  <= x"55423";
      d48_in  <= x"501EC";
      d49_in  <= x"50D2F";
      d50_in  <= x"7A28A";
      d51_in  <= x"02F11";
      d52_in  <= x"09D54";
      d53_in  <= x"5A4D0";
      d54_in  <= x"61547";
      d55_in  <= x"4BB5A";
      d56_in  <= x"19DD9";
      d57_in  <= x"3AFD4";
      d58_in  <= x"18C27";
      d59_in  <= x"77BB3";
      d60_in  <= x"41DE4";
      d61_in  <= x"0AC88";
      d62_in  <= x"4AC95";
      d63_in  <= x"2271C";
      d64_in  <= x"75E0A";

      wait until rising_edge(clk);  -- Pixel #3
      d01_in  <= x"418A7";
      d02_in  <= x"5CDEE";
      d03_in  <= x"6294D";
      d04_in  <= x"41DF5";
      d05_in  <= x"44B76";
      d06_in  <= x"14CA9";
      d07_in  <= x"70719";
      d08_in  <= x"14BBC";
      d09_in  <= x"21C99";
      d10_in  <= x"4078D";
      d11_in  <= x"30F3F";
      d12_in  <= x"3FD99";
      d13_in  <= x"7AD72";
      d14_in  <= x"2B66E";
      d15_in  <= x"7C32B";
      d16_in  <= x"67D25";
      d17_in  <= x"069C4";
      d18_in  <= x"142F9";
      d19_in  <= x"062A5";
      d20_in  <= x"73781";
      d21_in  <= x"231B7";
      d22_in  <= x"33DB1";
      d23_in  <= x"6870D";
      d24_in  <= x"7020F";
      d25_in  <= x"5005B";
      d26_in  <= x"1F3B6";
      d27_in  <= x"4077B";
      d28_in  <= x"15415";
      d29_in  <= x"70A35";
      d30_in  <= x"41085";
      d31_in  <= x"0E03D";
      d32_in  <= x"5DB64";
      d33_in  <= x"1C8F2";
      d34_in  <= x"1AA5F";
      d35_in  <= x"3DE26";
      d36_in  <= x"7C100";
      d37_in  <= x"7E08C";
      d38_in  <= x"5B683";
      d39_in  <= x"6D3C7";
      d40_in  <= x"3D132";
      d41_in  <= x"1BF12";
      d42_in  <= x"30EB4";
      d43_in  <= x"2F985";
      d44_in  <= x"115A3";
      d45_in  <= x"1D4D5";
      d46_in  <= x"08BE4";
      d47_in  <= x"20BA0";
      d48_in  <= x"142C2";
      d49_in  <= x"6C0EA";
      d50_in  <= x"75AA7";
      d51_in  <= x"37046";
      d52_in  <= x"17D73";
      d53_in  <= x"169ED";
      d54_in  <= x"783CE";
      d55_in  <= x"2D9E9";
      d56_in  <= x"3C4FD";
      d57_in  <= x"5812D";
      d58_in  <= x"39D38";
      d59_in  <= x"14FB4";
      d60_in  <= x"5CB96";
      d61_in  <= x"293B7";
      d62_in  <= x"5C6F7";
      d63_in  <= x"50E49";
      d64_in  <= x"5FC1B";

      wait until rising_edge(clk);  -- Pixel #4
      d01_in  <= x"649A6";
      d02_in  <= x"1F020";
      d03_in  <= x"5E454";
      d04_in  <= x"49C43";
      d05_in  <= x"4C37F";
      d06_in  <= x"6614A";
      d07_in  <= x"2F7BA";
      d08_in  <= x"18CA9";
      d09_in  <= x"72F0C";
      d10_in  <= x"202F0";
      d11_in  <= x"62BB2";
      d12_in  <= x"25DFA";
      d13_in  <= x"7A865";
      d14_in  <= x"5B56C";
      d15_in  <= x"4290B";
      d16_in  <= x"0D206";
      d17_in  <= x"66D78";
      d18_in  <= x"03547";
      d19_in  <= x"7288D";
      d20_in  <= x"7BEFB";
      d21_in  <= x"49958";
      d22_in  <= x"6FB4B";
      d23_in  <= x"6D7B0";
      d24_in  <= x"0BE3F";
      d25_in  <= x"221B1";
      d26_in  <= x"3DDF0";
      d27_in  <= x"129A3";
      d28_in  <= x"478F8";
      d29_in  <= x"09C3A";
      d30_in  <= x"141FC";
      d31_in  <= x"6A658";
      d32_in  <= x"39982";
      d33_in  <= x"3AED4";
      d34_in  <= x"17D3A";
      d35_in  <= x"5993C";
      d36_in  <= x"08F80";
      d37_in  <= x"4332B";
      d38_in  <= x"154FE";
      d39_in  <= x"04236";
      d40_in  <= x"721A9";
      d41_in  <= x"55BCD";
      d42_in  <= x"0CC92";
      d43_in  <= x"07CDB";
      d44_in  <= x"412B0";
      d45_in  <= x"55041";
      d46_in  <= x"549AC";
      d47_in  <= x"3F0A4";
      d48_in  <= x"1E5F4";
      d49_in  <= x"569BC";
      d50_in  <= x"0B10F";
      d51_in  <= x"6F177";
      d52_in  <= x"2DA0D";
      d53_in  <= x"54AB5";
      d54_in  <= x"634A2";
      d55_in  <= x"2CA2F";
      d56_in  <= x"1C98E";
      d57_in  <= x"73CF4";
      d58_in  <= x"72E1D";
      d59_in  <= x"11D3A";
      d60_in  <= x"17D4C";
      d61_in  <= x"0EF77";
      d62_in  <= x"5D851";
      d63_in  <= x"0E0D5";
      d64_in  <= x"2221C";

      wait until rising_edge(clk);  -- Pixel #5
      d01_in  <= x"5AA63";
      d02_in  <= x"01796";
      d03_in  <= x"4B7DA";
      d04_in  <= x"4644B";
      d05_in  <= x"4F37F";
      d06_in  <= x"2891E";
      d07_in  <= x"1E23B";
      d08_in  <= x"588E4";
      d09_in  <= x"6232F";
      d10_in  <= x"14A5F";
      d11_in  <= x"62DB6";
      d12_in  <= x"4900C";
      d13_in  <= x"7B71B";
      d14_in  <= x"53D3F";
      d15_in  <= x"51362";
      d16_in  <= x"3E575";
      d17_in  <= x"05835";
      d18_in  <= x"180A2";
      d19_in  <= x"1CB71";
      d20_in  <= x"1C573";
      d21_in  <= x"29809";
      d22_in  <= x"7D965";
      d23_in  <= x"3F100";
      d24_in  <= x"500FF";
      d25_in  <= x"38745";
      d26_in  <= x"41F08";
      d27_in  <= x"74F89";
      d28_in  <= x"38C5E";
      d29_in  <= x"01776";
      d30_in  <= x"5E561";
      d31_in  <= x"194C6";
      d32_in  <= x"27575";
      d33_in  <= x"36307";
      d34_in  <= x"63094";
      d35_in  <= x"26593";
      d36_in  <= x"42AD3";
      d37_in  <= x"1832A";
      d38_in  <= x"14686";
      d39_in  <= x"5934A";
      d40_in  <= x"0AA81";
      d41_in  <= x"3D2EE";
      d42_in  <= x"48943";
      d43_in  <= x"4D71D";
      d44_in  <= x"08629";
      d45_in  <= x"43D15";
      d46_in  <= x"58B24";
      d47_in  <= x"0B1F0";
      d48_in  <= x"38FFE";
      d49_in  <= x"4CD6A";
      d50_in  <= x"162A6";
      d51_in  <= x"44FFF";
      d52_in  <= x"68BF6";
      d53_in  <= x"17DD5";
      d54_in  <= x"4EE82";
      d55_in  <= x"68274";
      d56_in  <= x"39ED3";
      d57_in  <= x"41444";
      d58_in  <= x"29459";
      d59_in  <= x"6B097";
      d60_in  <= x"221ED";
      d61_in  <= x"1D99A";
      d62_in  <= x"0E702";
      d63_in  <= x"4FC73";
      d64_in  <= x"2DAEB";
    
      wait until rising_edge(clk);  -- Pixel #6
      d01_in  <= x"1A7FD";
      d02_in  <= x"4DF5E";
      d03_in  <= x"050F8";
      d04_in  <= x"75887";
      d05_in  <= x"7F763";
      d06_in  <= x"617FC";
      d07_in  <= x"36DEC";
      d08_in  <= x"64D91";
      d09_in  <= x"1C96A";
      d10_in  <= x"3F7B3";
      d11_in  <= x"2F6DC";
      d12_in  <= x"218EF";
      d13_in  <= x"029AB";
      d14_in  <= x"63845";
      d15_in  <= x"2B480";
      d16_in  <= x"6DA4D";
      d17_in  <= x"166F6";
      d18_in  <= x"121AF";
      d19_in  <= x"3B49A";
      d20_in  <= x"3051B";
      d21_in  <= x"4FF71";
      d22_in  <= x"508EF";
      d23_in  <= x"4E54E";
      d24_in  <= x"26BA3";
      d25_in  <= x"67484";
      d26_in  <= x"536AA";
      d27_in  <= x"57DA0";
      d28_in  <= x"19A36";
      d29_in  <= x"0DE48";
      d30_in  <= x"64731";
      d31_in  <= x"6DBF2";
      d32_in  <= x"364F4";
      d33_in  <= x"76459";
      d34_in  <= x"15A19";
      d35_in  <= x"020E3";
      d36_in  <= x"4CCEC";
      d37_in  <= x"49770";
      d38_in  <= x"2CE47";
      d39_in  <= x"6A042";
      d40_in  <= x"49B8B";
      d41_in  <= x"3168F";
      d42_in  <= x"7989C";
      d43_in  <= x"4DF34";
      d44_in  <= x"6E8A4";
      d45_in  <= x"62FF4";
      d46_in  <= x"1FD68";
      d47_in  <= x"6EC55";
      d48_in  <= x"14CA6";
      d49_in  <= x"3DDD3";
      d50_in  <= x"58C95";
      d51_in  <= x"1115C";
      d52_in  <= x"53AC9";
      d53_in  <= x"601BC";
      d54_in  <= x"7F696";
      d55_in  <= x"4D917";
      d56_in  <= x"23C69";
      d57_in  <= x"3F7DF";
      d58_in  <= x"4CF2E";
      d59_in  <= x"09FEB";
      d60_in  <= x"396DD";
      d61_in  <= x"215D7";
      d62_in  <= x"4FFD3";
      d63_in  <= x"3F7D2";
      d64_in  <= x"4FEA3";
    
      wait until rising_edge(clk);  -- Pixel #7
      d01_in  <= x"55A09";
      d02_in  <= x"12AD4";
      d03_in  <= x"763C4";
      d04_in  <= x"61670";
      d05_in  <= x"11A83";
      d06_in  <= x"6C15B";
      d07_in  <= x"64E95";
      d08_in  <= x"6E874";
      d09_in  <= x"5EAB1";
      d10_in  <= x"0BF41";
      d11_in  <= x"24C51";
      d12_in  <= x"2A146";
      d13_in  <= x"25A97";
      d14_in  <= x"1217C";
      d15_in  <= x"66E6A";
      d16_in  <= x"118AA";
      d17_in  <= x"361B1";
      d18_in  <= x"53D8C";
      d19_in  <= x"6FC78";
      d20_in  <= x"5D64B";
      d21_in  <= x"52B97";
      d22_in  <= x"73259";
      d23_in  <= x"5DE12";
      d24_in  <= x"1E728";
      d25_in  <= x"58CCE";
      d26_in  <= x"53813";
      d27_in  <= x"78CA0";
      d28_in  <= x"2BD75";
      d29_in  <= x"68604";
      d30_in  <= x"3E6E1";
      d31_in  <= x"6ACF7";
      d32_in  <= x"3EC43";
      d33_in  <= x"633A1";
      d34_in  <= x"6D025";
      d35_in  <= x"3FBD5";
      d36_in  <= x"6EC4C";
      d37_in  <= x"12FE7";
      d38_in  <= x"687A2";
      d39_in  <= x"6FCE2";
      d40_in  <= x"147EE";
      d41_in  <= x"4B389";
      d42_in  <= x"6FDE1";
      d43_in  <= x"26A37";
      d44_in  <= x"5F481";
      d45_in  <= x"572E6";
      d46_in  <= x"145E0";
      d47_in  <= x"128D9";
      d48_in  <= x"6EC92";
      d49_in  <= x"0F302";
      d50_in  <= x"69916";
      d51_in  <= x"4C605";
      d52_in  <= x"292A3";
      d53_in  <= x"52D35";
      d54_in  <= x"3DC67";
      d55_in  <= x"38B2D";
      d56_in  <= x"63F98";
      d57_in  <= x"514A1";
      d58_in  <= x"352B4";
      d59_in  <= x"754F9";
      d60_in  <= x"7F9DB";
      d61_in  <= x"019F5";
      d62_in  <= x"57C5E";
      d63_in  <= x"1A781";
      d64_in  <= x"72BF8";
   
      wait until rising_edge(clk);  -- Pixel #8
      d01_in  <= x"317EF";
      d02_in  <= x"134A9";
      d03_in  <= x"672AF";
      d04_in  <= x"405FF";
      d05_in  <= x"3668A";
      d06_in  <= x"5815C";
      d07_in  <= x"5CB64";
      d08_in  <= x"29AAA";
      d09_in  <= x"05FB6";
      d10_in  <= x"58F94";
      d11_in  <= x"719C0";
      d12_in  <= x"7B9A7";
      d13_in  <= x"4A4A0";
      d14_in  <= x"3758D";
      d15_in  <= x"23727";
      d16_in  <= x"71767";
      d17_in  <= x"6B3BF";
      d18_in  <= x"13904";
      d19_in  <= x"688B0";
      d20_in  <= x"5F9D2";
      d21_in  <= x"63433";
      d22_in  <= x"3240A";
      d23_in  <= x"08F68";
      d24_in  <= x"6365C";
      d25_in  <= x"60666";
      d26_in  <= x"09928";
      d27_in  <= x"115E0";
      d28_in  <= x"63F95";
      d29_in  <= x"7AFAA";
      d30_in  <= x"293B8";
      d31_in  <= x"1F69A";
      d32_in  <= x"6C10D";
      d33_in  <= x"01C82";
      d34_in  <= x"6F55B";
      d35_in  <= x"14F62";
      d36_in  <= x"6DF38";
      d37_in  <= x"76710";
      d38_in  <= x"10D59";
      d39_in  <= x"6CB2B";
      d40_in  <= x"4F234";
      d41_in  <= x"00F8D";
      d42_in  <= x"60767";
      d43_in  <= x"6402A";
      d44_in  <= x"64774";
      d45_in  <= x"752C0";
      d46_in  <= x"43162";
      d47_in  <= x"2931D";
      d48_in  <= x"5ADB9";
      d49_in  <= x"6506F";
      d50_in  <= x"55404";
      d51_in  <= x"44AEF";
      d52_in  <= x"4C06F";
      d53_in  <= x"6FBEF";
      d54_in  <= x"29B81";
      d55_in  <= x"3868A";
      d56_in  <= x"77972";
      d57_in  <= x"7DD41";
      d58_in  <= x"5B411";
      d59_in  <= x"5ABFC";
      d60_in  <= x"074A0";
      d61_in  <= x"6B259";
      d62_in  <= x"34840";
      d63_in  <= x"5CFDB";
      d64_in  <= x"3EC5A";



      wait until rising_edge(clk);  -- Pixel #9

      d01_in  <= x"645FD";
      d02_in  <= x"4D363";
      d03_in  <= x"00820";
      d04_in  <= x"3A12D";
      d05_in  <= x"5ED54";
      d06_in  <= x"5E402";
      d07_in  <= x"7F696";
      d08_in  <= x"27491";
      d09_in  <= x"581EC";
      d10_in  <= x"01F13";
      d11_in  <= x"273C1";
      d12_in  <= x"73D24";
      d13_in  <= x"1CC39";
      d14_in  <= x"64153";
      d15_in  <= x"73FB5";
      d16_in  <= x"4F5EC";
      d17_in  <= x"2DCA9";
      d18_in  <= x"54FA0";
      d19_in  <= x"6A920";
      d20_in  <= x"1822E";
      d21_in  <= x"0D4E4";
      d22_in  <= x"27508";
      d23_in  <= x"0DC6D";
      d24_in  <= x"731AB";
      d25_in  <= x"25E23";
      d26_in  <= x"7D4C0";
      d27_in  <= x"6FC44";
      d28_in  <= x"20FF3";
      d29_in  <= x"5398F";
      d30_in  <= x"2ECF4";
      d31_in  <= x"4E94D";
      d32_in  <= x"2F1C2";
      d33_in  <= x"08DB5";
      d34_in  <= x"48EAA";
      d35_in  <= x"1ADE3";
      d36_in  <= x"253B2";
      d37_in  <= x"148EC";
      d38_in  <= x"791F5";
      d39_in  <= x"52686";
      d40_in  <= x"6764E";
      d41_in  <= x"76A3B";
      d42_in  <= x"54865";
      d43_in  <= x"09015";
      d44_in  <= x"6C294";
      d45_in  <= x"248BD";
      d46_in  <= x"4D75C";
      d47_in  <= x"7E17A";
      d48_in  <= x"699F7";
      d49_in  <= x"0B0E1";
      d50_in  <= x"097E2";
      d51_in  <= x"17CAE";
      d52_in  <= x"2F10A";
      d53_in  <= x"46FC1";
      d54_in  <= x"6873B";
      d55_in  <= x"73673";
      d56_in  <= x"373AB";
      d57_in  <= x"57217";
      d58_in  <= x"37046";
      d59_in  <= x"76804";
      d60_in  <= x"50982";
      d61_in  <= x"4C5DD";
      d62_in  <= x"7726A";
      d63_in  <= x"5AE17";
      d64_in  <= x"0ECE0";

      wait until rising_edge(clk);  -- Pixel #10

      d01_in  <= x"5CF4E";
      d02_in  <= x"67717";
      d03_in  <= x"7072D";
      d04_in  <= x"5E0BD";
      d05_in  <= x"1596A";
      d06_in  <= x"5D2BE";
      d07_in  <= x"0627F";
      d08_in  <= x"67AB0";
      d09_in  <= x"06037";
      d10_in  <= x"3D800";
      d11_in  <= x"333D1";
      d12_in  <= x"60824";
      d13_in  <= x"27C7C";
      d14_in  <= x"51B0C";
      d15_in  <= x"14AC9";
      d16_in  <= x"39555";
      d17_in  <= x"0BDDD";
      d18_in  <= x"4A08C";
      d19_in  <= x"7E78A";
      d20_in  <= x"01E78";
      d21_in  <= x"3E82E";
      d22_in  <= x"21E92";
      d23_in  <= x"6B029";
      d24_in  <= x"5DABD";
      d25_in  <= x"43F53";
      d26_in  <= x"1AA8A";
      d27_in  <= x"4498A";
      d28_in  <= x"1BEFB";
      d29_in  <= x"2D874";
      d30_in  <= x"670E3";
      d31_in  <= x"4BDEB";
      d32_in  <= x"5B9F0";
      d33_in  <= x"4C381";
      d34_in  <= x"0A56A";
      d35_in  <= x"36EBB";
      d36_in  <= x"27843";
      d37_in  <= x"472BA";
      d38_in  <= x"7C3A0";
      d39_in  <= x"66741";
      d40_in  <= x"3B0A3";
      d41_in  <= x"4B3D5";
      d42_in  <= x"7116A";
      d43_in  <= x"716AC";
      d44_in  <= x"67EC5";
      d45_in  <= x"3B0B7";
      d46_in  <= x"31FBA";
      d47_in  <= x"1BAE0";
      d48_in  <= x"44053";
      d49_in  <= x"4DECF";
      d50_in  <= x"0C3BE";
      d51_in  <= x"399B3";
      d52_in  <= x"681F2";
      d53_in  <= x"56E9C";
      d54_in  <= x"49A8F";
      d55_in  <= x"280B3";
      d56_in  <= x"522DA";
      d57_in  <= x"54DAC";
      d58_in  <= x"25839";
      d59_in  <= x"728CA";
      d60_in  <= x"6270C";
      d61_in  <= x"28664";
      d62_in  <= x"61ED8";
      d63_in  <= x"37312";
      d64_in  <= x"7DB47";

      wait until rising_edge(clk);  -- Pixel #11

      d01_in  <= x"097AC";
      d02_in  <= x"6EE1B";
      d03_in  <= x"1D786";
      d04_in  <= x"2CA3F";
      d05_in  <= x"6740D";
      d06_in  <= x"61B22";
      d07_in  <= x"389C7";
      d08_in  <= x"78A5C";
      d09_in  <= x"4FE82";
      d10_in  <= x"65893";
      d11_in  <= x"0E994";
      d12_in  <= x"3B595";
      d13_in  <= x"7B7E8";
      d14_in  <= x"65E27";
      d15_in  <= x"2EBC5";
      d16_in  <= x"44F63";
      d17_in  <= x"7AC92";
      d18_in  <= x"28552";
      d19_in  <= x"25454";
      d20_in  <= x"01808";
      d21_in  <= x"114C4";
      d22_in  <= x"03806";
      d23_in  <= x"3F535";
      d24_in  <= x"6E53D";
      d25_in  <= x"706B5";
      d26_in  <= x"17336";
      d27_in  <= x"3214B";
      d28_in  <= x"75EBF";
      d29_in  <= x"3BB7E";
      d30_in  <= x"585F9";
      d31_in  <= x"4B268";
      d32_in  <= x"06177";
      d33_in  <= x"571A5";
      d34_in  <= x"1C7A1";
      d35_in  <= x"437D6";
      d36_in  <= x"38A4A";
      d37_in  <= x"27BAD";
      d38_in  <= x"5DAB1";
      d39_in  <= x"6ECCE";
      d40_in  <= x"1051F";
      d41_in  <= x"30F90";
      d42_in  <= x"7282A";
      d43_in  <= x"54559";
      d44_in  <= x"28AFC";
      d45_in  <= x"0F7E3";
      d46_in  <= x"71498";
      d47_in  <= x"42C17";
      d48_in  <= x"48C64";
      d49_in  <= x"514C2";
      d50_in  <= x"1A78B";
      d51_in  <= x"1520B";
      d52_in  <= x"7BAD9";
      d53_in  <= x"661FB";
      d54_in  <= x"54B36";
      d55_in  <= x"61F66";
      d56_in  <= x"0060B";
      d57_in  <= x"4B12C";
      d58_in  <= x"3E5A7";
      d59_in  <= x"797D7";
      d60_in  <= x"6DF24";
      d61_in  <= x"7C166";
      d62_in  <= x"6811B";
      d63_in  <= x"6B7BE";
      d64_in  <= x"0CF1A";

      wait until rising_edge(clk);  -- Pixel #12
      d01_in  <= x"07882";
      d02_in  <= x"4854D";
      d03_in  <= x"7275D";
      d04_in  <= x"242DE";
      d05_in  <= x"48F16";
      d06_in  <= x"62443";
      d07_in  <= x"33CC7";
      d08_in  <= x"68E25";
      d09_in  <= x"4505B";
      d10_in  <= x"14C08";
      d11_in  <= x"7D007";
      d12_in  <= x"51008";
      d13_in  <= x"15F31";
      d14_in  <= x"6BF29";
      d15_in  <= x"7EF72";
      d16_in  <= x"76208";
      d17_in  <= x"5F4B6";
      d18_in  <= x"155F1";
      d19_in  <= x"14EE0";
      d20_in  <= x"702B9";
      d21_in  <= x"559B8";
      d22_in  <= x"45CC6";
      d23_in  <= x"791FB";
      d24_in  <= x"50D79";
      d25_in  <= x"6FF86";
      d26_in  <= x"57457";
      d27_in  <= x"7CF92";
      d28_in  <= x"45B3E";
      d29_in  <= x"6BF1B";
      d30_in  <= x"0E119";
      d31_in  <= x"1AACF";
      d32_in  <= x"4779C";
      d33_in  <= x"786F4";
      d34_in  <= x"286D6";
      d35_in  <= x"46809";
      d36_in  <= x"00277";
      d37_in  <= x"14CD0";
      d38_in  <= x"16142";
      d39_in  <= x"6BB61";
      d40_in  <= x"495F9";
      d41_in  <= x"3C861";
      d42_in  <= x"64766";
      d43_in  <= x"7C8CB";
      d44_in  <= x"03D4E";
      d45_in  <= x"3A77C";
      d46_in  <= x"6A692";
      d47_in  <= x"0D0CD";
      d48_in  <= x"4B4A4";
      d49_in  <= x"3B02E";
      d50_in  <= x"447EC";
      d51_in  <= x"7B545";
      d52_in  <= x"45BAC";
      d53_in  <= x"09F37";
      d54_in  <= x"6E4B0";
      d55_in  <= x"48CC9";
      d56_in  <= x"1292F";
      d57_in  <= x"51BC3";
      d58_in  <= x"1715B";
      d59_in  <= x"1712D";
      d60_in  <= x"3344B";
      d61_in  <= x"719AC";
      d62_in  <= x"744A3";
      d63_in  <= x"2424B";
      d64_in  <= x"619B8";

      wait until rising_edge(clk);  -- Pixel #13
      d01_in  <= x"09D67";
      d02_in  <= x"56530";
      d03_in  <= x"34D2C";
      d04_in  <= x"12BA4";
      d05_in  <= x"20F95";
      d06_in  <= x"08C1E";
      d07_in  <= x"58B97";
      d08_in  <= x"51120";
      d09_in  <= x"23871";
      d10_in  <= x"1B2C5";
      d11_in  <= x"73267";
      d12_in  <= x"44C31";
      d13_in  <= x"38D54";
      d14_in  <= x"6BF9F";
      d15_in  <= x"39D9D";
      d16_in  <= x"7B806";
      d17_in  <= x"15320";
      d18_in  <= x"48765";
      d19_in  <= x"7B2BE";
      d20_in  <= x"5E5E1";
      d21_in  <= x"00AB5";
      d22_in  <= x"5C511";
      d23_in  <= x"274A3";
      d24_in  <= x"57160";
      d25_in  <= x"4089E";
      d26_in  <= x"36E1A";
      d27_in  <= x"566DF";
      d28_in  <= x"3C6A9";
      d29_in  <= x"17F2D";
      d30_in  <= x"010E8";
      d31_in  <= x"54016";
      d32_in  <= x"229AD";
      d33_in  <= x"7DD81";
      d34_in  <= x"4FBBC";
      d35_in  <= x"48438";
      d36_in  <= x"3890B";
      d37_in  <= x"6C8D3";
      d38_in  <= x"167E1";
      d39_in  <= x"59DC8";
      d40_in  <= x"76687";
      d41_in  <= x"2211A";
      d42_in  <= x"3CFE3";
      d43_in  <= x"0FC71";
      d44_in  <= x"54C80";
      d45_in  <= x"73937";
      d46_in  <= x"0068B";
      d47_in  <= x"226D9";
      d48_in  <= x"72390";
      d49_in  <= x"443B3";
      d50_in  <= x"68466";
      d51_in  <= x"3D13D";
      d52_in  <= x"11F80";
      d53_in  <= x"3F247";
      d54_in  <= x"04587";
      d55_in  <= x"2C262";
      d56_in  <= x"18FE1";
      d57_in  <= x"7C037";
      d58_in  <= x"2C4DA";
      d59_in  <= x"1AEB7";
      d60_in  <= x"5FA18";
      d61_in  <= x"355BE";
      d62_in  <= x"29BAE";
      d63_in  <= x"33F54";
      d64_in  <= x"015D4";

      wait until rising_edge(clk);  -- Pixel #14
      d01_in  <= x"206CA";
      d02_in  <= x"12F51";
      d03_in  <= x"79198";
      d04_in  <= x"3584D";
      d05_in  <= x"5FD70";
      d06_in  <= x"0E3A8";
      d07_in  <= x"4579C";
      d08_in  <= x"1E877";
      d09_in  <= x"14CA4";
      d10_in  <= x"04677";
      d11_in  <= x"79DDC";
      d12_in  <= x"5975C";
      d13_in  <= x"0A8C0";
      d14_in  <= x"6DC9C";
      d15_in  <= x"0D9BF";
      d16_in  <= x"367FB";
      d17_in  <= x"11650";
      d18_in  <= x"3FC93";
      d19_in  <= x"21F58";
      d20_in  <= x"73C34";
      d21_in  <= x"0A3B8";
      d22_in  <= x"71A01";
      d23_in  <= x"53FD9";
      d24_in  <= x"2238F";
      d25_in  <= x"3BB55";
      d26_in  <= x"63A3D";
      d27_in  <= x"1EE7B";
      d28_in  <= x"53365";
      d29_in  <= x"74241";
      d30_in  <= x"3675A";
      d31_in  <= x"28BE6";
      d32_in  <= x"5616A";
      d33_in  <= x"4BF7D";
      d34_in  <= x"63C1A";
      d35_in  <= x"62286";
      d36_in  <= x"7DCD0";
      d37_in  <= x"38FEE";
      d38_in  <= x"1589B";
      d39_in  <= x"736A9";
      d40_in  <= x"56032";
      d41_in  <= x"2C5C3";
      d42_in  <= x"18AF6";
      d43_in  <= x"2726C";
      d44_in  <= x"1EC2C";
      d45_in  <= x"5FE24";
      d46_in  <= x"044D7";
      d47_in  <= x"05807";
      d48_in  <= x"74212";
      d49_in  <= x"222FF";
      d50_in  <= x"00F8A";
      d51_in  <= x"19B6D";
      d52_in  <= x"39721";
      d53_in  <= x"2EB2B";
      d54_in  <= x"2BDD1";
      d55_in  <= x"262C6";
      d56_in  <= x"19BD1";
      d57_in  <= x"1A326";
      d58_in  <= x"57AA9";
      d59_in  <= x"7C677";
      d60_in  <= x"36631";
      d61_in  <= x"2826A";
      d62_in  <= x"0D2BF";
      d63_in  <= x"1DB73";
      d64_in  <= x"1E6B5";
      wait until rising_edge(clk);  -- Pixel #15

      d01_in  <= x"1D841";
      d02_in  <= x"7C0A8";
      d03_in  <= x"54DE5";
      d04_in  <= x"6CB6C";
      d05_in  <= x"4F680";
      d06_in  <= x"4E9BA";
      d07_in  <= x"705B7";
      d08_in  <= x"2620E";
      d09_in  <= x"405CD";
      d10_in  <= x"0881F";
      d11_in  <= x"41E77";
      d12_in  <= x"0187B";
      d13_in  <= x"34DAB";
      d14_in  <= x"21A00";
      d15_in  <= x"3C4BB";
      d16_in  <= x"3AB6E";
      d17_in  <= x"5CE17";
      d18_in  <= x"62A60";
      d19_in  <= x"1EB10";
      d20_in  <= x"72C20";
      d21_in  <= x"4B072";
      d22_in  <= x"3E0A1";
      d23_in  <= x"66B25";
      d24_in  <= x"437DD";
      d25_in  <= x"2CCA3";
      d26_in  <= x"0C1C6";
      d27_in  <= x"1CBA1";
      d28_in  <= x"3E7FA";
      d29_in  <= x"3E107";
      d30_in  <= x"49CFA";
      d31_in  <= x"2B45C";
      d32_in  <= x"28546";
      d33_in  <= x"42E8F";
      d34_in  <= x"4D6DB";
      d35_in  <= x"6126E";
      d36_in  <= x"52A99";
      d37_in  <= x"146FA";
      d38_in  <= x"601DA";
      d39_in  <= x"45DAB";
      d40_in  <= x"60F5F";
      d41_in  <= x"5158D";
      d42_in  <= x"595D4";
      d43_in  <= x"2F6B6";
      d44_in  <= x"39345";
      d45_in  <= x"1EB69";
      d46_in  <= x"71201";
      d47_in  <= x"74945";
      d48_in  <= x"71C23";
      d49_in  <= x"72BB1";
      d50_in  <= x"4B588";
      d51_in  <= x"5DA3F";
      d52_in  <= x"2416B";
      d53_in  <= x"6B205";
      d54_in  <= x"3FDE3";
      d55_in  <= x"0AAF7";
      d56_in  <= x"27C73";
      d57_in  <= x"640D7";
      d58_in  <= x"1B3AB";
      d59_in  <= x"1D147";
      d60_in  <= x"49C1A";
      d61_in  <= x"06156";
      d62_in  <= x"0605A";
      d63_in  <= x"22924";
      d64_in  <= x"6BEDB";
      wait until rising_edge(clk);  -- Pixel #16

      d01_in  <= x"738C8";
      d02_in  <= x"2D319";
      d03_in  <= x"2E43B";
      d04_in  <= x"063FF";
      d05_in  <= x"4F39D";
      d06_in  <= x"4AD8A";
      d07_in  <= x"67986";
      d08_in  <= x"191CC";
      d09_in  <= x"37B6C";
      d10_in  <= x"6E492";
      d11_in  <= x"7F099";
      d12_in  <= x"631E7";
      d13_in  <= x"0755B";
      d14_in  <= x"18287";
      d15_in  <= x"263B1";
      d16_in  <= x"7D907";
      d17_in  <= x"3C030";
      d18_in  <= x"7F83A";
      d19_in  <= x"511F9";
      d20_in  <= x"3EC4B";
      d21_in  <= x"20665";
      d22_in  <= x"72DE4";
      d23_in  <= x"52C60";
      d24_in  <= x"31F84";
      d25_in  <= x"7C1E0";
      d26_in  <= x"3E696";
      d27_in  <= x"7568B";
      d28_in  <= x"7735D";
      d29_in  <= x"25453";
      d30_in  <= x"31B25";
      d31_in  <= x"2F193";
      d32_in  <= x"3ECEF";
      d33_in  <= x"58DB2";
      d34_in  <= x"29AA9";
      d35_in  <= x"313BC";
      d36_in  <= x"0B411";
      d37_in  <= x"64DBD";
      d38_in  <= x"12C77";
      d39_in  <= x"08A86";
      d40_in  <= x"10BF0";
      d41_in  <= x"19691";
      d42_in  <= x"583F2";
      d43_in  <= x"5B33D";
      d44_in  <= x"64BE1";
      d45_in  <= x"6EDF3";
      d46_in  <= x"06B9E";
      d47_in  <= x"68700";
      d48_in  <= x"7E1F6";
      d49_in  <= x"45FF5";
      d50_in  <= x"09230";
      d51_in  <= x"4A758";
      d52_in  <= x"23D4B";
      d53_in  <= x"18DA4";
      d54_in  <= x"5FB9E";
      d55_in  <= x"50FC1";
      d56_in  <= x"0B8FE";
      d57_in  <= x"46E0F";
      d58_in  <= x"2958A";
      d59_in  <= x"18857";
      d60_in  <= x"19154";
      d61_in  <= x"74C06";
      d62_in  <= x"6E7B5";
      d63_in  <= x"2F390";
      d64_in  <= x"38019";
      wait until rising_edge(clk);  -- Pixel #17
      
      d01_in  <= x"6B6EB";
      d02_in  <= x"7225F";
      d03_in  <= x"1B20B";
      d04_in  <= x"77EDA";
      d05_in  <= x"73D61";
      d06_in  <= x"09B14";
      d07_in  <= x"6A120";
      d08_in  <= x"3C744";
      d09_in  <= x"07746";
      d10_in  <= x"76F78";
      d11_in  <= x"68C6D";
      d12_in  <= x"70639";
      d13_in  <= x"13F24";
      d14_in  <= x"70952";
      d15_in  <= x"5F54A";
      d16_in  <= x"229C4";
      d17_in  <= x"008E4";
      d18_in  <= x"11B36";
      d19_in  <= x"15CC0";
      d20_in  <= x"13EA9";
      d21_in  <= x"47E24";
      d22_in  <= x"6519A";
      d23_in  <= x"1DC3C";
      d24_in  <= x"29785";
      d25_in  <= x"57007";
      d26_in  <= x"5C9D5";
      d27_in  <= x"5B3D0";
      d28_in  <= x"631C9";
      d29_in  <= x"01CE2";
      d30_in  <= x"7E9FD";
      d31_in  <= x"32018";
      d32_in  <= x"2DC02";
      d33_in  <= x"74A66";
      d34_in  <= x"0F539";
      d35_in  <= x"38645";
      d36_in  <= x"3EF12";
      d37_in  <= x"6EB95";
      d38_in  <= x"5787F";
      d39_in  <= x"3DE95";
      d40_in  <= x"31770";
      d41_in  <= x"369D6";
      d42_in  <= x"100B5";
      d43_in  <= x"31AEA";
      d44_in  <= x"1FEE4";
      d45_in  <= x"54377";
      d46_in  <= x"23ED3";
      d47_in  <= x"35F16";
      d48_in  <= x"65C0E";
      d49_in  <= x"54011";
      d50_in  <= x"305E2";
      d51_in  <= x"61D1B";
      d52_in  <= x"388F0";
      d53_in  <= x"01D2E";
      d54_in  <= x"56202";
      d55_in  <= x"11545";
      d56_in  <= x"11107";
      d57_in  <= x"4B65A";
      d58_in  <= x"4B4C2";
      d59_in  <= x"516CA";
      d60_in  <= x"41D69";
      d61_in  <= x"2FFDA";
      d62_in  <= x"35562";
      d63_in  <= x"64745";
      d64_in  <= x"002BA";
      wait until rising_edge(clk);  -- Pixel #18

      d01_in  <= x"254FB";
      d02_in  <= x"14C33";
      d03_in  <= x"1AF58";
      d04_in  <= x"2E648";
      d05_in  <= x"3F220";
      d06_in  <= x"3E189";
      d07_in  <= x"4B485";
      d08_in  <= x"63398";
      d09_in  <= x"79AE5";
      d10_in  <= x"2C016";
      d11_in  <= x"57687";
      d12_in  <= x"037E4";
      d13_in  <= x"16CED";
      d14_in  <= x"158C1";
      d15_in  <= x"5FF1A";
      d16_in  <= x"54E54";
      d17_in  <= x"3728A";
      d18_in  <= x"1E4FF";
      d19_in  <= x"2BD99";
      d20_in  <= x"597D8";
      d21_in  <= x"4C5F0";
      d22_in  <= x"39D59";
      d23_in  <= x"63DCE";
      d24_in  <= x"1E8F6";
      d25_in  <= x"57A61";
      d26_in  <= x"660EC";
      d27_in  <= x"4176B";
      d28_in  <= x"31437";
      d29_in  <= x"1221C";
      d30_in  <= x"549BA";
      d31_in  <= x"51D9A";
      d32_in  <= x"79528";
      d33_in  <= x"5CBCE";
      d34_in  <= x"10DE2";
      d35_in  <= x"2577D";
      d36_in  <= x"4A389";
      d37_in  <= x"58506";
      d38_in  <= x"09E88";
      d39_in  <= x"3AE9A";
      d40_in  <= x"51F5F";
      d41_in  <= x"7ED15";
      d42_in  <= x"56639";
      d43_in  <= x"34D9A";
      d44_in  <= x"3F834";
      d45_in  <= x"3872B";
      d46_in  <= x"450FA";
      d47_in  <= x"54797";
      d48_in  <= x"39BD0";
      d49_in  <= x"69E10";
      d50_in  <= x"36855";
      d51_in  <= x"34347";
      d52_in  <= x"18B4A";
      d53_in  <= x"59277";
      d54_in  <= x"062B0";
      d55_in  <= x"0BD37";
      d56_in  <= x"5B834";
      d57_in  <= x"33F1F";
      d58_in  <= x"53838";
      d59_in  <= x"7ADE5";
      d60_in  <= x"7A35B";
      d61_in  <= x"3A595";
      d62_in  <= x"1F927";
      d63_in  <= x"58E5A";
      d64_in  <= x"4E634";
      wait until rising_edge(clk);  -- Pixel #19
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      sof_in <= '0';
    --end loop;
  end loop;
end process;




end PCA_64_tb;