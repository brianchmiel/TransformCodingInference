library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ConvLayer1_64 is
  generic (
  	       mult_sum      : string := "sum";
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 8; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 2 -- data shift right before output
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
end ConvLayer1_64;

architecture a of ConvLayer1_64 is

constant EN_BIT  : integer range 0 to 1 := 0;
constant SOF_BIT : integer range 0 to 1 := 1;

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

component ConvLayer1 is
  generic (
           mult_sum      : string := "sum";
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 8; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 2 -- data shift right before output
           );
  port    (
           clk         : in std_logic;
           rst         : in std_logic;
           data2conv1  : in std_logic_vector (N-1 downto 0);
           data2conv2  : in std_logic_vector (N-1 downto 0);
           data2conv3  : in std_logic_vector (N-1 downto 0);
           data2conv4  : in std_logic_vector (N-1 downto 0);
           data2conv5  : in std_logic_vector (N-1 downto 0);
           data2conv6  : in std_logic_vector (N-1 downto 0);
           data2conv7  : in std_logic_vector (N-1 downto 0);
           data2conv8  : in std_logic_vector (N-1 downto 0);
           data2conv9  : in std_logic_vector (N-1 downto 0);
           en_in       : in std_logic;
           sof_in      : in std_logic; -- start of frame
           --sol     : in std_logic; -- start of line
           --eof     : in std_logic; -- end of frame

          w1           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w2           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w3           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w4           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w5           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w6           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w7           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w8           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w9           : in std_logic_vector(M-1 downto 0); -- weight matrix

           d_out       : out std_logic_vector (W-1 downto 0);
           en_out      : out std_logic;
           sof_out     : out std_logic);
end component;

signal    d01_out   : std_logic_vector (W-1 downto 0);
signal    d02_out   : std_logic_vector (W-1 downto 0);
signal    d03_out   : std_logic_vector (W-1 downto 0);
signal    d04_out   : std_logic_vector (W-1 downto 0);
signal    d05_out   : std_logic_vector (W-1 downto 0);
signal    d06_out   : std_logic_vector (W-1 downto 0);
signal    d07_out   : std_logic_vector (W-1 downto 0);
signal    d08_out   : std_logic_vector (W-1 downto 0);
signal    d09_out   : std_logic_vector (W-1 downto 0);
signal    d10_out   : std_logic_vector (W-1 downto 0);
signal    d11_out   : std_logic_vector (W-1 downto 0);
signal    d12_out   : std_logic_vector (W-1 downto 0);
signal    d13_out   : std_logic_vector (W-1 downto 0);
signal    d14_out   : std_logic_vector (W-1 downto 0);
signal    d15_out   : std_logic_vector (W-1 downto 0);
signal    d16_out   : std_logic_vector (W-1 downto 0);
signal    d17_out   : std_logic_vector (W-1 downto 0);
signal    d18_out   : std_logic_vector (W-1 downto 0);
signal    d19_out   : std_logic_vector (W-1 downto 0);
signal    d20_out   : std_logic_vector (W-1 downto 0);
signal    d21_out   : std_logic_vector (W-1 downto 0);
signal    d22_out   : std_logic_vector (W-1 downto 0);
signal    d23_out   : std_logic_vector (W-1 downto 0);
signal    d24_out   : std_logic_vector (W-1 downto 0);
signal    d25_out   : std_logic_vector (W-1 downto 0);
signal    d26_out   : std_logic_vector (W-1 downto 0);
signal    d27_out   : std_logic_vector (W-1 downto 0);
signal    d28_out   : std_logic_vector (W-1 downto 0);
signal    d29_out   : std_logic_vector (W-1 downto 0);
signal    d30_out   : std_logic_vector (W-1 downto 0);
signal    d31_out   : std_logic_vector (W-1 downto 0);
signal    d32_out   : std_logic_vector (W-1 downto 0);
signal    d33_out   : std_logic_vector (W-1 downto 0);
signal    d34_out   : std_logic_vector (W-1 downto 0);
signal    d35_out   : std_logic_vector (W-1 downto 0);
signal    d36_out   : std_logic_vector (W-1 downto 0);
signal    d37_out   : std_logic_vector (W-1 downto 0);
signal    d38_out   : std_logic_vector (W-1 downto 0);
signal    d39_out   : std_logic_vector (W-1 downto 0);
signal    d40_out   : std_logic_vector (W-1 downto 0);
signal    d41_out   : std_logic_vector (W-1 downto 0);
signal    d42_out   : std_logic_vector (W-1 downto 0);
signal    d43_out   : std_logic_vector (W-1 downto 0);
signal    d44_out   : std_logic_vector (W-1 downto 0);
signal    d45_out   : std_logic_vector (W-1 downto 0);
signal    d46_out   : std_logic_vector (W-1 downto 0);
signal    d47_out   : std_logic_vector (W-1 downto 0);
signal    d48_out   : std_logic_vector (W-1 downto 0);
signal    d49_out   : std_logic_vector (W-1 downto 0);
signal    d50_out   : std_logic_vector (W-1 downto 0);
signal    d51_out   : std_logic_vector (W-1 downto 0);
signal    d52_out   : std_logic_vector (W-1 downto 0);
signal    d53_out   : std_logic_vector (W-1 downto 0);
signal    d54_out   : std_logic_vector (W-1 downto 0);
signal    d55_out   : std_logic_vector (W-1 downto 0);
signal    d56_out   : std_logic_vector (W-1 downto 0);
signal    d57_out   : std_logic_vector (W-1 downto 0);
signal    d58_out   : std_logic_vector (W-1 downto 0);
signal    d59_out   : std_logic_vector (W-1 downto 0);
signal    d60_out   : std_logic_vector (W-1 downto 0);
signal    d61_out   : std_logic_vector (W-1 downto 0);
signal    d62_out   : std_logic_vector (W-1 downto 0);
signal    d63_out   : std_logic_vector (W-1 downto 0);
signal    d64_out   : std_logic_vector (W-1 downto 0);

signal    sum1      : std_logic_vector (W+1 downto 0); 
signal    sum2      : std_logic_vector (W+1 downto 0); 
signal    sum3      : std_logic_vector (W+1 downto 0); 
signal    sum4      : std_logic_vector (W+1 downto 0); 
signal    sum5      : std_logic_vector (W+1 downto 0); 
signal    sum6      : std_logic_vector (W+1 downto 0); 
signal    sum7      : std_logic_vector (W+1 downto 0); 
signal    sum8      : std_logic_vector (W+1 downto 0); 
signal    sum9      : std_logic_vector (W+1 downto 0); 
signal    sum10     : std_logic_vector (W+1 downto 0); 
signal    sum11     : std_logic_vector (W+1 downto 0); 
signal    sum12     : std_logic_vector (W+1 downto 0); 
signal    sum13     : std_logic_vector (W+1 downto 0); 
signal    sum14     : std_logic_vector (W+1 downto 0); 
signal    sum15     : std_logic_vector (W+1 downto 0); 
signal    sum16     : std_logic_vector (W+1 downto 0); 
       
signal    sum17     : std_logic_vector (W+3 downto 0);   
signal    sum18     : std_logic_vector (W+3 downto 0);   
signal    sum19     : std_logic_vector (W+3 downto 0); 
signal    sum20     : std_logic_vector (W+3 downto 0); 
       
signal    sum21     : std_logic_vector (W+5 downto 0); 

begin


CL01: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d01_in(9*N-1 downto 8*N),data2conv2 =>d01_in(8*N-1 downto 7*N),data2conv3 =>d01_in(7*N-1 downto 6*N),data2conv4 =>d01_in(6*N-1 downto 5*N),data2conv5 =>d01_in(5*N-1 downto 4*N),data2conv6 =>d01_in(4*N-1 downto 3*N),data2conv7 =>d01_in(3*N-1 downto 2*N),data2conv8 =>d01_in(2*N-1 downto N),data2conv9 =>d01_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d01_in(9*N-1 downto 8*N),w2 => d01_in(8*N-1 downto 7*N),w3 => d01_in(7*N-1 downto 6*N),w4 => d01_in(6*N-1 downto 5*N),w5 => d01_in(5*N-1 downto 4*N),w6 => d01_in(4*N-1 downto 3*N),w7 => d01_in(3*N-1 downto 2*N),w8 => d01_in(2*N-1 downto N),w9 => d01_in(N-1 downto 0 ),d_out => d01_out,en_out =>en_out,sof_out=>sof_out);
CL02: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d02_in(9*N-1 downto 8*N),data2conv2 =>d02_in(8*N-1 downto 7*N),data2conv3 =>d02_in(7*N-1 downto 6*N),data2conv4 =>d02_in(6*N-1 downto 5*N),data2conv5 =>d02_in(5*N-1 downto 4*N),data2conv6 =>d02_in(4*N-1 downto 3*N),data2conv7 =>d02_in(3*N-1 downto 2*N),data2conv8 =>d02_in(2*N-1 downto N),data2conv9 =>d02_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d02_in(9*N-1 downto 8*N),w2 => d02_in(8*N-1 downto 7*N),w3 => d02_in(7*N-1 downto 6*N),w4 => d02_in(6*N-1 downto 5*N),w5 => d02_in(5*N-1 downto 4*N),w6 => d02_in(4*N-1 downto 3*N),w7 => d02_in(3*N-1 downto 2*N),w8 => d02_in(2*N-1 downto N),w9 => d02_in(N-1 downto 0 ),d_out => d02_out,en_out =>open  ,sof_out=>open   );
CL03: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d03_in(9*N-1 downto 8*N),data2conv2 =>d03_in(8*N-1 downto 7*N),data2conv3 =>d03_in(7*N-1 downto 6*N),data2conv4 =>d03_in(6*N-1 downto 5*N),data2conv5 =>d03_in(5*N-1 downto 4*N),data2conv6 =>d03_in(4*N-1 downto 3*N),data2conv7 =>d03_in(3*N-1 downto 2*N),data2conv8 =>d03_in(2*N-1 downto N),data2conv9 =>d03_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d03_in(9*N-1 downto 8*N),w2 => d03_in(8*N-1 downto 7*N),w3 => d03_in(7*N-1 downto 6*N),w4 => d03_in(6*N-1 downto 5*N),w5 => d03_in(5*N-1 downto 4*N),w6 => d03_in(4*N-1 downto 3*N),w7 => d03_in(3*N-1 downto 2*N),w8 => d03_in(2*N-1 downto N),w9 => d03_in(N-1 downto 0 ),d_out => d03_out,en_out =>open  ,sof_out=>open   );
CL04: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d04_in(9*N-1 downto 8*N),data2conv2 =>d04_in(8*N-1 downto 7*N),data2conv3 =>d04_in(7*N-1 downto 6*N),data2conv4 =>d04_in(6*N-1 downto 5*N),data2conv5 =>d04_in(5*N-1 downto 4*N),data2conv6 =>d04_in(4*N-1 downto 3*N),data2conv7 =>d04_in(3*N-1 downto 2*N),data2conv8 =>d04_in(2*N-1 downto N),data2conv9 =>d04_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d04_in(9*N-1 downto 8*N),w2 => d04_in(8*N-1 downto 7*N),w3 => d04_in(7*N-1 downto 6*N),w4 => d04_in(6*N-1 downto 5*N),w5 => d04_in(5*N-1 downto 4*N),w6 => d04_in(4*N-1 downto 3*N),w7 => d04_in(3*N-1 downto 2*N),w8 => d04_in(2*N-1 downto N),w9 => d04_in(N-1 downto 0 ),d_out => d04_out,en_out =>open  ,sof_out=>open   );
CL05: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d05_in(9*N-1 downto 8*N),data2conv2 =>d05_in(8*N-1 downto 7*N),data2conv3 =>d05_in(7*N-1 downto 6*N),data2conv4 =>d05_in(6*N-1 downto 5*N),data2conv5 =>d05_in(5*N-1 downto 4*N),data2conv6 =>d05_in(4*N-1 downto 3*N),data2conv7 =>d05_in(3*N-1 downto 2*N),data2conv8 =>d05_in(2*N-1 downto N),data2conv9 =>d05_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d05_in(9*N-1 downto 8*N),w2 => d05_in(8*N-1 downto 7*N),w3 => d05_in(7*N-1 downto 6*N),w4 => d05_in(6*N-1 downto 5*N),w5 => d05_in(5*N-1 downto 4*N),w6 => d05_in(4*N-1 downto 3*N),w7 => d05_in(3*N-1 downto 2*N),w8 => d05_in(2*N-1 downto N),w9 => d05_in(N-1 downto 0 ),d_out => d05_out,en_out =>open  ,sof_out=>open   );
CL06: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d06_in(9*N-1 downto 8*N),data2conv2 =>d06_in(8*N-1 downto 7*N),data2conv3 =>d06_in(7*N-1 downto 6*N),data2conv4 =>d06_in(6*N-1 downto 5*N),data2conv5 =>d06_in(5*N-1 downto 4*N),data2conv6 =>d06_in(4*N-1 downto 3*N),data2conv7 =>d06_in(3*N-1 downto 2*N),data2conv8 =>d06_in(2*N-1 downto N),data2conv9 =>d06_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d06_in(9*N-1 downto 8*N),w2 => d06_in(8*N-1 downto 7*N),w3 => d06_in(7*N-1 downto 6*N),w4 => d06_in(6*N-1 downto 5*N),w5 => d06_in(5*N-1 downto 4*N),w6 => d06_in(4*N-1 downto 3*N),w7 => d06_in(3*N-1 downto 2*N),w8 => d06_in(2*N-1 downto N),w9 => d06_in(N-1 downto 0 ),d_out => d06_out,en_out =>open  ,sof_out=>open   );
CL07: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d07_in(9*N-1 downto 8*N),data2conv2 =>d07_in(8*N-1 downto 7*N),data2conv3 =>d07_in(7*N-1 downto 6*N),data2conv4 =>d07_in(6*N-1 downto 5*N),data2conv5 =>d07_in(5*N-1 downto 4*N),data2conv6 =>d07_in(4*N-1 downto 3*N),data2conv7 =>d07_in(3*N-1 downto 2*N),data2conv8 =>d07_in(2*N-1 downto N),data2conv9 =>d07_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d07_in(9*N-1 downto 8*N),w2 => d07_in(8*N-1 downto 7*N),w3 => d07_in(7*N-1 downto 6*N),w4 => d07_in(6*N-1 downto 5*N),w5 => d07_in(5*N-1 downto 4*N),w6 => d07_in(4*N-1 downto 3*N),w7 => d07_in(3*N-1 downto 2*N),w8 => d07_in(2*N-1 downto N),w9 => d07_in(N-1 downto 0 ),d_out => d07_out,en_out =>open  ,sof_out=>open   );
CL08: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d08_in(9*N-1 downto 8*N),data2conv2 =>d08_in(8*N-1 downto 7*N),data2conv3 =>d08_in(7*N-1 downto 6*N),data2conv4 =>d08_in(6*N-1 downto 5*N),data2conv5 =>d08_in(5*N-1 downto 4*N),data2conv6 =>d08_in(4*N-1 downto 3*N),data2conv7 =>d08_in(3*N-1 downto 2*N),data2conv8 =>d08_in(2*N-1 downto N),data2conv9 =>d08_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d08_in(9*N-1 downto 8*N),w2 => d08_in(8*N-1 downto 7*N),w3 => d08_in(7*N-1 downto 6*N),w4 => d08_in(6*N-1 downto 5*N),w5 => d08_in(5*N-1 downto 4*N),w6 => d08_in(4*N-1 downto 3*N),w7 => d08_in(3*N-1 downto 2*N),w8 => d08_in(2*N-1 downto N),w9 => d08_in(N-1 downto 0 ),d_out => d08_out,en_out =>open  ,sof_out=>open   );
CL09: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d09_in(9*N-1 downto 8*N),data2conv2 =>d09_in(8*N-1 downto 7*N),data2conv3 =>d09_in(7*N-1 downto 6*N),data2conv4 =>d09_in(6*N-1 downto 5*N),data2conv5 =>d09_in(5*N-1 downto 4*N),data2conv6 =>d09_in(4*N-1 downto 3*N),data2conv7 =>d09_in(3*N-1 downto 2*N),data2conv8 =>d09_in(2*N-1 downto N),data2conv9 =>d09_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d09_in(9*N-1 downto 8*N),w2 => d09_in(8*N-1 downto 7*N),w3 => d09_in(7*N-1 downto 6*N),w4 => d09_in(6*N-1 downto 5*N),w5 => d09_in(5*N-1 downto 4*N),w6 => d09_in(4*N-1 downto 3*N),w7 => d09_in(3*N-1 downto 2*N),w8 => d09_in(2*N-1 downto N),w9 => d09_in(N-1 downto 0 ),d_out => d09_out,en_out =>open  ,sof_out=>open   );
CL10: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d10_in(9*N-1 downto 8*N),data2conv2 =>d10_in(8*N-1 downto 7*N),data2conv3 =>d10_in(7*N-1 downto 6*N),data2conv4 =>d10_in(6*N-1 downto 5*N),data2conv5 =>d10_in(5*N-1 downto 4*N),data2conv6 =>d10_in(4*N-1 downto 3*N),data2conv7 =>d10_in(3*N-1 downto 2*N),data2conv8 =>d10_in(2*N-1 downto N),data2conv9 =>d10_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d10_in(9*N-1 downto 8*N),w2 => d10_in(8*N-1 downto 7*N),w3 => d10_in(7*N-1 downto 6*N),w4 => d10_in(6*N-1 downto 5*N),w5 => d10_in(5*N-1 downto 4*N),w6 => d10_in(4*N-1 downto 3*N),w7 => d10_in(3*N-1 downto 2*N),w8 => d10_in(2*N-1 downto N),w9 => d10_in(N-1 downto 0 ),d_out => d10_out,en_out =>open  ,sof_out=>open   );
CL11: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d11_in(9*N-1 downto 8*N),data2conv2 =>d11_in(8*N-1 downto 7*N),data2conv3 =>d11_in(7*N-1 downto 6*N),data2conv4 =>d11_in(6*N-1 downto 5*N),data2conv5 =>d11_in(5*N-1 downto 4*N),data2conv6 =>d11_in(4*N-1 downto 3*N),data2conv7 =>d11_in(3*N-1 downto 2*N),data2conv8 =>d11_in(2*N-1 downto N),data2conv9 =>d11_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d11_in(9*N-1 downto 8*N),w2 => d11_in(8*N-1 downto 7*N),w3 => d11_in(7*N-1 downto 6*N),w4 => d11_in(6*N-1 downto 5*N),w5 => d11_in(5*N-1 downto 4*N),w6 => d11_in(4*N-1 downto 3*N),w7 => d11_in(3*N-1 downto 2*N),w8 => d11_in(2*N-1 downto N),w9 => d11_in(N-1 downto 0 ),d_out => d11_out,en_out =>open  ,sof_out=>open   );
CL12: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d12_in(9*N-1 downto 8*N),data2conv2 =>d12_in(8*N-1 downto 7*N),data2conv3 =>d12_in(7*N-1 downto 6*N),data2conv4 =>d12_in(6*N-1 downto 5*N),data2conv5 =>d12_in(5*N-1 downto 4*N),data2conv6 =>d12_in(4*N-1 downto 3*N),data2conv7 =>d12_in(3*N-1 downto 2*N),data2conv8 =>d12_in(2*N-1 downto N),data2conv9 =>d12_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d12_in(9*N-1 downto 8*N),w2 => d12_in(8*N-1 downto 7*N),w3 => d12_in(7*N-1 downto 6*N),w4 => d12_in(6*N-1 downto 5*N),w5 => d12_in(5*N-1 downto 4*N),w6 => d12_in(4*N-1 downto 3*N),w7 => d12_in(3*N-1 downto 2*N),w8 => d12_in(2*N-1 downto N),w9 => d12_in(N-1 downto 0 ),d_out => d12_out,en_out =>open  ,sof_out=>open   );
CL13: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d13_in(9*N-1 downto 8*N),data2conv2 =>d13_in(8*N-1 downto 7*N),data2conv3 =>d13_in(7*N-1 downto 6*N),data2conv4 =>d13_in(6*N-1 downto 5*N),data2conv5 =>d13_in(5*N-1 downto 4*N),data2conv6 =>d13_in(4*N-1 downto 3*N),data2conv7 =>d13_in(3*N-1 downto 2*N),data2conv8 =>d13_in(2*N-1 downto N),data2conv9 =>d13_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d13_in(9*N-1 downto 8*N),w2 => d13_in(8*N-1 downto 7*N),w3 => d13_in(7*N-1 downto 6*N),w4 => d13_in(6*N-1 downto 5*N),w5 => d13_in(5*N-1 downto 4*N),w6 => d13_in(4*N-1 downto 3*N),w7 => d13_in(3*N-1 downto 2*N),w8 => d13_in(2*N-1 downto N),w9 => d13_in(N-1 downto 0 ),d_out => d13_out,en_out =>open  ,sof_out=>open   );
CL14: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d14_in(9*N-1 downto 8*N),data2conv2 =>d14_in(8*N-1 downto 7*N),data2conv3 =>d14_in(7*N-1 downto 6*N),data2conv4 =>d14_in(6*N-1 downto 5*N),data2conv5 =>d14_in(5*N-1 downto 4*N),data2conv6 =>d14_in(4*N-1 downto 3*N),data2conv7 =>d14_in(3*N-1 downto 2*N),data2conv8 =>d14_in(2*N-1 downto N),data2conv9 =>d14_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d14_in(9*N-1 downto 8*N),w2 => d14_in(8*N-1 downto 7*N),w3 => d14_in(7*N-1 downto 6*N),w4 => d14_in(6*N-1 downto 5*N),w5 => d14_in(5*N-1 downto 4*N),w6 => d14_in(4*N-1 downto 3*N),w7 => d14_in(3*N-1 downto 2*N),w8 => d14_in(2*N-1 downto N),w9 => d14_in(N-1 downto 0 ),d_out => d14_out,en_out =>open  ,sof_out=>open   );
CL15: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d15_in(9*N-1 downto 8*N),data2conv2 =>d15_in(8*N-1 downto 7*N),data2conv3 =>d15_in(7*N-1 downto 6*N),data2conv4 =>d15_in(6*N-1 downto 5*N),data2conv5 =>d15_in(5*N-1 downto 4*N),data2conv6 =>d15_in(4*N-1 downto 3*N),data2conv7 =>d15_in(3*N-1 downto 2*N),data2conv8 =>d15_in(2*N-1 downto N),data2conv9 =>d15_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d15_in(9*N-1 downto 8*N),w2 => d15_in(8*N-1 downto 7*N),w3 => d15_in(7*N-1 downto 6*N),w4 => d15_in(6*N-1 downto 5*N),w5 => d15_in(5*N-1 downto 4*N),w6 => d15_in(4*N-1 downto 3*N),w7 => d15_in(3*N-1 downto 2*N),w8 => d15_in(2*N-1 downto N),w9 => d15_in(N-1 downto 0 ),d_out => d15_out,en_out =>open  ,sof_out=>open   );
CL16: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d16_in(9*N-1 downto 8*N),data2conv2 =>d16_in(8*N-1 downto 7*N),data2conv3 =>d16_in(7*N-1 downto 6*N),data2conv4 =>d16_in(6*N-1 downto 5*N),data2conv5 =>d16_in(5*N-1 downto 4*N),data2conv6 =>d16_in(4*N-1 downto 3*N),data2conv7 =>d16_in(3*N-1 downto 2*N),data2conv8 =>d16_in(2*N-1 downto N),data2conv9 =>d16_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d16_in(9*N-1 downto 8*N),w2 => d16_in(8*N-1 downto 7*N),w3 => d16_in(7*N-1 downto 6*N),w4 => d16_in(6*N-1 downto 5*N),w5 => d16_in(5*N-1 downto 4*N),w6 => d16_in(4*N-1 downto 3*N),w7 => d16_in(3*N-1 downto 2*N),w8 => d16_in(2*N-1 downto N),w9 => d16_in(N-1 downto 0 ),d_out => d16_out,en_out =>open  ,sof_out=>open   );
CL17: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d17_in(9*N-1 downto 8*N),data2conv2 =>d17_in(8*N-1 downto 7*N),data2conv3 =>d17_in(7*N-1 downto 6*N),data2conv4 =>d17_in(6*N-1 downto 5*N),data2conv5 =>d17_in(5*N-1 downto 4*N),data2conv6 =>d17_in(4*N-1 downto 3*N),data2conv7 =>d17_in(3*N-1 downto 2*N),data2conv8 =>d17_in(2*N-1 downto N),data2conv9 =>d17_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d17_in(9*N-1 downto 8*N),w2 => d17_in(8*N-1 downto 7*N),w3 => d17_in(7*N-1 downto 6*N),w4 => d17_in(6*N-1 downto 5*N),w5 => d17_in(5*N-1 downto 4*N),w6 => d17_in(4*N-1 downto 3*N),w7 => d17_in(3*N-1 downto 2*N),w8 => d17_in(2*N-1 downto N),w9 => d17_in(N-1 downto 0 ),d_out => d17_out,en_out =>open  ,sof_out=>open   );
CL18: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d18_in(9*N-1 downto 8*N),data2conv2 =>d18_in(8*N-1 downto 7*N),data2conv3 =>d18_in(7*N-1 downto 6*N),data2conv4 =>d18_in(6*N-1 downto 5*N),data2conv5 =>d18_in(5*N-1 downto 4*N),data2conv6 =>d18_in(4*N-1 downto 3*N),data2conv7 =>d18_in(3*N-1 downto 2*N),data2conv8 =>d18_in(2*N-1 downto N),data2conv9 =>d18_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d18_in(9*N-1 downto 8*N),w2 => d18_in(8*N-1 downto 7*N),w3 => d18_in(7*N-1 downto 6*N),w4 => d18_in(6*N-1 downto 5*N),w5 => d18_in(5*N-1 downto 4*N),w6 => d18_in(4*N-1 downto 3*N),w7 => d18_in(3*N-1 downto 2*N),w8 => d18_in(2*N-1 downto N),w9 => d18_in(N-1 downto 0 ),d_out => d18_out,en_out =>open  ,sof_out=>open   );
CL19: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d19_in(9*N-1 downto 8*N),data2conv2 =>d19_in(8*N-1 downto 7*N),data2conv3 =>d19_in(7*N-1 downto 6*N),data2conv4 =>d19_in(6*N-1 downto 5*N),data2conv5 =>d19_in(5*N-1 downto 4*N),data2conv6 =>d19_in(4*N-1 downto 3*N),data2conv7 =>d19_in(3*N-1 downto 2*N),data2conv8 =>d19_in(2*N-1 downto N),data2conv9 =>d19_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d19_in(9*N-1 downto 8*N),w2 => d19_in(8*N-1 downto 7*N),w3 => d19_in(7*N-1 downto 6*N),w4 => d19_in(6*N-1 downto 5*N),w5 => d19_in(5*N-1 downto 4*N),w6 => d19_in(4*N-1 downto 3*N),w7 => d19_in(3*N-1 downto 2*N),w8 => d19_in(2*N-1 downto N),w9 => d19_in(N-1 downto 0 ),d_out => d19_out,en_out =>open  ,sof_out=>open   );
CL20: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d20_in(9*N-1 downto 8*N),data2conv2 =>d20_in(8*N-1 downto 7*N),data2conv3 =>d20_in(7*N-1 downto 6*N),data2conv4 =>d20_in(6*N-1 downto 5*N),data2conv5 =>d20_in(5*N-1 downto 4*N),data2conv6 =>d20_in(4*N-1 downto 3*N),data2conv7 =>d20_in(3*N-1 downto 2*N),data2conv8 =>d20_in(2*N-1 downto N),data2conv9 =>d20_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d20_in(9*N-1 downto 8*N),w2 => d20_in(8*N-1 downto 7*N),w3 => d20_in(7*N-1 downto 6*N),w4 => d20_in(6*N-1 downto 5*N),w5 => d20_in(5*N-1 downto 4*N),w6 => d20_in(4*N-1 downto 3*N),w7 => d20_in(3*N-1 downto 2*N),w8 => d20_in(2*N-1 downto N),w9 => d20_in(N-1 downto 0 ),d_out => d20_out,en_out =>open  ,sof_out=>open   );
CL21: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d21_in(9*N-1 downto 8*N),data2conv2 =>d21_in(8*N-1 downto 7*N),data2conv3 =>d21_in(7*N-1 downto 6*N),data2conv4 =>d21_in(6*N-1 downto 5*N),data2conv5 =>d21_in(5*N-1 downto 4*N),data2conv6 =>d21_in(4*N-1 downto 3*N),data2conv7 =>d21_in(3*N-1 downto 2*N),data2conv8 =>d21_in(2*N-1 downto N),data2conv9 =>d21_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d21_in(9*N-1 downto 8*N),w2 => d21_in(8*N-1 downto 7*N),w3 => d21_in(7*N-1 downto 6*N),w4 => d21_in(6*N-1 downto 5*N),w5 => d21_in(5*N-1 downto 4*N),w6 => d21_in(4*N-1 downto 3*N),w7 => d21_in(3*N-1 downto 2*N),w8 => d21_in(2*N-1 downto N),w9 => d21_in(N-1 downto 0 ),d_out => d21_out,en_out =>open  ,sof_out=>open   );
CL22: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d22_in(9*N-1 downto 8*N),data2conv2 =>d22_in(8*N-1 downto 7*N),data2conv3 =>d22_in(7*N-1 downto 6*N),data2conv4 =>d22_in(6*N-1 downto 5*N),data2conv5 =>d22_in(5*N-1 downto 4*N),data2conv6 =>d22_in(4*N-1 downto 3*N),data2conv7 =>d22_in(3*N-1 downto 2*N),data2conv8 =>d22_in(2*N-1 downto N),data2conv9 =>d22_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d22_in(9*N-1 downto 8*N),w2 => d22_in(8*N-1 downto 7*N),w3 => d22_in(7*N-1 downto 6*N),w4 => d22_in(6*N-1 downto 5*N),w5 => d22_in(5*N-1 downto 4*N),w6 => d22_in(4*N-1 downto 3*N),w7 => d22_in(3*N-1 downto 2*N),w8 => d22_in(2*N-1 downto N),w9 => d22_in(N-1 downto 0 ),d_out => d22_out,en_out =>open  ,sof_out=>open   );
CL23: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d23_in(9*N-1 downto 8*N),data2conv2 =>d23_in(8*N-1 downto 7*N),data2conv3 =>d23_in(7*N-1 downto 6*N),data2conv4 =>d23_in(6*N-1 downto 5*N),data2conv5 =>d23_in(5*N-1 downto 4*N),data2conv6 =>d23_in(4*N-1 downto 3*N),data2conv7 =>d23_in(3*N-1 downto 2*N),data2conv8 =>d23_in(2*N-1 downto N),data2conv9 =>d23_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d23_in(9*N-1 downto 8*N),w2 => d23_in(8*N-1 downto 7*N),w3 => d23_in(7*N-1 downto 6*N),w4 => d23_in(6*N-1 downto 5*N),w5 => d23_in(5*N-1 downto 4*N),w6 => d23_in(4*N-1 downto 3*N),w7 => d23_in(3*N-1 downto 2*N),w8 => d23_in(2*N-1 downto N),w9 => d23_in(N-1 downto 0 ),d_out => d23_out,en_out =>open  ,sof_out=>open   );
CL24: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d24_in(9*N-1 downto 8*N),data2conv2 =>d24_in(8*N-1 downto 7*N),data2conv3 =>d24_in(7*N-1 downto 6*N),data2conv4 =>d24_in(6*N-1 downto 5*N),data2conv5 =>d24_in(5*N-1 downto 4*N),data2conv6 =>d24_in(4*N-1 downto 3*N),data2conv7 =>d24_in(3*N-1 downto 2*N),data2conv8 =>d24_in(2*N-1 downto N),data2conv9 =>d24_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d24_in(9*N-1 downto 8*N),w2 => d24_in(8*N-1 downto 7*N),w3 => d24_in(7*N-1 downto 6*N),w4 => d24_in(6*N-1 downto 5*N),w5 => d24_in(5*N-1 downto 4*N),w6 => d24_in(4*N-1 downto 3*N),w7 => d24_in(3*N-1 downto 2*N),w8 => d24_in(2*N-1 downto N),w9 => d24_in(N-1 downto 0 ),d_out => d24_out,en_out =>open  ,sof_out=>open   );
CL25: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d25_in(9*N-1 downto 8*N),data2conv2 =>d25_in(8*N-1 downto 7*N),data2conv3 =>d25_in(7*N-1 downto 6*N),data2conv4 =>d25_in(6*N-1 downto 5*N),data2conv5 =>d25_in(5*N-1 downto 4*N),data2conv6 =>d25_in(4*N-1 downto 3*N),data2conv7 =>d25_in(3*N-1 downto 2*N),data2conv8 =>d25_in(2*N-1 downto N),data2conv9 =>d25_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d25_in(9*N-1 downto 8*N),w2 => d25_in(8*N-1 downto 7*N),w3 => d25_in(7*N-1 downto 6*N),w4 => d25_in(6*N-1 downto 5*N),w5 => d25_in(5*N-1 downto 4*N),w6 => d25_in(4*N-1 downto 3*N),w7 => d25_in(3*N-1 downto 2*N),w8 => d25_in(2*N-1 downto N),w9 => d25_in(N-1 downto 0 ),d_out => d25_out,en_out =>open  ,sof_out=>open   );
CL26: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d26_in(9*N-1 downto 8*N),data2conv2 =>d26_in(8*N-1 downto 7*N),data2conv3 =>d26_in(7*N-1 downto 6*N),data2conv4 =>d26_in(6*N-1 downto 5*N),data2conv5 =>d26_in(5*N-1 downto 4*N),data2conv6 =>d26_in(4*N-1 downto 3*N),data2conv7 =>d26_in(3*N-1 downto 2*N),data2conv8 =>d26_in(2*N-1 downto N),data2conv9 =>d26_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d26_in(9*N-1 downto 8*N),w2 => d26_in(8*N-1 downto 7*N),w3 => d26_in(7*N-1 downto 6*N),w4 => d26_in(6*N-1 downto 5*N),w5 => d26_in(5*N-1 downto 4*N),w6 => d26_in(4*N-1 downto 3*N),w7 => d26_in(3*N-1 downto 2*N),w8 => d26_in(2*N-1 downto N),w9 => d26_in(N-1 downto 0 ),d_out => d26_out,en_out =>open  ,sof_out=>open   );
CL27: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d27_in(9*N-1 downto 8*N),data2conv2 =>d27_in(8*N-1 downto 7*N),data2conv3 =>d27_in(7*N-1 downto 6*N),data2conv4 =>d27_in(6*N-1 downto 5*N),data2conv5 =>d27_in(5*N-1 downto 4*N),data2conv6 =>d27_in(4*N-1 downto 3*N),data2conv7 =>d27_in(3*N-1 downto 2*N),data2conv8 =>d27_in(2*N-1 downto N),data2conv9 =>d27_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d27_in(9*N-1 downto 8*N),w2 => d27_in(8*N-1 downto 7*N),w3 => d27_in(7*N-1 downto 6*N),w4 => d27_in(6*N-1 downto 5*N),w5 => d27_in(5*N-1 downto 4*N),w6 => d27_in(4*N-1 downto 3*N),w7 => d27_in(3*N-1 downto 2*N),w8 => d27_in(2*N-1 downto N),w9 => d27_in(N-1 downto 0 ),d_out => d27_out,en_out =>open  ,sof_out=>open   );
CL28: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d28_in(9*N-1 downto 8*N),data2conv2 =>d28_in(8*N-1 downto 7*N),data2conv3 =>d28_in(7*N-1 downto 6*N),data2conv4 =>d28_in(6*N-1 downto 5*N),data2conv5 =>d28_in(5*N-1 downto 4*N),data2conv6 =>d28_in(4*N-1 downto 3*N),data2conv7 =>d28_in(3*N-1 downto 2*N),data2conv8 =>d28_in(2*N-1 downto N),data2conv9 =>d28_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d28_in(9*N-1 downto 8*N),w2 => d28_in(8*N-1 downto 7*N),w3 => d28_in(7*N-1 downto 6*N),w4 => d28_in(6*N-1 downto 5*N),w5 => d28_in(5*N-1 downto 4*N),w6 => d28_in(4*N-1 downto 3*N),w7 => d28_in(3*N-1 downto 2*N),w8 => d28_in(2*N-1 downto N),w9 => d28_in(N-1 downto 0 ),d_out => d28_out,en_out =>open  ,sof_out=>open   );
CL29: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d29_in(9*N-1 downto 8*N),data2conv2 =>d29_in(8*N-1 downto 7*N),data2conv3 =>d29_in(7*N-1 downto 6*N),data2conv4 =>d29_in(6*N-1 downto 5*N),data2conv5 =>d29_in(5*N-1 downto 4*N),data2conv6 =>d29_in(4*N-1 downto 3*N),data2conv7 =>d29_in(3*N-1 downto 2*N),data2conv8 =>d29_in(2*N-1 downto N),data2conv9 =>d29_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d29_in(9*N-1 downto 8*N),w2 => d29_in(8*N-1 downto 7*N),w3 => d29_in(7*N-1 downto 6*N),w4 => d29_in(6*N-1 downto 5*N),w5 => d29_in(5*N-1 downto 4*N),w6 => d29_in(4*N-1 downto 3*N),w7 => d29_in(3*N-1 downto 2*N),w8 => d29_in(2*N-1 downto N),w9 => d29_in(N-1 downto 0 ),d_out => d29_out,en_out =>open  ,sof_out=>open   );
CL30: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d30_in(9*N-1 downto 8*N),data2conv2 =>d30_in(8*N-1 downto 7*N),data2conv3 =>d30_in(7*N-1 downto 6*N),data2conv4 =>d30_in(6*N-1 downto 5*N),data2conv5 =>d30_in(5*N-1 downto 4*N),data2conv6 =>d30_in(4*N-1 downto 3*N),data2conv7 =>d30_in(3*N-1 downto 2*N),data2conv8 =>d30_in(2*N-1 downto N),data2conv9 =>d30_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d30_in(9*N-1 downto 8*N),w2 => d30_in(8*N-1 downto 7*N),w3 => d30_in(7*N-1 downto 6*N),w4 => d30_in(6*N-1 downto 5*N),w5 => d30_in(5*N-1 downto 4*N),w6 => d30_in(4*N-1 downto 3*N),w7 => d30_in(3*N-1 downto 2*N),w8 => d30_in(2*N-1 downto N),w9 => d30_in(N-1 downto 0 ),d_out => d30_out,en_out =>open  ,sof_out=>open   );
CL31: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d31_in(9*N-1 downto 8*N),data2conv2 =>d31_in(8*N-1 downto 7*N),data2conv3 =>d31_in(7*N-1 downto 6*N),data2conv4 =>d31_in(6*N-1 downto 5*N),data2conv5 =>d31_in(5*N-1 downto 4*N),data2conv6 =>d31_in(4*N-1 downto 3*N),data2conv7 =>d31_in(3*N-1 downto 2*N),data2conv8 =>d31_in(2*N-1 downto N),data2conv9 =>d31_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d31_in(9*N-1 downto 8*N),w2 => d31_in(8*N-1 downto 7*N),w3 => d31_in(7*N-1 downto 6*N),w4 => d31_in(6*N-1 downto 5*N),w5 => d31_in(5*N-1 downto 4*N),w6 => d31_in(4*N-1 downto 3*N),w7 => d31_in(3*N-1 downto 2*N),w8 => d31_in(2*N-1 downto N),w9 => d31_in(N-1 downto 0 ),d_out => d31_out,en_out =>open  ,sof_out=>open   );
CL32: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d32_in(9*N-1 downto 8*N),data2conv2 =>d32_in(8*N-1 downto 7*N),data2conv3 =>d32_in(7*N-1 downto 6*N),data2conv4 =>d32_in(6*N-1 downto 5*N),data2conv5 =>d32_in(5*N-1 downto 4*N),data2conv6 =>d32_in(4*N-1 downto 3*N),data2conv7 =>d32_in(3*N-1 downto 2*N),data2conv8 =>d32_in(2*N-1 downto N),data2conv9 =>d32_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d32_in(9*N-1 downto 8*N),w2 => d32_in(8*N-1 downto 7*N),w3 => d32_in(7*N-1 downto 6*N),w4 => d32_in(6*N-1 downto 5*N),w5 => d32_in(5*N-1 downto 4*N),w6 => d32_in(4*N-1 downto 3*N),w7 => d32_in(3*N-1 downto 2*N),w8 => d32_in(2*N-1 downto N),w9 => d32_in(N-1 downto 0 ),d_out => d32_out,en_out =>open  ,sof_out=>open   );
CL33: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d33_in(9*N-1 downto 8*N),data2conv2 =>d33_in(8*N-1 downto 7*N),data2conv3 =>d33_in(7*N-1 downto 6*N),data2conv4 =>d33_in(6*N-1 downto 5*N),data2conv5 =>d33_in(5*N-1 downto 4*N),data2conv6 =>d33_in(4*N-1 downto 3*N),data2conv7 =>d33_in(3*N-1 downto 2*N),data2conv8 =>d33_in(2*N-1 downto N),data2conv9 =>d33_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d33_in(9*N-1 downto 8*N),w2 => d33_in(8*N-1 downto 7*N),w3 => d33_in(7*N-1 downto 6*N),w4 => d33_in(6*N-1 downto 5*N),w5 => d33_in(5*N-1 downto 4*N),w6 => d33_in(4*N-1 downto 3*N),w7 => d33_in(3*N-1 downto 2*N),w8 => d33_in(2*N-1 downto N),w9 => d33_in(N-1 downto 0 ),d_out => d33_out,en_out =>open  ,sof_out=>open   );
CL34: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d34_in(9*N-1 downto 8*N),data2conv2 =>d34_in(8*N-1 downto 7*N),data2conv3 =>d34_in(7*N-1 downto 6*N),data2conv4 =>d34_in(6*N-1 downto 5*N),data2conv5 =>d34_in(5*N-1 downto 4*N),data2conv6 =>d34_in(4*N-1 downto 3*N),data2conv7 =>d34_in(3*N-1 downto 2*N),data2conv8 =>d34_in(2*N-1 downto N),data2conv9 =>d34_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d34_in(9*N-1 downto 8*N),w2 => d34_in(8*N-1 downto 7*N),w3 => d34_in(7*N-1 downto 6*N),w4 => d34_in(6*N-1 downto 5*N),w5 => d34_in(5*N-1 downto 4*N),w6 => d34_in(4*N-1 downto 3*N),w7 => d34_in(3*N-1 downto 2*N),w8 => d34_in(2*N-1 downto N),w9 => d34_in(N-1 downto 0 ),d_out => d34_out,en_out =>open  ,sof_out=>open   );
CL35: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d35_in(9*N-1 downto 8*N),data2conv2 =>d35_in(8*N-1 downto 7*N),data2conv3 =>d35_in(7*N-1 downto 6*N),data2conv4 =>d35_in(6*N-1 downto 5*N),data2conv5 =>d35_in(5*N-1 downto 4*N),data2conv6 =>d35_in(4*N-1 downto 3*N),data2conv7 =>d35_in(3*N-1 downto 2*N),data2conv8 =>d35_in(2*N-1 downto N),data2conv9 =>d35_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d35_in(9*N-1 downto 8*N),w2 => d35_in(8*N-1 downto 7*N),w3 => d35_in(7*N-1 downto 6*N),w4 => d35_in(6*N-1 downto 5*N),w5 => d35_in(5*N-1 downto 4*N),w6 => d35_in(4*N-1 downto 3*N),w7 => d35_in(3*N-1 downto 2*N),w8 => d35_in(2*N-1 downto N),w9 => d35_in(N-1 downto 0 ),d_out => d35_out,en_out =>open  ,sof_out=>open   );
CL36: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d36_in(9*N-1 downto 8*N),data2conv2 =>d36_in(8*N-1 downto 7*N),data2conv3 =>d36_in(7*N-1 downto 6*N),data2conv4 =>d36_in(6*N-1 downto 5*N),data2conv5 =>d36_in(5*N-1 downto 4*N),data2conv6 =>d36_in(4*N-1 downto 3*N),data2conv7 =>d36_in(3*N-1 downto 2*N),data2conv8 =>d36_in(2*N-1 downto N),data2conv9 =>d36_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d36_in(9*N-1 downto 8*N),w2 => d36_in(8*N-1 downto 7*N),w3 => d36_in(7*N-1 downto 6*N),w4 => d36_in(6*N-1 downto 5*N),w5 => d36_in(5*N-1 downto 4*N),w6 => d36_in(4*N-1 downto 3*N),w7 => d36_in(3*N-1 downto 2*N),w8 => d36_in(2*N-1 downto N),w9 => d36_in(N-1 downto 0 ),d_out => d36_out,en_out =>open  ,sof_out=>open   );
CL37: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d37_in(9*N-1 downto 8*N),data2conv2 =>d37_in(8*N-1 downto 7*N),data2conv3 =>d37_in(7*N-1 downto 6*N),data2conv4 =>d37_in(6*N-1 downto 5*N),data2conv5 =>d37_in(5*N-1 downto 4*N),data2conv6 =>d37_in(4*N-1 downto 3*N),data2conv7 =>d37_in(3*N-1 downto 2*N),data2conv8 =>d37_in(2*N-1 downto N),data2conv9 =>d37_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d37_in(9*N-1 downto 8*N),w2 => d37_in(8*N-1 downto 7*N),w3 => d37_in(7*N-1 downto 6*N),w4 => d37_in(6*N-1 downto 5*N),w5 => d37_in(5*N-1 downto 4*N),w6 => d37_in(4*N-1 downto 3*N),w7 => d37_in(3*N-1 downto 2*N),w8 => d37_in(2*N-1 downto N),w9 => d37_in(N-1 downto 0 ),d_out => d37_out,en_out =>open  ,sof_out=>open   );
CL38: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d38_in(9*N-1 downto 8*N),data2conv2 =>d38_in(8*N-1 downto 7*N),data2conv3 =>d38_in(7*N-1 downto 6*N),data2conv4 =>d38_in(6*N-1 downto 5*N),data2conv5 =>d38_in(5*N-1 downto 4*N),data2conv6 =>d38_in(4*N-1 downto 3*N),data2conv7 =>d38_in(3*N-1 downto 2*N),data2conv8 =>d38_in(2*N-1 downto N),data2conv9 =>d38_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d38_in(9*N-1 downto 8*N),w2 => d38_in(8*N-1 downto 7*N),w3 => d38_in(7*N-1 downto 6*N),w4 => d38_in(6*N-1 downto 5*N),w5 => d38_in(5*N-1 downto 4*N),w6 => d38_in(4*N-1 downto 3*N),w7 => d38_in(3*N-1 downto 2*N),w8 => d38_in(2*N-1 downto N),w9 => d38_in(N-1 downto 0 ),d_out => d38_out,en_out =>open  ,sof_out=>open   );
CL39: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d39_in(9*N-1 downto 8*N),data2conv2 =>d39_in(8*N-1 downto 7*N),data2conv3 =>d39_in(7*N-1 downto 6*N),data2conv4 =>d39_in(6*N-1 downto 5*N),data2conv5 =>d39_in(5*N-1 downto 4*N),data2conv6 =>d39_in(4*N-1 downto 3*N),data2conv7 =>d39_in(3*N-1 downto 2*N),data2conv8 =>d39_in(2*N-1 downto N),data2conv9 =>d39_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d39_in(9*N-1 downto 8*N),w2 => d39_in(8*N-1 downto 7*N),w3 => d39_in(7*N-1 downto 6*N),w4 => d39_in(6*N-1 downto 5*N),w5 => d39_in(5*N-1 downto 4*N),w6 => d39_in(4*N-1 downto 3*N),w7 => d39_in(3*N-1 downto 2*N),w8 => d39_in(2*N-1 downto N),w9 => d39_in(N-1 downto 0 ),d_out => d39_out,en_out =>open  ,sof_out=>open   );
CL40: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d40_in(9*N-1 downto 8*N),data2conv2 =>d40_in(8*N-1 downto 7*N),data2conv3 =>d40_in(7*N-1 downto 6*N),data2conv4 =>d40_in(6*N-1 downto 5*N),data2conv5 =>d40_in(5*N-1 downto 4*N),data2conv6 =>d40_in(4*N-1 downto 3*N),data2conv7 =>d40_in(3*N-1 downto 2*N),data2conv8 =>d40_in(2*N-1 downto N),data2conv9 =>d40_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d40_in(9*N-1 downto 8*N),w2 => d40_in(8*N-1 downto 7*N),w3 => d40_in(7*N-1 downto 6*N),w4 => d40_in(6*N-1 downto 5*N),w5 => d40_in(5*N-1 downto 4*N),w6 => d40_in(4*N-1 downto 3*N),w7 => d40_in(3*N-1 downto 2*N),w8 => d40_in(2*N-1 downto N),w9 => d40_in(N-1 downto 0 ),d_out => d40_out,en_out =>open  ,sof_out=>open   );
CL41: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d41_in(9*N-1 downto 8*N),data2conv2 =>d41_in(8*N-1 downto 7*N),data2conv3 =>d41_in(7*N-1 downto 6*N),data2conv4 =>d41_in(6*N-1 downto 5*N),data2conv5 =>d41_in(5*N-1 downto 4*N),data2conv6 =>d41_in(4*N-1 downto 3*N),data2conv7 =>d41_in(3*N-1 downto 2*N),data2conv8 =>d41_in(2*N-1 downto N),data2conv9 =>d41_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d41_in(9*N-1 downto 8*N),w2 => d41_in(8*N-1 downto 7*N),w3 => d41_in(7*N-1 downto 6*N),w4 => d41_in(6*N-1 downto 5*N),w5 => d41_in(5*N-1 downto 4*N),w6 => d41_in(4*N-1 downto 3*N),w7 => d41_in(3*N-1 downto 2*N),w8 => d41_in(2*N-1 downto N),w9 => d41_in(N-1 downto 0 ),d_out => d41_out,en_out =>open  ,sof_out=>open   );
CL42: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d42_in(9*N-1 downto 8*N),data2conv2 =>d42_in(8*N-1 downto 7*N),data2conv3 =>d42_in(7*N-1 downto 6*N),data2conv4 =>d42_in(6*N-1 downto 5*N),data2conv5 =>d42_in(5*N-1 downto 4*N),data2conv6 =>d42_in(4*N-1 downto 3*N),data2conv7 =>d42_in(3*N-1 downto 2*N),data2conv8 =>d42_in(2*N-1 downto N),data2conv9 =>d42_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d42_in(9*N-1 downto 8*N),w2 => d42_in(8*N-1 downto 7*N),w3 => d42_in(7*N-1 downto 6*N),w4 => d42_in(6*N-1 downto 5*N),w5 => d42_in(5*N-1 downto 4*N),w6 => d42_in(4*N-1 downto 3*N),w7 => d42_in(3*N-1 downto 2*N),w8 => d42_in(2*N-1 downto N),w9 => d42_in(N-1 downto 0 ),d_out => d42_out,en_out =>open  ,sof_out=>open   );
CL43: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d43_in(9*N-1 downto 8*N),data2conv2 =>d43_in(8*N-1 downto 7*N),data2conv3 =>d43_in(7*N-1 downto 6*N),data2conv4 =>d43_in(6*N-1 downto 5*N),data2conv5 =>d43_in(5*N-1 downto 4*N),data2conv6 =>d43_in(4*N-1 downto 3*N),data2conv7 =>d43_in(3*N-1 downto 2*N),data2conv8 =>d43_in(2*N-1 downto N),data2conv9 =>d43_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d43_in(9*N-1 downto 8*N),w2 => d43_in(8*N-1 downto 7*N),w3 => d43_in(7*N-1 downto 6*N),w4 => d43_in(6*N-1 downto 5*N),w5 => d43_in(5*N-1 downto 4*N),w6 => d43_in(4*N-1 downto 3*N),w7 => d43_in(3*N-1 downto 2*N),w8 => d43_in(2*N-1 downto N),w9 => d43_in(N-1 downto 0 ),d_out => d43_out,en_out =>open  ,sof_out=>open   );
CL44: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d44_in(9*N-1 downto 8*N),data2conv2 =>d44_in(8*N-1 downto 7*N),data2conv3 =>d44_in(7*N-1 downto 6*N),data2conv4 =>d44_in(6*N-1 downto 5*N),data2conv5 =>d44_in(5*N-1 downto 4*N),data2conv6 =>d44_in(4*N-1 downto 3*N),data2conv7 =>d44_in(3*N-1 downto 2*N),data2conv8 =>d44_in(2*N-1 downto N),data2conv9 =>d44_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d44_in(9*N-1 downto 8*N),w2 => d44_in(8*N-1 downto 7*N),w3 => d44_in(7*N-1 downto 6*N),w4 => d44_in(6*N-1 downto 5*N),w5 => d44_in(5*N-1 downto 4*N),w6 => d44_in(4*N-1 downto 3*N),w7 => d44_in(3*N-1 downto 2*N),w8 => d44_in(2*N-1 downto N),w9 => d44_in(N-1 downto 0 ),d_out => d44_out,en_out =>open  ,sof_out=>open   );
CL45: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d45_in(9*N-1 downto 8*N),data2conv2 =>d45_in(8*N-1 downto 7*N),data2conv3 =>d45_in(7*N-1 downto 6*N),data2conv4 =>d45_in(6*N-1 downto 5*N),data2conv5 =>d45_in(5*N-1 downto 4*N),data2conv6 =>d45_in(4*N-1 downto 3*N),data2conv7 =>d45_in(3*N-1 downto 2*N),data2conv8 =>d45_in(2*N-1 downto N),data2conv9 =>d45_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d45_in(9*N-1 downto 8*N),w2 => d45_in(8*N-1 downto 7*N),w3 => d45_in(7*N-1 downto 6*N),w4 => d45_in(6*N-1 downto 5*N),w5 => d45_in(5*N-1 downto 4*N),w6 => d45_in(4*N-1 downto 3*N),w7 => d45_in(3*N-1 downto 2*N),w8 => d45_in(2*N-1 downto N),w9 => d45_in(N-1 downto 0 ),d_out => d45_out,en_out =>open  ,sof_out=>open   );
CL46: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d46_in(9*N-1 downto 8*N),data2conv2 =>d46_in(8*N-1 downto 7*N),data2conv3 =>d46_in(7*N-1 downto 6*N),data2conv4 =>d46_in(6*N-1 downto 5*N),data2conv5 =>d46_in(5*N-1 downto 4*N),data2conv6 =>d46_in(4*N-1 downto 3*N),data2conv7 =>d46_in(3*N-1 downto 2*N),data2conv8 =>d46_in(2*N-1 downto N),data2conv9 =>d46_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d46_in(9*N-1 downto 8*N),w2 => d46_in(8*N-1 downto 7*N),w3 => d46_in(7*N-1 downto 6*N),w4 => d46_in(6*N-1 downto 5*N),w5 => d46_in(5*N-1 downto 4*N),w6 => d46_in(4*N-1 downto 3*N),w7 => d46_in(3*N-1 downto 2*N),w8 => d46_in(2*N-1 downto N),w9 => d46_in(N-1 downto 0 ),d_out => d46_out,en_out =>open  ,sof_out=>open   );
CL47: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d47_in(9*N-1 downto 8*N),data2conv2 =>d47_in(8*N-1 downto 7*N),data2conv3 =>d47_in(7*N-1 downto 6*N),data2conv4 =>d47_in(6*N-1 downto 5*N),data2conv5 =>d47_in(5*N-1 downto 4*N),data2conv6 =>d47_in(4*N-1 downto 3*N),data2conv7 =>d47_in(3*N-1 downto 2*N),data2conv8 =>d47_in(2*N-1 downto N),data2conv9 =>d47_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d47_in(9*N-1 downto 8*N),w2 => d47_in(8*N-1 downto 7*N),w3 => d47_in(7*N-1 downto 6*N),w4 => d47_in(6*N-1 downto 5*N),w5 => d47_in(5*N-1 downto 4*N),w6 => d47_in(4*N-1 downto 3*N),w7 => d47_in(3*N-1 downto 2*N),w8 => d47_in(2*N-1 downto N),w9 => d47_in(N-1 downto 0 ),d_out => d47_out,en_out =>open  ,sof_out=>open   );
CL48: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d48_in(9*N-1 downto 8*N),data2conv2 =>d48_in(8*N-1 downto 7*N),data2conv3 =>d48_in(7*N-1 downto 6*N),data2conv4 =>d48_in(6*N-1 downto 5*N),data2conv5 =>d48_in(5*N-1 downto 4*N),data2conv6 =>d48_in(4*N-1 downto 3*N),data2conv7 =>d48_in(3*N-1 downto 2*N),data2conv8 =>d48_in(2*N-1 downto N),data2conv9 =>d48_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d48_in(9*N-1 downto 8*N),w2 => d48_in(8*N-1 downto 7*N),w3 => d48_in(7*N-1 downto 6*N),w4 => d48_in(6*N-1 downto 5*N),w5 => d48_in(5*N-1 downto 4*N),w6 => d48_in(4*N-1 downto 3*N),w7 => d48_in(3*N-1 downto 2*N),w8 => d48_in(2*N-1 downto N),w9 => d48_in(N-1 downto 0 ),d_out => d48_out,en_out =>open  ,sof_out=>open   );
CL49: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d49_in(9*N-1 downto 8*N),data2conv2 =>d49_in(8*N-1 downto 7*N),data2conv3 =>d49_in(7*N-1 downto 6*N),data2conv4 =>d49_in(6*N-1 downto 5*N),data2conv5 =>d49_in(5*N-1 downto 4*N),data2conv6 =>d49_in(4*N-1 downto 3*N),data2conv7 =>d49_in(3*N-1 downto 2*N),data2conv8 =>d49_in(2*N-1 downto N),data2conv9 =>d49_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d49_in(9*N-1 downto 8*N),w2 => d49_in(8*N-1 downto 7*N),w3 => d49_in(7*N-1 downto 6*N),w4 => d49_in(6*N-1 downto 5*N),w5 => d49_in(5*N-1 downto 4*N),w6 => d49_in(4*N-1 downto 3*N),w7 => d49_in(3*N-1 downto 2*N),w8 => d49_in(2*N-1 downto N),w9 => d49_in(N-1 downto 0 ),d_out => d49_out,en_out =>open  ,sof_out=>open   );
CL50: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d50_in(9*N-1 downto 8*N),data2conv2 =>d50_in(8*N-1 downto 7*N),data2conv3 =>d50_in(7*N-1 downto 6*N),data2conv4 =>d50_in(6*N-1 downto 5*N),data2conv5 =>d50_in(5*N-1 downto 4*N),data2conv6 =>d50_in(4*N-1 downto 3*N),data2conv7 =>d50_in(3*N-1 downto 2*N),data2conv8 =>d50_in(2*N-1 downto N),data2conv9 =>d50_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d50_in(9*N-1 downto 8*N),w2 => d50_in(8*N-1 downto 7*N),w3 => d50_in(7*N-1 downto 6*N),w4 => d50_in(6*N-1 downto 5*N),w5 => d50_in(5*N-1 downto 4*N),w6 => d50_in(4*N-1 downto 3*N),w7 => d50_in(3*N-1 downto 2*N),w8 => d50_in(2*N-1 downto N),w9 => d50_in(N-1 downto 0 ),d_out => d50_out,en_out =>open  ,sof_out=>open   );
CL51: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d51_in(9*N-1 downto 8*N),data2conv2 =>d51_in(8*N-1 downto 7*N),data2conv3 =>d51_in(7*N-1 downto 6*N),data2conv4 =>d51_in(6*N-1 downto 5*N),data2conv5 =>d51_in(5*N-1 downto 4*N),data2conv6 =>d51_in(4*N-1 downto 3*N),data2conv7 =>d51_in(3*N-1 downto 2*N),data2conv8 =>d51_in(2*N-1 downto N),data2conv9 =>d51_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d51_in(9*N-1 downto 8*N),w2 => d51_in(8*N-1 downto 7*N),w3 => d51_in(7*N-1 downto 6*N),w4 => d51_in(6*N-1 downto 5*N),w5 => d51_in(5*N-1 downto 4*N),w6 => d51_in(4*N-1 downto 3*N),w7 => d51_in(3*N-1 downto 2*N),w8 => d51_in(2*N-1 downto N),w9 => d51_in(N-1 downto 0 ),d_out => d51_out,en_out =>open  ,sof_out=>open   );
CL52: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d52_in(9*N-1 downto 8*N),data2conv2 =>d52_in(8*N-1 downto 7*N),data2conv3 =>d52_in(7*N-1 downto 6*N),data2conv4 =>d52_in(6*N-1 downto 5*N),data2conv5 =>d52_in(5*N-1 downto 4*N),data2conv6 =>d52_in(4*N-1 downto 3*N),data2conv7 =>d52_in(3*N-1 downto 2*N),data2conv8 =>d52_in(2*N-1 downto N),data2conv9 =>d52_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d52_in(9*N-1 downto 8*N),w2 => d52_in(8*N-1 downto 7*N),w3 => d52_in(7*N-1 downto 6*N),w4 => d52_in(6*N-1 downto 5*N),w5 => d52_in(5*N-1 downto 4*N),w6 => d52_in(4*N-1 downto 3*N),w7 => d52_in(3*N-1 downto 2*N),w8 => d52_in(2*N-1 downto N),w9 => d52_in(N-1 downto 0 ),d_out => d52_out,en_out =>open  ,sof_out=>open   );
CL53: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d53_in(9*N-1 downto 8*N),data2conv2 =>d53_in(8*N-1 downto 7*N),data2conv3 =>d53_in(7*N-1 downto 6*N),data2conv4 =>d53_in(6*N-1 downto 5*N),data2conv5 =>d53_in(5*N-1 downto 4*N),data2conv6 =>d53_in(4*N-1 downto 3*N),data2conv7 =>d53_in(3*N-1 downto 2*N),data2conv8 =>d53_in(2*N-1 downto N),data2conv9 =>d53_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d53_in(9*N-1 downto 8*N),w2 => d53_in(8*N-1 downto 7*N),w3 => d53_in(7*N-1 downto 6*N),w4 => d53_in(6*N-1 downto 5*N),w5 => d53_in(5*N-1 downto 4*N),w6 => d53_in(4*N-1 downto 3*N),w7 => d53_in(3*N-1 downto 2*N),w8 => d53_in(2*N-1 downto N),w9 => d53_in(N-1 downto 0 ),d_out => d53_out,en_out =>open  ,sof_out=>open   );
CL54: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d54_in(9*N-1 downto 8*N),data2conv2 =>d54_in(8*N-1 downto 7*N),data2conv3 =>d54_in(7*N-1 downto 6*N),data2conv4 =>d54_in(6*N-1 downto 5*N),data2conv5 =>d54_in(5*N-1 downto 4*N),data2conv6 =>d54_in(4*N-1 downto 3*N),data2conv7 =>d54_in(3*N-1 downto 2*N),data2conv8 =>d54_in(2*N-1 downto N),data2conv9 =>d54_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d54_in(9*N-1 downto 8*N),w2 => d54_in(8*N-1 downto 7*N),w3 => d54_in(7*N-1 downto 6*N),w4 => d54_in(6*N-1 downto 5*N),w5 => d54_in(5*N-1 downto 4*N),w6 => d54_in(4*N-1 downto 3*N),w7 => d54_in(3*N-1 downto 2*N),w8 => d54_in(2*N-1 downto N),w9 => d54_in(N-1 downto 0 ),d_out => d54_out,en_out =>open  ,sof_out=>open   );
CL55: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d55_in(9*N-1 downto 8*N),data2conv2 =>d55_in(8*N-1 downto 7*N),data2conv3 =>d55_in(7*N-1 downto 6*N),data2conv4 =>d55_in(6*N-1 downto 5*N),data2conv5 =>d55_in(5*N-1 downto 4*N),data2conv6 =>d55_in(4*N-1 downto 3*N),data2conv7 =>d55_in(3*N-1 downto 2*N),data2conv8 =>d55_in(2*N-1 downto N),data2conv9 =>d55_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d55_in(9*N-1 downto 8*N),w2 => d55_in(8*N-1 downto 7*N),w3 => d55_in(7*N-1 downto 6*N),w4 => d55_in(6*N-1 downto 5*N),w5 => d55_in(5*N-1 downto 4*N),w6 => d55_in(4*N-1 downto 3*N),w7 => d55_in(3*N-1 downto 2*N),w8 => d55_in(2*N-1 downto N),w9 => d55_in(N-1 downto 0 ),d_out => d55_out,en_out =>open  ,sof_out=>open   );
CL56: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d56_in(9*N-1 downto 8*N),data2conv2 =>d56_in(8*N-1 downto 7*N),data2conv3 =>d56_in(7*N-1 downto 6*N),data2conv4 =>d56_in(6*N-1 downto 5*N),data2conv5 =>d56_in(5*N-1 downto 4*N),data2conv6 =>d56_in(4*N-1 downto 3*N),data2conv7 =>d56_in(3*N-1 downto 2*N),data2conv8 =>d56_in(2*N-1 downto N),data2conv9 =>d56_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d56_in(9*N-1 downto 8*N),w2 => d56_in(8*N-1 downto 7*N),w3 => d56_in(7*N-1 downto 6*N),w4 => d56_in(6*N-1 downto 5*N),w5 => d56_in(5*N-1 downto 4*N),w6 => d56_in(4*N-1 downto 3*N),w7 => d56_in(3*N-1 downto 2*N),w8 => d56_in(2*N-1 downto N),w9 => d56_in(N-1 downto 0 ),d_out => d56_out,en_out =>open  ,sof_out=>open   );
CL57: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d57_in(9*N-1 downto 8*N),data2conv2 =>d57_in(8*N-1 downto 7*N),data2conv3 =>d57_in(7*N-1 downto 6*N),data2conv4 =>d57_in(6*N-1 downto 5*N),data2conv5 =>d57_in(5*N-1 downto 4*N),data2conv6 =>d57_in(4*N-1 downto 3*N),data2conv7 =>d57_in(3*N-1 downto 2*N),data2conv8 =>d57_in(2*N-1 downto N),data2conv9 =>d57_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d57_in(9*N-1 downto 8*N),w2 => d57_in(8*N-1 downto 7*N),w3 => d57_in(7*N-1 downto 6*N),w4 => d57_in(6*N-1 downto 5*N),w5 => d57_in(5*N-1 downto 4*N),w6 => d57_in(4*N-1 downto 3*N),w7 => d57_in(3*N-1 downto 2*N),w8 => d57_in(2*N-1 downto N),w9 => d57_in(N-1 downto 0 ),d_out => d57_out,en_out =>open  ,sof_out=>open   );
CL58: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d58_in(9*N-1 downto 8*N),data2conv2 =>d58_in(8*N-1 downto 7*N),data2conv3 =>d58_in(7*N-1 downto 6*N),data2conv4 =>d58_in(6*N-1 downto 5*N),data2conv5 =>d58_in(5*N-1 downto 4*N),data2conv6 =>d58_in(4*N-1 downto 3*N),data2conv7 =>d58_in(3*N-1 downto 2*N),data2conv8 =>d58_in(2*N-1 downto N),data2conv9 =>d58_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d58_in(9*N-1 downto 8*N),w2 => d58_in(8*N-1 downto 7*N),w3 => d58_in(7*N-1 downto 6*N),w4 => d58_in(6*N-1 downto 5*N),w5 => d58_in(5*N-1 downto 4*N),w6 => d58_in(4*N-1 downto 3*N),w7 => d58_in(3*N-1 downto 2*N),w8 => d58_in(2*N-1 downto N),w9 => d58_in(N-1 downto 0 ),d_out => d58_out,en_out =>open  ,sof_out=>open   );
CL59: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d59_in(9*N-1 downto 8*N),data2conv2 =>d59_in(8*N-1 downto 7*N),data2conv3 =>d59_in(7*N-1 downto 6*N),data2conv4 =>d59_in(6*N-1 downto 5*N),data2conv5 =>d59_in(5*N-1 downto 4*N),data2conv6 =>d59_in(4*N-1 downto 3*N),data2conv7 =>d59_in(3*N-1 downto 2*N),data2conv8 =>d59_in(2*N-1 downto N),data2conv9 =>d59_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d59_in(9*N-1 downto 8*N),w2 => d59_in(8*N-1 downto 7*N),w3 => d59_in(7*N-1 downto 6*N),w4 => d59_in(6*N-1 downto 5*N),w5 => d59_in(5*N-1 downto 4*N),w6 => d59_in(4*N-1 downto 3*N),w7 => d59_in(3*N-1 downto 2*N),w8 => d59_in(2*N-1 downto N),w9 => d59_in(N-1 downto 0 ),d_out => d59_out,en_out =>open  ,sof_out=>open   );
CL60: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d60_in(9*N-1 downto 8*N),data2conv2 =>d60_in(8*N-1 downto 7*N),data2conv3 =>d60_in(7*N-1 downto 6*N),data2conv4 =>d60_in(6*N-1 downto 5*N),data2conv5 =>d60_in(5*N-1 downto 4*N),data2conv6 =>d60_in(4*N-1 downto 3*N),data2conv7 =>d60_in(3*N-1 downto 2*N),data2conv8 =>d60_in(2*N-1 downto N),data2conv9 =>d60_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d60_in(9*N-1 downto 8*N),w2 => d60_in(8*N-1 downto 7*N),w3 => d60_in(7*N-1 downto 6*N),w4 => d60_in(6*N-1 downto 5*N),w5 => d60_in(5*N-1 downto 4*N),w6 => d60_in(4*N-1 downto 3*N),w7 => d60_in(3*N-1 downto 2*N),w8 => d60_in(2*N-1 downto N),w9 => d60_in(N-1 downto 0 ),d_out => d60_out,en_out =>open  ,sof_out=>open   );
CL61: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d61_in(9*N-1 downto 8*N),data2conv2 =>d61_in(8*N-1 downto 7*N),data2conv3 =>d61_in(7*N-1 downto 6*N),data2conv4 =>d61_in(6*N-1 downto 5*N),data2conv5 =>d61_in(5*N-1 downto 4*N),data2conv6 =>d61_in(4*N-1 downto 3*N),data2conv7 =>d61_in(3*N-1 downto 2*N),data2conv8 =>d61_in(2*N-1 downto N),data2conv9 =>d61_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d61_in(9*N-1 downto 8*N),w2 => d61_in(8*N-1 downto 7*N),w3 => d61_in(7*N-1 downto 6*N),w4 => d61_in(6*N-1 downto 5*N),w5 => d61_in(5*N-1 downto 4*N),w6 => d61_in(4*N-1 downto 3*N),w7 => d61_in(3*N-1 downto 2*N),w8 => d61_in(2*N-1 downto N),w9 => d61_in(N-1 downto 0 ),d_out => d61_out,en_out =>open  ,sof_out=>open   );
CL62: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d62_in(9*N-1 downto 8*N),data2conv2 =>d62_in(8*N-1 downto 7*N),data2conv3 =>d62_in(7*N-1 downto 6*N),data2conv4 =>d62_in(6*N-1 downto 5*N),data2conv5 =>d62_in(5*N-1 downto 4*N),data2conv6 =>d62_in(4*N-1 downto 3*N),data2conv7 =>d62_in(3*N-1 downto 2*N),data2conv8 =>d62_in(2*N-1 downto N),data2conv9 =>d62_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d62_in(9*N-1 downto 8*N),w2 => d62_in(8*N-1 downto 7*N),w3 => d62_in(7*N-1 downto 6*N),w4 => d62_in(6*N-1 downto 5*N),w5 => d62_in(5*N-1 downto 4*N),w6 => d62_in(4*N-1 downto 3*N),w7 => d62_in(3*N-1 downto 2*N),w8 => d62_in(2*N-1 downto N),w9 => d62_in(N-1 downto 0 ),d_out => d62_out,en_out =>open  ,sof_out=>open   );
CL63: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d63_in(9*N-1 downto 8*N),data2conv2 =>d63_in(8*N-1 downto 7*N),data2conv3 =>d63_in(7*N-1 downto 6*N),data2conv4 =>d63_in(6*N-1 downto 5*N),data2conv5 =>d63_in(5*N-1 downto 4*N),data2conv6 =>d63_in(4*N-1 downto 3*N),data2conv7 =>d63_in(3*N-1 downto 2*N),data2conv8 =>d63_in(2*N-1 downto N),data2conv9 =>d63_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d63_in(9*N-1 downto 8*N),w2 => d63_in(8*N-1 downto 7*N),w3 => d63_in(7*N-1 downto 6*N),w4 => d63_in(6*N-1 downto 5*N),w5 => d63_in(5*N-1 downto 4*N),w6 => d63_in(4*N-1 downto 3*N),w7 => d63_in(3*N-1 downto 2*N),w8 => d63_in(2*N-1 downto N),w9 => d63_in(N-1 downto 0 ),d_out => d63_out,en_out =>open  ,sof_out=>open   );
CL64: ConvLayer1 generic map (mult_sum=>mult_sum,N=>N,M=>M,W=>W,SR=>SR) port map(clk=>clk,rst=>rst,data2conv1 =>d64_in(9*N-1 downto 8*N),data2conv2 =>d64_in(8*N-1 downto 7*N),data2conv3 =>d64_in(7*N-1 downto 6*N),data2conv4 =>d64_in(6*N-1 downto 5*N),data2conv5 =>d64_in(5*N-1 downto 4*N),data2conv6 =>d64_in(4*N-1 downto 3*N),data2conv7 =>d64_in(3*N-1 downto 2*N),data2conv8 =>d64_in(2*N-1 downto N),data2conv9 =>d64_in(N-1 downto 0 ),en_in =>en_in,sof_in =>sof_in,w1 => d64_in(9*N-1 downto 8*N),w2 => d64_in(8*N-1 downto 7*N),w3 => d64_in(7*N-1 downto 6*N),w4 => d64_in(6*N-1 downto 5*N),w5 => d64_in(5*N-1 downto 4*N),w6 => d64_in(4*N-1 downto 3*N),w7 => d64_in(3*N-1 downto 2*N),w8 => d64_in(2*N-1 downto N),w9 => d64_in(N-1 downto 0 ),d_out => d64_out,en_out =>open  ,sof_out=>open   );

  p_sums: process (clk)
  begin
    if rising_edge(clk) then
       sum1  <= (d01_out(d01_out'left) & d01_out(d01_out'left) & d01_out) +  (d02_out(d02_out'left) & d02_out(d02_out'left) & d02_out) + (d03_out(d03_out'left) & d03_out(d03_out'left) & d03_out) +  (d03_out(d03_out'left) & d03_out(d03_out'left) & d03_out);  
       sum2  <= (d05_out(d05_out'left) & d05_out(d05_out'left) & d05_out) +  (d06_out(d06_out'left) & d06_out(d06_out'left) & d06_out) + (d07_out(d07_out'left) & d07_out(d07_out'left) & d07_out) +  (d07_out(d07_out'left) & d07_out(d07_out'left) & d07_out);  
       sum3  <= (d09_out(d09_out'left) & d09_out(d09_out'left) & d09_out) +  (d10_out(d10_out'left) & d10_out(d10_out'left) & d10_out) + (d11_out(d11_out'left) & d11_out(d11_out'left) & d11_out) +  (d11_out(d11_out'left) & d11_out(d11_out'left) & d11_out);  
       sum4  <= (d13_out(d13_out'left) & d13_out(d13_out'left) & d13_out) +  (d14_out(d14_out'left) & d14_out(d14_out'left) & d14_out) + (d15_out(d15_out'left) & d15_out(d15_out'left) & d15_out) +  (d15_out(d15_out'left) & d15_out(d15_out'left) & d15_out);  
       sum5  <= (d17_out(d17_out'left) & d17_out(d17_out'left) & d17_out) +  (d18_out(d18_out'left) & d18_out(d18_out'left) & d18_out) + (d19_out(d19_out'left) & d19_out(d19_out'left) & d19_out) +  (d19_out(d19_out'left) & d19_out(d19_out'left) & d19_out);  
       sum6  <= (d21_out(d21_out'left) & d21_out(d21_out'left) & d21_out) +  (d22_out(d22_out'left) & d22_out(d22_out'left) & d22_out) + (d23_out(d23_out'left) & d23_out(d23_out'left) & d23_out) +  (d23_out(d23_out'left) & d23_out(d23_out'left) & d23_out);  
       sum7  <= (d25_out(d25_out'left) & d25_out(d25_out'left) & d25_out) +  (d26_out(d26_out'left) & d26_out(d26_out'left) & d26_out) + (d27_out(d27_out'left) & d27_out(d27_out'left) & d27_out) +  (d27_out(d27_out'left) & d27_out(d27_out'left) & d27_out);  
       sum8  <= (d29_out(d29_out'left) & d29_out(d29_out'left) & d29_out) +  (d30_out(d30_out'left) & d30_out(d30_out'left) & d30_out) + (d31_out(d31_out'left) & d31_out(d31_out'left) & d31_out) +  (d31_out(d31_out'left) & d31_out(d31_out'left) & d31_out);  
       sum9  <= (d33_out(d33_out'left) & d33_out(d33_out'left) & d33_out) +  (d34_out(d34_out'left) & d34_out(d34_out'left) & d34_out) + (d35_out(d35_out'left) & d35_out(d35_out'left) & d35_out) +  (d35_out(d35_out'left) & d35_out(d35_out'left) & d35_out);  
       sum10 <= (d37_out(d37_out'left) & d37_out(d37_out'left) & d37_out) +  (d38_out(d38_out'left) & d38_out(d38_out'left) & d38_out) + (d39_out(d39_out'left) & d39_out(d39_out'left) & d39_out) +  (d39_out(d39_out'left) & d39_out(d39_out'left) & d39_out);  
       sum11 <= (d41_out(d41_out'left) & d41_out(d41_out'left) & d41_out) +  (d42_out(d42_out'left) & d42_out(d42_out'left) & d42_out) + (d43_out(d43_out'left) & d43_out(d43_out'left) & d43_out) +  (d43_out(d43_out'left) & d43_out(d43_out'left) & d43_out);  
       sum12 <= (d45_out(d45_out'left) & d45_out(d45_out'left) & d45_out) +  (d46_out(d46_out'left) & d46_out(d46_out'left) & d46_out) + (d47_out(d47_out'left) & d47_out(d47_out'left) & d47_out) +  (d47_out(d47_out'left) & d47_out(d47_out'left) & d47_out);  
       sum13 <= (d49_out(d49_out'left) & d49_out(d49_out'left) & d49_out) +  (d50_out(d50_out'left) & d50_out(d50_out'left) & d50_out) + (d51_out(d51_out'left) & d51_out(d51_out'left) & d51_out) +  (d51_out(d51_out'left) & d51_out(d51_out'left) & d51_out);  
       sum14 <= (d53_out(d53_out'left) & d53_out(d53_out'left) & d53_out) +  (d54_out(d54_out'left) & d54_out(d54_out'left) & d54_out) + (d55_out(d55_out'left) & d55_out(d55_out'left) & d55_out) +  (d55_out(d55_out'left) & d55_out(d55_out'left) & d55_out);  
       sum15 <= (d57_out(d57_out'left) & d57_out(d57_out'left) & d57_out) +  (d58_out(d58_out'left) & d58_out(d58_out'left) & d58_out) + (d59_out(d59_out'left) & d59_out(d59_out'left) & d59_out) +  (d59_out(d59_out'left) & d59_out(d59_out'left) & d59_out);  
       sum16 <= (d61_out(d61_out'left) & d61_out(d61_out'left) & d61_out) +  (d62_out(d62_out'left) & d62_out(d62_out'left) & d62_out) + (d63_out(d63_out'left) & d63_out(d63_out'left) & d63_out) +  (d63_out(d63_out'left) & d63_out(d63_out'left) & d63_out);  
       
       sum17 <= (sum1(sum1  'left) & sum1(sum1  'left) & sum1 ) + (sum2(sum2  'left) & sum2(sum2  'left) & sum2 ) + (sum3(sum3  'left) & sum3(sum3  'left) & sum3 ) + (sum4(sum4  'left) & sum4(sum4  'left) & sum4 );  
       sum18 <= (sum5(sum5  'left) & sum5(sum5  'left) & sum5 ) + (sum6(sum6  'left) & sum6(sum6  'left) & sum6 ) + (sum7(sum7  'left) & sum7(sum7  'left) & sum7 ) + (sum8(sum8  'left) & sum8(sum8  'left) & sum8 );  
       sum19 <= (sum9(sum9  'left) & sum9(sum9  'left) & sum9 ) + (sum10(sum10'left) & sum10(sum10'left) & sum10) + (sum11(sum11'left) & sum11(sum11'left) & sum11) + (sum12(sum12'left) & sum12(sum12'left) & sum12);
       sum20 <= (sum13(sum13'left) & sum13(sum13'left) & sum13) + (sum14(sum14'left) & sum14(sum14'left) & sum14) + (sum15(sum15'left) & sum15(sum15'left) & sum15) + (sum16(sum16'left) & sum16(sum16'left) & sum16);
       
       sum21 <= (sum17(sum17'left) & sum17(sum17'left) & sum17) + (sum18(sum18'left) & sum18(sum18'left) & sum18) + (sum19(sum19'left) & sum19(sum19'left) & sum19) + (sum20(sum20'left) & sum20(sum20'left) & sum20); 
    end if;
  end process p_sums;

d_out <= sum21(sum21'left downto sum21'left -W +1);

end a;