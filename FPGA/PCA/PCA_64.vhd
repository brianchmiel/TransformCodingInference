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

entity PCA_64 is
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
end PCA_64;

architecture a of PCA_64 is

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

type t_acc is array (0 to 64-1) of std_logic_vector(N + M + 5  downto 0);
signal accumulator_vec  : t_acc;


signal en_mult, en_add1, en_add2, en_add3, en_add4, en_add5 : std_logic;
signal sof_mult, sof_add1, sof_add2, sof_add3, sof_add4, sof_add5 : std_logic;

signal d_active           : std_logic_vector (N-1 downto 0);
signal w_active           : std_logic_vector (M-1 downto 0); 
signal feature_sw         : std_logic_vector (  5 downto 0);
signal feature_sw_int     : integer;

begin

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



---- enable propagation
--
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