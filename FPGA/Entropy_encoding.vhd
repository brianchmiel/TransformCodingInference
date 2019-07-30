library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;    
--USE ieee.std_logic_arith.all;

entity Entropy_encoding is
  generic (
  	       mult_sum      : string := "sum";
           N             : integer :=   8; -- input data width
           Huff_wid      : integer :=  12; -- Huffman weight maximum width                   (after change need nedd to update "Huff_code" matrix)
           Wh            : integer :=  16; -- Huffman unit output data width (Note W>=M)
           Wb            : integer := 128; -- output buffer data width
           depth         : integer :=  64; -- buffer depth
           burst         : integer :=  10; -- buffer read burst
 
           PCA_en        : boolean := FALSE; --TRUE; -- PCA Enable/Bypass
           Huff_enc_en   : boolean := TRUE;--FALSE; -- Huffman encoder Enable/Bypass

  	       in_row        : integer := 256;
  	       in_col        : integer := 256
  	       );
  port    (
           clk       : in  std_logic;
           rst       : in  std_logic;

           pca_w_en  : in  std_logic;
           pca_w_num : in  std_logic_vector (6 downto 0);
           pca_w_in  : in  std_logic_vector (7 downto 0);

  	       d_in      : in  std_logic_vector (N-1 downto 0);
  	       en_in     : in  std_logic;
  	       sof_in    : in  std_logic; -- start of frame
  	       --sol     : in  std_logic; -- start of line
  	       --eof     : in  std_logic; -- end of frame

           buf_rd    : in  std_logic;
           buf_num   : in  std_logic_vector (5      downto 0);
           d_out     : out std_logic_vector (Wb  -1 downto 0);
           en_out    : out std_logic_vector (64  -1 downto 0);
           sof_out   : out std_logic);
end Entropy_encoding;

architecture a of Entropy_encoding is

constant PCAweightW   : integer := 8;

component ConvLayer is
  generic (
           mult_sum      : string := "sum";
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 8; -- output data width
           SR            : integer := 8; -- data shift right before output
           --bpp           : integer := 8; -- bit per pixel
           in_row        : integer := 8;
           in_col        : integer := 8
           );
  port    (
           clk     : in std_logic;
           rst     : in std_logic;
           d_in    : in std_logic_vector (N-1 downto 0);
           en_in   : in std_logic;
           sof_in  : in std_logic; -- start of frame
           --sol     : in std_logic; -- start of line
           --eof     : in std_logic; -- end of frame
           w_in    : in std_logic_vector(M-1 downto 0);
           w_num   : in std_logic_vector(  3 downto 0);
           w_en    : in std_logic;

           d_out   : out std_logic_vector (W-1 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end component;

component PCA_32 is
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
end component;

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

           d_out   : out std_logic_vector (N + M + 5 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end component;

component PCA_128 is
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
end component;

component Huffman64 is
  generic (
           N             : integer :=  4;  -- input data width
           M             : integer :=  8;  -- max code width
           Wh            : integer := 16;  -- Huffman unit output data width (Note W>=M)
           Wb            : integer := 512; -- output buffer data width
           Huff_enc_en   : boolean := TRUE; -- Huffman encoder Enable/Bypass
           depth         : integer := 500; -- buffer depth
           burst         : integer := 10   -- buffer read burst
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           init_en       : in  std_logic;                         -- initialising convert table
           alpha_data    : in  std_logic_vector(N-1 downto 0);    
           alpha_code    : in  std_logic_vector(M-1 downto 0);    
           alpha_width   : in  std_logic_vector(  3 downto 0);

           d01_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d02_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d03_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d04_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d05_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d06_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d07_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d08_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d09_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d10_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d11_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d12_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d13_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d14_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d15_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d16_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d17_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d18_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d19_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d20_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d21_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d22_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d23_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d24_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d25_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d26_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d27_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d28_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d29_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d30_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d31_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d32_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d33_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d34_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d35_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d36_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d37_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d38_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d39_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d40_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d41_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d42_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d43_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d44_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d45_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d46_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d47_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d48_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d49_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d50_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d51_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d52_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d53_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d54_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d55_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d56_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d57_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d58_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d59_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d60_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d61_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d62_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d63_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d64_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           en_in         : in  std_logic;
           sof_in        : in  std_logic;                         -- start of frame
           eof_in        : in  std_logic;                         -- end of frame

           buf_rd        : in  std_logic;
           buf_num       : in  std_logic_vector (5      downto 0);
           d_out         : out std_logic_vector (Wb  -1 downto 0);
           en_out        : out std_logic_vector (64  -1 downto 0);
           eof_out       : out std_logic);                        -- huffman codde output
end component;

constant CL_w_width : integer := 8;
type rom_type is array ( 0 to 15 ) of std_logic_vector(CL_w_width-1 downto 0 ) ;

constant weight01 : rom_type := ( 0 => x"00", 1 => x"17", 2 => x"92", 3 => x"14", 4 => x"61", 5 => x"27", 6 => x"53", 7 => x"60", 8 => x"11", 9 => x"61", others => x"00"); 
constant weight02 : rom_type := ( 0 => x"00", 1 => x"35", 2 => x"40", 3 => x"10", 4 => x"87", 5 => x"96", 6 => x"39", 7 => x"66", 8 => x"98", 9 => x"51", others => x"00"); 
constant weight03 : rom_type := ( 0 => x"00", 1 => x"85", 2 => x"48", 3 => x"56", 4 => x"67", 5 => x"82", 6 => x"28", 7 => x"70", 8 => x"72", 9 => x"58", others => x"00"); 
constant weight04 : rom_type := ( 0 => x"00", 1 => x"93", 2 => x"41", 3 => x"26", 4 => x"13", 5 => x"77", 6 => x"10", 7 => x"83", 8 => x"66", 9 => x"44", others => x"00"); 
constant weight05 : rom_type := ( 0 => x"00", 1 => x"88", 2 => x"82", 3 => x"74", 4 => x"24", 5 => x"10", 6 => x"41", 7 => x"99", 8 => x"61", 9 => x"53", others => x"00"); 
constant weight06 : rom_type := ( 0 => x"00", 1 => x"48", 2 => x"64", 3 => x"38", 4 => x"89", 5 => x"84", 6 => x"83", 7 => x"89", 8 => x"58", 9 => x"47", others => x"00"); 
constant weight07 : rom_type := ( 0 => x"00", 1 => x"35", 2 => x"79", 3 => x"73", 4 => x"99", 5 => x"67", 6 => x"26", 7 => x"82", 8 => x"39", 9 => x"49", others => x"00"); 
constant weight08 : rom_type := ( 0 => x"00", 1 => x"24", 2 => x"61", 3 => x"52", 4 => x"55", 5 => x"18", 6 => x"66", 7 => x"46", 8 => x"91", 9 => x"56", others => x"00"); 
constant weight09 : rom_type := ( 0 => x"00", 1 => x"43", 2 => x"16", 3 => x"32", 4 => x"43", 5 => x"81", 6 => x"49", 7 => x"99", 8 => x"51", 9 => x"42", others => x"00"); 
constant weight10 : rom_type := ( 0 => x"00", 1 => x"21", 2 => x"70", 3 => x"90", 4 => x"23", 5 => x"19", 6 => x"36", 7 => x"92", 8 => x"64", 9 => x"34", others => x"00"); 
constant weight11 : rom_type := ( 0 => x"00", 1 => x"19", 2 => x"70", 3 => x"58", 4 => x"17", 5 => x"49", 6 => x"28", 7 => x"34", 8 => x"28", 9 => x"78", others => x"00"); 
constant weight12 : rom_type := ( 0 => x"00", 1 => x"34", 2 => x"54", 3 => x"61", 4 => x"29", 5 => x"42", 6 => x"61", 7 => x"35", 8 => x"90", 9 => x"59", others => x"00"); 
constant weight13 : rom_type := ( 0 => x"00", 1 => x"23", 2 => x"20", 3 => x"51", 4 => x"10", 5 => x"83", 6 => x"64", 7 => x"24", 8 => x"15", 9 => x"69", others => x"00"); 
constant weight14 : rom_type := ( 0 => x"00", 1 => x"33", 2 => x"35", 3 => x"38", 4 => x"42", 5 => x"13", 6 => x"20", 7 => x"52", 8 => x"54", 9 => x"87", others => x"00"); 
constant weight15 : rom_type := ( 0 => x"00", 1 => x"11", 2 => x"11", 3 => x"77", 4 => x"58", 5 => x"54", 6 => x"55", 7 => x"12", 8 => x"13", 9 => x"53", others => x"00"); 
constant weight16 : rom_type := ( 0 => x"00", 1 => x"47", 2 => x"60", 3 => x"59", 4 => x"65", 5 => x"44", 6 => x"70", 7 => x"82", 8 => x"36", 9 => x"92", others => x"00"); 
constant weight17 : rom_type := ( 0 => x"00", 1 => x"35", 2 => x"94", 3 => x"56", 4 => x"40", 5 => x"16", 6 => x"76", 7 => x"46", 8 => x"72", 9 => x"36", others => x"00"); 
constant weight18 : rom_type := ( 0 => x"00", 1 => x"39", 2 => x"84", 3 => x"41", 4 => x"67", 5 => x"62", 6 => x"87", 7 => x"97", 8 => x"67", 9 => x"65", others => x"00"); 
constant weight19 : rom_type := ( 0 => x"00", 1 => x"96", 2 => x"96", 3 => x"12", 4 => x"91", 5 => x"98", 6 => x"46", 7 => x"50", 8 => x"77", 9 => x"60", others => x"00"); 
constant weight20 : rom_type := ( 0 => x"00", 1 => x"89", 2 => x"89", 3 => x"27", 4 => x"56", 5 => x"79", 6 => x"69", 7 => x"20", 8 => x"34", 9 => x"73", others => x"00"); 
constant weight21 : rom_type := ( 0 => x"00", 1 => x"61", 2 => x"79", 3 => x"15", 4 => x"36", 5 => x"10", 6 => x"71", 7 => x"41", 8 => x"35", 9 => x"34", others => x"00"); 
constant weight22 : rom_type := ( 0 => x"00", 1 => x"59", 2 => x"97", 3 => x"32", 4 => x"56", 5 => x"69", 6 => x"70", 7 => x"41", 8 => x"87", 9 => x"40", others => x"00"); 
constant weight23 : rom_type := ( 0 => x"00", 1 => x"32", 2 => x"19", 3 => x"63", 4 => x"12", 5 => x"51", 6 => x"20", 7 => x"30", 8 => x"49", 9 => x"88", others => x"00"); 
constant weight24 : rom_type := ( 0 => x"00", 1 => x"25", 2 => x"58", 3 => x"56", 4 => x"95", 5 => x"92", 6 => x"69", 7 => x"89", 8 => x"76", 9 => x"21", others => x"00"); 
constant weight25 : rom_type := ( 0 => x"00", 1 => x"44", 2 => x"99", 3 => x"99", 4 => x"71", 5 => x"46", 6 => x"39", 7 => x"88", 8 => x"96", 9 => x"19", others => x"00"); 
constant weight26 : rom_type := ( 0 => x"00", 1 => x"69", 2 => x"15", 3 => x"67", 4 => x"53", 5 => x"52", 6 => x"84", 7 => x"30", 8 => x"41", 9 => x"79", others => x"00"); 
constant weight27 : rom_type := ( 0 => x"00", 1 => x"52", 2 => x"91", 3 => x"30", 4 => x"23", 5 => x"11", 6 => x"36", 7 => x"98", 8 => x"32", 9 => x"46", others => x"00"); 
constant weight28 : rom_type := ( 0 => x"00", 1 => x"11", 2 => x"99", 3 => x"67", 4 => x"28", 5 => x"71", 6 => x"99", 7 => x"17", 8 => x"97", 9 => x"56", others => x"00"); 
constant weight29 : rom_type := ( 0 => x"00", 1 => x"77", 2 => x"25", 3 => x"78", 4 => x"63", 5 => x"50", 6 => x"32", 7 => x"33", 8 => x"59", 9 => x"71", others => x"00"); 
constant weight30 : rom_type := ( 0 => x"00", 1 => x"47", 2 => x"66", 3 => x"48", 4 => x"12", 5 => x"84", 6 => x"36", 7 => x"70", 8 => x"31", 9 => x"61", others => x"00"); 
constant weight31 : rom_type := ( 0 => x"00", 1 => x"75", 2 => x"84", 3 => x"84", 4 => x"14", 5 => x"14", 6 => x"62", 7 => x"20", 8 => x"70", 9 => x"94", others => x"00"); 
constant weight32 : rom_type := ( 0 => x"00", 1 => x"99", 2 => x"14", 3 => x"18", 4 => x"81", 5 => x"56", 6 => x"51", 7 => x"23", 8 => x"58", 9 => x"76", others => x"00"); 
constant weight33 : rom_type := ( 0 => x"00", 1 => x"44", 2 => x"77", 3 => x"26", 4 => x"24", 5 => x"50", 6 => x"66", 7 => x"26", 8 => x"36", 9 => x"88", others => x"00"); 
constant weight34 : rom_type := ( 0 => x"00", 1 => x"76", 2 => x"46", 3 => x"82", 4 => x"49", 5 => x"33", 6 => x"98", 7 => x"90", 8 => x"92", 9 => x"16", others => x"00"); 
constant weight35 : rom_type := ( 0 => x"00", 1 => x"31", 2 => x"30", 3 => x"59", 4 => x"30", 5 => x"68", 6 => x"56", 7 => x"70", 8 => x"42", 9 => x"34", others => x"00"); 
constant weight36 : rom_type := ( 0 => x"00", 1 => x"74", 2 => x"90", 3 => x"26", 4 => x"34", 5 => x"85", 6 => x"41", 7 => x"80", 8 => x"50", 9 => x"70", others => x"00"); 
constant weight37 : rom_type := ( 0 => x"00", 1 => x"69", 2 => x"57", 3 => x"57", 4 => x"60", 5 => x"78", 6 => x"62", 7 => x"11", 8 => x"29", 9 => x"36", others => x"00"); 
constant weight38 : rom_type := ( 0 => x"00", 1 => x"40", 2 => x"76", 3 => x"68", 4 => x"54", 5 => x"46", 6 => x"11", 7 => x"24", 8 => x"21", 9 => x"21", others => x"00"); 
constant weight39 : rom_type := ( 0 => x"00", 1 => x"98", 2 => x"58", 3 => x"54", 4 => x"75", 5 => x"93", 6 => x"45", 7 => x"71", 8 => x"82", 9 => x"24", others => x"00"); 
constant weight40 : rom_type := ( 0 => x"00", 1 => x"20", 2 => x"77", 3 => x"26", 4 => x"37", 5 => x"84", 6 => x"98", 7 => x"20", 8 => x"78", 9 => x"43", others => x"00"); 
constant weight41 : rom_type := ( 0 => x"00", 1 => x"64", 2 => x"45", 3 => x"40", 4 => x"31", 5 => x"26", 6 => x"35", 7 => x"74", 8 => x"98", 9 => x"32", others => x"00"); 
constant weight42 : rom_type := ( 0 => x"00", 1 => x"93", 2 => x"63", 3 => x"29", 4 => x"58", 5 => x"30", 6 => x"32", 7 => x"58", 8 => x"47", 9 => x"43", others => x"00"); 
constant weight43 : rom_type := ( 0 => x"00", 1 => x"47", 2 => x"89", 3 => x"14", 4 => x"50", 5 => x"11", 6 => x"65", 7 => x"87", 8 => x"73", 9 => x"23", others => x"00"); 
constant weight44 : rom_type := ( 0 => x"00", 1 => x"69", 2 => x"86", 3 => x"67", 4 => x"41", 5 => x"68", 6 => x"33", 7 => x"92", 8 => x"24", 9 => x"70", others => x"00"); 
constant weight45 : rom_type := ( 0 => x"00", 1 => x"98", 2 => x"95", 3 => x"94", 4 => x"47", 5 => x"67", 6 => x"35", 7 => x"72", 8 => x"19", 9 => x"62", others => x"00"); 
constant weight46 : rom_type := ( 0 => x"00", 1 => x"80", 2 => x"76", 3 => x"15", 4 => x"96", 5 => x"79", 6 => x"35", 7 => x"89", 8 => x"93", 9 => x"29", others => x"00"); 
constant weight47 : rom_type := ( 0 => x"00", 1 => x"49", 2 => x"54", 3 => x"49", 4 => x"37", 5 => x"57", 6 => x"76", 7 => x"51", 8 => x"75", 9 => x"63", others => x"00"); 
constant weight48 : rom_type := ( 0 => x"00", 1 => x"33", 2 => x"56", 3 => x"13", 4 => x"95", 5 => x"90", 6 => x"99", 7 => x"51", 8 => x"22", 9 => x"30", others => x"00"); 
constant weight49 : rom_type := ( 0 => x"00", 1 => x"29", 2 => x"66", 3 => x"72", 4 => x"60", 5 => x"77", 6 => x"83", 7 => x"36", 8 => x"99", 9 => x"58", others => x"00"); 
constant weight50 : rom_type := ( 0 => x"00", 1 => x"72", 2 => x"62", 3 => x"83", 4 => x"77", 5 => x"84", 6 => x"81", 7 => x"13", 8 => x"90", 9 => x"63", others => x"00"); 
constant weight51 : rom_type := ( 0 => x"00", 1 => x"52", 2 => x"74", 3 => x"40", 4 => x"72", 5 => x"86", 6 => x"64", 7 => x"44", 8 => x"63", 9 => x"93", others => x"00"); 
constant weight52 : rom_type := ( 0 => x"00", 1 => x"97", 2 => x"64", 3 => x"95", 4 => x"40", 5 => x"80", 6 => x"75", 7 => x"44", 8 => x"87", 9 => x"37", others => x"00"); 
constant weight53 : rom_type := ( 0 => x"00", 1 => x"39", 2 => x"85", 3 => x"15", 4 => x"19", 5 => x"99", 6 => x"72", 7 => x"92", 8 => x"89", 9 => x"23", others => x"00"); 
constant weight54 : rom_type := ( 0 => x"00", 1 => x"69", 2 => x"81", 3 => x"22", 4 => x"89", 5 => x"16", 6 => x"80", 7 => x"50", 8 => x"75", 9 => x"35", others => x"00"); 
constant weight55 : rom_type := ( 0 => x"00", 1 => x"96", 2 => x"77", 3 => x"69", 4 => x"57", 5 => x"90", 6 => x"26", 7 => x"54", 8 => x"60", 9 => x"15", others => x"00"); 
constant weight56 : rom_type := ( 0 => x"00", 1 => x"19", 2 => x"87", 3 => x"38", 4 => x"53", 5 => x"82", 6 => x"77", 7 => x"44", 8 => x"86", 9 => x"67", others => x"00"); 
constant weight57 : rom_type := ( 0 => x"00", 1 => x"61", 2 => x"95", 3 => x"32", 4 => x"59", 5 => x"68", 6 => x"71", 7 => x"93", 8 => x"24", 9 => x"35", others => x"00"); 
constant weight58 : rom_type := ( 0 => x"00", 1 => x"88", 2 => x"88", 3 => x"98", 4 => x"96", 5 => x"13", 6 => x"52", 7 => x"23", 8 => x"62", 9 => x"67", others => x"00"); 
constant weight59 : rom_type := ( 0 => x"00", 1 => x"80", 2 => x"20", 3 => x"80", 4 => x"34", 5 => x"83", 6 => x"77", 7 => x"76", 8 => x"17", 9 => x"87", others => x"00"); 
constant weight60 : rom_type := ( 0 => x"00", 1 => x"26", 2 => x"69", 3 => x"38", 4 => x"61", 5 => x"34", 6 => x"18", 7 => x"39", 8 => x"10", 9 => x"64", others => x"00"); 
constant weight61 : rom_type := ( 0 => x"00", 1 => x"25", 2 => x"75", 3 => x"60", 4 => x"85", 5 => x"16", 6 => x"81", 7 => x"92", 8 => x"70", 9 => x"47", others => x"00"); 
constant weight62 : rom_type := ( 0 => x"00", 1 => x"11", 2 => x"35", 3 => x"82", 4 => x"83", 5 => x"99", 6 => x"84", 7 => x"75", 8 => x"77", 9 => x"42", others => x"00"); 
constant weight63 : rom_type := ( 0 => x"00", 1 => x"22", 2 => x"47", 3 => x"53", 4 => x"71", 5 => x"19", 6 => x"83", 7 => x"43", 8 => x"53", 9 => x"81", others => x"00"); 
constant weight64 : rom_type := ( 0 => x"00", 1 => x"59", 2 => x"76", 3 => x"96", 4 => x"66", 5 => x"48", 6 => x"67", 7 => x"68", 8 => x"74", 9 => x"72", others => x"00"); 

constant weight65 : rom_type := ( 0 => x"00", 1 => x"9b", 2 => x"6e", 3 => x"6d", 4 => x"f4", 5 => x"09", 6 => x"cf", 7 => x"89", 8 => x"46", 9 => x"c0", others => x"00"); 
constant weight66 : rom_type := ( 0 => x"00", 1 => x"70", 2 => x"db", 3 => x"46", 4 => x"83", 5 => x"49", 6 => x"ed", 7 => x"96", 8 => x"11", 9 => x"42", others => x"00"); 
constant weight67 : rom_type := ( 0 => x"00", 1 => x"c4", 2 => x"80", 3 => x"19", 4 => x"26", 5 => x"70", 6 => x"4a", 7 => x"29", 8 => x"32", 9 => x"eb", others => x"00"); 
constant weight68 : rom_type := ( 0 => x"00", 1 => x"6d", 2 => x"2a", 3 => x"4a", 4 => x"87", 5 => x"d4", 6 => x"8e", 7 => x"b4", 8 => x"15", 9 => x"84", others => x"00"); 
constant weight69 : rom_type := ( 0 => x"00", 1 => x"0e", 2 => x"a9", 3 => x"38", 4 => x"69", 5 => x"69", 6 => x"24", 7 => x"83", 8 => x"9e", 9 => x"36", others => x"00"); 
constant weight70 : rom_type := ( 0 => x"00", 1 => x"44", 2 => x"6d", 3 => x"d1", 4 => x"9a", 5 => x"0d", 6 => x"8f", 7 => x"c1", 8 => x"63", 9 => x"6b", others => x"00"); 
constant weight71 : rom_type := ( 0 => x"00", 1 => x"24", 2 => x"fe", 3 => x"ba", 4 => x"99", 5 => x"91", 6 => x"22", 7 => x"0f", 8 => x"78", 9 => x"a4", others => x"00"); 
constant weight72 : rom_type := ( 0 => x"00", 1 => x"01", 2 => x"19", 3 => x"81", 4 => x"ca", 5 => x"14", 6 => x"1d", 7 => x"82", 8 => x"15", 9 => x"5c", others => x"00"); 
constant weight73 : rom_type := ( 0 => x"00", 1 => x"05", 2 => x"e7", 3 => x"64", 4 => x"f6", 5 => x"16", 6 => x"87", 7 => x"f2", 8 => x"18", 9 => x"ff", others => x"00"); 
constant weight74 : rom_type := ( 0 => x"00", 1 => x"0e", 2 => x"19", 3 => x"93", 4 => x"d4", 5 => x"65", 6 => x"17", 7 => x"65", 8 => x"97", 9 => x"99", others => x"00"); 
constant weight75 : rom_type := ( 0 => x"00", 1 => x"aa", 2 => x"b8", 3 => x"67", 4 => x"5a", 5 => x"34", 6 => x"49", 7 => x"a3", 8 => x"24", 9 => x"c4", others => x"00"); 
constant weight76 : rom_type := ( 0 => x"00", 1 => x"a0", 2 => x"64", 3 => x"58", 4 => x"73", 5 => x"57", 6 => x"a1", 7 => x"f5", 8 => x"74", 9 => x"e1", others => x"00"); 
constant weight77 : rom_type := ( 0 => x"00", 1 => x"40", 2 => x"dd", 3 => x"60", 4 => x"78", 5 => x"5c", 6 => x"6b", 7 => x"9b", 8 => x"20", 9 => x"7b", others => x"00"); 
constant weight78 : rom_type := ( 0 => x"00", 1 => x"e3", 2 => x"32", 3 => x"61", 4 => x"f5", 5 => x"c5", 6 => x"54", 7 => x"93", 8 => x"dc", 9 => x"05", others => x"00"); 
constant weight79 : rom_type := ( 0 => x"00", 1 => x"c4", 2 => x"4c", 3 => x"e3", 4 => x"37", 5 => x"f3", 6 => x"ff", 7 => x"5e", 8 => x"9d", 9 => x"72", others => x"00"); 
constant weight80 : rom_type := ( 0 => x"00", 1 => x"91", 2 => x"37", 3 => x"d0", 4 => x"91", 5 => x"8f", 6 => x"99", 7 => x"a2", 8 => x"13", 9 => x"ff", others => x"00"); 
constant weight81 : rom_type := ( 0 => x"00", 1 => x"f8", 2 => x"97", 3 => x"c6", 4 => x"ad", 5 => x"29", 6 => x"71", 7 => x"04", 8 => x"1f", 9 => x"7e", others => x"00"); 
constant weight82 : rom_type := ( 0 => x"00", 1 => x"2d", 2 => x"cb", 3 => x"1f", 4 => x"1d", 5 => x"a1", 6 => x"83", 7 => x"13", 8 => x"c4", 9 => x"3c", others => x"00"); 
constant weight83 : rom_type := ( 0 => x"00", 1 => x"8c", 2 => x"f0", 3 => x"04", 4 => x"23", 5 => x"dd", 6 => x"84", 7 => x"90", 8 => x"8d", 9 => x"a1", others => x"00"); 
constant weight84 : rom_type := ( 0 => x"00", 1 => x"3b", 2 => x"87", 3 => x"fb", 4 => x"89", 5 => x"95", 6 => x"47", 7 => x"0d", 8 => x"8a", 9 => x"c2", others => x"00"); 
constant weight85 : rom_type := ( 0 => x"00", 1 => x"e7", 2 => x"5e", 3 => x"8e", 4 => x"f0", 5 => x"f9", 6 => x"5f", 7 => x"26", 8 => x"c2", 9 => x"47", others => x"00"); 
constant weight86 : rom_type := ( 0 => x"00", 1 => x"f1", 2 => x"ec", 3 => x"76", 4 => x"41", 5 => x"d4", 6 => x"5c", 7 => x"22", 8 => x"b7", 9 => x"47", others => x"00"); 
constant weight87 : rom_type := ( 0 => x"00", 1 => x"ab", 2 => x"33", 3 => x"8c", 4 => x"8d", 5 => x"da", 6 => x"1d", 7 => x"98", 8 => x"4a", 9 => x"d2", others => x"00"); 
constant weight88 : rom_type := ( 0 => x"00", 1 => x"03", 2 => x"90", 3 => x"69", 4 => x"1f", 5 => x"ca", 6 => x"53", 7 => x"f0", 8 => x"ef", 9 => x"61", others => x"00"); 
constant weight89 : rom_type := ( 0 => x"00", 1 => x"41", 2 => x"b4", 3 => x"19", 4 => x"bf", 5 => x"b5", 6 => x"a2", 7 => x"5b", 8 => x"d0", 9 => x"6d", others => x"00"); 
constant weight90 : rom_type := ( 0 => x"00", 1 => x"dc", 2 => x"da", 3 => x"81", 4 => x"74", 5 => x"03", 6 => x"38", 7 => x"c9", 8 => x"2a", 9 => x"44", others => x"00"); 
constant weight91 : rom_type := ( 0 => x"00", 1 => x"c5", 2 => x"89", 3 => x"61", 4 => x"b0", 5 => x"a3", 6 => x"ad", 7 => x"ee", 8 => x"7a", 9 => x"81", others => x"00"); 
constant weight92 : rom_type := ( 0 => x"00", 1 => x"ab", 2 => x"b3", 3 => x"e6", 4 => x"59", 5 => x"d8", 6 => x"05", 7 => x"16", 8 => x"ef", 9 => x"a7", others => x"00"); 
constant weight93 : rom_type := ( 0 => x"00", 1 => x"3e", 2 => x"89", 3 => x"bf", 4 => x"7d", 5 => x"b5", 6 => x"7a", 7 => x"0a", 8 => x"37", 9 => x"37", others => x"00"); 
constant weight94 : rom_type := ( 0 => x"00", 1 => x"47", 2 => x"ba", 3 => x"6e", 4 => x"a1", 5 => x"18", 6 => x"a0", 7 => x"79", 8 => x"b3", 9 => x"cb", others => x"00"); 
constant weight95 : rom_type := ( 0 => x"00", 1 => x"0c", 2 => x"3b", 3 => x"aa", 4 => x"6b", 5 => x"d3", 6 => x"eb", 7 => x"c9", 8 => x"51", 9 => x"2a", others => x"00"); 
constant weight96 : rom_type := ( 0 => x"00", 1 => x"b2", 2 => x"2f", 3 => x"a8", 4 => x"fa", 5 => x"dd", 6 => x"40", 7 => x"c0", 8 => x"f1", 9 => x"2c", others => x"00"); 
constant weight97 : rom_type := ( 0 => x"00", 1 => x"dc", 2 => x"f5", 3 => x"84", 4 => x"68", 5 => x"59", 6 => x"1d", 7 => x"8d", 8 => x"9f", 9 => x"66", others => x"00"); 
constant weight98 : rom_type := ( 0 => x"00", 1 => x"78", 2 => x"76", 3 => x"a0", 4 => x"2b", 5 => x"16", 6 => x"6f", 7 => x"ae", 8 => x"58", 9 => x"12", others => x"00"); 
constant weight99 : rom_type := ( 0 => x"00", 1 => x"e5", 2 => x"0c", 3 => x"ac", 4 => x"c1", 5 => x"7e", 6 => x"55", 7 => x"80", 8 => x"e5", 9 => x"48", others => x"00"); 
constant weight100: rom_type := ( 0 => x"00", 1 => x"55", 2 => x"55", 3 => x"28", 4 => x"2e", 5 => x"65", 6 => x"05", 7 => x"0d", 8 => x"3d", 9 => x"a8", others => x"00"); 
constant weight101: rom_type := ( 0 => x"00", 1 => x"25", 2 => x"2e", 3 => x"ba", 4 => x"c5", 5 => x"53", 6 => x"a8", 7 => x"d3", 8 => x"64", 9 => x"13", others => x"00"); 
constant weight102: rom_type := ( 0 => x"00", 1 => x"2b", 2 => x"78", 3 => x"fe", 4 => x"27", 5 => x"57", 6 => x"32", 7 => x"41", 8 => x"7a", 9 => x"20", others => x"00"); 
constant weight103: rom_type := ( 0 => x"00", 1 => x"01", 2 => x"8f", 3 => x"9d", 4 => x"ba", 5 => x"a2", 6 => x"29", 7 => x"db", 8 => x"47", 9 => x"32", others => x"00"); 
constant weight104: rom_type := ( 0 => x"00", 1 => x"31", 2 => x"a7", 3 => x"89", 4 => x"07", 5 => x"d0", 6 => x"a6", 7 => x"aa", 8 => x"60", 9 => x"85", others => x"00"); 
constant weight105: rom_type := ( 0 => x"00", 1 => x"5f", 2 => x"48", 3 => x"8a", 4 => x"ce", 5 => x"df", 6 => x"fe", 7 => x"42", 8 => x"77", 9 => x"aa", others => x"00"); 
constant weight106: rom_type := ( 0 => x"00", 1 => x"ff", 2 => x"27", 3 => x"75", 4 => x"fc", 5 => x"af", 6 => x"8d", 7 => x"a5", 8 => x"da", 9 => x"20", others => x"00"); 
constant weight107: rom_type := ( 0 => x"00", 1 => x"0a", 2 => x"fd", 3 => x"6e", 4 => x"20", 5 => x"fc", 6 => x"bd", 7 => x"d0", 8 => x"b1", 9 => x"03", others => x"00"); 
constant weight108: rom_type := ( 0 => x"00", 1 => x"a8", 2 => x"d3", 3 => x"ee", 4 => x"dc", 5 => x"75", 6 => x"87", 7 => x"cf", 8 => x"11", 9 => x"bd", others => x"00"); 
constant weight109: rom_type := ( 0 => x"00", 1 => x"c7", 2 => x"04", 3 => x"33", 4 => x"60", 5 => x"27", 6 => x"41", 7 => x"df", 8 => x"ec", 9 => x"fb", others => x"00"); 
constant weight110: rom_type := ( 0 => x"00", 1 => x"02", 2 => x"d4", 3 => x"32", 4 => x"f5", 5 => x"7f", 6 => x"39", 7 => x"e3", 8 => x"3b", 9 => x"b2", others => x"00"); 
constant weight111: rom_type := ( 0 => x"00", 1 => x"20", 2 => x"55", 3 => x"ce", 4 => x"6f", 5 => x"26", 6 => x"67", 7 => x"35", 8 => x"05", 9 => x"c7", others => x"00"); 
constant weight112: rom_type := ( 0 => x"00", 1 => x"44", 2 => x"6a", 3 => x"37", 4 => x"9f", 5 => x"84", 6 => x"91", 7 => x"57", 8 => x"5d", 9 => x"67", others => x"00"); 
constant weight113: rom_type := ( 0 => x"00", 1 => x"87", 2 => x"27", 3 => x"8a", 4 => x"1e", 5 => x"a2", 6 => x"2d", 7 => x"b0", 8 => x"87", 9 => x"e5", others => x"00"); 
constant weight114: rom_type := ( 0 => x"00", 1 => x"06", 2 => x"d5", 3 => x"3f", 4 => x"aa", 5 => x"8b", 6 => x"6f", 7 => x"5f", 8 => x"7e", 9 => x"6b", others => x"00"); 
constant weight115: rom_type := ( 0 => x"00", 1 => x"49", 2 => x"e3", 3 => x"eb", 4 => x"d2", 5 => x"bb", 6 => x"d7", 7 => x"2c", 8 => x"de", 9 => x"e3", others => x"00"); 
constant weight116: rom_type := ( 0 => x"00", 1 => x"6f", 2 => x"79", 3 => x"70", 4 => x"b6", 5 => x"8b", 6 => x"b9", 7 => x"43", 8 => x"2c", 9 => x"93", others => x"00"); 
constant weight117: rom_type := ( 0 => x"00", 1 => x"56", 2 => x"9d", 3 => x"6d", 4 => x"03", 5 => x"ad", 6 => x"bd", 7 => x"8a", 8 => x"1b", 9 => x"f6", others => x"00"); 
constant weight118: rom_type := ( 0 => x"00", 1 => x"b5", 2 => x"b6", 3 => x"7e", 4 => x"1b", 5 => x"93", 6 => x"8a", 7 => x"58", 8 => x"87", 9 => x"7b", others => x"00"); 
constant weight119: rom_type := ( 0 => x"00", 1 => x"7d", 2 => x"45", 3 => x"40", 4 => x"58", 5 => x"16", 6 => x"61", 7 => x"68", 8 => x"3d", 9 => x"4a", others => x"00"); 
constant weight120: rom_type := ( 0 => x"00", 1 => x"2e", 2 => x"2f", 3 => x"71", 4 => x"37", 5 => x"5b", 6 => x"87", 7 => x"f5", 8 => x"d4", 9 => x"75", others => x"00"); 
constant weight121: rom_type := ( 0 => x"00", 1 => x"6f", 2 => x"2e", 3 => x"5e", 4 => x"db", 5 => x"5d", 6 => x"ad", 7 => x"9e", 8 => x"aa", 9 => x"a3", others => x"00"); 
constant weight122: rom_type := ( 0 => x"00", 1 => x"c8", 2 => x"61", 3 => x"ff", 4 => x"da", 5 => x"35", 6 => x"72", 7 => x"17", 8 => x"38", 9 => x"0d", others => x"00"); 
constant weight123: rom_type := ( 0 => x"00", 1 => x"8e", 2 => x"9e", 3 => x"36", 4 => x"a1", 5 => x"42", 6 => x"c4", 7 => x"2a", 8 => x"17", 9 => x"86", others => x"00"); 
constant weight124: rom_type := ( 0 => x"00", 1 => x"41", 2 => x"69", 3 => x"a3", 4 => x"12", 5 => x"cf", 6 => x"26", 7 => x"49", 8 => x"72", 9 => x"7a", others => x"00"); 
constant weight125: rom_type := ( 0 => x"00", 1 => x"83", 2 => x"d3", 3 => x"c6", 4 => x"a2", 5 => x"28", 6 => x"0c", 7 => x"09", 8 => x"1b", 9 => x"21", others => x"00"); 
constant weight126: rom_type := ( 0 => x"00", 1 => x"be", 2 => x"90", 3 => x"7e", 4 => x"30", 5 => x"9c", 6 => x"89", 7 => x"b2", 8 => x"f7", 9 => x"92", others => x"00"); 
constant weight127: rom_type := ( 0 => x"00", 1 => x"25", 2 => x"ad", 3 => x"c3", 4 => x"0a", 5 => x"81", 6 => x"06", 7 => x"eb", 8 => x"13", 9 => x"7c", others => x"00"); 
constant weight128: rom_type := ( 0 => x"00", 1 => x"bd", 2 => x"11", 3 => x"ff", 4 => x"96", 5 => x"bb", 6 => x"2e", 7 => x"c3", 8 => x"19", 9 => x"66", others => x"00"); 

-- weight init 

signal  w01_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w02_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w03_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w04_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w05_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w06_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w07_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w08_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w09_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w10_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w11_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w12_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w13_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w14_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w15_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w16_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w17_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w18_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w19_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w20_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w21_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w22_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w23_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w24_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w25_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w26_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w27_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w28_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w29_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w30_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w31_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w32_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w33_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w34_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w35_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w36_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w37_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w38_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w39_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w40_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w41_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w42_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w43_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w44_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w45_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w46_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w47_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w48_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w49_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w50_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w51_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w52_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w53_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w54_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w55_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w56_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w57_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w58_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w59_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w60_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w61_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w62_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w63_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w64_in    : std_logic_vector(CL_w_width-1 downto 0);

signal  w65_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w66_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w67_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w68_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w69_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w70_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w71_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w72_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w73_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w74_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w75_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w76_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w77_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w78_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w79_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w80_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w81_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w82_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w83_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w84_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w85_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w86_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w87_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w88_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w89_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w90_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w91_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w92_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w93_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w94_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w95_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w96_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w97_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w98_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w99_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w100_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w101_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w102_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w103_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w104_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w105_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w106_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w107_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w108_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w109_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w110_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w111_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w112_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w113_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w114_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w115_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w116_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w117_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w118_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w119_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w120_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w121_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w122_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w123_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w124_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w125_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w126_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w127_in    : std_logic_vector(CL_w_width-1 downto 0);
signal  w128_in    : std_logic_vector(CL_w_width-1 downto 0);

signal  w_num       : std_logic_vector(  3 downto 0);
signal  w_en        : std_logic;
signal  w_count     : std_logic_vector(  3 downto 0);
signal  w_count_en  : std_logic;
signal  w_count_en2 : std_logic;

-- conv layer
constant CL_W       : integer := N+CL_w_width+4; -- output data width
constant CL_SR      : integer := 0; -- data shift right before output
signal  cl_en_out, cl_sof_out: std_logic;
signal  d01_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d02_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d03_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d04_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d05_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d06_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d07_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d08_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d09_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d10_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d11_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d12_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d13_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d14_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d15_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d16_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d17_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d18_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d19_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d20_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d21_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d22_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d23_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d24_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d25_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d26_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d27_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d28_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d29_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d30_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d31_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d32_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d33_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d34_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d35_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d36_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d37_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d38_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d39_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d40_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d41_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d42_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d43_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d44_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d45_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d46_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d47_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d48_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d49_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d50_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d51_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d52_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d53_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d54_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d55_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d56_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d57_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d58_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d59_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d60_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d61_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d62_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d63_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d64_out1       : std_logic_vector (CL_W-1 downto 0);

signal  d65_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d66_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d67_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d68_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d69_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d70_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d71_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d72_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d73_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d74_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d75_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d76_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d77_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d78_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d79_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d80_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d81_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d82_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d83_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d84_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d85_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d86_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d87_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d88_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d89_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d90_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d91_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d92_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d93_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d94_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d95_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d96_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d97_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d98_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d99_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d100_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d101_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d102_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d103_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d104_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d105_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d106_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d107_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d108_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d109_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d110_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d111_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d112_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d113_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d114_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d115_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d116_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d117_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d118_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d119_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d120_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d121_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d122_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d123_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d124_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d125_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d126_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d127_out1       : std_logic_vector (CL_W-1 downto 0);
signal  d128_out1       : std_logic_vector (CL_W-1 downto 0);

constant PCA_data_w   : integer := 8; -- PCA data width
signal  d01_out       : std_logic_vector (CL_W-1 downto 0);
signal  d02_out       : std_logic_vector (CL_W-1 downto 0);
signal  d03_out       : std_logic_vector (CL_W-1 downto 0);
signal  d04_out       : std_logic_vector (CL_W-1 downto 0);
signal  d05_out       : std_logic_vector (CL_W-1 downto 0);
signal  d06_out       : std_logic_vector (CL_W-1 downto 0);
signal  d07_out       : std_logic_vector (CL_W-1 downto 0);
signal  d08_out       : std_logic_vector (CL_W-1 downto 0);
signal  d09_out       : std_logic_vector (CL_W-1 downto 0);
signal  d10_out       : std_logic_vector (CL_W-1 downto 0);
signal  d11_out       : std_logic_vector (CL_W-1 downto 0);
signal  d12_out       : std_logic_vector (CL_W-1 downto 0);
signal  d13_out       : std_logic_vector (CL_W-1 downto 0);
signal  d14_out       : std_logic_vector (CL_W-1 downto 0);
signal  d15_out       : std_logic_vector (CL_W-1 downto 0);
signal  d16_out       : std_logic_vector (CL_W-1 downto 0);
signal  d17_out       : std_logic_vector (CL_W-1 downto 0);
signal  d18_out       : std_logic_vector (CL_W-1 downto 0);
signal  d19_out       : std_logic_vector (CL_W-1 downto 0);
signal  d20_out       : std_logic_vector (CL_W-1 downto 0);
signal  d21_out       : std_logic_vector (CL_W-1 downto 0);
signal  d22_out       : std_logic_vector (CL_W-1 downto 0);
signal  d23_out       : std_logic_vector (CL_W-1 downto 0);
signal  d24_out       : std_logic_vector (CL_W-1 downto 0);
signal  d25_out       : std_logic_vector (CL_W-1 downto 0);
signal  d26_out       : std_logic_vector (CL_W-1 downto 0);
signal  d27_out       : std_logic_vector (CL_W-1 downto 0);
signal  d28_out       : std_logic_vector (CL_W-1 downto 0);
signal  d29_out       : std_logic_vector (CL_W-1 downto 0);
signal  d30_out       : std_logic_vector (CL_W-1 downto 0);
signal  d31_out       : std_logic_vector (CL_W-1 downto 0);
signal  d32_out       : std_logic_vector (CL_W-1 downto 0);
signal  d33_out       : std_logic_vector (CL_W-1 downto 0);
signal  d34_out       : std_logic_vector (CL_W-1 downto 0);
signal  d35_out       : std_logic_vector (CL_W-1 downto 0);
signal  d36_out       : std_logic_vector (CL_W-1 downto 0);
signal  d37_out       : std_logic_vector (CL_W-1 downto 0);
signal  d38_out       : std_logic_vector (CL_W-1 downto 0);
signal  d39_out       : std_logic_vector (CL_W-1 downto 0);
signal  d40_out       : std_logic_vector (CL_W-1 downto 0);
signal  d41_out       : std_logic_vector (CL_W-1 downto 0);
signal  d42_out       : std_logic_vector (CL_W-1 downto 0);
signal  d43_out       : std_logic_vector (CL_W-1 downto 0);
signal  d44_out       : std_logic_vector (CL_W-1 downto 0);
signal  d45_out       : std_logic_vector (CL_W-1 downto 0);
signal  d46_out       : std_logic_vector (CL_W-1 downto 0);
signal  d47_out       : std_logic_vector (CL_W-1 downto 0);
signal  d48_out       : std_logic_vector (CL_W-1 downto 0);
signal  d49_out       : std_logic_vector (CL_W-1 downto 0);
signal  d50_out       : std_logic_vector (CL_W-1 downto 0);
signal  d51_out       : std_logic_vector (CL_W-1 downto 0);
signal  d52_out       : std_logic_vector (CL_W-1 downto 0);
signal  d53_out       : std_logic_vector (CL_W-1 downto 0);
signal  d54_out       : std_logic_vector (CL_W-1 downto 0);
signal  d55_out       : std_logic_vector (CL_W-1 downto 0);
signal  d56_out       : std_logic_vector (CL_W-1 downto 0);
signal  d57_out       : std_logic_vector (CL_W-1 downto 0);
signal  d58_out       : std_logic_vector (CL_W-1 downto 0);
signal  d59_out       : std_logic_vector (CL_W-1 downto 0);
signal  d60_out       : std_logic_vector (CL_W-1 downto 0);
signal  d61_out       : std_logic_vector (CL_W-1 downto 0);
signal  d62_out       : std_logic_vector (CL_W-1 downto 0);
signal  d63_out       : std_logic_vector (CL_W-1 downto 0);
signal  d64_out       : std_logic_vector (CL_W-1 downto 0);

signal  d65_out       : std_logic_vector (CL_W-1 downto 0);
signal  d66_out       : std_logic_vector (CL_W-1 downto 0);
signal  d67_out       : std_logic_vector (CL_W-1 downto 0);
signal  d68_out       : std_logic_vector (CL_W-1 downto 0);
signal  d69_out       : std_logic_vector (CL_W-1 downto 0);
signal  d70_out       : std_logic_vector (CL_W-1 downto 0);
signal  d71_out       : std_logic_vector (CL_W-1 downto 0);
signal  d72_out       : std_logic_vector (CL_W-1 downto 0);
signal  d73_out       : std_logic_vector (CL_W-1 downto 0);
signal  d74_out       : std_logic_vector (CL_W-1 downto 0);
signal  d75_out       : std_logic_vector (CL_W-1 downto 0);
signal  d76_out       : std_logic_vector (CL_W-1 downto 0);
signal  d77_out       : std_logic_vector (CL_W-1 downto 0);
signal  d78_out       : std_logic_vector (CL_W-1 downto 0);
signal  d79_out       : std_logic_vector (CL_W-1 downto 0);
signal  d80_out       : std_logic_vector (CL_W-1 downto 0);
signal  d81_out       : std_logic_vector (CL_W-1 downto 0);
signal  d82_out       : std_logic_vector (CL_W-1 downto 0);
signal  d83_out       : std_logic_vector (CL_W-1 downto 0);
signal  d84_out       : std_logic_vector (CL_W-1 downto 0);
signal  d85_out       : std_logic_vector (CL_W-1 downto 0);
signal  d86_out       : std_logic_vector (CL_W-1 downto 0);
signal  d87_out       : std_logic_vector (CL_W-1 downto 0);
signal  d88_out       : std_logic_vector (CL_W-1 downto 0);
signal  d89_out       : std_logic_vector (CL_W-1 downto 0);
signal  d90_out       : std_logic_vector (CL_W-1 downto 0);
signal  d91_out       : std_logic_vector (CL_W-1 downto 0);
signal  d92_out       : std_logic_vector (CL_W-1 downto 0);
signal  d93_out       : std_logic_vector (CL_W-1 downto 0);
signal  d94_out       : std_logic_vector (CL_W-1 downto 0);
signal  d95_out       : std_logic_vector (CL_W-1 downto 0);
signal  d96_out       : std_logic_vector (CL_W-1 downto 0);
signal  d97_out       : std_logic_vector (CL_W-1 downto 0);
signal  d98_out       : std_logic_vector (CL_W-1 downto 0);
signal  d99_out       : std_logic_vector (CL_W-1 downto 0);
signal  d100_out       : std_logic_vector (CL_W-1 downto 0);
signal  d101_out       : std_logic_vector (CL_W-1 downto 0);
signal  d102_out       : std_logic_vector (CL_W-1 downto 0);
signal  d103_out       : std_logic_vector (CL_W-1 downto 0);
signal  d104_out       : std_logic_vector (CL_W-1 downto 0);
signal  d105_out       : std_logic_vector (CL_W-1 downto 0);
signal  d106_out       : std_logic_vector (CL_W-1 downto 0);
signal  d107_out       : std_logic_vector (CL_W-1 downto 0);
signal  d108_out       : std_logic_vector (CL_W-1 downto 0);
signal  d109_out       : std_logic_vector (CL_W-1 downto 0);
signal  d110_out       : std_logic_vector (CL_W-1 downto 0);
signal  d111_out       : std_logic_vector (CL_W-1 downto 0);
signal  d112_out       : std_logic_vector (CL_W-1 downto 0);
signal  d113_out       : std_logic_vector (CL_W-1 downto 0);
signal  d114_out       : std_logic_vector (CL_W-1 downto 0);
signal  d115_out       : std_logic_vector (CL_W-1 downto 0);
signal  d116_out       : std_logic_vector (CL_W-1 downto 0);
signal  d117_out       : std_logic_vector (CL_W-1 downto 0);
signal  d118_out       : std_logic_vector (CL_W-1 downto 0);
signal  d119_out       : std_logic_vector (CL_W-1 downto 0);
signal  d120_out       : std_logic_vector (CL_W-1 downto 0);
signal  d121_out       : std_logic_vector (CL_W-1 downto 0);
signal  d122_out       : std_logic_vector (CL_W-1 downto 0);
signal  d123_out       : std_logic_vector (CL_W-1 downto 0);
signal  d124_out       : std_logic_vector (CL_W-1 downto 0);
signal  d125_out       : std_logic_vector (CL_W-1 downto 0);
signal  d126_out       : std_logic_vector (CL_W-1 downto 0);
signal  d127_out       : std_logic_vector (CL_W-1 downto 0);
signal  d128_out       : std_logic_vector (CL_W-1 downto 0);
-- PCA weights

type pca_mem_type is array ( 0 to 127 ) of std_logic_vector(CL_w_width-1 downto 0 ) ;
signal pca_mem : pca_mem_type;
signal pca_w01,pca_w02,pca_w03,pca_w04,pca_w05,pca_w06,pca_w07,pca_w08,pca_w09,pca_w10,pca_w11,pca_w12,pca_w13,pca_w14,pca_w15,pca_w16 : std_logic_vector (7 downto 0);
signal pca_w17,pca_w18,pca_w19,pca_w20,pca_w21,pca_w22,pca_w23,pca_w24,pca_w25,pca_w26,pca_w27,pca_w28,pca_w29,pca_w30,pca_w31,pca_w32 : std_logic_vector (7 downto 0);
signal pca_w33,pca_w34,pca_w35,pca_w36,pca_w37,pca_w38,pca_w39,pca_w40,pca_w41,pca_w42,pca_w43,pca_w44,pca_w45,pca_w46,pca_w47,pca_w48 : std_logic_vector (7 downto 0);
signal pca_w49,pca_w50,pca_w51,pca_w52,pca_w53,pca_w54,pca_w55,pca_w56,pca_w57,pca_w58,pca_w59,pca_w60,pca_w61,pca_w62,pca_w63,pca_w64 : std_logic_vector (7 downto 0);
signal pca_w65,pca_w66,pca_w67,pca_w68,pca_w69,pca_w70,pca_w71,pca_w72,pca_w73,pca_w74,pca_w75,pca_w76,pca_w77,pca_w78,pca_w79,pca_w80 : std_logic_vector (7 downto 0);
signal pca_w81,pca_w82,pca_w83,pca_w84,pca_w85,pca_w86,pca_w87,pca_w88,pca_w89,pca_w90,pca_w91,pca_w92,pca_w93,pca_w94,pca_w95,pca_w96 : std_logic_vector (7 downto 0);
signal pca_w97,pca_w98,pca_w99,pca_w100, pca_w101,  pca_w102,  pca_w103,  pca_w104,  pca_w105,  pca_w106,  pca_w107,  pca_w108,  pca_w109,  pca_w110,  pca_w111  : std_logic_vector (7 downto 0);
signal pca_w112,  pca_w113,  pca_w114,  pca_w115,  pca_w116,  pca_w117,  pca_w118,  pca_w119,  pca_w120,  pca_w121,  pca_w122,  pca_w123,  pca_w124,  pca_w125,  pca_w126,  pca_w127,  pca_w128 : std_logic_vector (7 downto 0);

type PCArom_type is array ( 0 to 63 ) of std_logic_vector(64*8-1 downto 0 ) ;
constant PCAweight64 : 
PCArom_type := 
(  0 => x"52208362221476639939641397714843967281603451599978249459475456509872109434164133609996835373475696848033364030117262759726355567", 
   1 => x"39479722152029937557316143576396488783968217391482792389546537461462415185922718683874834958653595811077874139698551128541354250", 
   2 => x"67935477953368388160116386621876266327806177756618666383969613261511937950288876871857783552288537357971466563147769228465153360", 
   3 => x"77915378196732124979802182723284566862659773547594474525494484604723627898991269472017799544643350569437694178102933854138653982", 
   4 => x"46186242559966639446748085743576602596548148857710704874535490716457694335438098592755624420431766255731776088577173489543974217", 
   5 => x"67609060131937844549365868549753656153243138233897386636326925701834842843186849984645228035668828568942574262492875769723952965", 
   6 => x"78858963169520185910372285635140311413624484276018763444384516697159534867234291451866225242142861373957645144704951403382428786", 
   7 => x"45504956256787457976468065367596436686609394827783656672565077559615583371769231308958909254879790612945293171913841355626932596", 
   8 => x"57721828555431494280981312827780776448328362379017254047604012507652163960479620625181316837971655486588128683142040504760636174", 
   9 => x"67711614473273496573439846881294812943868681534724713348205664369071358029218399551375396119808366357232526549797522295376392325",
  10 => x"75881432798932634435881011158862571978866388617414779255845295477973859799926397861223526772672091194266104242146141666833489363", 
  11 => x"61691081563627564386505973457069538956806377702545657325605448297988941028598529119361943029254472698258527218511168516963404678", 
  12 => x"84803732277171417166678320361267449127509153497126471991753027198880784281452393724557127232907389916574974044691574463982594930", 
  13 => x"18848174787829266969558493616788597867895484418246467291472838352078695116469576579323576077602296346912869426175267259272112863", 
  14 => x"93131539381260646954892737538245417713161555381384401541191151759986876567226339137394795222883342589771379351147850599114953460", 
  15 => x"10612762865170275257231528738057785713973432192615503280497132355694666513628392901451816795147330675983365965359340739441921840", 
  16 => x"11624196141168543815588349224497626385881188533785448669852942943527611582126628516895512961938294485335903833774562886828496434", 
  17 => x"78197247664631153587535643935973616932274239982392373683745762183987686449186719483641972039841912863633309631229446461765929741", 
  18 => x"78106795523824509344286288949526374486968688913974371916961720956946113352357090374916654662456824348281741416251193212616917360", 
  19 => x"96964148127667571461826965571148687724742859431960205815224486835151716652269515114448786651421546226627845759182259893948776327",
  20 => x"25786476958895291251498597411158691054154319249312268314529328444871734940191838788116669582192356688835951344843056819631987984", 
  21 => x"33196718522277306941657876406988567736696466287334444398759926599893433344187988421381834945782522199129242175891318487417882730", 
  22 => x"31573729614910963053224991813050957593158329879481467739248035968846758696488756691296832038532633165633945041272659855280758621", 
  23 => x"50691541312031886568389618357668387726446195917856855790542516961247669244914830168091616958212327837484213069506148586689123562", 
  24 => x"58433068575130925817758871198493423250635672818057951192952987379947572054246044438576359419127946421584637918872192464812475771", 
  25 => x"27905574516216288180604477817550121077243733829814409343864283343536298789405386713512964572466423181156497828488819325574131287", 
  26 => x"56831629848814926662382317814741892856496099906588706841271389314262913639845852557125843467578515657347901826778455734937939568", 
  27 => x"50215235343744495436896919964735685187426539892468605165275437439612577169696875184260159717377763807464235024943471473516709323", 
  28 => x"35489692478987821582318518448613465396497416393595827613479959966950267028764555658186892718355896384466272892638014163239586338", 
  29 => x"88119954622065633320327930623712123398605420594719758412971291496147664526179533249469193659707398322739916914686744514632499886", 
  30 => x"51821917265259676811372421701222245028133570377891697529161176915422641129765671782583124186167953949754538919652052927322935776", 
  31 => x"72292781644227556270352232287315876123587432611118767545792316395023449833694870932211105634979357504490272290663340324336366279", 
  32 => x"66147072224088304484245044216750921341954123506168783896584442137192659436739436951733556866222453794284754345329572478012603940", 
  33 => x"66434589872488504167568826449447713247274526166386844682892878952729265190805587887546279053744327936694658641486095462740423995", 
  34 => x"35124777919427894476415012116312514678806482993042799369808758128890263232969336447613818136735788166566689178418980872537924565", 
  35 => x"78449363922254985598301283725346967886688835977895768241975140425596961138515088276248171980479896536346425598654262551682735769", 
  36 => x"68229798856376468268516239506848561119985285395964492189496835456119809578505383933575219614566969486384942178359277839328792091", 
  37 => x"37634816721775879887266574184861468513795645187854165285922926374330645028547514511952766759365898833430336873551321745065101483", 
  38 => x"59258199535166884682319983223840637215345944483954263883255414755687394635247561465055932610542624898054143814436719947170149319", 
  39 => x"89719060675910823346409766535511153591897665589058198112936540858370941441872820731845881338634755278965861975905812512313576619", 
  40 => x"73592295194920636074736420573616454429224537753358147941575232319838529563912852173781597825301367609363144467704168871627717092", 
  41 => x"98628180323447575022527931741298133597917940839791727190508976368299473251602485298696441351784127173611582954982224493484362137", 
  42 => x"34964038833842546254409755972694242426171121494465813192252685785988907288699037269397741931556673666259265489242726581455115821", 
  43 => x"47742152427950343868475863718532225486527564848245248888455136684580809789804942197090188623207212698781751518573769448447793183", 
  44 => x"30775823453149674512977888924125407880771042135473911887757988372758488380862857549356112033578729202467394558844380679334795892", 
  45 => x"11325338204998553637385342694589981430484951183986675096115581691842686542983870476751452482586568256974909974488542899366958034", 
  46 => x"82976634589466878843597610679462889086458115101391376084733750406452141845451443413733827873733023996931672995539893373884635613", 
  47 => x"70109076501979208499377138645423159398716463854769297848243616715464521234428170938181152396976959665563119574445961281377294636", 
  48 => x"66312376778334552960355039223737678730202881501270664968462983594152872225847362494517863914892198999592919197332121668499216246", 
  49 => x"26161150897457389035908832758558464860101173992128827186323611337351181431767848467495994432539216611097389215629656946979845985", 
  50 => x"69187959265321748482338293713334415627809993204984625611289064203448641957186071941327437074177082548649201739675059205037783238", 
  51 => x"18983772989923117942601280878818656350653990555134243620662924319024387065833571195053799675813790662956364185616172142580845825", 
  52 => x"58297866538030864434519289673966265525584638763236177670737764497015232035371617194536674075944267878016713115887852396113517717", 
  53 => x"40465628734083573768742085794612117057781730499687551889133438769035207125146466469052179163398685656654659699963553897014857911", 
  54 => x"76967660907988792148265113461989942075329467484431333234695537721880818270105085142164686084889252913672656942891825582986524096", 
  55 => x"36454194411383698054338081345753262845102211539142626452868033989785449064617859971788859169118746421549477044188919245370112340", 
  56 => x"23437675634465874989179411676195244180651062391823522697984390634280713336197078515118399317473529395892219637123266526210424182", 
  57 => x"61612741147294823132205695337695159760667979953871324149969443359073799978362682248796591381842954877345927934369330358619661442", 
  58 => x"11285943998636665739809831876847412081142065748750438766329560797090932829752648548693117273632848156924349387716275251181724083", 
  59 => x"69107994195346777647662373692098983481372284103031357546946550692830582630292898576978402557577711379194774042943466898848107138", 
  60 => x"42497832893382217681224285674917172538874530709631304035838422337335744912921131436232316976839279679358824148563076614078709587", 
  61 => x"73548468825335269454565986628470369066166899391668623023456580626111127857167275228146161380918212291337772596315433802617763892", 
  62 => x"44491720314133507981112391977770675352109478771095164259694644416047216449226889383121803895769084622480842581473178217980686951", 
  63 => x"78729680555083337952274282155195176159583364644713967333271179121386606663778962929752881442635240278589911677871574137783247488"
  ); 
--signal pca_w01  : std_logic_vector(7 downto 0); 
--signal pca_w02  : std_logic_vector(7 downto 0); 
--signal pca_w03  : std_logic_vector(7 downto 0); 
--signal pca_w04  : std_logic_vector(7 downto 0); 
--signal pca_w05  : std_logic_vector(7 downto 0); 
--signal pca_w06  : std_logic_vector(7 downto 0); 
--signal pca_w07  : std_logic_vector(7 downto 0); 
--signal pca_w08  : std_logic_vector(7 downto 0); 
--signal pca_w09  : std_logic_vector(7 downto 0); 
--signal pca_w10  : std_logic_vector(7 downto 0); 
--signal pca_w11  : std_logic_vector(7 downto 0); 
--signal pca_w12  : std_logic_vector(7 downto 0); 
--signal pca_w13  : std_logic_vector(7 downto 0); 
--signal pca_w14  : std_logic_vector(7 downto 0); 
--signal pca_w15  : std_logic_vector(7 downto 0); 
--signal pca_w16  : std_logic_vector(7 downto 0); 
--signal pca_w17  : std_logic_vector(7 downto 0); 
--signal pca_w18  : std_logic_vector(7 downto 0); 
--signal pca_w19  : std_logic_vector(7 downto 0); 
--signal pca_w20  : std_logic_vector(7 downto 0); 
--signal pca_w21  : std_logic_vector(7 downto 0); 
--signal pca_w22  : std_logic_vector(7 downto 0); 
--signal pca_w23  : std_logic_vector(7 downto 0); 
--signal pca_w24  : std_logic_vector(7 downto 0); 
--signal pca_w25  : std_logic_vector(7 downto 0); 
--signal pca_w26  : std_logic_vector(7 downto 0); 
--signal pca_w27  : std_logic_vector(7 downto 0); 
--signal pca_w28  : std_logic_vector(7 downto 0); 
--signal pca_w29  : std_logic_vector(7 downto 0); 
--signal pca_w30  : std_logic_vector(7 downto 0); 
--signal pca_w31  : std_logic_vector(7 downto 0); 
--signal pca_w32  : std_logic_vector(7 downto 0); 
--signal pca_w33  : std_logic_vector(7 downto 0); 
--signal pca_w34  : std_logic_vector(7 downto 0); 
--signal pca_w35  : std_logic_vector(7 downto 0); 
--signal pca_w36  : std_logic_vector(7 downto 0); 
--signal pca_w37  : std_logic_vector(7 downto 0); 
--signal pca_w38  : std_logic_vector(7 downto 0); 
--signal pca_w39  : std_logic_vector(7 downto 0); 
--signal pca_w40  : std_logic_vector(7 downto 0); 
--signal pca_w41  : std_logic_vector(7 downto 0); 
--signal pca_w42  : std_logic_vector(7 downto 0); 
--signal pca_w43  : std_logic_vector(7 downto 0); 
--signal pca_w44  : std_logic_vector(7 downto 0); 
--signal pca_w45  : std_logic_vector(7 downto 0); 
--signal pca_w46  : std_logic_vector(7 downto 0); 
--signal pca_w47  : std_logic_vector(7 downto 0); 
--signal pca_w48  : std_logic_vector(7 downto 0); 
--signal pca_w49  : std_logic_vector(7 downto 0); 
--signal pca_w50  : std_logic_vector(7 downto 0); 
--signal pca_w51  : std_logic_vector(7 downto 0); 
--signal pca_w52  : std_logic_vector(7 downto 0); 
--signal pca_w53  : std_logic_vector(7 downto 0); 
--signal pca_w54  : std_logic_vector(7 downto 0); 
--signal pca_w55  : std_logic_vector(7 downto 0); 
--signal pca_w56  : std_logic_vector(7 downto 0); 
--signal pca_w57  : std_logic_vector(7 downto 0); 
--signal pca_w58  : std_logic_vector(7 downto 0); 
--signal pca_w59  : std_logic_vector(7 downto 0); 
--signal pca_w60  : std_logic_vector(7 downto 0); 
--signal pca_w61  : std_logic_vector(7 downto 0); 
--signal pca_w62  : std_logic_vector(7 downto 0); 
--signal pca_w63  : std_logic_vector(7 downto 0); 
--signal pca_w64  : std_logic_vector(7 downto 0); 

signal pca_w_data     : std_logic_vector(64*8-1 downto 0);
signal pca_w_addr     : std_logic_vector(5 downto 0);
signal pca_col_count  : std_logic_vector(7 downto 0); --max 265 columns

signal pca_d01_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d02_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d03_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d04_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d05_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d06_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d07_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d08_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d09_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d10_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d11_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d12_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d13_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d14_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d15_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d16_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d17_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d18_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d19_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d20_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d21_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d22_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d23_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d24_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d25_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d26_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d27_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d28_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d29_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d30_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d31_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d32_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d33_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d34_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d35_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d36_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d37_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d38_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d39_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d40_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d41_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d42_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d43_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d44_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d45_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d46_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d47_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d48_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d49_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d50_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d51_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d52_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d53_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d54_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d55_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d56_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d57_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d58_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d59_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d60_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d61_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d62_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d63_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d64_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);


signal pca_d65_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d66_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d67_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d68_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d69_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d70_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d71_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d72_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d73_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d74_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d75_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d76_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d77_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d78_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d79_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d80_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d81_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d82_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d83_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d84_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d85_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d86_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d87_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d88_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d89_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d90_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d91_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d92_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d93_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d94_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d95_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d96_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d97_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d98_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d99_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d100_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d101_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d102_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d103_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d104_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d105_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d106_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d107_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d108_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d109_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d110_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d111_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d112_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d113_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d114_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d115_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d116_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d117_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d118_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d119_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d120_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d121_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d122_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d123_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d124_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d125_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d126_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d127_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);
signal pca_d128_out   : std_logic_vector(CL_W + PCAweightW + 5 downto 0);

signal pca_en_out  : std_logic;
signal pca_sof_out : std_logic;

signal d_tmp_1_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_2_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_3_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_4_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_5_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_6_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_7_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_8_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_9_out   : std_logic_vector (Wb-1 downto 0);
signal d_tmp_10_out  : std_logic_vector (Wb-1 downto 0);
signal d_tmp_11_out  : std_logic_vector (Wb-1 downto 0);
signal d_tmp_12_out  : std_logic_vector (Wb-1 downto 0);
signal d_tmp_13_out  : std_logic_vector (Wb-1 downto 0);
signal d_tmp_14_out  : std_logic_vector (Wb-1 downto 0);
signal d_tmp_15_out  : std_logic_vector (Wb-1 downto 0);
signal d_tmp_16_out  : std_logic_vector (Wb-1 downto 0);


type Huff_code_type  is array ( 0 to 255 ) of std_logic_vector(Huff_wid-1 downto 0);
type Huff_width_type is array ( 0 to 255 ) of std_logic_vector(         3 downto 0);

constant Huff_code  : Huff_code_type  := ( 0 => x"003", 1 => x"037", 2 => x"932", 3 => x"124", 4 => x"611", 5 => x"027", 6 => x"523", 7 => x"630", 8 => x"121", 9 => x"361", others => x"BAD"); 
constant Huff_width : Huff_width_type := ( 0 => x"4", 1 => x"8",  2 => x"C",   3 => x"C",   4 => x"C",   5 => x"8",  6 => x"C",   7 => x"C",   8 => x"C",   9 => x"C",   others => x"C"); 

signal h_en          : std_logic;
signal h_count_en    : std_logic;
signal h_count_en2   : std_logic;
signal h_count       : std_logic_vector(         7 downto 0);
signal alpha_data    : std_logic_vector(         7 downto 0);
signal alpha_code    : std_logic_vector(Huff_wid-1 downto 0);
signal alpha_width   : std_logic_vector(         3 downto 0);



signal huff_out      : std_logic_vector (Wb-1 downto 0);

-- PCA disable signals
signal PCA_dis1, PCA_dis2, PCA_dis3, PCA_dis4, PCA_dis5, PCA_dis6, PCA_dis7, PCA_dis8, PCA_dis9 , PCA_dis10, PCA_dis11, PCA_dis12, PCA_dis13, PCA_dis14, PCA_dis15, PCA_dis16  : std_logic_vector(7 downto 0);
begin

-- weight init

  p_weight1 : process (clk,rst)
  begin
    if rst = '1' then
       w_en        <= '0';
       w_count_en  <= '1';
       w_count_en2 <= '0';
       w_count     <= (others => '0');
    elsif rising_edge(clk) then
       if w_count_en = '1' then
          w_num   <= w_count;
          w_count <= w_count + 1;
       end if;
       if w_count = (2**(w_count'left+1) - 1) then
          w_count_en <= '0';
       end if;
       w_count_en2 <= w_count_en;
       w_en        <= w_count_en2;
    end if;
  end process p_weight1;

  p_weight2 : process (clk)
  begin
    if rising_edge(clk) then
       w01_in <=  weight01(conv_integer('0' & w_count));
       w02_in <=  weight02(conv_integer('0' & w_count));
       w03_in <=  weight03(conv_integer('0' & w_count));
       w04_in <=  weight04(conv_integer('0' & w_count));
       w05_in <=  weight05(conv_integer('0' & w_count));
       w06_in <=  weight06(conv_integer('0' & w_count));
       w07_in <=  weight07(conv_integer('0' & w_count));
       w08_in <=  weight08(conv_integer('0' & w_count));
       w09_in <=  weight09(conv_integer('0' & w_count));
       w10_in <=  weight10(conv_integer('0' & w_count));
       w11_in <=  weight11(conv_integer('0' & w_count));
       w12_in <=  weight12(conv_integer('0' & w_count));
       w13_in <=  weight13(conv_integer('0' & w_count));
       w14_in <=  weight14(conv_integer('0' & w_count));
       w15_in <=  weight15(conv_integer('0' & w_count));
       w16_in <=  weight16(conv_integer('0' & w_count));
       w17_in <=  weight17(conv_integer('0' & w_count));
       w18_in <=  weight18(conv_integer('0' & w_count));
       w19_in <=  weight19(conv_integer('0' & w_count));
       w20_in <=  weight20(conv_integer('0' & w_count));
       w21_in <=  weight21(conv_integer('0' & w_count));
       w22_in <=  weight22(conv_integer('0' & w_count));
       w23_in <=  weight23(conv_integer('0' & w_count));
       w24_in <=  weight24(conv_integer('0' & w_count));
       w25_in <=  weight25(conv_integer('0' & w_count));
       w26_in <=  weight26(conv_integer('0' & w_count));
       w27_in <=  weight27(conv_integer('0' & w_count));
       w28_in <=  weight28(conv_integer('0' & w_count));
       w29_in <=  weight29(conv_integer('0' & w_count));
       w30_in <=  weight30(conv_integer('0' & w_count));
       w31_in <=  weight31(conv_integer('0' & w_count));
       w32_in <=  weight32(conv_integer('0' & w_count));
       w33_in <=  weight33(conv_integer('0' & w_count));
       w34_in <=  weight34(conv_integer('0' & w_count));
       w35_in <=  weight35(conv_integer('0' & w_count));
       w36_in <=  weight36(conv_integer('0' & w_count));
       w37_in <=  weight37(conv_integer('0' & w_count));
       w38_in <=  weight38(conv_integer('0' & w_count));
       w39_in <=  weight39(conv_integer('0' & w_count));
       w40_in <=  weight40(conv_integer('0' & w_count));
       w41_in <=  weight41(conv_integer('0' & w_count));
       w42_in <=  weight42(conv_integer('0' & w_count));
       w43_in <=  weight43(conv_integer('0' & w_count));
       w44_in <=  weight44(conv_integer('0' & w_count));
       w45_in <=  weight45(conv_integer('0' & w_count));
       w46_in <=  weight46(conv_integer('0' & w_count));
       w47_in <=  weight47(conv_integer('0' & w_count));
       w48_in <=  weight48(conv_integer('0' & w_count));
       w49_in <=  weight49(conv_integer('0' & w_count));
       w50_in <=  weight50(conv_integer('0' & w_count));
       w51_in <=  weight51(conv_integer('0' & w_count));
       w52_in <=  weight52(conv_integer('0' & w_count));
       w53_in <=  weight53(conv_integer('0' & w_count));
       w54_in <=  weight54(conv_integer('0' & w_count));
       w55_in <=  weight55(conv_integer('0' & w_count));
       w56_in <=  weight56(conv_integer('0' & w_count));
       w57_in <=  weight57(conv_integer('0' & w_count));
       w58_in <=  weight58(conv_integer('0' & w_count));
       w59_in <=  weight59(conv_integer('0' & w_count));
       w60_in <=  weight60(conv_integer('0' & w_count));
       w61_in <=  weight61(conv_integer('0' & w_count));
       w62_in <=  weight62(conv_integer('0' & w_count));
       w63_in <=  weight63(conv_integer('0' & w_count));
       w64_in <=  weight64(conv_integer('0' & w_count));


       w65_in <=  weight01(conv_integer('0' & w_count));
       w66_in <=  weight02(conv_integer('0' & w_count));
       w67_in <=  weight03(conv_integer('0' & w_count));
       w68_in <=  weight04(conv_integer('0' & w_count));
       w69_in <=  weight05(conv_integer('0' & w_count));
       w70_in <=  weight06(conv_integer('0' & w_count));
       w71_in <=  weight07(conv_integer('0' & w_count));
       w72_in <=  weight08(conv_integer('0' & w_count));
       w73_in <=  weight09(conv_integer('0' & w_count));
       w74_in <=  weight10(conv_integer('0' & w_count));
       w75_in <=  weight11(conv_integer('0' & w_count));
       w76_in <=  weight12(conv_integer('0' & w_count));
       w77_in <=  weight13(conv_integer('0' & w_count));
       w78_in <=  weight14(conv_integer('0' & w_count));
       w79_in <=  weight15(conv_integer('0' & w_count));
       w80_in <=  weight16(conv_integer('0' & w_count));
       w81_in <=  weight17(conv_integer('0' & w_count));
       w82_in <=  weight18(conv_integer('0' & w_count));
       w83_in <=  weight19(conv_integer('0' & w_count));
       w84_in <=  weight20(conv_integer('0' & w_count));
       w85_in <=  weight21(conv_integer('0' & w_count));
       w86_in <=  weight22(conv_integer('0' & w_count));
       w87_in <=  weight23(conv_integer('0' & w_count));
       w88_in <=  weight24(conv_integer('0' & w_count));
       w89_in <=  weight25(conv_integer('0' & w_count));
       w90_in <=  weight26(conv_integer('0' & w_count));
       w91_in <=  weight27(conv_integer('0' & w_count));
       w92_in <=  weight28(conv_integer('0' & w_count));
       w93_in <=  weight29(conv_integer('0' & w_count));
       w94_in <=  weight30(conv_integer('0' & w_count));
       w95_in <=  weight31(conv_integer('0' & w_count));
       w96_in <=  weight32(conv_integer('0' & w_count));
       w97_in <=  weight33(conv_integer('0' & w_count));
       w98_in <=  weight34(conv_integer('0' & w_count));
       w99_in <=  weight35(conv_integer('0' & w_count));
       w100_in <=  weight36(conv_integer('0' & w_count));
       w101_in <=  weight37(conv_integer('0' & w_count));
       w102_in <=  weight38(conv_integer('0' & w_count));
       w103_in <=  weight39(conv_integer('0' & w_count));
       w104_in <=  weight40(conv_integer('0' & w_count));
       w105_in <=  weight41(conv_integer('0' & w_count));
       w106_in <=  weight42(conv_integer('0' & w_count));
       w107_in <=  weight43(conv_integer('0' & w_count));
       w108_in <=  weight44(conv_integer('0' & w_count));
       w109_in <=  weight45(conv_integer('0' & w_count));
       w110_in <=  weight46(conv_integer('0' & w_count));
       w111_in <=  weight47(conv_integer('0' & w_count));
       w112_in <=  weight48(conv_integer('0' & w_count));
       w113_in <=  weight49(conv_integer('0' & w_count));
       w114_in <=  weight50(conv_integer('0' & w_count));
       w115_in <=  weight51(conv_integer('0' & w_count));
       w116_in <=  weight52(conv_integer('0' & w_count));
       w117_in <=  weight53(conv_integer('0' & w_count));
       w118_in <=  weight54(conv_integer('0' & w_count));
       w119_in <=  weight55(conv_integer('0' & w_count));
       w120_in <=  weight56(conv_integer('0' & w_count));
       w121_in <=  weight57(conv_integer('0' & w_count));
       w122_in <=  weight58(conv_integer('0' & w_count));
       w123_in <=  weight59(conv_integer('0' & w_count));
       w124_in <=  weight60(conv_integer('0' & w_count));
       w125_in <=  weight61(conv_integer('0' & w_count));
       w126_in <=  weight62(conv_integer('0' & w_count));
       w127_in <=  weight63(conv_integer('0' & w_count));
       w128_in <=  weight64(conv_integer('0' & w_count));

    end if;
  end process p_weight2;

CL01: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w01_in, w_num => w_num, w_en => w_en, d_out => d01_out1, en_out => cl_en_out, sof_out => cl_sof_out);
CL02: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w02_in, w_num => w_num, w_en => w_en, d_out => d02_out1, en_out => open, sof_out => open);
CL03: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w03_in, w_num => w_num, w_en => w_en, d_out => d03_out1, en_out => open, sof_out => open);
CL04: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w04_in, w_num => w_num, w_en => w_en, d_out => d04_out1, en_out => open, sof_out => open);
CL05: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w05_in, w_num => w_num, w_en => w_en, d_out => d05_out1, en_out => open, sof_out => open);
CL06: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w06_in, w_num => w_num, w_en => w_en, d_out => d06_out1, en_out => open, sof_out => open);
CL07: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w07_in, w_num => w_num, w_en => w_en, d_out => d07_out1, en_out => open, sof_out => open);
CL08: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w08_in, w_num => w_num, w_en => w_en, d_out => d08_out1, en_out => open, sof_out => open);
CL09: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w09_in, w_num => w_num, w_en => w_en, d_out => d09_out1, en_out => open, sof_out => open);
CL10: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w10_in, w_num => w_num, w_en => w_en, d_out => d10_out1, en_out => open, sof_out => open);
CL11: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w11_in, w_num => w_num, w_en => w_en, d_out => d11_out1, en_out => open, sof_out => open);
CL12: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w12_in, w_num => w_num, w_en => w_en, d_out => d12_out1, en_out => open, sof_out => open);
CL13: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w13_in, w_num => w_num, w_en => w_en, d_out => d13_out1, en_out => open, sof_out => open);
CL14: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w14_in, w_num => w_num, w_en => w_en, d_out => d14_out1, en_out => open, sof_out => open);
CL15: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w15_in, w_num => w_num, w_en => w_en, d_out => d15_out1, en_out => open, sof_out => open);
CL16: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w16_in, w_num => w_num, w_en => w_en, d_out => d16_out1, en_out => open, sof_out => open);
CL17: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w17_in, w_num => w_num, w_en => w_en, d_out => d17_out1, en_out => open, sof_out => open);
CL18: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w18_in, w_num => w_num, w_en => w_en, d_out => d18_out1, en_out => open, sof_out => open);
CL19: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w19_in, w_num => w_num, w_en => w_en, d_out => d19_out1, en_out => open, sof_out => open);
CL20: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w20_in, w_num => w_num, w_en => w_en, d_out => d20_out1, en_out => open, sof_out => open);
CL21: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w21_in, w_num => w_num, w_en => w_en, d_out => d21_out1, en_out => open, sof_out => open);
CL22: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w22_in, w_num => w_num, w_en => w_en, d_out => d22_out1, en_out => open, sof_out => open);
CL23: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w23_in, w_num => w_num, w_en => w_en, d_out => d23_out1, en_out => open, sof_out => open);
CL24: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w24_in, w_num => w_num, w_en => w_en, d_out => d24_out1, en_out => open, sof_out => open);
CL25: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w25_in, w_num => w_num, w_en => w_en, d_out => d25_out1, en_out => open, sof_out => open);
CL26: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w26_in, w_num => w_num, w_en => w_en, d_out => d26_out1, en_out => open, sof_out => open);
CL27: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w27_in, w_num => w_num, w_en => w_en, d_out => d27_out1, en_out => open, sof_out => open);
CL28: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w28_in, w_num => w_num, w_en => w_en, d_out => d28_out1, en_out => open, sof_out => open);
CL29: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w29_in, w_num => w_num, w_en => w_en, d_out => d29_out1, en_out => open, sof_out => open);
CL30: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w30_in, w_num => w_num, w_en => w_en, d_out => d30_out1, en_out => open, sof_out => open);
CL31: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w31_in, w_num => w_num, w_en => w_en, d_out => d31_out1, en_out => open, sof_out => open);
CL32: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w32_in, w_num => w_num, w_en => w_en, d_out => d32_out1, en_out => open, sof_out => open);
CL33: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w33_in, w_num => w_num, w_en => w_en, d_out => d33_out1, en_out => open, sof_out => open);
CL34: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w34_in, w_num => w_num, w_en => w_en, d_out => d34_out1, en_out => open, sof_out => open);
CL35: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w35_in, w_num => w_num, w_en => w_en, d_out => d35_out1, en_out => open, sof_out => open);
CL36: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w36_in, w_num => w_num, w_en => w_en, d_out => d36_out1, en_out => open, sof_out => open);
CL37: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w37_in, w_num => w_num, w_en => w_en, d_out => d37_out1, en_out => open, sof_out => open);
CL38: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w38_in, w_num => w_num, w_en => w_en, d_out => d38_out1, en_out => open, sof_out => open);
CL39: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w39_in, w_num => w_num, w_en => w_en, d_out => d39_out1, en_out => open, sof_out => open);
CL40: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w40_in, w_num => w_num, w_en => w_en, d_out => d40_out1, en_out => open, sof_out => open);
CL41: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w41_in, w_num => w_num, w_en => w_en, d_out => d41_out1, en_out => open, sof_out => open);
CL42: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w42_in, w_num => w_num, w_en => w_en, d_out => d42_out1, en_out => open, sof_out => open);
CL43: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w43_in, w_num => w_num, w_en => w_en, d_out => d43_out1, en_out => open, sof_out => open);
CL44: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w44_in, w_num => w_num, w_en => w_en, d_out => d44_out1, en_out => open, sof_out => open);
CL45: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w45_in, w_num => w_num, w_en => w_en, d_out => d45_out1, en_out => open, sof_out => open);
CL46: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w46_in, w_num => w_num, w_en => w_en, d_out => d46_out1, en_out => open, sof_out => open);
CL47: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w47_in, w_num => w_num, w_en => w_en, d_out => d47_out1, en_out => open, sof_out => open);
CL48: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w48_in, w_num => w_num, w_en => w_en, d_out => d48_out1, en_out => open, sof_out => open);
CL49: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w49_in, w_num => w_num, w_en => w_en, d_out => d49_out1, en_out => open, sof_out => open);
CL50: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w50_in, w_num => w_num, w_en => w_en, d_out => d50_out1, en_out => open, sof_out => open);
CL51: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w51_in, w_num => w_num, w_en => w_en, d_out => d51_out1, en_out => open, sof_out => open);
CL52: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w52_in, w_num => w_num, w_en => w_en, d_out => d52_out1, en_out => open, sof_out => open);
CL53: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w53_in, w_num => w_num, w_en => w_en, d_out => d53_out1, en_out => open, sof_out => open);
CL54: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w54_in, w_num => w_num, w_en => w_en, d_out => d54_out1, en_out => open, sof_out => open);
CL55: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w55_in, w_num => w_num, w_en => w_en, d_out => d55_out1, en_out => open, sof_out => open);
CL56: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w56_in, w_num => w_num, w_en => w_en, d_out => d56_out1, en_out => open, sof_out => open);
CL57: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w57_in, w_num => w_num, w_en => w_en, d_out => d57_out1, en_out => open, sof_out => open);
CL58: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w58_in, w_num => w_num, w_en => w_en, d_out => d58_out1, en_out => open, sof_out => open);
CL59: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w59_in, w_num => w_num, w_en => w_en, d_out => d59_out1, en_out => open, sof_out => open);
CL60: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w60_in, w_num => w_num, w_en => w_en, d_out => d60_out1, en_out => open, sof_out => open);
CL61: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w61_in, w_num => w_num, w_en => w_en, d_out => d61_out1, en_out => open, sof_out => open);
CL62: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w62_in, w_num => w_num, w_en => w_en, d_out => d62_out1, en_out => open, sof_out => open);
CL63: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w63_in, w_num => w_num, w_en => w_en, d_out => d63_out1, en_out => open, sof_out => open);
CL64: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w64_in, w_num => w_num, w_en => w_en, d_out => d64_out1, en_out => open, sof_out => open);

CL65 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w65_in,  w_num => w_num, w_en => w_en, d_out => d65_out1 , en_out => open, sof_out => open);
CL66 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w66_in,  w_num => w_num, w_en => w_en, d_out => d66_out1 , en_out => open, sof_out => open);
CL67 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w67_in,  w_num => w_num, w_en => w_en, d_out => d67_out1 , en_out => open, sof_out => open);
CL68 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w68_in,  w_num => w_num, w_en => w_en, d_out => d68_out1 , en_out => open, sof_out => open);
CL69 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w69_in,  w_num => w_num, w_en => w_en, d_out => d69_out1 , en_out => open, sof_out => open);
CL70 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w70_in,  w_num => w_num, w_en => w_en, d_out => d70_out1 , en_out => open, sof_out => open);
CL71 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w71_in,  w_num => w_num, w_en => w_en, d_out => d71_out1 , en_out => open, sof_out => open);
CL72 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w72_in,  w_num => w_num, w_en => w_en, d_out => d72_out1 , en_out => open, sof_out => open);
CL73 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w73_in,  w_num => w_num, w_en => w_en, d_out => d73_out1 , en_out => open, sof_out => open);
CL74 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w74_in,  w_num => w_num, w_en => w_en, d_out => d74_out1 , en_out => open, sof_out => open);
CL75 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w75_in,  w_num => w_num, w_en => w_en, d_out => d75_out1 , en_out => open, sof_out => open);
CL76 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w76_in,  w_num => w_num, w_en => w_en, d_out => d76_out1 , en_out => open, sof_out => open);
CL77 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w77_in,  w_num => w_num, w_en => w_en, d_out => d77_out1 , en_out => open, sof_out => open);
CL78 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w78_in,  w_num => w_num, w_en => w_en, d_out => d78_out1 , en_out => open, sof_out => open);
CL79 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w79_in,  w_num => w_num, w_en => w_en, d_out => d79_out1 , en_out => open, sof_out => open);
CL80 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w80_in,  w_num => w_num, w_en => w_en, d_out => d80_out1 , en_out => open, sof_out => open);
CL81 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w81_in,  w_num => w_num, w_en => w_en, d_out => d81_out1 , en_out => open, sof_out => open);
CL82 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w82_in,  w_num => w_num, w_en => w_en, d_out => d82_out1 , en_out => open, sof_out => open);
CL83 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w83_in,  w_num => w_num, w_en => w_en, d_out => d83_out1 , en_out => open, sof_out => open);
CL84 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w84_in,  w_num => w_num, w_en => w_en, d_out => d84_out1 , en_out => open, sof_out => open);
CL85 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w85_in,  w_num => w_num, w_en => w_en, d_out => d85_out1 , en_out => open, sof_out => open);
CL86 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w86_in,  w_num => w_num, w_en => w_en, d_out => d86_out1 , en_out => open, sof_out => open);
CL87 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w87_in,  w_num => w_num, w_en => w_en, d_out => d87_out1 , en_out => open, sof_out => open);
CL88 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w88_in,  w_num => w_num, w_en => w_en, d_out => d88_out1 , en_out => open, sof_out => open);
CL89 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w89_in,  w_num => w_num, w_en => w_en, d_out => d89_out1 , en_out => open, sof_out => open);
CL90 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w90_in,  w_num => w_num, w_en => w_en, d_out => d90_out1 , en_out => open, sof_out => open);
CL91 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w91_in,  w_num => w_num, w_en => w_en, d_out => d91_out1 , en_out => open, sof_out => open);
CL92 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w92_in,  w_num => w_num, w_en => w_en, d_out => d92_out1 , en_out => open, sof_out => open);
CL93 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w93_in,  w_num => w_num, w_en => w_en, d_out => d93_out1 , en_out => open, sof_out => open);
CL94 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w94_in,  w_num => w_num, w_en => w_en, d_out => d94_out1 , en_out => open, sof_out => open);
CL95 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w95_in,  w_num => w_num, w_en => w_en, d_out => d95_out1 , en_out => open, sof_out => open);
CL96 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w96_in,  w_num => w_num, w_en => w_en, d_out => d96_out1 , en_out => open, sof_out => open);
CL97 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w97_in,  w_num => w_num, w_en => w_en, d_out => d97_out1 , en_out => open, sof_out => open);
CL98 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w98_in,  w_num => w_num, w_en => w_en, d_out => d98_out1 , en_out => open, sof_out => open);
CL99 : ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w99_in,  w_num => w_num, w_en => w_en, d_out => d99_out1 , en_out => open, sof_out => open);
CL100: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w100_in, w_num => w_num, w_en => w_en, d_out => d100_out1, en_out => open, sof_out => open);
CL101: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w101_in, w_num => w_num, w_en => w_en, d_out => d101_out1, en_out => open, sof_out => open);
CL102: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w102_in, w_num => w_num, w_en => w_en, d_out => d102_out1, en_out => open, sof_out => open);
CL103: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w103_in, w_num => w_num, w_en => w_en, d_out => d103_out1, en_out => open, sof_out => open);
CL104: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w104_in, w_num => w_num, w_en => w_en, d_out => d104_out1, en_out => open, sof_out => open);
CL105: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w105_in, w_num => w_num, w_en => w_en, d_out => d105_out1, en_out => open, sof_out => open);
CL106: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w106_in, w_num => w_num, w_en => w_en, d_out => d106_out1, en_out => open, sof_out => open);
CL107: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w107_in, w_num => w_num, w_en => w_en, d_out => d107_out1, en_out => open, sof_out => open);
CL108: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w108_in, w_num => w_num, w_en => w_en, d_out => d108_out1, en_out => open, sof_out => open);
CL109: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w109_in, w_num => w_num, w_en => w_en, d_out => d109_out1, en_out => open, sof_out => open);
CL110: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w110_in, w_num => w_num, w_en => w_en, d_out => d110_out1, en_out => open, sof_out => open);
CL111: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w111_in, w_num => w_num, w_en => w_en, d_out => d111_out1, en_out => open, sof_out => open);
CL112: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w112_in, w_num => w_num, w_en => w_en, d_out => d112_out1, en_out => open, sof_out => open);
CL113: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w113_in, w_num => w_num, w_en => w_en, d_out => d113_out1, en_out => open, sof_out => open);
CL114: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w114_in, w_num => w_num, w_en => w_en, d_out => d114_out1, en_out => open, sof_out => open);
CL115: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w115_in, w_num => w_num, w_en => w_en, d_out => d115_out1, en_out => open, sof_out => open);
CL116: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w116_in, w_num => w_num, w_en => w_en, d_out => d116_out1, en_out => open, sof_out => open);
CL117: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w117_in, w_num => w_num, w_en => w_en, d_out => d117_out1, en_out => open, sof_out => open);
CL118: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w118_in, w_num => w_num, w_en => w_en, d_out => d118_out1, en_out => open, sof_out => open);
CL119: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w119_in, w_num => w_num, w_en => w_en, d_out => d119_out1, en_out => open, sof_out => open);
CL120: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w120_in, w_num => w_num, w_en => w_en, d_out => d120_out1, en_out => open, sof_out => open);
CL121: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w121_in, w_num => w_num, w_en => w_en, d_out => d121_out1, en_out => open, sof_out => open);
CL122: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w122_in, w_num => w_num, w_en => w_en, d_out => d122_out1, en_out => open, sof_out => open);
CL123: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w123_in, w_num => w_num, w_en => w_en, d_out => d123_out1, en_out => open, sof_out => open);
CL124: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w124_in, w_num => w_num, w_en => w_en, d_out => d124_out1, en_out => open, sof_out => open);
CL125: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w125_in, w_num => w_num, w_en => w_en, d_out => d125_out1, en_out => open, sof_out => open);
CL126: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w126_in, w_num => w_num, w_en => w_en, d_out => d126_out1, en_out => open, sof_out => open);
CL127: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w127_in, w_num => w_num, w_en => w_en, d_out => d127_out1, en_out => open, sof_out => open);
CL128: ConvLayer generic map (mult_sum => mult_sum,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w128_in, w_num => w_num, w_en => w_en, d_out => d128_out1, en_out => open, sof_out => open);


d01_out(7 downto 0) <= d01_out1(d01_out1'left downto d01_out1'left -7);
d02_out(7 downto 0) <= d02_out1(d02_out1'left downto d02_out1'left -7);
d03_out(7 downto 0) <= d03_out1(d03_out1'left downto d03_out1'left -7);
d04_out(7 downto 0) <= d04_out1(d04_out1'left downto d04_out1'left -7);
d05_out(7 downto 0) <= d05_out1(d05_out1'left downto d05_out1'left -7);
d06_out(7 downto 0) <= d06_out1(d06_out1'left downto d06_out1'left -7);
d07_out(7 downto 0) <= d07_out1(d07_out1'left downto d07_out1'left -7);
d08_out(7 downto 0) <= d08_out1(d08_out1'left downto d08_out1'left -7);
d09_out(7 downto 0) <= d09_out1(d09_out1'left downto d09_out1'left -7);
d10_out(7 downto 0) <= d10_out1(d10_out1'left downto d10_out1'left -7);
d11_out(7 downto 0) <= d11_out1(d11_out1'left downto d11_out1'left -7);
d12_out(7 downto 0) <= d12_out1(d12_out1'left downto d12_out1'left -7);
d13_out(7 downto 0) <= d13_out1(d13_out1'left downto d13_out1'left -7);
d14_out(7 downto 0) <= d14_out1(d14_out1'left downto d14_out1'left -7);
d15_out(7 downto 0) <= d15_out1(d15_out1'left downto d15_out1'left -7);
d16_out(7 downto 0) <= d16_out1(d16_out1'left downto d16_out1'left -7);
d17_out(7 downto 0) <= d17_out1(d17_out1'left downto d17_out1'left -7);
d18_out(7 downto 0) <= d18_out1(d18_out1'left downto d18_out1'left -7);
d19_out(7 downto 0) <= d19_out1(d19_out1'left downto d19_out1'left -7);
d20_out(7 downto 0) <= d20_out1(d20_out1'left downto d20_out1'left -7);
d21_out(7 downto 0) <= d21_out1(d21_out1'left downto d21_out1'left -7);
d22_out(7 downto 0) <= d22_out1(d22_out1'left downto d22_out1'left -7);
d23_out(7 downto 0) <= d23_out1(d23_out1'left downto d23_out1'left -7);
d24_out(7 downto 0) <= d24_out1(d24_out1'left downto d24_out1'left -7);
d25_out(7 downto 0) <= d25_out1(d25_out1'left downto d25_out1'left -7);
d26_out(7 downto 0) <= d26_out1(d26_out1'left downto d26_out1'left -7);
d27_out(7 downto 0) <= d27_out1(d27_out1'left downto d27_out1'left -7);
d28_out(7 downto 0) <= d28_out1(d28_out1'left downto d28_out1'left -7);
d29_out(7 downto 0) <= d29_out1(d29_out1'left downto d29_out1'left -7);
d30_out(7 downto 0) <= d30_out1(d30_out1'left downto d30_out1'left -7);
d31_out(7 downto 0) <= d31_out1(d31_out1'left downto d31_out1'left -7);
d32_out(7 downto 0) <= d32_out1(d32_out1'left downto d32_out1'left -7);
d33_out(7 downto 0) <= d33_out1(d33_out1'left downto d33_out1'left -7);
d34_out(7 downto 0) <= d34_out1(d34_out1'left downto d34_out1'left -7);
d35_out(7 downto 0) <= d35_out1(d35_out1'left downto d35_out1'left -7);
d36_out(7 downto 0) <= d36_out1(d36_out1'left downto d36_out1'left -7);
d37_out(7 downto 0) <= d37_out1(d37_out1'left downto d37_out1'left -7);
d38_out(7 downto 0) <= d38_out1(d38_out1'left downto d38_out1'left -7);
d39_out(7 downto 0) <= d39_out1(d39_out1'left downto d39_out1'left -7);
d40_out(7 downto 0) <= d40_out1(d40_out1'left downto d40_out1'left -7);
d41_out(7 downto 0) <= d41_out1(d41_out1'left downto d41_out1'left -7);
d42_out(7 downto 0) <= d42_out1(d42_out1'left downto d42_out1'left -7);
d43_out(7 downto 0) <= d43_out1(d43_out1'left downto d43_out1'left -7);
d44_out(7 downto 0) <= d44_out1(d44_out1'left downto d44_out1'left -7);
d45_out(7 downto 0) <= d45_out1(d45_out1'left downto d45_out1'left -7);
d46_out(7 downto 0) <= d46_out1(d46_out1'left downto d46_out1'left -7);
d47_out(7 downto 0) <= d47_out1(d47_out1'left downto d47_out1'left -7);
d48_out(7 downto 0) <= d48_out1(d48_out1'left downto d48_out1'left -7);
d49_out(7 downto 0) <= d49_out1(d49_out1'left downto d49_out1'left -7);
d50_out(7 downto 0) <= d50_out1(d50_out1'left downto d50_out1'left -7);
d51_out(7 downto 0) <= d51_out1(d51_out1'left downto d51_out1'left -7);
d52_out(7 downto 0) <= d52_out1(d52_out1'left downto d52_out1'left -7);
d53_out(7 downto 0) <= d53_out1(d53_out1'left downto d53_out1'left -7);
d54_out(7 downto 0) <= d54_out1(d54_out1'left downto d54_out1'left -7);
d55_out(7 downto 0) <= d55_out1(d55_out1'left downto d55_out1'left -7);
d56_out(7 downto 0) <= d56_out1(d56_out1'left downto d56_out1'left -7);
d57_out(7 downto 0) <= d57_out1(d57_out1'left downto d57_out1'left -7);
d58_out(7 downto 0) <= d58_out1(d58_out1'left downto d58_out1'left -7);
d59_out(7 downto 0) <= d59_out1(d59_out1'left downto d59_out1'left -7);
d60_out(7 downto 0) <= d60_out1(d60_out1'left downto d60_out1'left -7);
d61_out(7 downto 0) <= d61_out1(d61_out1'left downto d61_out1'left -7);
d62_out(7 downto 0) <= d62_out1(d62_out1'left downto d62_out1'left -7);
d63_out(7 downto 0) <= d63_out1(d63_out1'left downto d63_out1'left -7);
d64_out(7 downto 0) <= d64_out1(d64_out1'left downto d64_out1'left -7);

d65_out (7 downto 0) <= d65_out1 (d65_out1'left  downto d65_out1'left  -7);
d66_out (7 downto 0) <= d66_out1 (d66_out1'left  downto d66_out1'left  -7);
d67_out (7 downto 0) <= d67_out1 (d67_out1'left  downto d67_out1'left  -7);
d68_out (7 downto 0) <= d68_out1 (d68_out1'left  downto d68_out1'left  -7);
d69_out (7 downto 0) <= d69_out1 (d69_out1'left  downto d69_out1'left  -7);
d70_out (7 downto 0) <= d70_out1 (d70_out1'left  downto d70_out1'left  -7);
d71_out (7 downto 0) <= d71_out1 (d71_out1'left  downto d71_out1'left  -7);
d72_out (7 downto 0) <= d72_out1 (d72_out1'left  downto d72_out1'left  -7);
d73_out (7 downto 0) <= d73_out1 (d73_out1'left  downto d73_out1'left  -7);
d74_out (7 downto 0) <= d74_out1 (d74_out1'left  downto d74_out1'left  -7);
d75_out (7 downto 0) <= d75_out1 (d75_out1'left  downto d75_out1'left  -7);
d76_out (7 downto 0) <= d76_out1 (d76_out1'left  downto d76_out1'left  -7);
d77_out (7 downto 0) <= d77_out1 (d77_out1'left  downto d77_out1'left  -7);
d78_out (7 downto 0) <= d78_out1 (d78_out1'left  downto d78_out1'left  -7);
d79_out (7 downto 0) <= d79_out1 (d79_out1'left  downto d79_out1'left  -7);
d80_out (7 downto 0) <= d80_out1 (d80_out1'left  downto d80_out1'left  -7);
d81_out (7 downto 0) <= d81_out1 (d81_out1'left  downto d81_out1'left  -7);
d82_out (7 downto 0) <= d82_out1 (d82_out1'left  downto d82_out1'left  -7);
d83_out (7 downto 0) <= d83_out1 (d83_out1'left  downto d83_out1'left  -7);
d84_out (7 downto 0) <= d84_out1 (d84_out1'left  downto d84_out1'left  -7);
d85_out (7 downto 0) <= d85_out1 (d85_out1'left  downto d85_out1'left  -7);
d86_out (7 downto 0) <= d86_out1 (d86_out1'left  downto d86_out1'left  -7);
d87_out (7 downto 0) <= d87_out1 (d87_out1'left  downto d87_out1'left  -7);
d88_out (7 downto 0) <= d88_out1 (d88_out1'left  downto d88_out1'left  -7);
d89_out (7 downto 0) <= d89_out1 (d89_out1'left  downto d89_out1'left  -7);
d90_out (7 downto 0) <= d90_out1 (d90_out1'left  downto d90_out1'left  -7);
d91_out (7 downto 0) <= d91_out1 (d91_out1'left  downto d91_out1'left  -7);
d92_out (7 downto 0) <= d92_out1 (d92_out1'left  downto d92_out1'left  -7);
d93_out (7 downto 0) <= d93_out1 (d93_out1'left  downto d93_out1'left  -7);
d94_out (7 downto 0) <= d94_out1 (d94_out1'left  downto d94_out1'left  -7);
d95_out (7 downto 0) <= d95_out1 (d95_out1'left  downto d95_out1'left  -7);
d96_out (7 downto 0) <= d96_out1 (d96_out1'left  downto d96_out1'left  -7);
d97_out (7 downto 0) <= d97_out1 (d97_out1'left  downto d97_out1'left  -7);
d98_out (7 downto 0) <= d98_out1 (d98_out1'left  downto d98_out1'left  -7);
d99_out (7 downto 0) <= d99_out1 (d99_out1'left  downto d99_out1'left  -7);
d100_out(7 downto 0) <= d100_out1(d100_out1'left downto d100_out1'left -7);
d101_out(7 downto 0) <= d101_out1(d101_out1'left downto d101_out1'left -7);
d102_out(7 downto 0) <= d102_out1(d102_out1'left downto d102_out1'left -7);
d103_out(7 downto 0) <= d103_out1(d103_out1'left downto d103_out1'left -7);
d104_out(7 downto 0) <= d104_out1(d104_out1'left downto d104_out1'left -7);
d105_out(7 downto 0) <= d105_out1(d105_out1'left downto d105_out1'left -7);
d106_out(7 downto 0) <= d106_out1(d106_out1'left downto d106_out1'left -7);
d107_out(7 downto 0) <= d107_out1(d107_out1'left downto d107_out1'left -7);
d108_out(7 downto 0) <= d108_out1(d108_out1'left downto d108_out1'left -7);
d109_out(7 downto 0) <= d109_out1(d109_out1'left downto d109_out1'left -7);
d110_out(7 downto 0) <= d110_out1(d110_out1'left downto d110_out1'left -7);
d111_out(7 downto 0) <= d111_out1(d111_out1'left downto d111_out1'left -7);
d112_out(7 downto 0) <= d112_out1(d112_out1'left downto d112_out1'left -7);
d113_out(7 downto 0) <= d113_out1(d113_out1'left downto d113_out1'left -7);
d114_out(7 downto 0) <= d114_out1(d114_out1'left downto d114_out1'left -7);
d115_out(7 downto 0) <= d115_out1(d115_out1'left downto d115_out1'left -7);
d116_out(7 downto 0) <= d116_out1(d116_out1'left downto d116_out1'left -7);
d117_out(7 downto 0) <= d117_out1(d117_out1'left downto d117_out1'left -7);
d118_out(7 downto 0) <= d118_out1(d118_out1'left downto d118_out1'left -7);
d119_out(7 downto 0) <= d119_out1(d119_out1'left downto d119_out1'left -7);
d120_out(7 downto 0) <= d120_out1(d120_out1'left downto d120_out1'left -7);
d121_out(7 downto 0) <= d121_out1(d121_out1'left downto d121_out1'left -7);
d122_out(7 downto 0) <= d122_out1(d122_out1'left downto d122_out1'left -7);
d123_out(7 downto 0) <= d123_out1(d123_out1'left downto d123_out1'left -7);
d124_out(7 downto 0) <= d124_out1(d124_out1'left downto d124_out1'left -7);
d125_out(7 downto 0) <= d125_out1(d125_out1'left downto d125_out1'left -7);
d126_out(7 downto 0) <= d126_out1(d126_out1'left downto d126_out1'left -7);
d127_out(7 downto 0) <= d127_out1(d127_out1'left downto d127_out1'left -7);
d128_out(7 downto 0) <= d128_out1(d128_out1'left downto d128_out1'left -7);

  p_pca_weight : process (clk)
  begin
    if rising_edge(clk) then
       if pca_w_en = '1' then
          pca_mem(conv_integer('0' & pca_w_num)) <= pca_w_in;
       end if;
    end if;
  end process p_pca_weight;

pca_w01 <= pca_mem( 0);
pca_w02 <= pca_mem( 1);
pca_w03 <= pca_mem( 2);
pca_w04 <= pca_mem( 3);
pca_w05 <= pca_mem( 4);
pca_w06 <= pca_mem( 5);
pca_w07 <= pca_mem( 6);
pca_w08 <= pca_mem( 7);
pca_w09 <= pca_mem( 8);
pca_w10 <= pca_mem( 9);
pca_w11 <= pca_mem(10);
pca_w12 <= pca_mem(11);
pca_w13 <= pca_mem(12);
pca_w14 <= pca_mem(13);
pca_w15 <= pca_mem(14);
pca_w16 <= pca_mem(15);
pca_w17 <= pca_mem(16);
pca_w18 <= pca_mem(17);
pca_w19 <= pca_mem(18);
pca_w20 <= pca_mem(19);
pca_w21 <= pca_mem(20);
pca_w22 <= pca_mem(21);
pca_w23 <= pca_mem(22);
pca_w24 <= pca_mem(23);
pca_w25 <= pca_mem(24);
pca_w26 <= pca_mem(25);
pca_w27 <= pca_mem(26);
pca_w28 <= pca_mem(27);
pca_w29 <= pca_mem(28);
pca_w30 <= pca_mem(29);
pca_w31 <= pca_mem(30);
pca_w32 <= pca_mem(31);
pca_w33 <= pca_mem(32);
pca_w34 <= pca_mem(33);
pca_w35 <= pca_mem(34);
pca_w36 <= pca_mem(35);
pca_w37 <= pca_mem(36);
pca_w38 <= pca_mem(37);
pca_w39 <= pca_mem(38);
pca_w40 <= pca_mem(39);
pca_w41 <= pca_mem(40);
pca_w42 <= pca_mem(41);
pca_w43 <= pca_mem(42);
pca_w44 <= pca_mem(43);
pca_w45 <= pca_mem(44);
pca_w46 <= pca_mem(45);
pca_w47 <= pca_mem(46);
pca_w48 <= pca_mem(47);
pca_w49 <= pca_mem(48);
pca_w50 <= pca_mem(49);
pca_w51 <= pca_mem(50);
pca_w52 <= pca_mem(51);
pca_w53 <= pca_mem(52);
pca_w54 <= pca_mem(53);
pca_w55 <= pca_mem(54);
pca_w56 <= pca_mem(55);
pca_w57 <= pca_mem(56);
pca_w58 <= pca_mem(57);
pca_w59 <= pca_mem(58);
pca_w60 <= pca_mem(59);
pca_w61 <= pca_mem(60);
pca_w62 <= pca_mem(61);
pca_w63 <= pca_mem(62);
pca_w64 <= pca_mem(63);


pca_w65  <= pca_mem( 64);
pca_w66  <= pca_mem( 65);
pca_w67  <= pca_mem( 66);
pca_w68  <= pca_mem( 67);
pca_w69  <= pca_mem( 68);
pca_w70  <= pca_mem( 69);
pca_w71  <= pca_mem( 70);
pca_w72  <= pca_mem( 71);
pca_w73  <= pca_mem( 72);
pca_w74  <= pca_mem( 73);
pca_w75  <= pca_mem( 74);
pca_w76  <= pca_mem( 75);
pca_w77  <= pca_mem( 76);
pca_w78  <= pca_mem( 77);
pca_w79  <= pca_mem( 78);
pca_w80  <= pca_mem( 79);
pca_w81  <= pca_mem( 80);
pca_w82  <= pca_mem( 81);
pca_w83  <= pca_mem( 82);
pca_w84  <= pca_mem( 83);
pca_w85  <= pca_mem( 84);
pca_w86  <= pca_mem( 85);
pca_w87  <= pca_mem( 86);
pca_w88  <= pca_mem( 87);
pca_w89  <= pca_mem( 88);
pca_w90  <= pca_mem( 89);
pca_w91  <= pca_mem( 90);
pca_w92  <= pca_mem( 91);
pca_w93  <= pca_mem( 92);
pca_w94  <= pca_mem( 93);
pca_w95  <= pca_mem( 94);
pca_w96  <= pca_mem( 95);
pca_w97  <= pca_mem( 96);
pca_w98  <= pca_mem( 97);
pca_w99  <= pca_mem( 98);
pca_w100 <= pca_mem( 99);
pca_w101 <= pca_mem(100);
pca_w102 <= pca_mem(101);
pca_w103 <= pca_mem(102);
pca_w104 <= pca_mem(103);
pca_w105 <= pca_mem(104);
pca_w106 <= pca_mem(105);
pca_w107 <= pca_mem(106);
pca_w108 <= pca_mem(107);
pca_w109 <= pca_mem(108);
pca_w110 <= pca_mem(109);
pca_w111 <= pca_mem(110);
pca_w112 <= pca_mem(111);
pca_w113 <= pca_mem(112);
pca_w114 <= pca_mem(113);
pca_w115 <= pca_mem(114);
pca_w116 <= pca_mem(115);
pca_w117 <= pca_mem(116);
pca_w118 <= pca_mem(117);
pca_w119 <= pca_mem(118);
pca_w120 <= pca_mem(119);
pca_w121 <= pca_mem(120);
pca_w122 <= pca_mem(121);
pca_w123 <= pca_mem(122);
pca_w124 <= pca_mem(123);
pca_w125 <= pca_mem(124);
pca_w126 <= pca_mem(125);
pca_w127 <= pca_mem(126);
pca_w128 <= pca_mem(127);
g_PCA_en: if PCA_en = TRUE generate
--PCA32_1_inst: PCA_32 
--  generic map(
--           mult_sum => mult_sum,
--           N        => CL_W,
--           M        => PCAweightW,
--           in_row   => in_row,
--           in_col   => in_col
--           )
--  port map (
--           clk       => clk    ,
--           rst       => rst    ,
--d01_in    => d01_out, d02_in    => d02_out, d03_in    => d03_out, d04_in    => d04_out, d05_in    => d05_out, d06_in    => d06_out, d07_in    => d07_out, d08_in    => d08_out, 
--d09_in    => d09_out, d10_in    => d10_out, d11_in    => d11_out, d12_in    => d12_out, d13_in    => d13_out, d14_in    => d14_out, d15_in    => d15_out, d16_in    => d16_out, 
--d17_in    => d17_out, d18_in    => d18_out, d19_in    => d19_out, d20_in    => d20_out, d21_in    => d21_out, d22_in    => d22_out, d23_in    => d23_out, d24_in    => d24_out, 
--d25_in    => d25_out, d26_in    => d26_out, d27_in    => d27_out, d28_in    => d28_out, d29_in    => d29_out, d30_in    => d30_out, d31_in    => d31_out, d32_in    => d32_out, 
--
--           en_in     => cl_en_out,
--           sof_in    => cl_sof_out,
--
--           w01      => pca_w01, --x"d9", 
--           w02      => pca_w02, --x"66", 
--           w03      => pca_w03, --x"71", 
--           w04      => pca_w04, --x"f3", 
--           w05      => pca_w05, --x"12", 
--           w06      => pca_w06, --x"8e", 
--           w07      => pca_w07, --x"9c", 
--           w08      => pca_w08, --x"ab", 
--           w09      => pca_w09, --x"dc", 
--           w10      => pca_w10, --x"ec", 
--           w11      => pca_w11, --x"af", 
--           w12      => pca_w12, --x"b7", 
--           w13      => pca_w13, --x"67", 
--           w14      => pca_w14, --x"c9", 
--           w15      => pca_w15, --x"77", 
--           w16      => pca_w16, --x"5a", 
--           w17      => pca_w17, --x"45", 
--           w18      => pca_w18, --x"89", 
--           w19      => pca_w19, --x"a3", 
--           w20      => pca_w20, --x"0a", 
--           w21      => pca_w21, --x"9c", 
--           w22      => pca_w22, --x"c9", 
--           w23      => pca_w23, --x"65", 
--           w24      => pca_w24, --x"3d", 
--           w25      => pca_w25, --x"4c", 
--           w26      => pca_w26, --x"62", 
--           w27      => pca_w27, --x"2f", 
--           w28      => pca_w28, --x"66", 
--           w29      => pca_w29, --x"4b", 
--           w30      => pca_w30, --x"f3", 
--           w31      => pca_w31, --x"a1", 
--           w32      => pca_w32, --x"ba", 
--
--           d_out   => pca_d01_out   ,
--           en_out  => pca_en_out  ,
--           sof_out => pca_sof_out );


--PCA64_1_inst: PCA_64 
--  generic map(
--           mult_sum => mult_sum,
--           N        => CL_W,
--           M        => PCAweightW,
--           in_row   => in_row,
--           in_col   => in_col
--           )
--  port map (
--           clk       => clk    ,
--           rst       => rst    ,
--d01_in    => d01_out, d02_in    => d02_out, d03_in    => d03_out, d04_in    => d04_out, d05_in    => d05_out, d06_in    => d06_out, d07_in    => d07_out, d08_in    => d08_out, 
--d09_in    => d09_out, d10_in    => d10_out, d11_in    => d11_out, d12_in    => d12_out, d13_in    => d13_out, d14_in    => d14_out, d15_in    => d15_out, d16_in    => d16_out, 
--d17_in    => d17_out, d18_in    => d18_out, d19_in    => d19_out, d20_in    => d20_out, d21_in    => d21_out, d22_in    => d22_out, d23_in    => d23_out, d24_in    => d24_out, 
--d25_in    => d25_out, d26_in    => d26_out, d27_in    => d27_out, d28_in    => d28_out, d29_in    => d29_out, d30_in    => d30_out, d31_in    => d31_out, d32_in    => d32_out, 
--d33_in    => d33_out, d34_in    => d34_out, d35_in    => d35_out, d36_in    => d36_out, d37_in    => d37_out, d38_in    => d38_out, d39_in    => d39_out, d40_in    => d40_out, 
--d41_in    => d41_out, d42_in    => d42_out, d43_in    => d43_out, d44_in    => d44_out, d45_in    => d45_out, d46_in    => d46_out, d47_in    => d47_out, d48_in    => d48_out, 
--d49_in    => d49_out, d50_in    => d50_out, d51_in    => d51_out, d52_in    => d52_out, d53_in    => d53_out, d54_in    => d54_out, d55_in    => d55_out, d56_in    => d56_out,
--d57_in    => d57_out, d58_in    => d58_out, d59_in    => d59_out, d60_in    => d60_out, d61_in    => d61_out, d62_in    => d62_out, d63_in    => d63_out, d64_in    => d64_out, 
--           en_in     => cl_en_out,
--           sof_in    => cl_sof_out,
--
--           w01      => pca_w01, --x"d9", 
--           w02      => pca_w02, --x"66", 
--           w03      => pca_w03, --x"71", 
--           w04      => pca_w04, --x"f3", 
--           w05      => pca_w05, --x"12", 
--           w06      => pca_w06, --x"8e", 
--           w07      => pca_w07, --x"9c", 
--           w08      => pca_w08, --x"ab", 
--           w09      => pca_w09, --x"dc", 
--           w10      => pca_w10, --x"ec", 
--           w11      => pca_w11, --x"af", 
--           w12      => pca_w12, --x"b7", 
--           w13      => pca_w13, --x"67", 
--           w14      => pca_w14, --x"c9", 
--           w15      => pca_w15, --x"77", 
--           w16      => pca_w16, --x"5a", 
--           w17      => pca_w17, --x"45", 
--           w18      => pca_w18, --x"89", 
--           w19      => pca_w19, --x"a3", 
--           w20      => pca_w20, --x"0a", 
--           w21      => pca_w21, --x"9c", 
--           w22      => pca_w22, --x"c9", 
--           w23      => pca_w23, --x"65", 
--           w24      => pca_w24, --x"3d", 
--           w25      => pca_w25, --x"4c", 
--           w26      => pca_w26, --x"62", 
--           w27      => pca_w27, --x"2f", 
--           w28      => pca_w28, --x"66", 
--           w29      => pca_w29, --x"4b", 
--           w30      => pca_w30, --x"f3", 
--           w31      => pca_w31, --x"a1", 
--           w32      => pca_w32, --x"ba", 
--           w33      => pca_w33, --x"38", 
--           w34      => pca_w34, --x"89", 
--           w35      => pca_w35, --x"30", 
--           w36      => pca_w36, --x"e0", 
--           w37      => pca_w37, --x"91", 
--           w38      => pca_w38, --x"e0", 
--           w39      => pca_w39, --x"69", 
--           w40      => pca_w40, --x"f8", 
--           w41      => pca_w41, --x"2f", 
--           w42      => pca_w42, --x"10", 
--           w43      => pca_w43, --x"a2", 
--           w44      => pca_w44, --x"ab", 
--           w45      => pca_w45, --x"de", 
--           w46      => pca_w46, --x"6f", 
--           w47      => pca_w47, --x"25", 
--           w48      => pca_w48, --x"a8", 
--           w49      => pca_w49, --x"b4", 
--           w50      => pca_w50, --x"89", 
--           w51      => pca_w51, --x"de", 
--           w52      => pca_w52, --x"5f", 
--           w53      => pca_w53, --x"c2", 
--           w54      => pca_w54, --x"ad", 
--           w55      => pca_w55, --x"d7", 
--           w56      => pca_w56, --x"fc", 
--           w57      => pca_w57, --x"ce", 
--           w58      => pca_w58, --x"4a", 
--           w59      => pca_w59, --x"0b", 
--           w60      => pca_w60, --x"dd", 
--           w61      => pca_w61, --x"d3", 
--           w62      => pca_w62, --x"0f", 
--           w63      => pca_w63, --x"80", 
--           w64      => pca_w64, --x"90", 
--
--           d_out   => pca_d01_out   ,
--           en_out  => pca_en_out  ,
--           sof_out => pca_sof_out );


PCA128_1_inst: PCA_128 
  generic map(
           mult_sum => mult_sum,
           N        => CL_W,
           M        => PCAweightW,
           in_row   => in_row,
           in_col   => in_col
           )
  port map (
           clk       => clk    ,
           rst       => rst    ,
d01_in    => d01_out, d02_in    => d02_out, d03_in    => d03_out, d04_in    => d04_out, d05_in    => d05_out, d06_in    => d06_out, d07_in    => d07_out, d08_in    => d08_out, 
d09_in    => d09_out, d10_in    => d10_out, d11_in    => d11_out, d12_in    => d12_out, d13_in    => d13_out, d14_in    => d14_out, d15_in    => d15_out, d16_in    => d16_out, 
d17_in    => d17_out, d18_in    => d18_out, d19_in    => d19_out, d20_in    => d20_out, d21_in    => d21_out, d22_in    => d22_out, d23_in    => d23_out, d24_in    => d24_out, 
d25_in    => d25_out, d26_in    => d26_out, d27_in    => d27_out, d28_in    => d28_out, d29_in    => d29_out, d30_in    => d30_out, d31_in    => d31_out, d32_in    => d32_out, 
d33_in    => d33_out, d34_in    => d34_out, d35_in    => d35_out, d36_in    => d36_out, d37_in    => d37_out, d38_in    => d38_out, d39_in    => d39_out, d40_in    => d40_out, 
d41_in    => d41_out, d42_in    => d42_out, d43_in    => d43_out, d44_in    => d44_out, d45_in    => d45_out, d46_in    => d46_out, d47_in    => d47_out, d48_in    => d48_out, 
d49_in    => d49_out, d50_in    => d50_out, d51_in    => d51_out, d52_in    => d52_out, d53_in    => d53_out, d54_in    => d54_out, d55_in    => d55_out, d56_in    => d56_out,
d57_in    => d57_out, d58_in    => d58_out, d59_in    => d59_out, d60_in    => d60_out, d61_in    => d61_out, d62_in    => d62_out, d63_in    => d63_out, d64_in    => d64_out, 


d65_in     => d65_out, 
d66_in     => d66_out, 
d67_in     => d67_out, 
d68_in     => d68_out, 
d69_in     => d69_out, 
d70_in     => d70_out, 
d71_in     => d71_out, 
d72_in     => d72_out, 
d73_in     => d73_out, 
d74_in     => d74_out, 
d75_in     => d75_out, 
d76_in     => d76_out, 
d77_in     => d77_out, 
d78_in     => d78_out, 
d79_in     => d79_out, 
d80_in     => d80_out, 
d81_in     => d81_out, 
d82_in     => d82_out, 
d83_in     => d83_out, 
d84_in     => d84_out, 
d85_in     => d85_out, 
d86_in     => d86_out, 
d87_in     => d87_out, 
d88_in     => d88_out, 
d89_in     => d89_out, 
d90_in     => d90_out, 
d91_in     => d91_out, 
d92_in     => d92_out, 
d93_in     => d93_out, 
d94_in     => d94_out, 
d95_in     => d95_out, 
d96_in     => d96_out, 
d97_in     => d97_out, 
d98_in     => d98_out, 
d99_in     => d99_out, 
d100_in    => d100_out, 
d101_in    => d101_out, 
d102_in    => d102_out, 
d103_in    => d103_out, 
d104_in    => d104_out, 
d105_in    => d105_out, 
d106_in    => d106_out, 
d107_in    => d107_out, 
d108_in    => d108_out, 
d109_in    => d109_out, 
d110_in    => d110_out, 
d111_in    => d111_out, 
d112_in    => d112_out, 
d113_in    => d113_out, 
d114_in    => d114_out, 
d115_in    => d115_out, 
d116_in    => d116_out, 
d117_in    => d117_out, 
d118_in    => d118_out, 
d119_in    => d119_out, 
d120_in    => d120_out,
d121_in    => d121_out, 
d122_in    => d122_out, 
d123_in    => d123_out, 
d124_in    => d124_out, 
d125_in    => d125_out, 
d126_in    => d126_out, 
d127_in    => d127_out, 
d128_in    => d128_out, 
           en_in     => cl_en_out,
           sof_in    => cl_sof_out,

           w01      => pca_w01, --x"d9", 
           w02      => pca_w02, --x"66", 
           w03      => pca_w03, --x"71", 
           w04      => pca_w04, --x"f3", 
           w05      => pca_w05, --x"12", 
           w06      => pca_w06, --x"8e", 
           w07      => pca_w07, --x"9c", 
           w08      => pca_w08, --x"ab", 
           w09      => pca_w09, --x"dc", 
           w10      => pca_w10, --x"ec", 
           w11      => pca_w11, --x"af", 
           w12      => pca_w12, --x"b7", 
           w13      => pca_w13, --x"67", 
           w14      => pca_w14, --x"c9", 
           w15      => pca_w15, --x"77", 
           w16      => pca_w16, --x"5a", 
           w17      => pca_w17, --x"45", 
           w18      => pca_w18, --x"89", 
           w19      => pca_w19, --x"a3", 
           w20      => pca_w20, --x"0a", 
           w21      => pca_w21, --x"9c", 
           w22      => pca_w22, --x"c9", 
           w23      => pca_w23, --x"65", 
           w24      => pca_w24, --x"3d", 
           w25      => pca_w25, --x"4c", 
           w26      => pca_w26, --x"62", 
           w27      => pca_w27, --x"2f", 
           w28      => pca_w28, --x"66", 
           w29      => pca_w29, --x"4b", 
           w30      => pca_w30, --x"f3", 
           w31      => pca_w31, --x"a1", 
           w32      => pca_w32, --x"ba", 
           w33      => pca_w33, --x"38", 
           w34      => pca_w34, --x"89", 
           w35      => pca_w35, --x"30", 
           w36      => pca_w36, --x"e0", 
           w37      => pca_w37, --x"91", 
           w38      => pca_w38, --x"e0", 
           w39      => pca_w39, --x"69", 
           w40      => pca_w40, --x"f8", 
           w41      => pca_w41, --x"2f", 
           w42      => pca_w42, --x"10", 
           w43      => pca_w43, --x"a2", 
           w44      => pca_w44, --x"ab", 
           w45      => pca_w45, --x"de", 
           w46      => pca_w46, --x"6f", 
           w47      => pca_w47, --x"25", 
           w48      => pca_w48, --x"a8", 
           w49      => pca_w49, --x"b4", 
           w50      => pca_w50, --x"89", 
           w51      => pca_w51, --x"de", 
           w52      => pca_w52, --x"5f", 
           w53      => pca_w53, --x"c2", 
           w54      => pca_w54, --x"ad", 
           w55      => pca_w55, --x"d7", 
           w56      => pca_w56, --x"fc", 
           w57      => pca_w57, --x"ce", 
           w58      => pca_w58, --x"4a", 
           w59      => pca_w59, --x"0b", 
           w60      => pca_w60, --x"dd", 
           w61      => pca_w61, --x"d3", 
           w62      => pca_w62, --x"0f", 
           w63      => pca_w63, --x"80", 
           w64      => pca_w64, --x"90", 


           w65       => pca_w65, --x"d9", 
           w66       => pca_w66, --x"66", 
           w67       => pca_w67, --x"71", 
           w68       => pca_w68, --x"f3", 
           w69       => pca_w69, --x"12", 
           w70       => pca_w70, --x"8e", 
           w71       => pca_w71, --x"9c", 
           w72       => pca_w72, --x"ab", 
           w73       => pca_w73, --x"dc", 
           w74       => pca_w74, --x"ec", 
           w75       => pca_w75, --x"af", 
           w76       => pca_w76, --x"b7", 
           w77       => pca_w77, --x"67", 
           w78       => pca_w78, --x"c9", 
           w79       => pca_w79, --x"77", 
           w80       => pca_w80, --x"5a", 
           w81       => pca_w81, --x"45", 
           w82       => pca_w82, --x"89", 
           w83       => pca_w83, --x"a3", 
           w84       => pca_w84, --x"0a", 
           w85       => pca_w85, --x"9c", 
           w86       => pca_w86, --x"c9", 
           w87       => pca_w87, --x"65", 
           w88       => pca_w88, --x"3d", 
           w89       => pca_w89, --x"4c", 
           w90       => pca_w90, --x"62", 
           w91       => pca_w91, --x"2f", 
           w92       => pca_w92, --x"66", 
           w93       => pca_w93, --x"4b", 
           w94       => pca_w94, --x"f3", 
           w95       => pca_w95, --x"a1", 
           w96       => pca_w96, --x"ba", 
           w97       => pca_w97, --x"38", 
           w98       => pca_w98, --x"89", 
           w99       => pca_w99, --x"30", 
           w100      => pca_w100, --x"e0", 
           w101      => pca_w101, --x"91", 
           w102      => pca_w102, --x"e0", 
           w103      => pca_w103, --x"69", 
           w104      => pca_w104, --x"f8", 
           w105      => pca_w105, --x"2f", 
           w106      => pca_w106, --x"10", 
           w107      => pca_w107, --x"a2", 
           w108      => pca_w108, --x"ab", 
           w109      => pca_w109, --x"de", 
           w110      => pca_w110, --x"6f", 
           w111      => pca_w111, --x"25", 
           w112      => pca_w112, --x"a8", 
           w113      => pca_w113, --x"b4", 
           w114      => pca_w114, --x"89", 
           w115      => pca_w115, --x"de", 
           w116      => pca_w116, --x"5f", 
           w117      => pca_w117, --x"c2", 
           w118      => pca_w118, --x"ad", 
           w119      => pca_w119, --x"d7", 
           w120      => pca_w120, --x"fc", 
           w121      => pca_w121, --x"ce", 
           w122      => pca_w122, --x"4a", 
           w123      => pca_w123, --x"0b", 
           w124      => pca_w124, --x"dd", 
           w125      => pca_w125, --x"d3", 
           w126      => pca_w126, --x"0f", 
           w127      => pca_w127, --x"80", 
           w128      => pca_w128, --x"90", 
           d_out   => pca_d01_out   ,
           en_out  => pca_en_out  ,
           sof_out => pca_sof_out );


end generate g_PCA_en;

g_PCA_bp: if PCA_en = FALSE generate
   pca_en_out                          <=  cl_en_out;

p_PCA_dis: process (clk)
 begin
    if  rising_edge(clk) then
PCA_dis1 <= d01_out(7 downto 0)+ d02_out(7 downto 0)+ d03_out(7 downto 0)+ d04_out(7 downto 0)+ d05_out(7 downto 0)+ d06_out(7 downto 0)+ d07_out(7 downto 0)+ d08_out(7 downto 0);  
PCA_dis2 <= d09_out(7 downto 0)+ d10_out(7 downto 0)+ d11_out(7 downto 0)+ d12_out(7 downto 0)+ d13_out(7 downto 0)+ d14_out(7 downto 0)+ d15_out(7 downto 0)+ d16_out(7 downto 0);  
PCA_dis3 <= d17_out(7 downto 0)+ d18_out(7 downto 0)+ d19_out(7 downto 0)+ d20_out(7 downto 0)+ d21_out(7 downto 0)+ d22_out(7 downto 0)+ d23_out(7 downto 0)+ d24_out(7 downto 0);  
PCA_dis4 <= d25_out(7 downto 0)+ d26_out(7 downto 0)+ d27_out(7 downto 0)+ d28_out(7 downto 0)+ d29_out(7 downto 0)+ d30_out(7 downto 0)+ d31_out(7 downto 0)+ d32_out(7 downto 0);  
PCA_dis5 <= d33_out(7 downto 0)+ d34_out(7 downto 0)+ d35_out(7 downto 0)+ d36_out(7 downto 0)+ d37_out(7 downto 0)+ d38_out(7 downto 0)+ d39_out(7 downto 0)+ d40_out(7 downto 0);  
PCA_dis6 <= d41_out(7 downto 0)+ d42_out(7 downto 0)+ d43_out(7 downto 0)+ d44_out(7 downto 0)+ d45_out(7 downto 0)+ d46_out(7 downto 0)+ d47_out(7 downto 0)+ d48_out(7 downto 0);  
PCA_dis7 <= d49_out(7 downto 0)+ d50_out(7 downto 0)+ d51_out(7 downto 0)+ d52_out(7 downto 0)+ d53_out(7 downto 0)+ d54_out(7 downto 0)+ d55_out(7 downto 0)+ d56_out(7 downto 0); 
PCA_dis8 <= d57_out(7 downto 0)+ d58_out(7 downto 0)+ d59_out(7 downto 0)+ d60_out(7 downto 0)+ d61_out(7 downto 0)+ d62_out(7 downto 0)+ d63_out(7 downto 0)+ d64_out(7 downto 0);  

 
PCA_dis9  <= d65_out (7 downto 0) + d66_out (7 downto 0) + d67_out (7 downto 0) + d68_out (7 downto 0) + d69_out (7 downto 0) + d70_out (7 downto 0) + d71_out (7 downto 0) + d72_out (7 downto 0);
PCA_dis10 <= d73_out (7 downto 0) + d74_out (7 downto 0) + d75_out (7 downto 0) + d76_out (7 downto 0) + d77_out (7 downto 0) + d78_out (7 downto 0) + d79_out (7 downto 0) + d80_out (7 downto 0);
PCA_dis11 <= d81_out (7 downto 0) + d82_out (7 downto 0) + d83_out (7 downto 0) + d84_out (7 downto 0) + d85_out (7 downto 0) + d86_out (7 downto 0) + d87_out (7 downto 0) + d88_out (7 downto 0);
PCA_dis12 <= d89_out (7 downto 0) + d90_out (7 downto 0) + d91_out (7 downto 0) + d92_out (7 downto 0) + d93_out (7 downto 0) + d94_out (7 downto 0) + d95_out (7 downto 0) + d96_out (7 downto 0);
PCA_dis13 <= d97_out (7 downto 0) + d98_out (7 downto 0) + d99_out (7 downto 0) + d100_out(7 downto 0) + d101_out(7 downto 0) + d102_out(7 downto 0) + d103_out(7 downto 0) + d104_out(7 downto 0);
PCA_dis14 <= d105_out(7 downto 0) + d106_out(7 downto 0) + d107_out(7 downto 0) + d108_out(7 downto 0) + d109_out(7 downto 0) + d110_out(7 downto 0) + d111_out(7 downto 0) + d112_out(7 downto 0);
PCA_dis15 <= d113_out(7 downto 0) + d114_out(7 downto 0) + d115_out(7 downto 0) + d116_out(7 downto 0) + d117_out(7 downto 0) + d118_out(7 downto 0) + d119_out(7 downto 0) + d120_out(7 downto 0);
PCA_dis16 <= d121_out(7 downto 0) + d122_out(7 downto 0) + d123_out(7 downto 0) + d124_out(7 downto 0) + d125_out(7 downto 0) + d126_out(7 downto 0) + d127_out(7 downto 0) + d128_out(7 downto 0);

pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7)  <= PCA_dis1 + PCA_dis2 + PCA_dis3 + PCA_dis4 + PCA_dis5 + PCA_dis6 + PCA_dis7 + PCA_dis8 + PCA_dis9  + PCA_dis10 + PCA_dis11 + PCA_dis12 + PCA_dis13 + PCA_dis14 + PCA_dis15 + PCA_dis16;

    end if;
 end process p_PCA_dis;

end generate g_PCA_bp;

--temp connection


-- p_temp: process (clk)
-- begin
--   if  rising_edge(clk) then
--      d_tmp_1_out  <=   pca_d01_out + pca_d09_out + pca_d17_out + pca_d25_out;
--      d_tmp_2_out  <=   pca_d02_out + pca_d10_out + pca_d18_out + pca_d26_out;
--      d_tmp_3_out  <=   pca_d03_out + pca_d11_out + pca_d19_out + pca_d27_out;
--      d_tmp_4_out  <=   pca_d04_out + pca_d12_out + pca_d20_out + pca_d28_out;
--      d_tmp_5_out  <=   pca_d05_out + pca_d13_out + pca_d21_out + pca_d29_out;
--      d_tmp_6_out  <=   pca_d06_out + pca_d14_out + pca_d22_out + pca_d30_out;
--      d_tmp_7_out  <=   pca_d07_out + pca_d15_out + pca_d23_out + pca_d31_out;
--      d_tmp_8_out  <=   pca_d08_out + pca_d16_out + pca_d24_out + pca_d32_out;
--
--      d_tmp_9_out   <=   pca_d33_out + pca_d41_out + pca_d49_out + pca_d57_out;
--      d_tmp_10_out  <=   pca_d34_out + pca_d42_out + pca_d50_out + pca_d58_out;
--      d_tmp_11_out  <=   pca_d35_out + pca_d43_out + pca_d51_out + pca_d59_out;
--      d_tmp_12_out  <=   pca_d36_out + pca_d44_out + pca_d52_out + pca_d60_out;
--      d_tmp_13_out  <=   pca_d37_out + pca_d45_out + pca_d53_out + pca_d61_out;
--      d_tmp_14_out  <=   pca_d38_out + pca_d46_out + pca_d54_out + pca_d62_out;
--      d_tmp_15_out  <=   pca_d39_out + pca_d47_out + pca_d55_out + pca_d63_out;
--      d_tmp_16_out  <=   pca_d40_out + pca_d48_out + pca_d56_out + pca_d64_out;
--
--      d1_out  <=   d_tmp_1_out + d_tmp_9_out   ;
--      d2_out  <=   d_tmp_2_out + d_tmp_10_out  ;
--      d3_out  <=   d_tmp_3_out + d_tmp_11_out  ;
--      d4_out  <=   d_tmp_4_out + d_tmp_12_out  ;
--      d5_out  <=   d_tmp_5_out + d_tmp_13_out  ;
--      d6_out  <=   d_tmp_6_out + d_tmp_14_out  ;
--      d7_out  <=   d_tmp_7_out + d_tmp_15_out  ;
--      d8_out  <=   d_tmp_8_out + d_tmp_16_out  ;
--
--      
--      en_out  <= pca_en_out  ;
--      sof_out <= pca_sof_out ;
--   end if;
-- end process p_temp;

  p_huff1 : process (clk,rst)
  begin
    if rst = '1' then
       h_en        <= '0';
       h_count_en  <= '1';
       h_count_en2 <= '0';
       h_count     <= (others => '0');
    elsif rising_edge(clk) then
       if h_count_en = '1' then
          --h_num   <= h_count;
          h_count <= h_count + 1;
       end if;
       if h_count = 255 then
          h_count_en <= '0';
       end if;
       h_count_en2 <= h_count_en;
       h_en        <= h_count_en2;
    end if;
  end process p_huff1;

  p_huff2 : process (clk)
  begin
    if rising_edge(clk) then
       alpha_data  <=                                h_count  ;
       alpha_code  <=  Huff_code (conv_integer("0" & h_count));
       alpha_width <=  Huff_width(conv_integer("0" & h_count));
    end if;
  end process p_huff2;


Huffman64_inst: Huffman64 
  generic map(
           N           => 8          ,  -- input data width
           M           => Huff_wid   ,  -- max code width
           Wh          => Wh         ,
           Wb          => Wb         ,
           Huff_enc_en => Huff_enc_en,
           depth       => depth      ,
           burst       => burst
           )
  port map (
           clk      => clk  ,
           rst      => rst  , 

           init_en        => h_en       ,
           alpha_data     => alpha_data ,   
           alpha_code     => alpha_code ,    
           alpha_width    => alpha_width,

           d01_in         => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7),
           d02_in         => pca_d02_out(pca_d02_out'left downto pca_d02_out'left - 7),
           d03_in         => pca_d03_out(pca_d03_out'left downto pca_d03_out'left - 7),
           d04_in         => pca_d04_out(pca_d04_out'left downto pca_d04_out'left - 7),
           d05_in         => pca_d05_out(pca_d05_out'left downto pca_d05_out'left - 7),
           d06_in         => pca_d06_out(pca_d06_out'left downto pca_d06_out'left - 7),
           d07_in         => pca_d07_out(pca_d07_out'left downto pca_d07_out'left - 7),
           d08_in         => pca_d08_out(pca_d08_out'left downto pca_d08_out'left - 7),
           d09_in         => pca_d09_out(pca_d09_out'left downto pca_d09_out'left - 7),
           d10_in         => pca_d10_out(pca_d10_out'left downto pca_d10_out'left - 7),
           d11_in         => pca_d11_out(pca_d11_out'left downto pca_d11_out'left - 7),
           d12_in         => pca_d12_out(pca_d12_out'left downto pca_d12_out'left - 7),
           d13_in         => pca_d13_out(pca_d13_out'left downto pca_d13_out'left - 7),
           d14_in         => pca_d14_out(pca_d14_out'left downto pca_d14_out'left - 7),
           d15_in         => pca_d15_out(pca_d15_out'left downto pca_d15_out'left - 7),
           d16_in         => pca_d16_out(pca_d16_out'left downto pca_d16_out'left - 7),
           d17_in         => pca_d17_out(pca_d17_out'left downto pca_d17_out'left - 7),
           d18_in         => pca_d18_out(pca_d18_out'left downto pca_d18_out'left - 7),
           d19_in         => pca_d19_out(pca_d19_out'left downto pca_d19_out'left - 7),
           d20_in         => pca_d20_out(pca_d20_out'left downto pca_d20_out'left - 7),
           d21_in         => pca_d21_out(pca_d21_out'left downto pca_d21_out'left - 7),
           d22_in         => pca_d22_out(pca_d22_out'left downto pca_d22_out'left - 7),
           d23_in         => pca_d23_out(pca_d23_out'left downto pca_d23_out'left - 7),
           d24_in         => pca_d24_out(pca_d24_out'left downto pca_d24_out'left - 7),
           d25_in         => pca_d25_out(pca_d25_out'left downto pca_d25_out'left - 7),
           d26_in         => pca_d26_out(pca_d26_out'left downto pca_d26_out'left - 7),
           d27_in         => pca_d27_out(pca_d27_out'left downto pca_d27_out'left - 7),
           d28_in         => pca_d28_out(pca_d28_out'left downto pca_d28_out'left - 7),
           d29_in         => pca_d29_out(pca_d29_out'left downto pca_d29_out'left - 7),
           d30_in         => pca_d30_out(pca_d30_out'left downto pca_d30_out'left - 7),
           d31_in         => pca_d31_out(pca_d31_out'left downto pca_d31_out'left - 7),
           d32_in         => pca_d32_out(pca_d32_out'left downto pca_d32_out'left - 7),
           d33_in         => pca_d33_out(pca_d33_out'left downto pca_d33_out'left - 7),
           d34_in         => pca_d34_out(pca_d34_out'left downto pca_d34_out'left - 7),
           d35_in         => pca_d35_out(pca_d35_out'left downto pca_d35_out'left - 7),
           d36_in         => pca_d36_out(pca_d36_out'left downto pca_d36_out'left - 7),
           d37_in         => pca_d37_out(pca_d37_out'left downto pca_d37_out'left - 7),
           d38_in         => pca_d38_out(pca_d38_out'left downto pca_d38_out'left - 7),
           d39_in         => pca_d39_out(pca_d39_out'left downto pca_d39_out'left - 7),
           d40_in         => pca_d40_out(pca_d40_out'left downto pca_d40_out'left - 7),
           d41_in         => pca_d41_out(pca_d41_out'left downto pca_d41_out'left - 7),
           d42_in         => pca_d42_out(pca_d42_out'left downto pca_d42_out'left - 7),
           d43_in         => pca_d43_out(pca_d43_out'left downto pca_d43_out'left - 7),
           d44_in         => pca_d44_out(pca_d44_out'left downto pca_d44_out'left - 7),
           d45_in         => pca_d45_out(pca_d45_out'left downto pca_d45_out'left - 7),
           d46_in         => pca_d46_out(pca_d46_out'left downto pca_d46_out'left - 7),
           d47_in         => pca_d47_out(pca_d47_out'left downto pca_d47_out'left - 7),
           d48_in         => pca_d48_out(pca_d48_out'left downto pca_d48_out'left - 7),
           d49_in         => pca_d49_out(pca_d49_out'left downto pca_d49_out'left - 7),
           d50_in         => pca_d50_out(pca_d50_out'left downto pca_d50_out'left - 7),
           d51_in         => pca_d51_out(pca_d51_out'left downto pca_d51_out'left - 7),
           d52_in         => pca_d52_out(pca_d52_out'left downto pca_d52_out'left - 7),
           d53_in         => pca_d53_out(pca_d53_out'left downto pca_d53_out'left - 7),
           d54_in         => pca_d54_out(pca_d54_out'left downto pca_d54_out'left - 7),
           d55_in         => pca_d55_out(pca_d55_out'left downto pca_d55_out'left - 7),
           d56_in         => pca_d56_out(pca_d56_out'left downto pca_d56_out'left - 7),
           d57_in         => pca_d57_out(pca_d57_out'left downto pca_d57_out'left - 7),
           d58_in         => pca_d58_out(pca_d58_out'left downto pca_d58_out'left - 7),
           d59_in         => pca_d59_out(pca_d59_out'left downto pca_d59_out'left - 7),
           d60_in         => pca_d60_out(pca_d60_out'left downto pca_d60_out'left - 7),
           d61_in         => pca_d61_out(pca_d61_out'left downto pca_d61_out'left - 7),
           d62_in         => pca_d62_out(pca_d62_out'left downto pca_d62_out'left - 7),
           d63_in         => pca_d63_out(pca_d63_out'left downto pca_d63_out'left - 7),
           d64_in         => pca_d64_out(pca_d64_out'left downto pca_d64_out'left - 7),
           en_in          => pca_en_out,        --
           sof_in         => pca_sof_out,        --                         -- start of frame
           eof_in         => '0',        --                         -- end of frame

           buf_rd        => buf_rd         ,
           buf_num       => buf_num        ,
           d_out         => huff_out       ,
           en_out        => open           ,
           eof_out       => open           );                        -- huffman codde output

    d_out  <=  huff_out;


-- PCA weights

    
--  p_pca_w : process (clk,rst)
--  begin
--    if rst = '1' then
--       pca_w_addr      <= (others => '0');
--       pca_col_count   <= (others => '0');
--       --pca_w_init      <= '1';
--    elsif rising_edge(clk) then
--       --pca_w_init      <= '0';
--       --if pca_w_init = '1' or ( cl_en_out = '1' and pca_w_addr = std_logic_vector(to_unsigned(in_col, pca_w_addr'length))) then
--       if cl_en_out = '1' and pca_col_count = std_logic_vector(to_unsigned(in_col-1, pca_w_addr'length)) then
--          pca_w_addr <= pca_w_addr + 1;
--       end if;
--
--       if cl_en_out = '1'  then
--          if pca_col_count = std_logic_vector(to_unsigned(in_col-1, pca_w_addr'length)) then
--             pca_col_count   <= (others => '0');
--          else
--             pca_col_count <= pca_col_count + 1;
--          end if;
--       end if;
--    end if;
--  end process p_pca_w;

--  p_pca_w2 : process (clk)
--  begin
--    if rising_edge(clk) then
--      pca_w_data <= PCAweight64(conv_integer("0" & pca_w_addr));
--    end if;
--  end process p_pca_w2;
--pca_w01 <= pca_w_data(   8-1 downto    0); 
--pca_w02 <= pca_w_data( 2*8-1 downto    8); 
--pca_w03 <= pca_w_data( 3*8-1 downto  2*8); 
--pca_w04 <= pca_w_data( 4*8-1 downto  3*8); 
--pca_w05 <= pca_w_data( 5*8-1 downto  4*8); 
--pca_w06 <= pca_w_data( 6*8-1 downto  5*8); 
--pca_w07 <= pca_w_data( 7*8-1 downto  6*8); 
--pca_w08 <= pca_w_data( 8*8-1 downto  7*8); 
--pca_w09 <= pca_w_data( 9*8-1 downto  8*8); 
--pca_w10 <= pca_w_data(10*8-1 downto  9*8); 
--pca_w11 <= pca_w_data(11*8-1 downto 10*8); 
--pca_w12 <= pca_w_data(12*8-1 downto 11*8); 
--pca_w13 <= pca_w_data(13*8-1 downto 12*8); 
--pca_w14 <= pca_w_data(14*8-1 downto 13*8); 
--pca_w15 <= pca_w_data(15*8-1 downto 14*8); 
--pca_w16 <= pca_w_data(16*8-1 downto 15*8); 
--pca_w17 <= pca_w_data(17*8-1 downto 16*8); 
--pca_w18 <= pca_w_data(18*8-1 downto 17*8); 
--pca_w19 <= pca_w_data(19*8-1 downto 18*8); 
--pca_w20 <= pca_w_data(20*8-1 downto 19*8); 
--pca_w21 <= pca_w_data(21*8-1 downto 20*8); 
--pca_w22 <= pca_w_data(22*8-1 downto 21*8); 
--pca_w23 <= pca_w_data(23*8-1 downto 22*8); 
--pca_w24 <= pca_w_data(24*8-1 downto 23*8); 
--pca_w25 <= pca_w_data(25*8-1 downto 24*8); 
--pca_w26 <= pca_w_data(26*8-1 downto 25*8); 
--pca_w27 <= pca_w_data(27*8-1 downto 26*8); 
--pca_w28 <= pca_w_data(28*8-1 downto 27*8); 
--pca_w29 <= pca_w_data(29*8-1 downto 28*8); 
--pca_w30 <= pca_w_data(30*8-1 downto 29*8); 
--pca_w31 <= pca_w_data(31*8-1 downto 30*8); 
--pca_w32 <= pca_w_data(32*8-1 downto 31*8); 
--pca_w33 <= pca_w_data(33*8-1 downto 32*8); 
--pca_w34 <= pca_w_data(34*8-1 downto 33*8); 
--pca_w35 <= pca_w_data(35*8-1 downto 34*8); 
--pca_w36 <= pca_w_data(36*8-1 downto 35*8); 
--pca_w37 <= pca_w_data(37*8-1 downto 36*8); 
--pca_w38 <= pca_w_data(38*8-1 downto 37*8); 
--pca_w39 <= pca_w_data(39*8-1 downto 38*8); 
--pca_w40 <= pca_w_data(40*8-1 downto 39*8); 
--pca_w41 <= pca_w_data(41*8-1 downto 40*8); 
--pca_w42 <= pca_w_data(42*8-1 downto 41*8); 
--pca_w43 <= pca_w_data(43*8-1 downto 42*8); 
--pca_w44 <= pca_w_data(44*8-1 downto 43*8); 
--pca_w45 <= pca_w_data(45*8-1 downto 44*8); 
--pca_w46 <= pca_w_data(46*8-1 downto 45*8); 
--pca_w47 <= pca_w_data(47*8-1 downto 46*8); 
--pca_w48 <= pca_w_data(48*8-1 downto 47*8); 
--pca_w49 <= pca_w_data(49*8-1 downto 48*8); 
--pca_w50 <= pca_w_data(50*8-1 downto 49*8); 
--pca_w51 <= pca_w_data(51*8-1 downto 50*8); 
--pca_w52 <= pca_w_data(52*8-1 downto 51*8); 
--pca_w53 <= pca_w_data(53*8-1 downto 52*8); 
--pca_w54 <= pca_w_data(54*8-1 downto 53*8); 
--pca_w55 <= pca_w_data(55*8-1 downto 54*8); 
--pca_w56 <= pca_w_data(56*8-1 downto 55*8); 
--pca_w57 <= pca_w_data(57*8-1 downto 56*8); 
--pca_w58 <= pca_w_data(58*8-1 downto 57*8); 
--pca_w59 <= pca_w_data(59*8-1 downto 58*8); 
--pca_w60 <= pca_w_data(60*8-1 downto 59*8); 
--pca_w61 <= pca_w_data(61*8-1 downto 60*8); 
--pca_w62 <= pca_w_data(62*8-1 downto 61*8); 
--pca_w63 <= pca_w_data(63*8-1 downto 62*8); 
--pca_w64 <= pca_w_data(64*8-1 downto 63*8); 

end a;