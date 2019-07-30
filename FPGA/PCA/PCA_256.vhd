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

entity PCA_256 is
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
  	       d01_in,  d65_in , d129_in , d193_in : in std_logic_vector (N-1 downto 0);
           d02_in,  d66_in , d130_in , d194_in : in std_logic_vector (N-1 downto 0);
           d03_in,  d67_in , d131_in , d195_in : in std_logic_vector (N-1 downto 0);
           d04_in,  d68_in , d132_in , d196_in : in std_logic_vector (N-1 downto 0);
           d05_in,  d69_in , d133_in , d197_in : in std_logic_vector (N-1 downto 0);
           d06_in,  d70_in , d134_in , d198_in : in std_logic_vector (N-1 downto 0);
           d07_in,  d71_in , d135_in , d199_in : in std_logic_vector (N-1 downto 0);
           d08_in,  d72_in , d136_in , d200_in : in std_logic_vector (N-1 downto 0);
           d09_in,  d73_in , d137_in , d201_in : in std_logic_vector (N-1 downto 0);
           d10_in,  d74_in , d138_in , d202_in : in std_logic_vector (N-1 downto 0);
           d11_in,  d75_in , d139_in , d203_in : in std_logic_vector (N-1 downto 0);
           d12_in,  d76_in , d140_in , d204_in : in std_logic_vector (N-1 downto 0);
           d13_in,  d77_in , d141_in , d205_in : in std_logic_vector (N-1 downto 0);
           d14_in,  d78_in , d142_in , d206_in : in std_logic_vector (N-1 downto 0);
           d15_in,  d79_in , d143_in , d207_in : in std_logic_vector (N-1 downto 0);
           d16_in,  d80_in , d144_in , d208_in : in std_logic_vector (N-1 downto 0);
           d17_in,  d81_in , d145_in , d209_in : in std_logic_vector (N-1 downto 0);
           d18_in,  d82_in , d146_in , d210_in : in std_logic_vector (N-1 downto 0);
           d19_in,  d83_in , d147_in , d211_in : in std_logic_vector (N-1 downto 0);
           d20_in,  d84_in , d148_in , d212_in : in std_logic_vector (N-1 downto 0);
           d21_in,  d85_in , d149_in , d213_in : in std_logic_vector (N-1 downto 0);
           d22_in,  d86_in , d150_in , d214_in : in std_logic_vector (N-1 downto 0);
           d23_in,  d87_in , d151_in , d215_in : in std_logic_vector (N-1 downto 0);
           d24_in,  d88_in , d152_in , d216_in : in std_logic_vector (N-1 downto 0);
           d25_in,  d89_in , d153_in , d217_in : in std_logic_vector (N-1 downto 0);
           d26_in,  d90_in , d154_in , d218_in : in std_logic_vector (N-1 downto 0);
           d27_in,  d91_in , d155_in , d219_in : in std_logic_vector (N-1 downto 0);
           d28_in,  d92_in , d156_in , d220_in : in std_logic_vector (N-1 downto 0);
           d29_in,  d93_in , d157_in , d221_in : in std_logic_vector (N-1 downto 0);
           d30_in,  d94_in , d158_in , d222_in : in std_logic_vector (N-1 downto 0);
           d31_in,  d95_in , d159_in , d223_in : in std_logic_vector (N-1 downto 0);
           d32_in,  d96_in , d160_in , d224_in : in std_logic_vector (N-1 downto 0);
           d33_in,  d97_in , d161_in , d225_in : in std_logic_vector (N-1 downto 0);
           d34_in,  d98_in , d162_in , d226_in : in std_logic_vector (N-1 downto 0);
           d35_in,  d99_in , d163_in , d227_in : in std_logic_vector (N-1 downto 0);
           d36_in,  d100_in, d164_in , d228_in : in std_logic_vector (N-1 downto 0);
           d37_in,  d101_in, d165_in , d229_in : in std_logic_vector (N-1 downto 0);
           d38_in,  d102_in, d166_in , d230_in : in std_logic_vector (N-1 downto 0);
           d39_in,  d103_in, d167_in , d231_in : in std_logic_vector (N-1 downto 0);
           d40_in,  d104_in, d168_in , d232_in : in std_logic_vector (N-1 downto 0);
           d41_in,  d105_in, d169_in , d233_in : in std_logic_vector (N-1 downto 0);
           d42_in,  d106_in, d170_in , d234_in : in std_logic_vector (N-1 downto 0);
           d43_in,  d107_in, d171_in , d235_in : in std_logic_vector (N-1 downto 0);
           d44_in,  d108_in, d172_in , d236_in : in std_logic_vector (N-1 downto 0);
           d45_in,  d109_in, d173_in , d237_in : in std_logic_vector (N-1 downto 0);
           d46_in,  d110_in, d174_in , d238_in : in std_logic_vector (N-1 downto 0);
           d47_in,  d111_in, d175_in , d239_in : in std_logic_vector (N-1 downto 0);
           d48_in,  d112_in, d176_in , d240_in : in std_logic_vector (N-1 downto 0);
           d49_in,  d113_in, d177_in , d241_in : in std_logic_vector (N-1 downto 0);
           d50_in,  d114_in, d178_in , d242_in : in std_logic_vector (N-1 downto 0);
           d51_in,  d115_in, d179_in , d243_in : in std_logic_vector (N-1 downto 0);
           d52_in,  d116_in, d180_in , d244_in : in std_logic_vector (N-1 downto 0);
           d53_in,  d117_in, d181_in , d245_in : in std_logic_vector (N-1 downto 0);
           d54_in,  d118_in, d182_in , d246_in : in std_logic_vector (N-1 downto 0);
           d55_in,  d119_in, d183_in , d247_in : in std_logic_vector (N-1 downto 0);
           d56_in,  d120_in, d184_in , d248_in : in std_logic_vector (N-1 downto 0);
           d57_in,  d121_in, d185_in , d249_in : in std_logic_vector (N-1 downto 0);
           d58_in,  d122_in, d186_in , d250_in : in std_logic_vector (N-1 downto 0);
           d59_in,  d123_in, d187_in , d251_in : in std_logic_vector (N-1 downto 0);
           d60_in,  d124_in, d188_in , d252_in : in std_logic_vector (N-1 downto 0);
           d61_in,  d125_in, d189_in , d253_in : in std_logic_vector (N-1 downto 0);
           d62_in,  d126_in, d190_in , d254_in : in std_logic_vector (N-1 downto 0);
           d63_in,  d127_in, d191_in , d255_in : in std_logic_vector (N-1 downto 0);
           d64_in,  d128_in, d192_in , d256_in : in std_logic_vector (N-1 downto 0);

  	       en_in     : in std_logic ;
  	       sof_in    : in std_logic; -- start of frame 

           w01, w65 , w129 , w193      : in std_logic_vector(M-1 downto 0); 
           w02, w66 , w130 , w194      : in std_logic_vector(M-1 downto 0); 
           w03, w67 , w131 , w195      : in std_logic_vector(M-1 downto 0); 
           w04, w68 , w132 , w196      : in std_logic_vector(M-1 downto 0); 
           w05, w69 , w133 , w197      : in std_logic_vector(M-1 downto 0); 
           w06, w70 , w134 , w198      : in std_logic_vector(M-1 downto 0); 
           w07, w71 , w135 , w199      : in std_logic_vector(M-1 downto 0); 
           w08, w72 , w136 , w200      : in std_logic_vector(M-1 downto 0); 
           w09, w73 , w137 , w201      : in std_logic_vector(M-1 downto 0); 
           w10, w74 , w138 , w202      : in std_logic_vector(M-1 downto 0); 
           w11, w75 , w139 , w203      : in std_logic_vector(M-1 downto 0); 
           w12, w76 , w140 , w204      : in std_logic_vector(M-1 downto 0); 
           w13, w77 , w141 , w205      : in std_logic_vector(M-1 downto 0); 
           w14, w78 , w142 , w206      : in std_logic_vector(M-1 downto 0); 
           w15, w79 , w143 , w207      : in std_logic_vector(M-1 downto 0); 
           w16, w80 , w144 , w208      : in std_logic_vector(M-1 downto 0); 
           w17, w81 , w145 , w209      : in std_logic_vector(M-1 downto 0); 
           w18, w82 , w146 , w210      : in std_logic_vector(M-1 downto 0); 
           w19, w83 , w147 , w211      : in std_logic_vector(M-1 downto 0); 
           w20, w84 , w148 , w212      : in std_logic_vector(M-1 downto 0); 
           w21, w85 , w149 , w213      : in std_logic_vector(M-1 downto 0); 
           w22, w86 , w150 , w214      : in std_logic_vector(M-1 downto 0); 
           w23, w87 , w151 , w215      : in std_logic_vector(M-1 downto 0); 
           w24, w88 , w152 , w216      : in std_logic_vector(M-1 downto 0); 
           w25, w89 , w153 , w217      : in std_logic_vector(M-1 downto 0); 
           w26, w90 , w154 , w218      : in std_logic_vector(M-1 downto 0); 
           w27, w91 , w155 , w219      : in std_logic_vector(M-1 downto 0); 
           w28, w92 , w156 , w220      : in std_logic_vector(M-1 downto 0); 
           w29, w93 , w157 , w221      : in std_logic_vector(M-1 downto 0); 
           w30, w94 , w158 , w222      : in std_logic_vector(M-1 downto 0); 
           w31, w95 , w159 , w223      : in std_logic_vector(M-1 downto 0); 
           w32, w96 , w160 , w224      : in std_logic_vector(M-1 downto 0); 
           w33, w97 , w161 , w225      : in std_logic_vector(M-1 downto 0); 
           w34, w98 , w162 , w226      : in std_logic_vector(M-1 downto 0); 
           w35, w99 , w163 , w227      : in std_logic_vector(M-1 downto 0); 
           w36, w100, w164 , w228      : in std_logic_vector(M-1 downto 0); 
           w37, w101, w165 , w229      : in std_logic_vector(M-1 downto 0); 
           w38, w102, w166 , w230      : in std_logic_vector(M-1 downto 0); 
           w39, w103, w167 , w231      : in std_logic_vector(M-1 downto 0); 
           w40, w104, w168 , w232      : in std_logic_vector(M-1 downto 0); 
           w41, w105, w169 , w233      : in std_logic_vector(M-1 downto 0); 
           w42, w106, w170 , w234      : in std_logic_vector(M-1 downto 0); 
           w43, w107, w171 , w235      : in std_logic_vector(M-1 downto 0); 
           w44, w108, w172 , w236      : in std_logic_vector(M-1 downto 0); 
           w45, w109, w173 , w237      : in std_logic_vector(M-1 downto 0); 
           w46, w110, w174 , w238      : in std_logic_vector(M-1 downto 0); 
           w47, w111, w175 , w239      : in std_logic_vector(M-1 downto 0); 
           w48, w112, w176 , w240      : in std_logic_vector(M-1 downto 0); 
           w49, w113, w177 , w241      : in std_logic_vector(M-1 downto 0); 
           w50, w114, w178 , w242      : in std_logic_vector(M-1 downto 0); 
           w51, w115, w179 , w243      : in std_logic_vector(M-1 downto 0); 
           w52, w116, w180 , w244      : in std_logic_vector(M-1 downto 0); 
           w53, w117, w181 , w245      : in std_logic_vector(M-1 downto 0); 
           w54, w118, w182 , w246      : in std_logic_vector(M-1 downto 0); 
           w55, w119, w183 , w247      : in std_logic_vector(M-1 downto 0); 
           w56, w120, w184 , w248      : in std_logic_vector(M-1 downto 0); 
           w57, w121, w185 , w249      : in std_logic_vector(M-1 downto 0); 
           w58, w122, w186 , w250      : in std_logic_vector(M-1 downto 0); 
           w59, w123, w187 , w251      : in std_logic_vector(M-1 downto 0); 
           w60, w124, w188 , w252      : in std_logic_vector(M-1 downto 0); 
           w61, w125, w189 , w253      : in std_logic_vector(M-1 downto 0); 
           w62, w126, w190 , w254      : in std_logic_vector(M-1 downto 0); 
           w63, w127, w191 , w255      : in std_logic_vector(M-1 downto 0); 
           w64, w128, w192 , w256      : in std_logic_vector(M-1 downto 0); 

           d_out   : out std_logic_vector (N + M + 5 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end PCA_256;

architecture a of PCA_256 is

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

type t_acc is array (0 to 256-1) of std_logic_vector(N + M + 5  downto 0);
signal accumulator_vec  : t_acc;


signal en_mult, en_add1, en_add2, en_add3, en_add4, en_add5 : std_logic;
signal sof_mult, sof_add1, sof_add2, sof_add3, sof_add4, sof_add5 : std_logic;

signal d_active           : std_logic_vector (N-1 downto 0);
signal w_active           : std_logic_vector (M-1 downto 0); 
signal feature_sw         : std_logic_vector (  7 downto 0);
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
          when 128 => d_active <= d129_in; w_active <= w129;
          when 129 => d_active <= d130_in; w_active <= w130;
          when 130 => d_active <= d131_in; w_active <= w131;
          when 131 => d_active <= d132_in; w_active <= w132;
          when 132 => d_active <= d133_in; w_active <= w133;
          when 133 => d_active <= d134_in; w_active <= w134;
          when 134 => d_active <= d135_in; w_active <= w135;
          when 135 => d_active <= d136_in; w_active <= w136;
          when 136 => d_active <= d137_in; w_active <= w137;
          when 137 => d_active <= d138_in; w_active <= w138;
          when 138 => d_active <= d139_in; w_active <= w139;
          when 139 => d_active <= d140_in; w_active <= w140;
          when 140 => d_active <= d141_in; w_active <= w141;
          when 141 => d_active <= d142_in; w_active <= w142;
          when 142 => d_active <= d143_in; w_active <= w143;
          when 143 => d_active <= d144_in; w_active <= w144;
          when 144 => d_active <= d145_in; w_active <= w145;
          when 145 => d_active <= d146_in; w_active <= w146;
          when 146 => d_active <= d147_in; w_active <= w147;
          when 147 => d_active <= d148_in; w_active <= w148;
          when 148 => d_active <= d149_in; w_active <= w149;
          when 149 => d_active <= d150_in; w_active <= w150;
          when 150 => d_active <= d151_in; w_active <= w151;
          when 151 => d_active <= d152_in; w_active <= w152;
          when 152 => d_active <= d153_in; w_active <= w153;
          when 153 => d_active <= d154_in; w_active <= w154;
          when 154 => d_active <= d155_in; w_active <= w155;
          when 155 => d_active <= d156_in; w_active <= w156;
          when 156 => d_active <= d157_in; w_active <= w157;
          when 157 => d_active <= d158_in; w_active <= w158;
          when 158 => d_active <= d159_in; w_active <= w159;
          when 159 => d_active <= d160_in; w_active <= w160;
          when 160 => d_active <= d161_in; w_active <= w161;
          when 161 => d_active <= d162_in; w_active <= w162;
          when 162 => d_active <= d163_in; w_active <= w163;
          when 163 => d_active <= d164_in; w_active <= w164;
          when 164 => d_active <= d165_in; w_active <= w165;
          when 165 => d_active <= d166_in; w_active <= w166;
          when 166 => d_active <= d167_in; w_active <= w167;
          when 167 => d_active <= d168_in; w_active <= w168;
          when 168 => d_active <= d169_in; w_active <= w169;
          when 169 => d_active <= d170_in; w_active <= w170;
          when 170 => d_active <= d171_in; w_active <= w171;
          when 171 => d_active <= d172_in; w_active <= w172;
          when 172 => d_active <= d173_in; w_active <= w173;
          when 173 => d_active <= d174_in; w_active <= w174;
          when 174 => d_active <= d175_in; w_active <= w175;
          when 175 => d_active <= d176_in; w_active <= w176;
          when 176 => d_active <= d177_in; w_active <= w177;
          when 177 => d_active <= d178_in; w_active <= w178;
          when 178 => d_active <= d179_in; w_active <= w179;
          when 179 => d_active <= d180_in; w_active <= w180;
          when 180 => d_active <= d181_in; w_active <= w181;
          when 181 => d_active <= d182_in; w_active <= w182;
          when 182 => d_active <= d183_in; w_active <= w183;
          when 183 => d_active <= d184_in; w_active <= w184;
          when 184 => d_active <= d185_in; w_active <= w185;
          when 185 => d_active <= d186_in; w_active <= w186;
          when 186 => d_active <= d187_in; w_active <= w187;
          when 187 => d_active <= d188_in; w_active <= w188;
          when 188 => d_active <= d189_in; w_active <= w189;
          when 189 => d_active <= d190_in; w_active <= w190;
          when 190 => d_active <= d191_in; w_active <= w191;
          when 191 => d_active <= d192_in; w_active <= w192;
          when 192 => d_active <= d193_in; w_active <= w193;
          when 193 => d_active <= d194_in; w_active <= w194;
          when 194 => d_active <= d195_in; w_active <= w195;
          when 195 => d_active <= d196_in; w_active <= w196;
          when 196 => d_active <= d197_in; w_active <= w197;
          when 197 => d_active <= d198_in; w_active <= w198;
          when 198 => d_active <= d199_in; w_active <= w199;
          when 199 => d_active <= d200_in; w_active <= w200;
          when 200 => d_active <= d201_in; w_active <= w201;
          when 201 => d_active <= d202_in; w_active <= w202;
          when 202 => d_active <= d203_in; w_active <= w203;
          when 203 => d_active <= d204_in; w_active <= w204;
          when 204 => d_active <= d205_in; w_active <= w205;
          when 205 => d_active <= d206_in; w_active <= w206;
          when 206 => d_active <= d207_in; w_active <= w207;
          when 207 => d_active <= d208_in; w_active <= w208;
          when 208 => d_active <= d209_in; w_active <= w209;
          when 209 => d_active <= d210_in; w_active <= w210;
          when 210 => d_active <= d211_in; w_active <= w211;
          when 211 => d_active <= d212_in; w_active <= w212;
          when 212 => d_active <= d213_in; w_active <= w213;
          when 213 => d_active <= d214_in; w_active <= w214;
          when 214 => d_active <= d215_in; w_active <= w215;
          when 215 => d_active <= d216_in; w_active <= w216;
          when 216 => d_active <= d217_in; w_active <= w217;
          when 217 => d_active <= d218_in; w_active <= w218;
          when 218 => d_active <= d219_in; w_active <= w219;
          when 219 => d_active <= d220_in; w_active <= w220;
          when 220 => d_active <= d221_in; w_active <= w221;
          when 221 => d_active <= d222_in; w_active <= w222;
          when 222 => d_active <= d223_in; w_active <= w223;
          when 223 => d_active <= d224_in; w_active <= w224;
          when 224 => d_active <= d225_in; w_active <= w225;
          when 225 => d_active <= d226_in; w_active <= w226;
          when 226 => d_active <= d227_in; w_active <= w227;
          when 227 => d_active <= d228_in; w_active <= w228;
          when 228 => d_active <= d229_in; w_active <= w229;
          when 229 => d_active <= d230_in; w_active <= w230;
          when 230 => d_active <= d231_in; w_active <= w231;
          when 231 => d_active <= d232_in; w_active <= w232;
          when 232 => d_active <= d233_in; w_active <= w233;
          when 233 => d_active <= d234_in; w_active <= w234;
          when 234 => d_active <= d235_in; w_active <= w235;
          when 235 => d_active <= d236_in; w_active <= w236;
          when 236 => d_active <= d237_in; w_active <= w237;
          when 237 => d_active <= d238_in; w_active <= w238;
          when 238 => d_active <= d239_in; w_active <= w239;
          when 239 => d_active <= d240_in; w_active <= w240;
          when 240 => d_active <= d241_in; w_active <= w241;
          when 241 => d_active <= d242_in; w_active <= w242;
          when 242 => d_active <= d243_in; w_active <= w243;
          when 243 => d_active <= d244_in; w_active <= w244;
          when 244 => d_active <= d245_in; w_active <= w245;
          when 245 => d_active <= d246_in; w_active <= w246;
          when 246 => d_active <= d247_in; w_active <= w247;
          when 247 => d_active <= d248_in; w_active <= w248;
          when 248 => d_active <= d249_in; w_active <= w249;
          when 249 => d_active <= d250_in; w_active <= w250;
          when 250 => d_active <= d251_in; w_active <= w251;
          when 251 => d_active <= d252_in; w_active <= w252;
          when 252 => d_active <= d253_in; w_active <= w253;
          when 253 => d_active <= d254_in; w_active <= w254;
          when 254 => d_active <= d255_in; w_active <= w255;
          when 255 => d_active <= d256_in; w_active <= w256;
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