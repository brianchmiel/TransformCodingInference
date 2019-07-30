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


 
signal mult_res01, mult_res65 ,  mult_res129 , mult_res193  : std_logic_vector(N+M-1 downto 0);
signal mult_res02, mult_res66 ,  mult_res130 , mult_res194  : std_logic_vector(N+M-1 downto 0);
signal mult_res03, mult_res67 ,  mult_res131 , mult_res195  : std_logic_vector(N+M-1 downto 0);
signal mult_res04, mult_res68 ,  mult_res132 , mult_res196  : std_logic_vector(N+M-1 downto 0);
signal mult_res05, mult_res69 ,  mult_res133 , mult_res197  : std_logic_vector(N+M-1 downto 0);
signal mult_res06, mult_res70 ,  mult_res134 , mult_res198  : std_logic_vector(N+M-1 downto 0);
signal mult_res07, mult_res71 ,  mult_res135 , mult_res199  : std_logic_vector(N+M-1 downto 0);
signal mult_res08, mult_res72 ,  mult_res136 , mult_res200  : std_logic_vector(N+M-1 downto 0);
signal mult_res09, mult_res73 ,  mult_res137 , mult_res201  : std_logic_vector(N+M-1 downto 0);
signal mult_res10, mult_res74 ,  mult_res138 , mult_res202  : std_logic_vector(N+M-1 downto 0);
signal mult_res11, mult_res75 ,  mult_res139 , mult_res203  : std_logic_vector(N+M-1 downto 0);
signal mult_res12, mult_res76 ,  mult_res140 , mult_res204  : std_logic_vector(N+M-1 downto 0);
signal mult_res13, mult_res77 ,  mult_res141 , mult_res205  : std_logic_vector(N+M-1 downto 0);
signal mult_res14, mult_res78 ,  mult_res142 , mult_res206  : std_logic_vector(N+M-1 downto 0);
signal mult_res15, mult_res79 ,  mult_res143 , mult_res207  : std_logic_vector(N+M-1 downto 0);
signal mult_res16, mult_res80 ,  mult_res144 , mult_res208  : std_logic_vector(N+M-1 downto 0);
signal mult_res17, mult_res81 ,  mult_res145 , mult_res209  : std_logic_vector(N+M-1 downto 0);
signal mult_res18, mult_res82 ,  mult_res146 , mult_res210  : std_logic_vector(N+M-1 downto 0);
signal mult_res19, mult_res83 ,  mult_res147 , mult_res211  : std_logic_vector(N+M-1 downto 0);
signal mult_res20, mult_res84 ,  mult_res148 , mult_res212  : std_logic_vector(N+M-1 downto 0);
signal mult_res21, mult_res85 ,  mult_res149 , mult_res213  : std_logic_vector(N+M-1 downto 0);
signal mult_res22, mult_res86 ,  mult_res150 , mult_res214  : std_logic_vector(N+M-1 downto 0);
signal mult_res23, mult_res87 ,  mult_res151 , mult_res215  : std_logic_vector(N+M-1 downto 0);
signal mult_res24, mult_res88 ,  mult_res152 , mult_res216  : std_logic_vector(N+M-1 downto 0);
signal mult_res25, mult_res89 ,  mult_res153 , mult_res217  : std_logic_vector(N+M-1 downto 0);
signal mult_res26, mult_res90 ,  mult_res154 , mult_res218  : std_logic_vector(N+M-1 downto 0);
signal mult_res27, mult_res91 ,  mult_res155 , mult_res219  : std_logic_vector(N+M-1 downto 0);
signal mult_res28, mult_res92 ,  mult_res156 , mult_res220  : std_logic_vector(N+M-1 downto 0);
signal mult_res29, mult_res93 ,  mult_res157 , mult_res221  : std_logic_vector(N+M-1 downto 0);
signal mult_res30, mult_res94 ,  mult_res158 , mult_res222  : std_logic_vector(N+M-1 downto 0);
signal mult_res31, mult_res95 ,  mult_res159 , mult_res223  : std_logic_vector(N+M-1 downto 0);
signal mult_res32, mult_res96 ,  mult_res160 , mult_res224  : std_logic_vector(N+M-1 downto 0);
signal mult_res33, mult_res97 ,  mult_res161 , mult_res225  : std_logic_vector(N+M-1 downto 0);
signal mult_res34, mult_res98 ,  mult_res162 , mult_res226  : std_logic_vector(N+M-1 downto 0);
signal mult_res35, mult_res99 ,  mult_res163 , mult_res227  : std_logic_vector(N+M-1 downto 0);
signal mult_res36, mult_res100,  mult_res164 , mult_res228  : std_logic_vector(N+M-1 downto 0);
signal mult_res37, mult_res101,  mult_res165 , mult_res229  : std_logic_vector(N+M-1 downto 0);
signal mult_res38, mult_res102,  mult_res166 , mult_res230  : std_logic_vector(N+M-1 downto 0);
signal mult_res39, mult_res103,  mult_res167 , mult_res231  : std_logic_vector(N+M-1 downto 0);
signal mult_res40, mult_res104,  mult_res168 , mult_res232  : std_logic_vector(N+M-1 downto 0);
signal mult_res41, mult_res105,  mult_res169 , mult_res233  : std_logic_vector(N+M-1 downto 0);
signal mult_res42, mult_res106,  mult_res170 , mult_res234  : std_logic_vector(N+M-1 downto 0);
signal mult_res43, mult_res107,  mult_res171 , mult_res235  : std_logic_vector(N+M-1 downto 0);
signal mult_res44, mult_res108,  mult_res172 , mult_res236  : std_logic_vector(N+M-1 downto 0);
signal mult_res45, mult_res109,  mult_res173 , mult_res237  : std_logic_vector(N+M-1 downto 0);
signal mult_res46, mult_res110,  mult_res174 , mult_res238  : std_logic_vector(N+M-1 downto 0);
signal mult_res47, mult_res111,  mult_res175 , mult_res239  : std_logic_vector(N+M-1 downto 0);
signal mult_res48, mult_res112,  mult_res176 , mult_res240  : std_logic_vector(N+M-1 downto 0);
signal mult_res49, mult_res113,  mult_res177 , mult_res241  : std_logic_vector(N+M-1 downto 0);
signal mult_res50, mult_res114,  mult_res178 , mult_res242  : std_logic_vector(N+M-1 downto 0);
signal mult_res51, mult_res115,  mult_res179 , mult_res243  : std_logic_vector(N+M-1 downto 0);
signal mult_res52, mult_res116,  mult_res180 , mult_res244  : std_logic_vector(N+M-1 downto 0);
signal mult_res53, mult_res117,  mult_res181 , mult_res245  : std_logic_vector(N+M-1 downto 0);
signal mult_res54, mult_res118,  mult_res182 , mult_res246  : std_logic_vector(N+M-1 downto 0);
signal mult_res55, mult_res119,  mult_res183 , mult_res247  : std_logic_vector(N+M-1 downto 0);
signal mult_res56, mult_res120,  mult_res184 , mult_res248  : std_logic_vector(N+M-1 downto 0);
signal mult_res57, mult_res121,  mult_res185 , mult_res249  : std_logic_vector(N+M-1 downto 0);
signal mult_res58, mult_res122,  mult_res186 , mult_res250  : std_logic_vector(N+M-1 downto 0);
signal mult_res59, mult_res123,  mult_res187 , mult_res251  : std_logic_vector(N+M-1 downto 0);
signal mult_res60, mult_res124,  mult_res188 , mult_res252  : std_logic_vector(N+M-1 downto 0);
signal mult_res61, mult_res125,  mult_res189 , mult_res253  : std_logic_vector(N+M-1 downto 0);
signal mult_res62, mult_res126,  mult_res190 , mult_res254  : std_logic_vector(N+M-1 downto 0);
signal mult_res63, mult_res127,  mult_res191 , mult_res255  : std_logic_vector(N+M-1 downto 0);
signal mult_res64, mult_res128,  mult_res192 , mult_res256  : std_logic_vector(N+M-1 downto 0);

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

signal adder_1_33, adder_1_34, adder_1_35, adder_1_36, adder_1_37, adder_1_38, adder_1_39, adder_1_40, adder_1_41, adder_1_42, adder_1_43, adder_1_44, adder_1_45, adder_1_46, adder_1_47, adder_1_48 : std_logic_vector (N + M downto 0);
signal adder_1_49, adder_1_50, adder_1_51, adder_1_52, adder_1_53, adder_1_54, adder_1_55, adder_1_56, adder_1_57, adder_1_58, adder_1_59, adder_1_60, adder_1_61, adder_1_62, adder_1_63, adder_1_64 : std_logic_vector (N + M downto 0);
signal adder_1_65, adder_1_66, adder_1_67, adder_1_68, adder_1_69, adder_1_70, adder_1_71, adder_1_72, adder_1_73, adder_1_74, adder_1_75, adder_1_76, adder_1_77, adder_1_78, adder_1_79, adder_1_80 : std_logic_vector (N + M downto 0);

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
signal adder_2_21, adder_2_22, adder_2_23, adder_2_24, adder_2_25, adder_2_26, adder_2_27, adder_2_28   : std_logic_vector (N + M + 1 downto 0);


signal adder_3_01         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_02         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_03         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_04         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_05         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_06         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_07         : std_logic_vector (N + M + 2 downto 0);
signal adder_3_08         : std_logic_vector (N + M + 2 downto 0);

signal adder_3_09, adder_3_10, adder_3_11 : std_logic_vector (N + M + 2 downto 0);

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

         mult_res65  <=  d65_in  * w65 ;  mult_res129  <= d129_in * w129;   mult_res193 <= d193_in * w193;
         mult_res66  <=  d66_in  * w66 ;  mult_res130  <= d130_in * w130;   mult_res194 <= d194_in * w194;
         mult_res67  <=  d67_in  * w67 ;  mult_res131  <= d131_in * w131;   mult_res195 <= d195_in * w195;
         mult_res68  <=  d68_in  * w68 ;  mult_res132  <= d132_in * w132;   mult_res196 <= d196_in * w196;
         mult_res69  <=  d69_in  * w69 ;  mult_res133  <= d133_in * w133;   mult_res197 <= d197_in * w197;
         mult_res70  <=  d70_in  * w70 ;  mult_res134  <= d134_in * w134;   mult_res198 <= d198_in * w198;
         mult_res71  <=  d71_in  * w71 ;  mult_res135  <= d135_in * w135;   mult_res199 <= d199_in * w199;
         mult_res72  <=  d72_in  * w72 ;  mult_res136  <= d136_in * w136;   mult_res200 <= d200_in * w200;
         mult_res73  <=  d73_in  * w73 ;  mult_res137  <= d137_in * w137;   mult_res201 <= d201_in * w201;
         mult_res74  <=  d74_in  * w74 ;  mult_res138  <= d138_in * w138;   mult_res202 <= d202_in * w202;
         mult_res75  <=  d75_in  * w75 ;  mult_res139  <= d139_in * w139;   mult_res203 <= d203_in * w203;
         mult_res76  <=  d76_in  * w76 ;  mult_res140  <= d140_in * w140;   mult_res204 <= d204_in * w204;
         mult_res77  <=  d77_in  * w77 ;  mult_res141  <= d141_in * w141;   mult_res205 <= d205_in * w205;
         mult_res78  <=  d78_in  * w78 ;  mult_res142  <= d142_in * w142;   mult_res206 <= d206_in * w206;
         mult_res79  <=  d79_in  * w79 ;  mult_res143  <= d143_in * w143;   mult_res207 <= d207_in * w207;
         mult_res80  <=  d80_in  * w80 ;  mult_res144  <= d144_in * w144;   mult_res208 <= d208_in * w208;
         mult_res81  <=  d81_in  * w81 ;  mult_res145  <= d145_in * w145;   mult_res209 <= d209_in * w209;
         mult_res82  <=  d82_in  * w82 ;  mult_res146  <= d146_in * w146;   mult_res210 <= d210_in * w210;
         mult_res83  <=  d83_in  * w83 ;  mult_res147  <= d147_in * w147;   mult_res211 <= d211_in * w211;
         mult_res84  <=  d84_in  * w84 ;  mult_res148  <= d148_in * w148;   mult_res212 <= d212_in * w212;
         mult_res85  <=  d85_in  * w85 ;  mult_res149  <= d149_in * w149;   mult_res213 <= d213_in * w213;
         mult_res86  <=  d86_in  * w86 ;  mult_res150  <= d150_in * w150;   mult_res214 <= d214_in * w214;
         mult_res87  <=  d87_in  * w87 ;  mult_res151  <= d151_in * w151;   mult_res215 <= d215_in * w215;
         mult_res88  <=  d88_in  * w88 ;  mult_res152  <= d152_in * w152;   mult_res216 <= d216_in * w216;
         mult_res89  <=  d89_in  * w89 ;  mult_res153  <= d153_in * w153;   mult_res217 <= d217_in * w217;
         mult_res90  <=  d90_in  * w90 ;  mult_res154  <= d154_in * w154;   mult_res218 <= d218_in * w218;
         mult_res91  <=  d91_in  * w91 ;  mult_res155  <= d155_in * w155;   mult_res219 <= d219_in * w219;
         mult_res92  <=  d92_in  * w92 ;  mult_res156  <= d156_in * w156;   mult_res220 <= d220_in * w220;
         mult_res93  <=  d93_in  * w93 ;  mult_res157  <= d157_in * w157;   mult_res221 <= d221_in * w221;
         mult_res94  <=  d94_in  * w94 ;  mult_res158  <= d158_in * w158;   mult_res222 <= d222_in * w222;
         mult_res95  <=  d95_in  * w95 ;  mult_res159  <= d159_in * w159;   mult_res223 <= d223_in * w223;
         mult_res96  <=  d96_in  * w96 ;  mult_res160  <= d160_in * w160;   mult_res224 <= d224_in * w224;
         mult_res97  <=  d97_in  * w97 ;  mult_res161  <= d161_in * w161;   mult_res225 <= d225_in * w225;
         mult_res98  <=  d98_in  * w98 ;  mult_res162  <= d162_in * w162;   mult_res226 <= d226_in * w226;
         mult_res99  <=  d99_in  * w99 ;  mult_res163  <= d163_in * w163;   mult_res227 <= d227_in * w227;
         mult_res100 <=  d100_in * w100;  mult_res164  <= d164_in * w164;   mult_res228 <= d228_in * w228;
         mult_res101 <=  d101_in * w101;  mult_res165  <= d165_in * w165;   mult_res229 <= d229_in * w229;
         mult_res102 <=  d102_in * w102;  mult_res166  <= d166_in * w166;   mult_res230 <= d230_in * w230;
         mult_res103 <=  d103_in * w103;  mult_res167  <= d167_in * w167;   mult_res231 <= d231_in * w231;
         mult_res104 <=  d104_in * w104;  mult_res168  <= d168_in * w168;   mult_res232 <= d232_in * w232;
         mult_res105 <=  d105_in * w105;  mult_res169  <= d169_in * w169;   mult_res233 <= d233_in * w233;
         mult_res106 <=  d106_in * w106;  mult_res170  <= d170_in * w170;   mult_res234 <= d234_in * w234;
         mult_res107 <=  d107_in * w107;  mult_res171  <= d171_in * w171;   mult_res235 <= d235_in * w235;
         mult_res108 <=  d108_in * w108;  mult_res172  <= d172_in * w172;   mult_res236 <= d236_in * w236;
         mult_res109 <=  d109_in * w109;  mult_res173  <= d173_in * w173;   mult_res237 <= d237_in * w237;
         mult_res110 <=  d110_in * w110;  mult_res174  <= d174_in * w174;   mult_res238 <= d238_in * w238;
         mult_res111 <=  d111_in * w111;  mult_res175  <= d175_in * w175;   mult_res239 <= d239_in * w239;
         mult_res112 <=  d112_in * w112;  mult_res176  <= d176_in * w176;   mult_res240 <= d240_in * w240;
         mult_res113 <=  d113_in * w113;  mult_res177  <= d177_in * w177;   mult_res241 <= d241_in * w241;
         mult_res114 <=  d114_in * w114;  mult_res178  <= d178_in * w178;   mult_res242 <= d242_in * w242;
         mult_res115 <=  d115_in * w115;  mult_res179  <= d179_in * w179;   mult_res243 <= d243_in * w243;
         mult_res116 <=  d116_in * w116;  mult_res180  <= d180_in * w180;   mult_res244 <= d244_in * w244;
         mult_res117 <=  d117_in * w117;  mult_res181  <= d181_in * w181;   mult_res245 <= d245_in * w245;
         mult_res118 <=  d118_in * w118;  mult_res182  <= d182_in * w182;   mult_res246 <= d246_in * w246;
         mult_res119 <=  d119_in * w119;  mult_res183  <= d183_in * w183;   mult_res247 <= d247_in * w247;
         mult_res120 <=  d120_in * w120;  mult_res184  <= d184_in * w184;   mult_res248 <= d248_in * w248;
         mult_res121 <=  d121_in * w121;  mult_res185  <= d185_in * w185;   mult_res249 <= d249_in * w249;
         mult_res122 <=  d122_in * w122;  mult_res186  <= d186_in * w186;   mult_res250 <= d250_in * w250;
         mult_res123 <=  d123_in * w123;  mult_res187  <= d187_in * w187;   mult_res251 <= d251_in * w251;
         mult_res124 <=  d124_in * w124;  mult_res188  <= d188_in * w188;   mult_res252 <= d252_in * w252;
         mult_res125 <=  d125_in * w125;  mult_res189  <= d189_in * w189;   mult_res253 <= d253_in * w253;
         mult_res126 <=  d126_in * w126;  mult_res190  <= d190_in * w190;   mult_res254 <= d254_in * w254;
         mult_res127 <=  d127_in * w127;  mult_res191  <= d191_in * w191;   mult_res255 <= d255_in * w255;
         mult_res128 <=  d128_in * w128;  mult_res192  <= d192_in * w192;   mult_res256 <= d256_in * w256;
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


  A129: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d129_in, Multiplicand => w129,d_out => mult_res129, en_out => open);
  A130: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d130_in, Multiplicand => w130,d_out => mult_res130, en_out => open);
  A131: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d131_in, Multiplicand => w131,d_out => mult_res131, en_out => open);
  A132: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d132_in, Multiplicand => w132,d_out => mult_res132, en_out => open);
  A133: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d133_in, Multiplicand => w133,d_out => mult_res133, en_out => open);
  A134: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d134_in, Multiplicand => w134,d_out => mult_res134, en_out => open);
  A135: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d135_in, Multiplicand => w135,d_out => mult_res135, en_out => open);
  A136: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d136_in, Multiplicand => w136,d_out => mult_res136, en_out => open);
  A137: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d137_in, Multiplicand => w137,d_out => mult_res137, en_out => open);
  A138: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d138_in, Multiplicand => w138,d_out => mult_res138, en_out => open);
  A139: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d139_in, Multiplicand => w139,d_out => mult_res139, en_out => open);
  A140: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d140_in, Multiplicand => w140,d_out => mult_res140, en_out => open);
  A141: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d141_in, Multiplicand => w141,d_out => mult_res141, en_out => open);
  A142: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d142_in, Multiplicand => w142,d_out => mult_res142, en_out => open);
  A143: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d143_in, Multiplicand => w143,d_out => mult_res143, en_out => open);
  A144: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d144_in, Multiplicand => w144,d_out => mult_res144, en_out => open);
  A145: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d145_in, Multiplicand => w145,d_out => mult_res145, en_out => open);
  A146: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d146_in, Multiplicand => w146,d_out => mult_res146, en_out => open);
  A147: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d147_in, Multiplicand => w147,d_out => mult_res147, en_out => open);
  A148: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d148_in, Multiplicand => w148,d_out => mult_res148, en_out => open);
  A149: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d149_in, Multiplicand => w149,d_out => mult_res149, en_out => open);
  A150: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d150_in, Multiplicand => w150,d_out => mult_res150, en_out => open);
  A151: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d151_in, Multiplicand => w151,d_out => mult_res151, en_out => open);
  A152: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d152_in, Multiplicand => w152,d_out => mult_res152, en_out => open);
  A153: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d153_in, Multiplicand => w153,d_out => mult_res153, en_out => open);
  A154: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d154_in, Multiplicand => w154,d_out => mult_res154, en_out => open);
  A155: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d155_in, Multiplicand => w155,d_out => mult_res155, en_out => open);
  A156: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d156_in, Multiplicand => w156,d_out => mult_res156, en_out => open);
  A157: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d157_in, Multiplicand => w157,d_out => mult_res157, en_out => open);
  A158: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d158_in, Multiplicand => w158,d_out => mult_res158, en_out => open);
  A159: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d159_in, Multiplicand => w159,d_out => mult_res159, en_out => open);
  A160: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d160_in, Multiplicand => w160,d_out => mult_res160, en_out => open);
  A161: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d161_in, Multiplicand => w161,d_out => mult_res161, en_out => open);
  A162: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d162_in, Multiplicand => w162,d_out => mult_res162, en_out => open);
  A163: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d163_in, Multiplicand => w163,d_out => mult_res163, en_out => open);
  A164: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d164_in, Multiplicand => w164,d_out => mult_res164, en_out => open);
  A165: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d165_in, Multiplicand => w165,d_out => mult_res165, en_out => open);
  A166: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d166_in, Multiplicand => w166,d_out => mult_res166, en_out => open);
  A167: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d167_in, Multiplicand => w167,d_out => mult_res167, en_out => open);
  A168: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d168_in, Multiplicand => w168,d_out => mult_res168, en_out => open);
  A169: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d169_in, Multiplicand => w169,d_out => mult_res169, en_out => open);
  A170: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d170_in, Multiplicand => w170,d_out => mult_res170, en_out => open);
  A171: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d171_in, Multiplicand => w171,d_out => mult_res171, en_out => open);
  A172: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d172_in, Multiplicand => w172,d_out => mult_res172, en_out => open);
  A173: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d173_in, Multiplicand => w173,d_out => mult_res173, en_out => open);
  A174: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d174_in, Multiplicand => w174,d_out => mult_res174, en_out => open);
  A175: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d175_in, Multiplicand => w175,d_out => mult_res175, en_out => open);
  A176: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d176_in, Multiplicand => w176,d_out => mult_res176, en_out => open);
  A177: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d177_in, Multiplicand => w177,d_out => mult_res177, en_out => open);
  A178: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d178_in, Multiplicand => w178,d_out => mult_res178, en_out => open);
  A179: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d179_in, Multiplicand => w179,d_out => mult_res179, en_out => open);
  A180: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d180_in, Multiplicand => w180,d_out => mult_res180, en_out => open);
  A181: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d181_in, Multiplicand => w181,d_out => mult_res181, en_out => open);
  A182: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d182_in, Multiplicand => w182,d_out => mult_res182, en_out => open);
  A183: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d183_in, Multiplicand => w183,d_out => mult_res183, en_out => open);
  A184: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d184_in, Multiplicand => w184,d_out => mult_res184, en_out => open);
  A185: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d185_in, Multiplicand => w185,d_out => mult_res185, en_out => open);
  A186: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d186_in, Multiplicand => w186,d_out => mult_res186, en_out => open);
  A187: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d187_in, Multiplicand => w187,d_out => mult_res187, en_out => open);
  A188: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d188_in, Multiplicand => w188,d_out => mult_res188, en_out => open);
  A189: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d189_in, Multiplicand => w189,d_out => mult_res189, en_out => open);
  A190: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d190_in, Multiplicand => w190,d_out => mult_res190, en_out => open);
  A191: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d191_in, Multiplicand => w191,d_out => mult_res191, en_out => open);
  A192: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d192_in, Multiplicand => w192,d_out => mult_res192, en_out => open);


  A193: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d193_in, Multiplicand => w193,d_out => mult_res193, en_out => open);
  A194: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d194_in, Multiplicand => w194,d_out => mult_res194, en_out => open);
  A195: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d195_in, Multiplicand => w195,d_out => mult_res195, en_out => open);
  A196: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d196_in, Multiplicand => w196,d_out => mult_res196, en_out => open);
  A197: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d197_in, Multiplicand => w197,d_out => mult_res197, en_out => open);
  A198: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d198_in, Multiplicand => w198,d_out => mult_res198, en_out => open);
  A199: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d199_in, Multiplicand => w199,d_out => mult_res199, en_out => open);
  A200: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d200_in, Multiplicand => w200,d_out => mult_res200, en_out => open);
  A201: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d201_in, Multiplicand => w201,d_out => mult_res201, en_out => open);
  A202: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d202_in, Multiplicand => w202,d_out => mult_res202, en_out => open);
  A203: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d203_in, Multiplicand => w203,d_out => mult_res203, en_out => open);
  A204: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d204_in, Multiplicand => w204,d_out => mult_res204, en_out => open);
  A205: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d205_in, Multiplicand => w205,d_out => mult_res205, en_out => open);
  A206: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d206_in, Multiplicand => w206,d_out => mult_res206, en_out => open);
  A207: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d207_in, Multiplicand => w207,d_out => mult_res207, en_out => open);
  A208: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d208_in, Multiplicand => w208,d_out => mult_res208, en_out => open);
  A209: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d209_in, Multiplicand => w209,d_out => mult_res209, en_out => open);
  A210: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d210_in, Multiplicand => w210,d_out => mult_res210, en_out => open);
  A211: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d211_in, Multiplicand => w211,d_out => mult_res211, en_out => open);
  A212: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d212_in, Multiplicand => w212,d_out => mult_res212, en_out => open);
  A213: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d213_in, Multiplicand => w213,d_out => mult_res213, en_out => open);
  A214: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d214_in, Multiplicand => w214,d_out => mult_res214, en_out => open);
  A215: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d215_in, Multiplicand => w215,d_out => mult_res215, en_out => open);
  A216: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d216_in, Multiplicand => w216,d_out => mult_res216, en_out => open);
  A217: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d217_in, Multiplicand => w217,d_out => mult_res217, en_out => open);
  A218: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d218_in, Multiplicand => w218,d_out => mult_res218, en_out => open);
  A219: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d219_in, Multiplicand => w219,d_out => mult_res219, en_out => open);
  A220: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d220_in, Multiplicand => w220,d_out => mult_res220, en_out => open);
  A221: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d221_in, Multiplicand => w221,d_out => mult_res221, en_out => open);
  A222: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d222_in, Multiplicand => w222,d_out => mult_res222, en_out => open);
  A223: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d223_in, Multiplicand => w223,d_out => mult_res223, en_out => open);
  A224: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d224_in, Multiplicand => w224,d_out => mult_res224, en_out => open);
  A225: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d225_in, Multiplicand => w225,d_out => mult_res225, en_out => open);
  A226: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d226_in, Multiplicand => w226,d_out => mult_res226, en_out => open);
  A227: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d227_in, Multiplicand => w227,d_out => mult_res227, en_out => open);
  A228: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d228_in, Multiplicand => w228,d_out => mult_res228, en_out => open);
  A229: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d229_in, Multiplicand => w229,d_out => mult_res229, en_out => open);
  A230: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d230_in, Multiplicand => w230,d_out => mult_res230, en_out => open);
  A231: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d231_in, Multiplicand => w231,d_out => mult_res231, en_out => open);
  A232: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d232_in, Multiplicand => w232,d_out => mult_res232, en_out => open);
  A233: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d233_in, Multiplicand => w233,d_out => mult_res233, en_out => open);
  A234: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d234_in, Multiplicand => w234,d_out => mult_res234, en_out => open);
  A235: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d235_in, Multiplicand => w235,d_out => mult_res235, en_out => open);
  A236: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d236_in, Multiplicand => w236,d_out => mult_res236, en_out => open);
  A237: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d237_in, Multiplicand => w237,d_out => mult_res237, en_out => open);
  A238: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d238_in, Multiplicand => w238,d_out => mult_res238, en_out => open);
  A239: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d239_in, Multiplicand => w239,d_out => mult_res239, en_out => open);
  A240: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d240_in, Multiplicand => w240,d_out => mult_res240, en_out => open);
  A241: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d241_in, Multiplicand => w241,d_out => mult_res241, en_out => open);
  A242: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d242_in, Multiplicand => w242,d_out => mult_res242, en_out => open);
  A243: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d243_in, Multiplicand => w243,d_out => mult_res243, en_out => open);
  A244: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d244_in, Multiplicand => w244,d_out => mult_res244, en_out => open);
  A245: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d245_in, Multiplicand => w245,d_out => mult_res245, en_out => open);
  A246: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d246_in, Multiplicand => w246,d_out => mult_res246, en_out => open);
  A247: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d247_in, Multiplicand => w247,d_out => mult_res247, en_out => open);
  A248: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d248_in, Multiplicand => w248,d_out => mult_res248, en_out => open);
  A249: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d249_in, Multiplicand => w249,d_out => mult_res249, en_out => open);
  A250: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d250_in, Multiplicand => w250,d_out => mult_res250, en_out => open);
  A251: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d251_in, Multiplicand => w251,d_out => mult_res251, en_out => open);
  A252: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d252_in, Multiplicand => w252,d_out => mult_res252, en_out => open);
  A253: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d253_in, Multiplicand => w253,d_out => mult_res253, en_out => open);
  A254: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d254_in, Multiplicand => w254,d_out => mult_res254, en_out => open);
  A255: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d255_in, Multiplicand => w255,d_out => mult_res255, en_out => open);
  A256: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => d256_in, Multiplicand => w256,d_out => mult_res256, en_out => open);
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

      adder_1_49  <= (mult_res129(mult_res129'left) & mult_res129) + (mult_res130(mult_res130'left) & mult_res130) + (mult_res131(mult_res131'left) & mult_res131) + (mult_res132(mult_res132'left) & mult_res132); 
      adder_1_50  <= (mult_res133(mult_res133'left) & mult_res133) + (mult_res134(mult_res134'left) & mult_res134) + (mult_res135(mult_res135'left) & mult_res135) + (mult_res136(mult_res136'left) & mult_res136); 
      adder_1_51  <= (mult_res137(mult_res137'left) & mult_res137) + (mult_res138(mult_res138'left) & mult_res138) + (mult_res139(mult_res139'left) & mult_res139) + (mult_res140(mult_res140'left) & mult_res140); 
      adder_1_52  <= (mult_res141(mult_res141'left) & mult_res141) + (mult_res142(mult_res142'left) & mult_res142) + (mult_res143(mult_res143'left) & mult_res143) + (mult_res144(mult_res144'left) & mult_res144); 
      adder_1_53  <= (mult_res145(mult_res145'left) & mult_res145) + (mult_res146(mult_res146'left) & mult_res146) + (mult_res147(mult_res147'left) & mult_res147) + (mult_res148(mult_res148'left) & mult_res148); 
      adder_1_54  <= (mult_res149(mult_res149'left) & mult_res149) + (mult_res150(mult_res150'left) & mult_res150) + (mult_res151(mult_res151'left) & mult_res151) + (mult_res152(mult_res152'left) & mult_res152); 
      adder_1_55  <= (mult_res153(mult_res153'left) & mult_res153) + (mult_res154(mult_res154'left) & mult_res154) + (mult_res155(mult_res155'left) & mult_res155) + (mult_res156(mult_res156'left) & mult_res156); 
      adder_1_56  <= (mult_res157(mult_res157'left) & mult_res157) + (mult_res158(mult_res158'left) & mult_res158) + (mult_res159(mult_res159'left) & mult_res159) + (mult_res160(mult_res160'left) & mult_res160); 
      adder_1_57  <= (mult_res161(mult_res161'left) & mult_res161) + (mult_res162(mult_res162'left) & mult_res162) + (mult_res163(mult_res163'left) & mult_res163) + (mult_res164(mult_res164'left) & mult_res164); 
      adder_1_58  <= (mult_res165(mult_res165'left) & mult_res165) + (mult_res166(mult_res166'left) & mult_res166) + (mult_res167(mult_res167'left) & mult_res167) + (mult_res168(mult_res168'left) & mult_res168); 
      adder_1_59  <= (mult_res169(mult_res169'left) & mult_res169) + (mult_res170(mult_res170'left) & mult_res170) + (mult_res171(mult_res171'left) & mult_res171) + (mult_res172(mult_res172'left) & mult_res172); 
      adder_1_60  <= (mult_res173(mult_res173'left) & mult_res173) + (mult_res174(mult_res174'left) & mult_res174) + (mult_res175(mult_res175'left) & mult_res175) + (mult_res176(mult_res176'left) & mult_res176); 
      adder_1_61  <= (mult_res177(mult_res177'left) & mult_res177) + (mult_res178(mult_res178'left) & mult_res178) + (mult_res179(mult_res179'left) & mult_res179) + (mult_res180(mult_res180'left) & mult_res180); 
      adder_1_62  <= (mult_res181(mult_res181'left) & mult_res181) + (mult_res182(mult_res182'left) & mult_res182) + (mult_res183(mult_res183'left) & mult_res183) + (mult_res184(mult_res184'left) & mult_res184); 
      adder_1_63  <= (mult_res185(mult_res185'left) & mult_res185) + (mult_res186(mult_res186'left) & mult_res186) + (mult_res187(mult_res187'left) & mult_res187) + (mult_res188(mult_res188'left) & mult_res188); 
      adder_1_64  <= (mult_res189(mult_res189'left) & mult_res189) + (mult_res190(mult_res190'left) & mult_res190) + (mult_res191(mult_res191'left) & mult_res191) + (mult_res192(mult_res192'left) & mult_res192); 


      adder_1_65  <= (mult_res193(mult_res193'left) & mult_res193) + (mult_res194(mult_res194'left) & mult_res194) + (mult_res195(mult_res195'left) & mult_res195) + (mult_res196(mult_res196'left) & mult_res196); 
      adder_1_66  <= (mult_res197(mult_res197'left) & mult_res197) + (mult_res198(mult_res198'left) & mult_res198) + (mult_res199(mult_res199'left) & mult_res199) + (mult_res200(mult_res200'left) & mult_res200); 
      adder_1_67  <= (mult_res201(mult_res201'left) & mult_res201) + (mult_res202(mult_res202'left) & mult_res202) + (mult_res203(mult_res203'left) & mult_res203) + (mult_res204(mult_res204'left) & mult_res204); 
      adder_1_68  <= (mult_res205(mult_res205'left) & mult_res205) + (mult_res206(mult_res206'left) & mult_res206) + (mult_res207(mult_res207'left) & mult_res207) + (mult_res208(mult_res208'left) & mult_res208); 
      adder_1_69  <= (mult_res209(mult_res209'left) & mult_res209) + (mult_res210(mult_res210'left) & mult_res210) + (mult_res211(mult_res211'left) & mult_res211) + (mult_res212(mult_res212'left) & mult_res212); 
      adder_1_70  <= (mult_res213(mult_res213'left) & mult_res213) + (mult_res214(mult_res214'left) & mult_res214) + (mult_res215(mult_res215'left) & mult_res215) + (mult_res216(mult_res216'left) & mult_res216); 
      adder_1_71  <= (mult_res217(mult_res217'left) & mult_res217) + (mult_res218(mult_res218'left) & mult_res218) + (mult_res219(mult_res219'left) & mult_res219) + (mult_res220(mult_res220'left) & mult_res220); 
      adder_1_72  <= (mult_res221(mult_res221'left) & mult_res221) + (mult_res222(mult_res222'left) & mult_res222) + (mult_res223(mult_res223'left) & mult_res223) + (mult_res224(mult_res224'left) & mult_res224); 
      adder_1_73  <= (mult_res225(mult_res225'left) & mult_res225) + (mult_res226(mult_res226'left) & mult_res226) + (mult_res227(mult_res227'left) & mult_res227) + (mult_res228(mult_res228'left) & mult_res228); 
      adder_1_74  <= (mult_res229(mult_res229'left) & mult_res229) + (mult_res230(mult_res230'left) & mult_res230) + (mult_res231(mult_res231'left) & mult_res231) + (mult_res232(mult_res232'left) & mult_res232); 
      adder_1_75  <= (mult_res233(mult_res233'left) & mult_res233) + (mult_res234(mult_res234'left) & mult_res234) + (mult_res235(mult_res235'left) & mult_res235) + (mult_res236(mult_res236'left) & mult_res236); 
      adder_1_76  <= (mult_res237(mult_res237'left) & mult_res237) + (mult_res238(mult_res238'left) & mult_res238) + (mult_res239(mult_res239'left) & mult_res239) + (mult_res240(mult_res240'left) & mult_res240); 
      adder_1_77  <= (mult_res241(mult_res241'left) & mult_res241) + (mult_res242(mult_res242'left) & mult_res242) + (mult_res243(mult_res243'left) & mult_res243) + (mult_res244(mult_res244'left) & mult_res244); 
      adder_1_78  <= (mult_res245(mult_res245'left) & mult_res245) + (mult_res246(mult_res246'left) & mult_res246) + (mult_res247(mult_res247'left) & mult_res247) + (mult_res248(mult_res248'left) & mult_res248); 
      adder_1_79  <= (mult_res249(mult_res249'left) & mult_res249) + (mult_res250(mult_res250'left) & mult_res250) + (mult_res251(mult_res251'left) & mult_res251) + (mult_res252(mult_res252'left) & mult_res252); 
      adder_1_80  <= (mult_res253(mult_res253'left) & mult_res253) + (mult_res254(mult_res254'left) & mult_res254) + (mult_res255(mult_res255'left) & mult_res255) + (mult_res256(mult_res256'left) & mult_res256); 

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

      adder_2_21 <= (adder_1_49(adder_1_49'left) & adder_1_49) + (adder_1_50(adder_1_50'left) & adder_1_50) + (adder_1_51(adder_1_51'left) & adder_1_51) + (adder_1_52(adder_1_52'left) & adder_1_52);  
      adder_2_22 <= (adder_1_53(adder_1_53'left) & adder_1_53) + (adder_1_54(adder_1_54'left) & adder_1_54) + (adder_1_55(adder_1_55'left) & adder_1_55) + (adder_1_56(adder_1_56'left) & adder_1_56);  
      adder_2_23 <= (adder_1_57(adder_1_57'left) & adder_1_57) + (adder_1_58(adder_1_58'left) & adder_1_58) + (adder_1_59(adder_1_59'left) & adder_1_59) + (adder_1_60(adder_1_60'left) & adder_1_60);  
      adder_2_24 <= (adder_1_61(adder_1_61'left) & adder_1_61) + (adder_1_62(adder_1_62'left) & adder_1_62) + (adder_1_63(adder_1_63'left) & adder_1_63) + (adder_1_64(adder_1_64'left) & adder_1_64);  
      adder_2_25 <= (adder_1_65(adder_1_65'left) & adder_1_65) + (adder_1_66(adder_1_66'left) & adder_1_66) + (adder_1_67(adder_1_67'left) & adder_1_67) + (adder_1_68(adder_1_68'left) & adder_1_68);  
      adder_2_26 <= (adder_1_69(adder_1_69'left) & adder_1_69) + (adder_1_70(adder_1_70'left) & adder_1_70) + (adder_1_71(adder_1_71'left) & adder_1_71) + (adder_1_72(adder_1_72'left) & adder_1_72);  
      adder_2_27 <= (adder_1_73(adder_1_73'left) & adder_1_73) + (adder_1_74(adder_1_74'left) & adder_1_74) + (adder_1_75(adder_1_75'left) & adder_1_75) + (adder_1_76(adder_1_76'left) & adder_1_76);  
      adder_2_28 <= (adder_1_77(adder_1_77'left) & adder_1_77) + (adder_1_78(adder_1_78'left) & adder_1_78) + (adder_1_79(adder_1_79'left) & adder_1_79) + (adder_1_80(adder_1_80'left) & adder_1_80);  


       adder_3_01     <= (adder_2_01(adder_2_01'left) & adder_2_01) + (adder_2_09(adder_2_09'left) & adder_2_09)
      --adder_3_02  <= (adder_2_02(adder_2_02'left) & adder_2_02) + (adder_2_10(adder_2_10'left) & adder_2_10);
      --adder_3_03  <= (adder_2_03(adder_2_03'left) & adder_2_03) + (adder_2_11(adder_2_11'left) & adder_2_11);
      --adder_3_04  <= (adder_2_04(adder_2_04'left) & adder_2_04) + (adder_2_12(adder_2_12'left) & adder_2_12);
                   + (adder_2_05(adder_2_05'left) & adder_2_05) + (adder_2_13(adder_2_13'left) & adder_2_13);
      --adder_3_06  <= (adder_2_06(adder_2_06'left) & adder_2_06) + (adder_2_14(adder_2_14'left) & adder_2_14);
      --adder_3_07  <= (adder_2_07(adder_2_07'left) & adder_2_07) + (adder_2_15(adder_2_15'left) & adder_2_15);
      --adder_3_08  <= (adder_2_08(adder_2_08'left) & adder_2_08) + (adder_2_16(adder_2_16'left) & adder_2_16);
       adder_3_09 <= (adder_2_17(adder_2_17'left) & adder_2_17) + (adder_2_18(adder_2_18'left) & adder_2_18) + (adder_2_19(adder_2_19'left) & adder_2_19) + (adder_2_20(adder_2_20'left) & adder_2_20);
       adder_3_10 <= (adder_2_21(adder_2_21'left) & adder_2_21) + (adder_2_22(adder_2_22'left) & adder_2_22) + (adder_2_23(adder_2_23'left) & adder_2_23) + (adder_2_24(adder_2_24'left) & adder_2_24);
       adder_3_11 <= (adder_2_25(adder_2_25'left) & adder_2_25) + (adder_2_26(adder_2_26'left) & adder_2_26) + (adder_2_27(adder_2_27'left) & adder_2_27) + (adder_2_28(adder_2_28'left) & adder_2_28);


 d_out(30 downto 0) <= (adder_3_01(adder_3_01'left) & adder_3_01(adder_3_01'left downto 1)) + (adder_3_09(adder_3_09'left) & adder_3_09(adder_3_09'left downto 1))+
                       (adder_3_10(adder_3_10'left) & adder_3_10(adder_3_10'left downto 1)) + (adder_3_11(adder_3_11'left) & adder_3_11(adder_3_11'left downto 1));
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