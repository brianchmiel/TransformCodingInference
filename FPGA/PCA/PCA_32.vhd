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



signal mult_res    : std_logic_vector (N + M - 1 downto 0);
signal accumulator : std_logic_vector (N + M + 5 downto 0);

type t_acc is array (0 to 32-1) of std_logic_vector(N + M + 5  downto 0);
signal accumulator_vec  : t_acc;



signal en_mult, en_add1, en_add2, en_add3, en_add4, en_add5 : std_logic;
signal sof_mult, sof_add1, sof_add2, sof_add3, sof_add4, sof_add5 : std_logic;

signal d_active           : std_logic_vector (N-1 downto 0);
signal w_active           : std_logic_vector (M-1 downto 0); 
signal feature_sw         : std_logic_vector (  4 downto 0);
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
         mult_res(7 downto 0)  <=  d_active(7 downto 0) * w_active(7 downto 0) ;
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
          accumulator <= accumulator  + ("000000" + mult_res);
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