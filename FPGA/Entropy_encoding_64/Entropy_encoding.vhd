library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;    
--USE ieee.std_logic_arith.all;
library work;
use work.types_packege.all;

entity Entropy_encoding is
  generic (
  	       mult_sum_CL   : string := "mult"; --"sum";
           mult_sum_PCA  : string := "sum";
           N             : integer :=   8; -- input data width
           M             : integer :=   8; -- data weight width
           Huff_wid      : integer :=  12; -- Huffman weight maximum width                   (after change need nedd to update "Huff_code" matrix)
           Wh            : integer :=  16; -- Huffman unit output data width (Note W>=M)
           Wb            : integer := 128; -- output buffer data width
           depth         : integer :=  64; -- buffer depth
           burst         : integer :=  10; -- buffer read burst
 
           PCA_en        : boolean := FALSE; --TRUE; -- PCA Enable/Bypass
           Huff_enc_en   : boolean := FALSE;--FALSE; -- Huffman encoder Enable/Bypass

  	       in_row        : integer := 114;
  	       in_col        : integer := 114
  	       );
  port    (
           clk       : in  std_logic;
           rst       : in  std_logic;
           d01_in    : in std_logic_vector (9*N-1 downto 0);
           d02_in    : in std_logic_vector (9*N-1 downto 0);
           d03_in    : in std_logic_vector (9*N-1 downto 0);
           d04_in    : in std_logic_vector (9*N-1 downto 0);
           d05_in    : in std_logic_vector (9*N-1 downto 0);
           d06_in    : in std_logic_vector (9*N-1 downto 0);
           d07_in    : in std_logic_vector (9*N-1 downto 0);
           d08_in    : in std_logic_vector (9*N-1 downto 0);
           d09_in    : in std_logic_vector (9*N-1 downto 0);
           d10_in    : in std_logic_vector (9*N-1 downto 0);
           d11_in    : in std_logic_vector (9*N-1 downto 0);
           d12_in    : in std_logic_vector (9*N-1 downto 0);
           d13_in    : in std_logic_vector (9*N-1 downto 0);
           d14_in    : in std_logic_vector (9*N-1 downto 0);
           d15_in    : in std_logic_vector (9*N-1 downto 0);
           d16_in    : in std_logic_vector (9*N-1 downto 0);
           d17_in    : in std_logic_vector (9*N-1 downto 0);
           d18_in    : in std_logic_vector (9*N-1 downto 0);
           d19_in    : in std_logic_vector (9*N-1 downto 0);
           d20_in    : in std_logic_vector (9*N-1 downto 0);
           d21_in    : in std_logic_vector (9*N-1 downto 0);
           d22_in    : in std_logic_vector (9*N-1 downto 0);
           d23_in    : in std_logic_vector (9*N-1 downto 0);
           d24_in    : in std_logic_vector (9*N-1 downto 0);
           d25_in    : in std_logic_vector (9*N-1 downto 0);
           d26_in    : in std_logic_vector (9*N-1 downto 0);
           d27_in    : in std_logic_vector (9*N-1 downto 0);
           d28_in    : in std_logic_vector (9*N-1 downto 0);
           d29_in    : in std_logic_vector (9*N-1 downto 0);
           d30_in    : in std_logic_vector (9*N-1 downto 0);
           d31_in    : in std_logic_vector (9*N-1 downto 0);
           d32_in    : in std_logic_vector (9*N-1 downto 0);
           d33_in    : in std_logic_vector (9*N-1 downto 0);
           d34_in    : in std_logic_vector (9*N-1 downto 0);
           d35_in    : in std_logic_vector (9*N-1 downto 0);
           d36_in    : in std_logic_vector (9*N-1 downto 0);
           d37_in    : in std_logic_vector (9*N-1 downto 0);
           d38_in    : in std_logic_vector (9*N-1 downto 0);
           d39_in    : in std_logic_vector (9*N-1 downto 0);
           d40_in    : in std_logic_vector (9*N-1 downto 0);
           d41_in    : in std_logic_vector (9*N-1 downto 0);
           d42_in    : in std_logic_vector (9*N-1 downto 0);
           d43_in    : in std_logic_vector (9*N-1 downto 0);
           d44_in    : in std_logic_vector (9*N-1 downto 0);
           d45_in    : in std_logic_vector (9*N-1 downto 0);
           d46_in    : in std_logic_vector (9*N-1 downto 0);
           d47_in    : in std_logic_vector (9*N-1 downto 0);
           d48_in    : in std_logic_vector (9*N-1 downto 0);
           d49_in    : in std_logic_vector (9*N-1 downto 0);
           d50_in    : in std_logic_vector (9*N-1 downto 0);
           d51_in    : in std_logic_vector (9*N-1 downto 0);
           d52_in    : in std_logic_vector (9*N-1 downto 0);
           d53_in    : in std_logic_vector (9*N-1 downto 0);
           d54_in    : in std_logic_vector (9*N-1 downto 0);
           d55_in    : in std_logic_vector (9*N-1 downto 0);
           d56_in    : in std_logic_vector (9*N-1 downto 0);
           d57_in    : in std_logic_vector (9*N-1 downto 0);
           d58_in    : in std_logic_vector (9*N-1 downto 0);
           d59_in    : in std_logic_vector (9*N-1 downto 0);
           d60_in    : in std_logic_vector (9*N-1 downto 0);
           d61_in    : in std_logic_vector (9*N-1 downto 0);
           d62_in    : in std_logic_vector (9*N-1 downto 0);
           d63_in    : in std_logic_vector (9*N-1 downto 0);
           d64_in    : in std_logic_vector (9*N-1 downto 0);
           en_in     : in std_logic;
           sof_in    : in std_logic; -- start of frame
           --sol     : in std_logic; -- start of line
           --eof     : in std_logic; -- end of frame

           w01_in    : in std_logic_vector(9*M-1 downto 0);
           w02_in    : in std_logic_vector(9*M-1 downto 0);
           w03_in    : in std_logic_vector(9*M-1 downto 0);
           w04_in    : in std_logic_vector(9*M-1 downto 0);
           w05_in    : in std_logic_vector(9*M-1 downto 0);
           w06_in    : in std_logic_vector(9*M-1 downto 0);
           w07_in    : in std_logic_vector(9*M-1 downto 0);
           w08_in    : in std_logic_vector(9*M-1 downto 0);
           w09_in    : in std_logic_vector(9*M-1 downto 0);
           w10_in    : in std_logic_vector(9*M-1 downto 0);
           w11_in    : in std_logic_vector(9*M-1 downto 0);
           w12_in    : in std_logic_vector(9*M-1 downto 0);
           w13_in    : in std_logic_vector(9*M-1 downto 0);
           w14_in    : in std_logic_vector(9*M-1 downto 0);
           w15_in    : in std_logic_vector(9*M-1 downto 0);
           w16_in    : in std_logic_vector(9*M-1 downto 0);
           w17_in    : in std_logic_vector(9*M-1 downto 0);
           w18_in    : in std_logic_vector(9*M-1 downto 0);
           w19_in    : in std_logic_vector(9*M-1 downto 0);
           w20_in    : in std_logic_vector(9*M-1 downto 0);
           w21_in    : in std_logic_vector(9*M-1 downto 0);
           w22_in    : in std_logic_vector(9*M-1 downto 0);
           w23_in    : in std_logic_vector(9*M-1 downto 0);
           w24_in    : in std_logic_vector(9*M-1 downto 0);
           w25_in    : in std_logic_vector(9*M-1 downto 0);
           w26_in    : in std_logic_vector(9*M-1 downto 0);
           w27_in    : in std_logic_vector(9*M-1 downto 0);
           w28_in    : in std_logic_vector(9*M-1 downto 0);
           w29_in    : in std_logic_vector(9*M-1 downto 0);
           w30_in    : in std_logic_vector(9*M-1 downto 0);
           w31_in    : in std_logic_vector(9*M-1 downto 0);
           w32_in    : in std_logic_vector(9*M-1 downto 0);
           w33_in    : in std_logic_vector(9*M-1 downto 0);
           w34_in    : in std_logic_vector(9*M-1 downto 0);
           w35_in    : in std_logic_vector(9*M-1 downto 0);
           w36_in    : in std_logic_vector(9*M-1 downto 0);
           w37_in    : in std_logic_vector(9*M-1 downto 0);
           w38_in    : in std_logic_vector(9*M-1 downto 0);
           w39_in    : in std_logic_vector(9*M-1 downto 0);
           w40_in    : in std_logic_vector(9*M-1 downto 0);
           w41_in    : in std_logic_vector(9*M-1 downto 0);
           w42_in    : in std_logic_vector(9*M-1 downto 0);
           w43_in    : in std_logic_vector(9*M-1 downto 0);
           w44_in    : in std_logic_vector(9*M-1 downto 0);
           w45_in    : in std_logic_vector(9*M-1 downto 0);
           w46_in    : in std_logic_vector(9*M-1 downto 0);
           w47_in    : in std_logic_vector(9*M-1 downto 0);
           w48_in    : in std_logic_vector(9*M-1 downto 0);
           w49_in    : in std_logic_vector(9*M-1 downto 0);
           w50_in    : in std_logic_vector(9*M-1 downto 0);
           w51_in    : in std_logic_vector(9*M-1 downto 0);
           w52_in    : in std_logic_vector(9*M-1 downto 0);
           w53_in    : in std_logic_vector(9*M-1 downto 0);
           w54_in    : in std_logic_vector(9*M-1 downto 0);
           w55_in    : in std_logic_vector(9*M-1 downto 0);
           w56_in    : in std_logic_vector(9*M-1 downto 0);
           w57_in    : in std_logic_vector(9*M-1 downto 0);
           w58_in    : in std_logic_vector(9*M-1 downto 0);
           w59_in    : in std_logic_vector(9*M-1 downto 0);
           w60_in    : in std_logic_vector(9*M-1 downto 0);
           w61_in    : in std_logic_vector(9*M-1 downto 0);
           w62_in    : in std_logic_vector(9*M-1 downto 0);
           w63_in    : in std_logic_vector(9*M-1 downto 0);
           w64_in    : in std_logic_vector(9*M-1 downto 0);

           pca_w_en  : in  std_logic;
           pca_w_num : in  std_logic_vector (5 downto 0);
           pca_w_in  : in  std_logic_vector (7 downto 0);

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

component ConvLayer1_64 is
  generic (
           mult_sum      : string := "sum";
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 8; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 2  -- data shift right before output
           );
  port    (
           clk     : in std_logic;
           rst     : in std_logic;
           d01_in    : in std_logic_vector (9*N-1 downto 0);
           d02_in    : in std_logic_vector (9*N-1 downto 0);
           d03_in    : in std_logic_vector (9*N-1 downto 0);
           d04_in    : in std_logic_vector (9*N-1 downto 0);
           d05_in    : in std_logic_vector (9*N-1 downto 0);
           d06_in    : in std_logic_vector (9*N-1 downto 0);
           d07_in    : in std_logic_vector (9*N-1 downto 0);
           d08_in    : in std_logic_vector (9*N-1 downto 0);
           d09_in    : in std_logic_vector (9*N-1 downto 0);
           d10_in    : in std_logic_vector (9*N-1 downto 0);
           d11_in    : in std_logic_vector (9*N-1 downto 0);
           d12_in    : in std_logic_vector (9*N-1 downto 0);
           d13_in    : in std_logic_vector (9*N-1 downto 0);
           d14_in    : in std_logic_vector (9*N-1 downto 0);
           d15_in    : in std_logic_vector (9*N-1 downto 0);
           d16_in    : in std_logic_vector (9*N-1 downto 0);
           d17_in    : in std_logic_vector (9*N-1 downto 0);
           d18_in    : in std_logic_vector (9*N-1 downto 0);
           d19_in    : in std_logic_vector (9*N-1 downto 0);
           d20_in    : in std_logic_vector (9*N-1 downto 0);
           d21_in    : in std_logic_vector (9*N-1 downto 0);
           d22_in    : in std_logic_vector (9*N-1 downto 0);
           d23_in    : in std_logic_vector (9*N-1 downto 0);
           d24_in    : in std_logic_vector (9*N-1 downto 0);
           d25_in    : in std_logic_vector (9*N-1 downto 0);
           d26_in    : in std_logic_vector (9*N-1 downto 0);
           d27_in    : in std_logic_vector (9*N-1 downto 0);
           d28_in    : in std_logic_vector (9*N-1 downto 0);
           d29_in    : in std_logic_vector (9*N-1 downto 0);
           d30_in    : in std_logic_vector (9*N-1 downto 0);
           d31_in    : in std_logic_vector (9*N-1 downto 0);
           d32_in    : in std_logic_vector (9*N-1 downto 0);
           d33_in    : in std_logic_vector (9*N-1 downto 0);
           d34_in    : in std_logic_vector (9*N-1 downto 0);
           d35_in    : in std_logic_vector (9*N-1 downto 0);
           d36_in    : in std_logic_vector (9*N-1 downto 0);
           d37_in    : in std_logic_vector (9*N-1 downto 0);
           d38_in    : in std_logic_vector (9*N-1 downto 0);
           d39_in    : in std_logic_vector (9*N-1 downto 0);
           d40_in    : in std_logic_vector (9*N-1 downto 0);
           d41_in    : in std_logic_vector (9*N-1 downto 0);
           d42_in    : in std_logic_vector (9*N-1 downto 0);
           d43_in    : in std_logic_vector (9*N-1 downto 0);
           d44_in    : in std_logic_vector (9*N-1 downto 0);
           d45_in    : in std_logic_vector (9*N-1 downto 0);
           d46_in    : in std_logic_vector (9*N-1 downto 0);
           d47_in    : in std_logic_vector (9*N-1 downto 0);
           d48_in    : in std_logic_vector (9*N-1 downto 0);
           d49_in    : in std_logic_vector (9*N-1 downto 0);
           d50_in    : in std_logic_vector (9*N-1 downto 0);
           d51_in    : in std_logic_vector (9*N-1 downto 0);
           d52_in    : in std_logic_vector (9*N-1 downto 0);
           d53_in    : in std_logic_vector (9*N-1 downto 0);
           d54_in    : in std_logic_vector (9*N-1 downto 0);
           d55_in    : in std_logic_vector (9*N-1 downto 0);
           d56_in    : in std_logic_vector (9*N-1 downto 0);
           d57_in    : in std_logic_vector (9*N-1 downto 0);
           d58_in    : in std_logic_vector (9*N-1 downto 0);
           d59_in    : in std_logic_vector (9*N-1 downto 0);
           d60_in    : in std_logic_vector (9*N-1 downto 0);
           d61_in    : in std_logic_vector (9*N-1 downto 0);
           d62_in    : in std_logic_vector (9*N-1 downto 0);
           d63_in    : in std_logic_vector (9*N-1 downto 0);
           d64_in    : in std_logic_vector (9*N-1 downto 0);
           en_in     : in std_logic;
           sof_in    : in std_logic; -- start of frame
           --sol     : in std_logic; -- start of line
           --eof     : in std_logic; -- end of frame

           w01_in    : in std_logic_vector(9*M-1 downto 0);
           w02_in    : in std_logic_vector(9*M-1 downto 0);
           w03_in    : in std_logic_vector(9*M-1 downto 0);
           w04_in    : in std_logic_vector(9*M-1 downto 0);
           w05_in    : in std_logic_vector(9*M-1 downto 0);
           w06_in    : in std_logic_vector(9*M-1 downto 0);
           w07_in    : in std_logic_vector(9*M-1 downto 0);
           w08_in    : in std_logic_vector(9*M-1 downto 0);
           w09_in    : in std_logic_vector(9*M-1 downto 0);
           w10_in    : in std_logic_vector(9*M-1 downto 0);
           w11_in    : in std_logic_vector(9*M-1 downto 0);
           w12_in    : in std_logic_vector(9*M-1 downto 0);
           w13_in    : in std_logic_vector(9*M-1 downto 0);
           w14_in    : in std_logic_vector(9*M-1 downto 0);
           w15_in    : in std_logic_vector(9*M-1 downto 0);
           w16_in    : in std_logic_vector(9*M-1 downto 0);
           w17_in    : in std_logic_vector(9*M-1 downto 0);
           w18_in    : in std_logic_vector(9*M-1 downto 0);
           w19_in    : in std_logic_vector(9*M-1 downto 0);
           w20_in    : in std_logic_vector(9*M-1 downto 0);
           w21_in    : in std_logic_vector(9*M-1 downto 0);
           w22_in    : in std_logic_vector(9*M-1 downto 0);
           w23_in    : in std_logic_vector(9*M-1 downto 0);
           w24_in    : in std_logic_vector(9*M-1 downto 0);
           w25_in    : in std_logic_vector(9*M-1 downto 0);
           w26_in    : in std_logic_vector(9*M-1 downto 0);
           w27_in    : in std_logic_vector(9*M-1 downto 0);
           w28_in    : in std_logic_vector(9*M-1 downto 0);
           w29_in    : in std_logic_vector(9*M-1 downto 0);
           w30_in    : in std_logic_vector(9*M-1 downto 0);
           w31_in    : in std_logic_vector(9*M-1 downto 0);
           w32_in    : in std_logic_vector(9*M-1 downto 0);
           w33_in    : in std_logic_vector(9*M-1 downto 0);
           w34_in    : in std_logic_vector(9*M-1 downto 0);
           w35_in    : in std_logic_vector(9*M-1 downto 0);
           w36_in    : in std_logic_vector(9*M-1 downto 0);
           w37_in    : in std_logic_vector(9*M-1 downto 0);
           w38_in    : in std_logic_vector(9*M-1 downto 0);
           w39_in    : in std_logic_vector(9*M-1 downto 0);
           w40_in    : in std_logic_vector(9*M-1 downto 0);
           w41_in    : in std_logic_vector(9*M-1 downto 0);
           w42_in    : in std_logic_vector(9*M-1 downto 0);
           w43_in    : in std_logic_vector(9*M-1 downto 0);
           w44_in    : in std_logic_vector(9*M-1 downto 0);
           w45_in    : in std_logic_vector(9*M-1 downto 0);
           w46_in    : in std_logic_vector(9*M-1 downto 0);
           w47_in    : in std_logic_vector(9*M-1 downto 0);
           w48_in    : in std_logic_vector(9*M-1 downto 0);
           w49_in    : in std_logic_vector(9*M-1 downto 0);
           w50_in    : in std_logic_vector(9*M-1 downto 0);
           w51_in    : in std_logic_vector(9*M-1 downto 0);
           w52_in    : in std_logic_vector(9*M-1 downto 0);
           w53_in    : in std_logic_vector(9*M-1 downto 0);
           w54_in    : in std_logic_vector(9*M-1 downto 0);
           w55_in    : in std_logic_vector(9*M-1 downto 0);
           w56_in    : in std_logic_vector(9*M-1 downto 0);
           w57_in    : in std_logic_vector(9*M-1 downto 0);
           w58_in    : in std_logic_vector(9*M-1 downto 0);
           w59_in    : in std_logic_vector(9*M-1 downto 0);
           w60_in    : in std_logic_vector(9*M-1 downto 0);
           w61_in    : in std_logic_vector(9*M-1 downto 0);
           w62_in    : in std_logic_vector(9*M-1 downto 0);
           w63_in    : in std_logic_vector(9*M-1 downto 0);
           w64_in    : in std_logic_vector(9*M-1 downto 0);

           d_out   : out std_logic_vector (W-1 downto 0);
           en_out    : out std_logic;
           sof_out   : out std_logic);
end component;


component PCA_pixel is
    generic (
            number_output_features_g : positive := 64
        );
    port (
        reset          : in  std_logic;
        clock          : in  std_logic;
        sof            : in  std_logic;
        eof            : in  std_logic;
        data_in        : in  std_logic_vector(7 downto 0);
        data_in_valid  : in  std_logic;
        weight_in      : in  mat(0 to number_output_features_g - 1)(0 to number_output_features_g - 1);
        data_out       : out vec(0 to number_output_features_g - 1);
        data_out_valid : out std_logic
    ) ;
end component;

component Huffman is
  generic (
           N             : integer := 4; -- input data width
           M             : integer := 8; -- max code width
           W             : integer := 10 -- output data width (Note W>=M)
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           init_en       : in  std_logic;                         -- initialising convert table
           alpha_data    : in  std_logic_vector(N-1 downto 0);    
           alpha_code    : in  std_logic_vector(M-1 downto 0);    
           alpha_width   : in  std_logic_vector(  3 downto 0);

           d_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           en_in         : in  std_logic;
           sof_in        : in  std_logic;                         -- start of frame
           eof_in        : in  std_logic;                         -- end of frame

           d_out         : out std_logic_vector (W-1 downto 0);
           en_out        : out std_logic;
           eof_out       : out std_logic);                        -- huffman codde output
end component;

--component Huffman64 is
--  generic (
--           N             : integer :=  4;  -- input data width
--           M             : integer :=  8;  -- max code width
--           Wh            : integer := 16;  -- Huffman unit output data width (Note W>=M)
--           Wb            : integer := 512; -- output buffer data width
--           Huff_enc_en   : boolean := TRUE; -- Huffman encoder Enable/Bypass
--           depth         : integer := 500; -- buffer depth
--           burst         : integer := 10   -- buffer read burst
--           );
--  port    (
--           clk           : in  std_logic;
--           rst           : in  std_logic; 
--
--           init_en       : in  std_logic;                         -- initialising convert table
--           alpha_data    : in  std_logic_vector(N-1 downto 0);    
--           alpha_code    : in  std_logic_vector(M-1 downto 0);    
--           alpha_width   : in  std_logic_vector(  3 downto 0);
--
--           d01_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d02_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d03_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d04_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d05_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d06_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d07_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d08_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d09_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d10_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d11_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d12_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d13_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d14_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d15_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d16_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d17_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d18_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d19_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d20_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d21_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d22_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d23_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d24_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d25_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d26_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d27_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d28_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d29_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d30_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d31_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d32_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d33_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d34_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d35_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d36_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d37_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d38_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d39_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d40_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d41_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d42_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d43_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d44_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d45_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d46_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d47_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d48_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d49_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d50_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d51_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d52_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d53_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d54_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d55_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d56_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d57_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d58_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d59_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d60_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d61_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d62_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d63_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           d64_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           en_in         : in  std_logic;
--           sof_in        : in  std_logic;                         -- start of frame
--           eof_in        : in  std_logic;                         -- end of frame
--
--           buf_rd        : in  std_logic;
--           buf_num       : in  std_logic_vector (5      downto 0);
--           d_out         : out std_logic_vector (Wb  -1 downto 0);
--           en_out        : out std_logic_vector (64  -1 downto 0);
--           eof_out       : out std_logic);                        -- huffman codde output
--end component;

constant number_output_features_g : positive := 64;

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


-- weight init 

--signal  w01_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w02_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w03_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w04_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w05_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w06_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w07_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w08_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w09_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w10_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w11_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w12_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w13_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w14_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w15_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w16_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w17_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w18_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w19_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w20_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w21_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w22_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w23_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w24_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w25_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w26_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w27_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w28_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w29_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w30_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w31_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w32_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w33_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w34_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w35_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w36_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w37_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w38_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w39_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w40_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w41_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w42_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w43_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w44_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w45_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w46_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w47_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w48_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w49_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w50_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w51_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w52_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w53_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w54_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w55_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w56_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w57_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w58_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w59_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w60_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w61_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w62_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w63_in    : std_logic_vector(CL_w_width-1 downto 0);
--signal  w64_in    : std_logic_vector(CL_w_width-1 downto 0);


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
-- PCA weights

type pca_mem_type is array ( 0 to 63 ) of std_logic_vector(CL_w_width-1 downto 0 ) ;
signal pca_mem : pca_mem_type;
signal pca_w01,pca_w02,pca_w03,pca_w04,pca_w05,pca_w06,pca_w07,pca_w08,pca_w09,pca_w10,pca_w11,pca_w12,pca_w13,pca_w14,pca_w15,pca_w16 : std_logic_vector (7 downto 0);
signal pca_w17,pca_w18,pca_w19,pca_w20,pca_w21,pca_w22,pca_w23,pca_w24,pca_w25,pca_w26,pca_w27,pca_w28,pca_w29,pca_w30,pca_w31,pca_w32 : std_logic_vector (7 downto 0);
signal pca_w33,pca_w34,pca_w35,pca_w36,pca_w37,pca_w38,pca_w39,pca_w40,pca_w41,pca_w42,pca_w43,pca_w44,pca_w45,pca_w46,pca_w47,pca_w48 : std_logic_vector (7 downto 0);
signal pca_w49,pca_w50,pca_w51,pca_w52,pca_w53,pca_w54,pca_w55,pca_w56,pca_w57,pca_w58,pca_w59,pca_w60,pca_w61,pca_w62,pca_w63,pca_w64 : std_logic_vector (7 downto 0);

type PCArom_type is array ( 0 to 63 ) of std_logic_vector(64*8-1 downto 0 ) ;
constant Pw: --PCAweight64 : 
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

signal weight_pca_in  : mat(0 to number_output_features_g - 1)(0 to number_output_features_g - 1);
signal data_pca_out   : vec(0 to number_output_features_g - 1);
signal data_pca_out1   : vec(0 to number_output_features_g - 1);

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
signal PCA_dis1      : std_logic_vector(7 downto 0);
signal PCA_dis2      : std_logic_vector(7 downto 0);
signal PCA_dis3      : std_logic_vector(7 downto 0);
signal PCA_dis4      : std_logic_vector(7 downto 0);
signal PCA_dis5      : std_logic_vector(7 downto 0);
signal PCA_dis6      : std_logic_vector(7 downto 0);
signal PCA_dis7      : std_logic_vector(7 downto 0);
signal PCA_dis8      : std_logic_vector(7 downto 0);

signal count , pca_count        : integer;

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

  --p_weight2 : process (clk,rst)
  --begin
  --    if rst = '1' then
  --     w01_in <= x"52" ;
  --     w02_in <= x"39" ;
  --     w03_in <= x"67" ;
  --     w04_in <= x"77" ;
  --     w05_in <= x"46" ;
  --     w06_in <= x"67" ;
  --     w07_in <= x"78" ;
  --     w08_in <= x"45" ;
  --     w09_in <= x"57" ;
  --     w10_in <= x"67" ;
  --     w11_in <= x"75" ;
  --     w12_in <= x"61" ;
  --     w13_in <= x"84" ;
  --     w14_in <= x"18" ;
  --     w15_in <= x"93" ;
  --     w16_in <= x"10" ;
  --     w17_in <= x"11" ;
  --     w18_in <= x"78" ;
  --     w19_in <= x"78" ;
  --     w20_in <= x"96" ;
  --     w21_in <= x"25" ;
  --     w22_in <= x"33" ;
  --     w23_in <= x"31" ;
  --     w24_in <= x"50" ;
  --     w25_in <= x"58" ;
  --     w26_in <= x"27" ;
  --     w27_in <= x"56" ;
  --     w28_in <= x"50" ;
  --     w29_in <= x"35" ;
  --     w30_in <= x"88" ;
  --     w31_in <= x"51" ;
  --     w32_in <= x"72" ;
  --     w33_in <= x"66" ;
  --     w34_in <= x"66" ;
  --     w35_in <= x"35" ;
  --     w36_in <= x"78" ;
  --     w37_in <= x"68" ;
  --     w38_in <= x"37" ;
  --     w39_in <= x"59" ;
  --     w40_in <= x"89" ;
  --     w41_in <= x"73" ;
  --     w42_in <= x"98" ;
  --     w43_in <= x"34" ;
  --     w44_in <= x"47" ;
  --     w45_in <= x"30" ;
  --     w46_in <= x"11" ;
  --     w47_in <= x"82" ;
  --     w48_in <= x"70" ;
  --     w49_in <= x"66" ;
  --     w50_in <= x"26" ;
  --     w51_in <= x"69" ;
  --     w52_in <= x"18" ;
  --     w53_in <= x"58" ;
  --     w54_in <= x"40" ;
  --     w55_in <= x"76" ;
  --     w56_in <= x"36" ;
  --     w57_in <= x"23" ;
  --     w58_in <= x"61" ;
  --     w59_in <= x"11" ;
  --     w60_in <= x"69" ;
  --     w61_in <= x"42" ;
  --     w62_in <= x"73" ;
  --     w63_in <= x"44" ;
  --     w64_in <= x"78" ;
  --  elsif rising_edge(clk) then
  --     w01_in <=  (w01_in(1) xor w01_in(0)) & w01_in(w01_in'left downto 1) ; --weight01(conv_integer('0' & w_count));
  --     w02_in <=  (w02_in(1) xor w02_in(0)) & w02_in(w02_in'left downto 1) ; --weight02(conv_integer('0' & w_count));
  --     w03_in <=  (w03_in(1) xor w03_in(0)) & w03_in(w03_in'left downto 1) ; --weight03(conv_integer('0' & w_count));
  --     w04_in <=  (w04_in(1) xor w04_in(0)) & w04_in(w04_in'left downto 1) ; --weight04(conv_integer('0' & w_count));
  --     w05_in <=  (w05_in(1) xor w05_in(0)) & w05_in(w05_in'left downto 1) ; --weight05(conv_integer('0' & w_count));
  --     w06_in <=  (w06_in(1) xor w06_in(0)) & w06_in(w06_in'left downto 1) ; --weight06(conv_integer('0' & w_count));
  --     w07_in <=  (w07_in(1) xor w07_in(0)) & w07_in(w07_in'left downto 1) ; --weight07(conv_integer('0' & w_count));
  --     w08_in <=  (w08_in(1) xor w08_in(0)) & w08_in(w08_in'left downto 1) ; --weight08(conv_integer('0' & w_count));
  --     w09_in <=  (w09_in(1) xor w09_in(0)) & w09_in(w09_in'left downto 1) ; --weight09(conv_integer('0' & w_count));
  --     w10_in <=  (w10_in(1) xor w10_in(0)) & w10_in(w10_in'left downto 1) ; --weight10(conv_integer('0' & w_count));
  --     w11_in <=  (w11_in(1) xor w11_in(0)) & w11_in(w11_in'left downto 1) ; --weight11(conv_integer('0' & w_count));
  --     w12_in <=  (w12_in(1) xor w12_in(0)) & w12_in(w12_in'left downto 1) ; --weight12(conv_integer('0' & w_count));
  --     w13_in <=  (w13_in(1) xor w13_in(0)) & w13_in(w13_in'left downto 1) ; --weight13(conv_integer('0' & w_count));
  --     w14_in <=  (w14_in(1) xor w14_in(0)) & w14_in(w14_in'left downto 1) ; --weight14(conv_integer('0' & w_count));
  --     w15_in <=  (w15_in(1) xor w15_in(0)) & w15_in(w15_in'left downto 1) ; --weight15(conv_integer('0' & w_count));
  --     w16_in <=  (w16_in(1) xor w16_in(0)) & w16_in(w16_in'left downto 1) ; --weight16(conv_integer('0' & w_count));
  --     w17_in <=  (w17_in(1) xor w17_in(0)) & w17_in(w17_in'left downto 1) ; --weight17(conv_integer('0' & w_count));
  --     w18_in <=  (w18_in(1) xor w18_in(0)) & w18_in(w18_in'left downto 1) ; --weight18(conv_integer('0' & w_count));
  --     w19_in <=  (w19_in(1) xor w19_in(0)) & w19_in(w19_in'left downto 1) ; --weight19(conv_integer('0' & w_count));
  --     w20_in <=  (w20_in(1) xor w20_in(0)) & w20_in(w20_in'left downto 1) ; --weight20(conv_integer('0' & w_count));
  --     w21_in <=  (w21_in(1) xor w21_in(0)) & w21_in(w21_in'left downto 1) ; --weight21(conv_integer('0' & w_count));
  --     w22_in <=  (w22_in(1) xor w22_in(0)) & w22_in(w22_in'left downto 1) ; --weight22(conv_integer('0' & w_count));
  --     w23_in <=  (w23_in(1) xor w23_in(0)) & w23_in(w23_in'left downto 1) ; --weight23(conv_integer('0' & w_count));
  --     w24_in <=  (w24_in(1) xor w24_in(0)) & w24_in(w24_in'left downto 1) ; --weight24(conv_integer('0' & w_count));
  --     w25_in <=  (w25_in(1) xor w25_in(0)) & w25_in(w25_in'left downto 1) ; --weight25(conv_integer('0' & w_count));
  --     w26_in <=  (w26_in(1) xor w26_in(0)) & w26_in(w26_in'left downto 1) ; --weight26(conv_integer('0' & w_count));
  --     w27_in <=  (w27_in(1) xor w27_in(0)) & w27_in(w27_in'left downto 1) ; --weight27(conv_integer('0' & w_count));
  --     w28_in <=  (w28_in(1) xor w28_in(0)) & w28_in(w28_in'left downto 1) ; --weight28(conv_integer('0' & w_count));
  --     w29_in <=  (w29_in(1) xor w29_in(0)) & w29_in(w29_in'left downto 1) ; --weight29(conv_integer('0' & w_count));
  --     w30_in <=  (w30_in(1) xor w30_in(0)) & w30_in(w30_in'left downto 1) ; --weight30(conv_integer('0' & w_count));
  --     w31_in <=  (w31_in(1) xor w31_in(0)) & w31_in(w31_in'left downto 1) ; --weight31(conv_integer('0' & w_count));
  --     w32_in <=  (w32_in(1) xor w32_in(0)) & w32_in(w32_in'left downto 1) ; --weight32(conv_integer('0' & w_count));
  --     w33_in <=  (w33_in(1) xor w33_in(0)) & w33_in(w33_in'left downto 1) ; --weight33(conv_integer('0' & w_count));
  --     w34_in <=  (w34_in(1) xor w34_in(0)) & w34_in(w34_in'left downto 1) ; --weight34(conv_integer('0' & w_count));
  --     w35_in <=  (w35_in(1) xor w35_in(0)) & w35_in(w35_in'left downto 1) ; --weight35(conv_integer('0' & w_count));
  --     w36_in <=  (w36_in(1) xor w36_in(0)) & w36_in(w36_in'left downto 1) ; --weight36(conv_integer('0' & w_count));
  --     w37_in <=  (w37_in(1) xor w37_in(0)) & w37_in(w37_in'left downto 1) ; --weight37(conv_integer('0' & w_count));
  --     w38_in <=  (w38_in(1) xor w38_in(0)) & w38_in(w38_in'left downto 1) ; --weight38(conv_integer('0' & w_count));
  --     w39_in <=  (w39_in(1) xor w39_in(0)) & w39_in(w39_in'left downto 1) ; --weight39(conv_integer('0' & w_count));
  --     w40_in <=  (w40_in(1) xor w40_in(0)) & w40_in(w40_in'left downto 1) ; --weight40(conv_integer('0' & w_count));
  --     w41_in <=  (w41_in(1) xor w41_in(0)) & w41_in(w41_in'left downto 1) ; --weight41(conv_integer('0' & w_count));
  --     w42_in <=  (w42_in(1) xor w42_in(0)) & w42_in(w42_in'left downto 1) ; --weight42(conv_integer('0' & w_count));
  --     w43_in <=  (w43_in(1) xor w43_in(0)) & w43_in(w43_in'left downto 1) ; --weight43(conv_integer('0' & w_count));
  --     w44_in <=  (w44_in(1) xor w44_in(0)) & w44_in(w44_in'left downto 1) ; --weight44(conv_integer('0' & w_count));
  --     w45_in <=  (w45_in(1) xor w45_in(0)) & w45_in(w45_in'left downto 1) ; --weight45(conv_integer('0' & w_count));
  --     w46_in <=  (w46_in(1) xor w46_in(0)) & w46_in(w46_in'left downto 1) ; --weight46(conv_integer('0' & w_count));
  --     w47_in <=  (w47_in(1) xor w47_in(0)) & w47_in(w47_in'left downto 1) ; --weight47(conv_integer('0' & w_count));
  --     w48_in <=  (w48_in(1) xor w48_in(0)) & w48_in(w48_in'left downto 1) ; --weight48(conv_integer('0' & w_count));
  --     w49_in <=  (w49_in(1) xor w49_in(0)) & w49_in(w49_in'left downto 1) ; --weight49(conv_integer('0' & w_count));
  --     w50_in <=  (w50_in(1) xor w50_in(0)) & w50_in(w50_in'left downto 1) ; --weight50(conv_integer('0' & w_count));
  --     w51_in <=  (w51_in(1) xor w51_in(0)) & w51_in(w51_in'left downto 1) ; --weight51(conv_integer('0' & w_count));
  --     w52_in <=  (w52_in(1) xor w52_in(0)) & w52_in(w52_in'left downto 1) ; --weight52(conv_integer('0' & w_count));
  --     w53_in <=  (w53_in(1) xor w53_in(0)) & w53_in(w53_in'left downto 1) ; --weight53(conv_integer('0' & w_count));
  --     w54_in <=  (w54_in(1) xor w54_in(0)) & w54_in(w54_in'left downto 1) ; --weight54(conv_integer('0' & w_count));
  --     w55_in <=  (w55_in(1) xor w55_in(0)) & w55_in(w55_in'left downto 1) ; --weight55(conv_integer('0' & w_count));
  --     w56_in <=  (w56_in(1) xor w56_in(0)) & w56_in(w56_in'left downto 1) ; --weight56(conv_integer('0' & w_count));
  --     w57_in <=  (w57_in(1) xor w57_in(0)) & w57_in(w57_in'left downto 1) ; --weight57(conv_integer('0' & w_count));
  --     w58_in <=  (w58_in(1) xor w58_in(0)) & w58_in(w58_in'left downto 1) ; --weight58(conv_integer('0' & w_count));
  --     w59_in <=  (w59_in(1) xor w59_in(0)) & w59_in(w59_in'left downto 1) ; --weight59(conv_integer('0' & w_count));
  --     w60_in <=  (w60_in(1) xor w60_in(0)) & w60_in(w60_in'left downto 1) ; --weight60(conv_integer('0' & w_count));
  --     w61_in <=  (w61_in(1) xor w61_in(0)) & w61_in(w61_in'left downto 1) ; --weight61(conv_integer('0' & w_count));
  --     w62_in <=  (w62_in(1) xor w62_in(0)) & w62_in(w62_in'left downto 1) ; --weight62(conv_integer('0' & w_count));
  --     w63_in <=  (w63_in(1) xor w63_in(0)) & w63_in(w63_in'left downto 1) ; --weight63(conv_integer('0' & w_count));
  --     w64_in <=  (w64_in(1) xor w64_in(0)) & w64_in(w64_in'left downto 1) ; --weight64(conv_integer('0' & w_count));
  --  end if;
  --end process p_weight2;

--CL01: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w01_in, w_num => w_num, w_en => w_en, d_out => d01_out1, en_out => cl_en_out, sof_out => cl_sof_out);
--CL02: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w02_in, w_num => w_num, w_en => w_en, d_out => d02_out1, en_out => open, sof_out => open);
--CL03: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w03_in, w_num => w_num, w_en => w_en, d_out => d03_out1, en_out => open, sof_out => open);
--CL04: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w04_in, w_num => w_num, w_en => w_en, d_out => d04_out1, en_out => open, sof_out => open);
--CL05: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w05_in, w_num => w_num, w_en => w_en, d_out => d05_out1, en_out => open, sof_out => open);
--CL06: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w06_in, w_num => w_num, w_en => w_en, d_out => d06_out1, en_out => open, sof_out => open);
--CL07: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w07_in, w_num => w_num, w_en => w_en, d_out => d07_out1, en_out => open, sof_out => open);
--CL08: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w08_in, w_num => w_num, w_en => w_en, d_out => d08_out1, en_out => open, sof_out => open);
--CL09: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w09_in, w_num => w_num, w_en => w_en, d_out => d09_out1, en_out => open, sof_out => open);
--CL10: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w10_in, w_num => w_num, w_en => w_en, d_out => d10_out1, en_out => open, sof_out => open);
--CL11: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w11_in, w_num => w_num, w_en => w_en, d_out => d11_out1, en_out => open, sof_out => open);
--CL12: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w12_in, w_num => w_num, w_en => w_en, d_out => d12_out1, en_out => open, sof_out => open);
--CL13: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w13_in, w_num => w_num, w_en => w_en, d_out => d13_out1, en_out => open, sof_out => open);
--CL14: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w14_in, w_num => w_num, w_en => w_en, d_out => d14_out1, en_out => open, sof_out => open);
--CL15: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w15_in, w_num => w_num, w_en => w_en, d_out => d15_out1, en_out => open, sof_out => open);
--CL16: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w16_in, w_num => w_num, w_en => w_en, d_out => d16_out1, en_out => open, sof_out => open);
--CL17: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w17_in, w_num => w_num, w_en => w_en, d_out => d17_out1, en_out => open, sof_out => open);
--CL18: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w18_in, w_num => w_num, w_en => w_en, d_out => d18_out1, en_out => open, sof_out => open);
--CL19: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w19_in, w_num => w_num, w_en => w_en, d_out => d19_out1, en_out => open, sof_out => open);
--CL20: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w20_in, w_num => w_num, w_en => w_en, d_out => d20_out1, en_out => open, sof_out => open);
--CL21: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w21_in, w_num => w_num, w_en => w_en, d_out => d21_out1, en_out => open, sof_out => open);
--CL22: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w22_in, w_num => w_num, w_en => w_en, d_out => d22_out1, en_out => open, sof_out => open);
--CL23: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w23_in, w_num => w_num, w_en => w_en, d_out => d23_out1, en_out => open, sof_out => open);
--CL24: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w24_in, w_num => w_num, w_en => w_en, d_out => d24_out1, en_out => open, sof_out => open);
--CL25: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w25_in, w_num => w_num, w_en => w_en, d_out => d25_out1, en_out => open, sof_out => open);
--CL26: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w26_in, w_num => w_num, w_en => w_en, d_out => d26_out1, en_out => open, sof_out => open);
--CL27: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w27_in, w_num => w_num, w_en => w_en, d_out => d27_out1, en_out => open, sof_out => open);
--CL28: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w28_in, w_num => w_num, w_en => w_en, d_out => d28_out1, en_out => open, sof_out => open);
--CL29: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w29_in, w_num => w_num, w_en => w_en, d_out => d29_out1, en_out => open, sof_out => open);
--CL30: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w30_in, w_num => w_num, w_en => w_en, d_out => d30_out1, en_out => open, sof_out => open);
--CL31: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w31_in, w_num => w_num, w_en => w_en, d_out => d31_out1, en_out => open, sof_out => open);
--CL32: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w32_in, w_num => w_num, w_en => w_en, d_out => d32_out1, en_out => open, sof_out => open);
--CL33: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w33_in, w_num => w_num, w_en => w_en, d_out => d33_out1, en_out => open, sof_out => open);
--CL34: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w34_in, w_num => w_num, w_en => w_en, d_out => d34_out1, en_out => open, sof_out => open);
--CL35: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w35_in, w_num => w_num, w_en => w_en, d_out => d35_out1, en_out => open, sof_out => open);
--CL36: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w36_in, w_num => w_num, w_en => w_en, d_out => d36_out1, en_out => open, sof_out => open);
--CL37: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w37_in, w_num => w_num, w_en => w_en, d_out => d37_out1, en_out => open, sof_out => open);
--CL38: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w38_in, w_num => w_num, w_en => w_en, d_out => d38_out1, en_out => open, sof_out => open);
--CL39: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w39_in, w_num => w_num, w_en => w_en, d_out => d39_out1, en_out => open, sof_out => open);
--CL40: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w40_in, w_num => w_num, w_en => w_en, d_out => d40_out1, en_out => open, sof_out => open);
--CL41: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w41_in, w_num => w_num, w_en => w_en, d_out => d41_out1, en_out => open, sof_out => open);
--CL42: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w42_in, w_num => w_num, w_en => w_en, d_out => d42_out1, en_out => open, sof_out => open);
--CL43: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w43_in, w_num => w_num, w_en => w_en, d_out => d43_out1, en_out => open, sof_out => open);
--CL44: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w44_in, w_num => w_num, w_en => w_en, d_out => d44_out1, en_out => open, sof_out => open);
--CL45: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w45_in, w_num => w_num, w_en => w_en, d_out => d45_out1, en_out => open, sof_out => open);
--CL46: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w46_in, w_num => w_num, w_en => w_en, d_out => d46_out1, en_out => open, sof_out => open);
--CL47: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w47_in, w_num => w_num, w_en => w_en, d_out => d47_out1, en_out => open, sof_out => open);
--CL48: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w48_in, w_num => w_num, w_en => w_en, d_out => d48_out1, en_out => open, sof_out => open);
--CL49: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w49_in, w_num => w_num, w_en => w_en, d_out => d49_out1, en_out => open, sof_out => open);
--CL50: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w50_in, w_num => w_num, w_en => w_en, d_out => d50_out1, en_out => open, sof_out => open);
--CL51: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w51_in, w_num => w_num, w_en => w_en, d_out => d51_out1, en_out => open, sof_out => open);
--CL52: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w52_in, w_num => w_num, w_en => w_en, d_out => d52_out1, en_out => open, sof_out => open);
--CL53: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w53_in, w_num => w_num, w_en => w_en, d_out => d53_out1, en_out => open, sof_out => open);
--CL54: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w54_in, w_num => w_num, w_en => w_en, d_out => d54_out1, en_out => open, sof_out => open);
--CL55: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w55_in, w_num => w_num, w_en => w_en, d_out => d55_out1, en_out => open, sof_out => open);
--CL56: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w56_in, w_num => w_num, w_en => w_en, d_out => d56_out1, en_out => open, sof_out => open);
--CL57: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w57_in, w_num => w_num, w_en => w_en, d_out => d57_out1, en_out => open, sof_out => open);
--CL58: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w58_in, w_num => w_num, w_en => w_en, d_out => d58_out1, en_out => open, sof_out => open);
--CL59: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w59_in, w_num => w_num, w_en => w_en, d_out => d59_out1, en_out => open, sof_out => open);
--CL60: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w60_in, w_num => w_num, w_en => w_en, d_out => d60_out1, en_out => open, sof_out => open);
--CL61: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w61_in, w_num => w_num, w_en => w_en, d_out => d61_out1, en_out => open, sof_out => open);
--CL62: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w62_in, w_num => w_num, w_en => w_en, d_out => d62_out1, en_out => open, sof_out => open);
--CL63: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w63_in, w_num => w_num, w_en => w_en, d_out => d63_out1, en_out => open, sof_out => open);
--CL64: ConvLayer64 generic map (mult_sum => mult_sum_CL,N => N,M => CL_w_width,W => CL_W,SR => CL_SR,in_row => in_row, in_col => in_col)port map ( clk => clk, rst => rst, d_in => d_in, en_in => en_in, sof_in => sof_in, w_in => w64_in, w_num => w_num, w_en => w_en, d_out => d64_out1, en_out => open, sof_out => open);

CL64: ConvLayer1_64 generic map (
           mult_sum  => mult_sum_CL,
           N         => N       ,
           M         => CL_w_width      ,
           W         => CL_W       ,
           SR        => CL_SR      
           )
  port map   (
           clk       => clk     ,
           rst       => rst     ,
           d01_in    => d01_in,
           d02_in    => d02_in,
           d03_in    => d03_in,
           d04_in    => d04_in,
           d05_in    => d05_in,
           d06_in    => d06_in,
           d07_in    => d07_in,
           d08_in    => d08_in,
           d09_in    => d09_in,
           d10_in    => d10_in,
           d11_in    => d11_in,
           d12_in    => d12_in,
           d13_in    => d13_in,
           d14_in    => d14_in,
           d15_in    => d15_in,
           d16_in    => d16_in,
           d17_in    => d17_in,
           d18_in    => d18_in,
           d19_in    => d19_in,
           d20_in    => d20_in,
           d21_in    => d21_in,
           d22_in    => d22_in,
           d23_in    => d23_in,
           d24_in    => d24_in,
           d25_in    => d25_in,
           d26_in    => d26_in,
           d27_in    => d27_in,
           d28_in    => d28_in,
           d29_in    => d29_in,
           d30_in    => d30_in,
           d31_in    => d31_in,
           d32_in    => d32_in,
           d33_in    => d33_in,
           d34_in    => d34_in,
           d35_in    => d35_in,
           d36_in    => d36_in,
           d37_in    => d37_in,
           d38_in    => d38_in,
           d39_in    => d39_in,
           d40_in    => d40_in,
           d41_in    => d41_in,
           d42_in    => d42_in,
           d43_in    => d43_in,
           d44_in    => d44_in,
           d45_in    => d45_in,
           d46_in    => d46_in,
           d47_in    => d47_in,
           d48_in    => d48_in,
           d49_in    => d49_in,
           d50_in    => d50_in,
           d51_in    => d51_in,
           d52_in    => d52_in,
           d53_in    => d53_in,
           d54_in    => d54_in,
           d55_in    => d55_in,
           d56_in    => d56_in,
           d57_in    => d57_in,
           d58_in    => d58_in,
           d59_in    => d59_in,
           d60_in    => d60_in,
           d61_in    => d61_in,
           d62_in    => d62_in,
           d63_in    => d63_in,
           d64_in    => d64_in,
           en_in     => en_in ,
           sof_in    => sof_in,

           w01_in    => w01_in,
           w02_in    => w02_in,
           w03_in    => w03_in,
           w04_in    => w04_in,
           w05_in    => w05_in,
           w06_in    => w06_in,
           w07_in    => w07_in,
           w08_in    => w08_in,
           w09_in    => w09_in,
           w10_in    => w10_in,
           w11_in    => w11_in,
           w12_in    => w12_in,
           w13_in    => w13_in,
           w14_in    => w14_in,
           w15_in    => w15_in,
           w16_in    => w16_in,
           w17_in    => w17_in,
           w18_in    => w18_in,
           w19_in    => w19_in,
           w20_in    => w20_in,
           w21_in    => w21_in,
           w22_in    => w22_in,
           w23_in    => w23_in,
           w24_in    => w24_in,
           w25_in    => w25_in,
           w26_in    => w26_in,
           w27_in    => w27_in,
           w28_in    => w28_in,
           w29_in    => w29_in,
           w30_in    => w30_in,
           w31_in    => w31_in,
           w32_in    => w32_in,
           w33_in    => w33_in,
           w34_in    => w34_in,
           w35_in    => w35_in,
           w36_in    => w36_in,
           w37_in    => w37_in,
           w38_in    => w38_in,
           w39_in    => w39_in,
           w40_in    => w40_in,
           w41_in    => w41_in,
           w42_in    => w42_in,
           w43_in    => w43_in,
           w44_in    => w44_in,
           w45_in    => w45_in,
           w46_in    => w46_in,
           w47_in    => w47_in,
           w48_in    => w48_in,
           w49_in    => w49_in,
           w50_in    => w50_in,
           w51_in    => w51_in,
           w52_in    => w52_in,
           w53_in    => w53_in,
           w54_in    => w54_in,
           w55_in    => w55_in,
           w56_in    => w56_in,
           w57_in    => w57_in,
           w58_in    => w58_in,
           w59_in    => w59_in,
           w60_in    => w60_in,
           w61_in    => w61_in,
           w62_in    => w62_in,
           w63_in    => w63_in,
           w64_in    => w64_in,

           d_out     => d01_out1,
           en_out    => cl_en_out,
           sof_out   => cl_sof_out);


d01_out(7 downto 0) <= d01_out1(d01_out1'left downto d01_out1'left -7); d01_out(d01_out'left downto 8) <= (others => '0');

  p_pca_weight1 : process (clk,rst)
  begin
    if rst = '1' then
       pca_count <= 0;
    elsif rising_edge(clk) then
       if pca_w_en = '1' then
          pca_count <= pca_count + 1;
       end if;
    end if;
  end process p_pca_weight1;

  p_pca_weight : process (clk)
  begin
    if rising_edge(clk) then
       if pca_w_en = '1' then
          weight_pca_in(conv_integer('0' & pca_w_num))(pca_count) <= pca_w_in;
       end if;
    end if;
  end process p_pca_weight;

pca_w01 <= pca_mem( 0);


g_PCA_en: if PCA_en = TRUE generate


PCA64_inst: PCA_pixel 
  generic map (
            number_output_features_g => number_output_features_g
        )
    port map(
        reset          => clk,
        clock          => rst,
        sof            => cl_en_out, -- fix it, add start of frame
        eof            => '1',
        data_in        => d01_out1(d01_out1'left downto d01_out1'left -7),
        data_in_valid  => cl_en_out,
        weight_in      => weight_pca_in,
        data_out       => data_pca_out,
        data_out_valid => en_out(0)
    ) ;

  insamp2 : process (clk,rst)
  begin
    if rst = '1' then
       count  <= 0;
    elsif rising_edge(clk) then
       if en_out(0) = '1' then
        data_pca_out1 <= data_pca_out;
       end if;
       count <= count + 1;
        case count is
          when   0 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 0) ;
          when   1 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 1) ;
          when   2 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 2) ;
          when   3 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 3) ;
          when   4 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 4) ;
          when   5 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 5) ;
          when   6 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 6) ;
          when   7 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 7) ;
          when   8 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 8) ;
          when   9 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out( 9) ;
          when  10 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(10) ;
          when  11 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(11) ;
          when  12 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(12) ;
          when  13 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(13) ;
          when  14 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(14) ;
          when  15 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(15) ;
          when  16 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(16) ;
          when  17 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(17) ;
          when  18 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(18) ;
          when  19 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(19) ;
          when  20 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(20) ;
          when  21 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(21) ;
          when  22 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(22) ;
          when  23 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(23) ;
          when  24 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(24) ;
          when  25 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(25) ;
          when  26 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(26) ;
          when  27 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(27) ;
          when  28 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(28) ;
          when  29 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(29) ;
          when  30 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(30) ;
          when  31 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(31) ;
          when  32 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(32) ;
          when  33 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(33) ;
          when  34 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(34) ;
          when  35 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(35) ;
          when  36 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(36) ;
          when  37 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(37) ;
          when  38 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(38) ;
          when  39 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(39) ;
          when  40 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(40) ;
          when  41 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(41) ;
          when  42 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(42) ;
          when  43 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(43) ;
          when  44 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(44) ;
          when  45 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(45) ;
          when  46 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(46) ;
          when  47 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(47) ;
          when  48 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(48) ;
          when  49 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(49) ;
          when  50 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(50) ;
          when  51 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(51) ;
          when  52 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(52) ;
          when  53 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(53) ;
          when  54 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(54) ;
          when  55 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(55) ;
          when  56 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(56) ;
          when  57 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(57) ;
          when  58 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(58) ;
          when  59 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(59) ;
          when  60 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(60) ;
          when  61 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(61) ;
          when  62 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(62) ;
          when  63 => pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= data_pca_out(63) ;
          when others => null;
          end case;
    end if;
  end process insamp2;

end generate g_PCA_en;

g_PCA_bp: if PCA_en = FALSE generate
   pca_en_out                          <=  cl_en_out;

p_PCA_dis: process (clk)
 begin
    if  rising_edge(clk) then
--PCA_dis1 <= d01_out(7 downto 0)+ d02_out(7 downto 0)+ d03_out(7 downto 0)+ d04_out(7 downto 0)+ d05_out(7 downto 0)+ d06_out(7 downto 0)+ d07_out(7 downto 0)+ d08_out(7 downto 0);  
--PCA_dis2 <= d09_out(7 downto 0)+ d10_out(7 downto 0)+ d11_out(7 downto 0)+ d12_out(7 downto 0)+ d13_out(7 downto 0)+ d14_out(7 downto 0)+ d15_out(7 downto 0)+ d16_out(7 downto 0);  
--PCA_dis3 <= d17_out(7 downto 0)+ d18_out(7 downto 0)+ d19_out(7 downto 0)+ d20_out(7 downto 0)+ d21_out(7 downto 0)+ d22_out(7 downto 0)+ d23_out(7 downto 0)+ d24_out(7 downto 0);  
--PCA_dis4 <= d25_out(7 downto 0)+ d26_out(7 downto 0)+ d27_out(7 downto 0)+ d28_out(7 downto 0)+ d29_out(7 downto 0)+ d30_out(7 downto 0)+ d31_out(7 downto 0)+ d32_out(7 downto 0);  
--PCA_dis5 <= d33_out(7 downto 0)+ d34_out(7 downto 0)+ d35_out(7 downto 0)+ d36_out(7 downto 0)+ d37_out(7 downto 0)+ d38_out(7 downto 0)+ d39_out(7 downto 0)+ d40_out(7 downto 0);  
--PCA_dis6 <= d41_out(7 downto 0)+ d42_out(7 downto 0)+ d43_out(7 downto 0)+ d44_out(7 downto 0)+ d45_out(7 downto 0)+ d46_out(7 downto 0)+ d47_out(7 downto 0)+ d48_out(7 downto 0);  
--PCA_dis7 <= d49_out(7 downto 0)+ d50_out(7 downto 0)+ d51_out(7 downto 0)+ d52_out(7 downto 0)+ d53_out(7 downto 0)+ d54_out(7 downto 0)+ d55_out(7 downto 0)+ d56_out(7 downto 0); 
--PCA_dis8 <= d57_out(7 downto 0)+ d58_out(7 downto 0)+ d59_out(7 downto 0)+ d60_out(7 downto 0)+ d61_out(7 downto 0)+ d62_out(7 downto 0)+ d63_out(7 downto 0)+ d64_out(7 downto 0);  
--pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7)  <= PCA_dis1 + PCA_dis2 + PCA_dis3 + PCA_dis4 + PCA_dis5 + PCA_dis6 + PCA_dis7 + PCA_dis8;

pca_d01_out(pca_d01_out'left downto pca_d01_out'left - 7) <= d01_out(7 downto 0);

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

g_Huff_enc_en: if Huff_enc_en = TRUE generate
Huffman_inst: Huffman
  generic map(
           N           => 8          ,  -- input data width
           M           => Huff_wid   ,  -- max code width
           W           => Wh         
           )
  port map   (
           clk      => clk  ,
           rst      => rst  , 

           init_en        => h_en       ,
           alpha_data     => alpha_data ,   
           alpha_code     => alpha_code ,    
           alpha_width    => alpha_width,

           d_in           => pca_d01_out(30 downto 30-7), 
           en_in          => pca_en_out,        --
           sof_in         => pca_sof_out,        --                         -- start of frame
           eof_in         => '0',        --                         -- end of frame

           d_out          => d_out(15 downto 0),
           en_out         => en_out(0),
           eof_out        => sof_out);                        -- huffman codde output

 end generate g_Huff_enc_en;

 g_Huff_enc_dis: if Huff_enc_en = FALSE generate
  d_out(7 downto 0) <= pca_d01_out(30 downto 30-7);
 end generate g_Huff_enc_dis;  
  
--Huffman64_inst: Huffman64 
--  generic map(
--           N           => 8          ,  -- input data width
--           M           => Huff_wid   ,  -- max code width
--           Wh          => Wh         ,
--           Wb          => Wb         ,
--           Huff_enc_en => Huff_enc_en,
--           depth       => depth      ,
--           burst       => burst
--           )
--  port map (
--           clk      => clk  ,
--           rst      => rst  , 
--
--           init_en        => h_en       ,
--           alpha_data     => alpha_data ,   
--           alpha_code     => alpha_code ,    
--           alpha_width    => alpha_width,
--
--           d01_in         => pca_d01_out(30 downto 30-7), --(pca_d01_out'left downto pca_d01_out'left - 7),
--           d02_in         => (others => '0'), --pca_d02_out(30 downto 30-7), --(pca_d02_out'left downto pca_d02_out'left - 7),
--           d03_in         => (others => '0'), --pca_d03_out(30 downto 30-7), --(pca_d03_out'left downto pca_d03_out'left - 7),
--           d04_in         => (others => '0'), --pca_d04_out(30 downto 30-7), --(pca_d04_out'left downto pca_d04_out'left - 7),
--           d05_in         => (others => '0'), --pca_d05_out(30 downto 30-7), --(pca_d05_out'left downto pca_d05_out'left - 7),
--           d06_in         => (others => '0'), --pca_d06_out(30 downto 30-7), --(pca_d06_out'left downto pca_d06_out'left - 7),
--           d07_in         => (others => '0'), --pca_d07_out(30 downto 30-7), --(pca_d07_out'left downto pca_d07_out'left - 7),
--           d08_in         => (others => '0'), --pca_d08_out(30 downto 30-7), --(pca_d08_out'left downto pca_d08_out'left - 7),
--           d09_in         => (others => '0'), --pca_d09_out(30 downto 30-7), --(pca_d09_out'left downto pca_d09_out'left - 7),
--           d10_in         => (others => '0'), --pca_d10_out(30 downto 30-7), --(pca_d10_out'left downto pca_d10_out'left - 7),
--           d11_in         => (others => '0'), --pca_d11_out(30 downto 30-7), --(pca_d11_out'left downto pca_d11_out'left - 7),
--           d12_in         => (others => '0'), --pca_d12_out(30 downto 30-7), --(pca_d12_out'left downto pca_d12_out'left - 7),
--           d13_in         => (others => '0'), --pca_d13_out(30 downto 30-7), --(pca_d13_out'left downto pca_d13_out'left - 7),
--           d14_in         => (others => '0'), --pca_d14_out(30 downto 30-7), --(pca_d14_out'left downto pca_d14_out'left - 7),
--           d15_in         => (others => '0'), --pca_d15_out(30 downto 30-7), --(pca_d15_out'left downto pca_d15_out'left - 7),
--           d16_in         => (others => '0'), --pca_d16_out(30 downto 30-7), --(pca_d16_out'left downto pca_d16_out'left - 7),
--           d17_in         => (others => '0'), --pca_d17_out(30 downto 30-7), --(pca_d17_out'left downto pca_d17_out'left - 7),
--           d18_in         => (others => '0'), --pca_d18_out(30 downto 30-7), --(pca_d18_out'left downto pca_d18_out'left - 7),
--           d19_in         => (others => '0'), --pca_d19_out(30 downto 30-7), --(pca_d19_out'left downto pca_d19_out'left - 7),
--           d20_in         => (others => '0'), --pca_d20_out(30 downto 30-7), --(pca_d20_out'left downto pca_d20_out'left - 7),
--           d21_in         => (others => '0'), --pca_d21_out(30 downto 30-7), --(pca_d21_out'left downto pca_d21_out'left - 7),
--           d22_in         => (others => '0'), --pca_d22_out(30 downto 30-7), --(pca_d22_out'left downto pca_d22_out'left - 7),
--           d23_in         => (others => '0'), --pca_d23_out(30 downto 30-7), --(pca_d23_out'left downto pca_d23_out'left - 7),
--           d24_in         => (others => '0'), --pca_d24_out(30 downto 30-7), --(pca_d24_out'left downto pca_d24_out'left - 7),
--           d25_in         => (others => '0'), --pca_d25_out(30 downto 30-7), --(pca_d25_out'left downto pca_d25_out'left - 7),
--           d26_in         => (others => '0'), --pca_d26_out(30 downto 30-7), --(pca_d26_out'left downto pca_d26_out'left - 7),
--           d27_in         => (others => '0'), --pca_d27_out(30 downto 30-7), --(pca_d27_out'left downto pca_d27_out'left - 7),
--           d28_in         => (others => '0'), --pca_d28_out(30 downto 30-7), --(pca_d28_out'left downto pca_d28_out'left - 7),
--           d29_in         => (others => '0'), --pca_d29_out(30 downto 30-7), --(pca_d29_out'left downto pca_d29_out'left - 7),
--           d30_in         => (others => '0'), --pca_d30_out(30 downto 30-7), --(pca_d30_out'left downto pca_d30_out'left - 7),
--           d31_in         => (others => '0'), --pca_d31_out(30 downto 30-7), --(pca_d31_out'left downto pca_d31_out'left - 7),
--           d32_in         => (others => '0'), --pca_d32_out(30 downto 30-7), --(pca_d32_out'left downto pca_d32_out'left - 7),
--           d33_in         => (others => '0'), --pca_d33_out(30 downto 30-7), --(pca_d33_out'left downto pca_d33_out'left - 7),
--           d34_in         => (others => '0'), --pca_d34_out(30 downto 30-7), --(pca_d34_out'left downto pca_d34_out'left - 7),
--           d35_in         => (others => '0'), --pca_d35_out(30 downto 30-7), --(pca_d35_out'left downto pca_d35_out'left - 7),
--           d36_in         => (others => '0'), --pca_d36_out(30 downto 30-7), --(pca_d36_out'left downto pca_d36_out'left - 7),
--           d37_in         => (others => '0'), --pca_d37_out(30 downto 30-7), --(pca_d37_out'left downto pca_d37_out'left - 7),
--           d38_in         => (others => '0'), --pca_d38_out(30 downto 30-7), --(pca_d38_out'left downto pca_d38_out'left - 7),
--           d39_in         => (others => '0'), --pca_d39_out(30 downto 30-7), --(pca_d39_out'left downto pca_d39_out'left - 7),
--           d40_in         => (others => '0'), --pca_d40_out(30 downto 30-7), --(pca_d40_out'left downto pca_d40_out'left - 7),
--           d41_in         => (others => '0'), --pca_d41_out(30 downto 30-7), --(pca_d41_out'left downto pca_d41_out'left - 7),
--           d42_in         => (others => '0'), --pca_d42_out(30 downto 30-7), --(pca_d42_out'left downto pca_d42_out'left - 7),
--           d43_in         => (others => '0'), --pca_d43_out(30 downto 30-7), --(pca_d43_out'left downto pca_d43_out'left - 7),
--           d44_in         => (others => '0'), --pca_d44_out(30 downto 30-7), --(pca_d44_out'left downto pca_d44_out'left - 7),
--           d45_in         => (others => '0'), --pca_d45_out(30 downto 30-7), --(pca_d45_out'left downto pca_d45_out'left - 7),
--           d46_in         => (others => '0'), --pca_d46_out(30 downto 30-7), --(pca_d46_out'left downto pca_d46_out'left - 7),
--           d47_in         => (others => '0'), --pca_d47_out(30 downto 30-7), --(pca_d47_out'left downto pca_d47_out'left - 7),
--           d48_in         => (others => '0'), --pca_d48_out(30 downto 30-7), --(pca_d48_out'left downto pca_d48_out'left - 7),
--           d49_in         => (others => '0'), --pca_d49_out(30 downto 30-7), --(pca_d49_out'left downto pca_d49_out'left - 7),
--           d50_in         => (others => '0'), --pca_d50_out(30 downto 30-7), --(pca_d50_out'left downto pca_d50_out'left - 7),
--           d51_in         => (others => '0'), --pca_d51_out(30 downto 30-7), --(pca_d51_out'left downto pca_d51_out'left - 7),
--           d52_in         => (others => '0'), --pca_d52_out(30 downto 30-7), --(pca_d52_out'left downto pca_d52_out'left - 7),
--           d53_in         => (others => '0'), --pca_d53_out(30 downto 30-7), --(pca_d53_out'left downto pca_d53_out'left - 7),
--           d54_in         => (others => '0'), --pca_d54_out(30 downto 30-7), --(pca_d54_out'left downto pca_d54_out'left - 7),
--           d55_in         => (others => '0'), --pca_d55_out(30 downto 30-7), --(pca_d55_out'left downto pca_d55_out'left - 7),
--           d56_in         => (others => '0'), --pca_d56_out(30 downto 30-7), --(pca_d56_out'left downto pca_d56_out'left - 7),
--           d57_in         => (others => '0'), --pca_d57_out(30 downto 30-7), --(pca_d57_out'left downto pca_d57_out'left - 7),
--           d58_in         => (others => '0'), --pca_d58_out(30 downto 30-7), --(pca_d58_out'left downto pca_d58_out'left - 7),
--           d59_in         => (others => '0'), --pca_d59_out(30 downto 30-7), --(pca_d59_out'left downto pca_d59_out'left - 7),
--           d60_in         => (others => '0'), --pca_d60_out(30 downto 30-7), --(pca_d60_out'left downto pca_d60_out'left - 7),
--           d61_in         => (others => '0'), --pca_d61_out(30 downto 30-7), --(pca_d61_out'left downto pca_d61_out'left - 7),
--           d62_in         => (others => '0'), --pca_d62_out(30 downto 30-7), --(pca_d62_out'left downto pca_d62_out'left - 7),
--           d63_in         => (others => '0'), --pca_d63_out(30 downto 30-7), --(pca_d63_out'left downto pca_d63_out'left - 7),
--           d64_in         => (others => '0'), --pca_d64_out(30 downto 30-7), --(pca_d64_out'left downto pca_d64_out'left - 7),
--           en_in          => pca_en_out,        --
--           sof_in         => pca_sof_out,        --                         -- start of frame
--           eof_in         => '0',        --                         -- end of frame
--
--           buf_rd        => buf_rd         ,
--           buf_num       => buf_num        ,
--           d_out         => huff_out       ,
--           en_out        => open           ,
--           eof_out       => open           );                        -- huffman codde output
--
--    d_out  <=  huff_out;


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