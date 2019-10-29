library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.math_real.all;
library work;
use work.ConvLayer_types_package.all;

entity ConvLayer is
  generic (
           Relu          : string := "yes";  --"no"/"yes"  -- nonlinear Relu function
           BP            : string := "no";   --"no"/"yes"  -- Bypass
           TP            : string := "no";   --"no"/"yes"  -- Test pattern output
  	       mult_sum      : string := "sum"; --"mult"/"sum";
           Kernel_size   : integer := 5; -- 3/5
           zero_padding  : string := "yes";  --"no"/"yes"
           stride        : integer := 1;
           CL_inputs     : integer := 3; -- number of inputs features
           CL_outs       : integer := 4; -- number of output features

           --CL_outs      : integer := 3; -- number of CL units
           N             : integer := 8; --W; -- input data width
           M             : integer := 8; --W; -- input weight width
           W             : integer := 8; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 1; -- data shift right before output (deleted LSBs)
           --bpp           : integer := 8; -- bit per pixel
  	       in_row        : integer := 114;
  	       in_col        : integer := 114
  	       );
  port    (
           clk     : in std_logic;
           rst     : in std_logic;
  	       d_in    : in vec(0 to CL_inputs -1)(N-1 downto 0); --invec;                                      --std_logic_vector (N-1 downto 0);
  	       en_in   : in std_logic;
  	       sof_in  : in std_logic; -- start of frame
  	       --sol     : in std_logic; -- start of line
  	       --eof     : in std_logic; -- end of frame

           w_unit_n: in std_logic_vector( 15 downto 0);  -- address weight generators,  8MSB - CL inputs, 8LSB - CL outputs
           w_in    : in std_logic_vector(M-1 downto 0);  -- value
           w_num   : in std_logic_vector(  4 downto 0);  -- number of weight
           w_en    : in std_logic;

           d_out   : out vec(0 to CL_outs -1)(W-1 downto 0); --std_logic_vector (W-1 downto 0); --vec;
           en_out  : out std_logic;
           sof_out : out std_logic);
end ConvLayer;

architecture a of ConvLayer is

component ConvLayer_calc is
  generic (
           --Relu          : string := "yes"; --"no"/"yes"  -- nonlinear Relu function
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           TP            : string := "no";  --"no"/"yes"  -- Test pattern output
           mult_sum      : string := "sum"; --"mult"/"sum"
           Kernel_size   : integer := 3; -- 3/5
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 8  -- output data width      (Note, W+SR <= N+M+4)
           --SR            : integer := 2 -- data shift right before output
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
           data2conv10 : in std_logic_vector (N-1 downto 0);
           data2conv11 : in std_logic_vector (N-1 downto 0);
           data2conv12 : in std_logic_vector (N-1 downto 0);
           data2conv13 : in std_logic_vector (N-1 downto 0);
           data2conv14 : in std_logic_vector (N-1 downto 0);
           data2conv15 : in std_logic_vector (N-1 downto 0);
           data2conv16 : in std_logic_vector (N-1 downto 0);
           data2conv17 : in std_logic_vector (N-1 downto 0);
           data2conv18 : in std_logic_vector (N-1 downto 0);
           data2conv19 : in std_logic_vector (N-1 downto 0);
           data2conv20 : in std_logic_vector (N-1 downto 0);
           data2conv21 : in std_logic_vector (N-1 downto 0);
           data2conv22 : in std_logic_vector (N-1 downto 0);
           data2conv23 : in std_logic_vector (N-1 downto 0);
           data2conv24 : in std_logic_vector (N-1 downto 0);
           data2conv25 : in std_logic_vector (N-1 downto 0);
           en_in       : in std_logic;
           sof_in      : in std_logic; -- start of frame
           --sol     : in std_logic; -- start of line
           --eof     : in std_logic; -- end of frame

          w1           : in std_logic_vector(M-1 downto 0); -- weight matrix
          w2           : in std_logic_vector(M-1 downto 0);
          w3           : in std_logic_vector(M-1 downto 0);
          w4           : in std_logic_vector(M-1 downto 0);
          w5           : in std_logic_vector(M-1 downto 0);
          w6           : in std_logic_vector(M-1 downto 0);
          w7           : in std_logic_vector(M-1 downto 0);
          w8           : in std_logic_vector(M-1 downto 0);
          w9           : in std_logic_vector(M-1 downto 0);
          w10          : in std_logic_vector(M-1 downto 0);
          w11          : in std_logic_vector(M-1 downto 0);
          w12          : in std_logic_vector(M-1 downto 0);
          w13          : in std_logic_vector(M-1 downto 0);
          w14          : in std_logic_vector(M-1 downto 0);
          w15          : in std_logic_vector(M-1 downto 0);
          w16          : in std_logic_vector(M-1 downto 0);
          w17          : in std_logic_vector(M-1 downto 0);
          w18          : in std_logic_vector(M-1 downto 0);
          w19          : in std_logic_vector(M-1 downto 0);
          w20          : in std_logic_vector(M-1 downto 0);
          w21          : in std_logic_vector(M-1 downto 0);
          w22          : in std_logic_vector(M-1 downto 0);
          w23          : in std_logic_vector(M-1 downto 0);
          w24          : in std_logic_vector(M-1 downto 0);
          w25          : in std_logic_vector(M-1 downto 0);

           d_out       : out std_logic_vector (N + M +4  downto 0);
           en_out      : out std_logic;
           sof_out     : out std_logic);                     
end component;

component ConvLayer_data_gen is
  generic (
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           mult_sum      : string := "sum";           
           Kernel_size   : integer := 3; -- 3/5
           zero_padding  : string := "yes";  --"no"/"yes"
           stride        : integer := 1;
           N             : integer := 8; -- input data width
     --      M             : integer := 8; -- input weight width
     --      W             : integer := 8; -- output data width      (Note, W+SR <= N+M+4)
     --      SR            : integer := 2; -- data shift right before output
           --bpp           : integer := 8; -- bit per pixel
           in_row        : integer := 256;
           in_col        : integer := 256
           );
  port    (
           clk         : in std_logic;
           rst         : in std_logic;
           d_in        : in std_logic_vector (N-1 downto 0);
           en_in       : in std_logic;
           sof_in      : in std_logic; -- start of frame
           --sol         : in std_logic; -- start of line
           --eof         : in std_logic; -- end of frame


           data2conv1  : out std_logic_vector (N-1 downto 0);
           data2conv2  : out std_logic_vector (N-1 downto 0);
           data2conv3  : out std_logic_vector (N-1 downto 0);
           data2conv4  : out std_logic_vector (N-1 downto 0);
           data2conv5  : out std_logic_vector (N-1 downto 0);
           data2conv6  : out std_logic_vector (N-1 downto 0);
           data2conv7  : out std_logic_vector (N-1 downto 0);
           data2conv8  : out std_logic_vector (N-1 downto 0);
           data2conv9  : out std_logic_vector (N-1 downto 0);
           data2conv10 : out std_logic_vector (N-1 downto 0);
           data2conv11 : out std_logic_vector (N-1 downto 0);
           data2conv12 : out std_logic_vector (N-1 downto 0);
           data2conv13 : out std_logic_vector (N-1 downto 0);
           data2conv14 : out std_logic_vector (N-1 downto 0);
           data2conv15 : out std_logic_vector (N-1 downto 0);
           data2conv16 : out std_logic_vector (N-1 downto 0);
           data2conv17 : out std_logic_vector (N-1 downto 0);
           data2conv18 : out std_logic_vector (N-1 downto 0);
           data2conv19 : out std_logic_vector (N-1 downto 0);
           data2conv20 : out std_logic_vector (N-1 downto 0);
           data2conv21 : out std_logic_vector (N-1 downto 0);
           data2conv22 : out std_logic_vector (N-1 downto 0);
           data2conv23 : out std_logic_vector (N-1 downto 0);
           data2conv24 : out std_logic_vector (N-1 downto 0);
           data2conv25 : out std_logic_vector (N-1 downto 0);

           en_out      : out std_logic;
           sof_out     : out std_logic);
end component;

component ConvLayer_weight_gen is
  generic (
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           M             : integer := 8 -- input weight width
           );
  port    (
           clk         : in std_logic;
           rst         : in std_logic;

           w_in        : in  std_logic_vector(M-1 downto 0);
           w_num       : in  std_logic_vector(  4 downto 0);
           w_en        : in  std_logic;

          w1           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w2           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w3           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w4           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w5           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w6           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w7           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w8           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w9           : out std_logic_vector(M-1 downto 0);  -- weight matrix
          w10          : out std_logic_vector(M-1 downto 0);
          w11          : out std_logic_vector(M-1 downto 0);
          w12          : out std_logic_vector(M-1 downto 0);
          w13          : out std_logic_vector(M-1 downto 0);
          w14          : out std_logic_vector(M-1 downto 0);
          w15          : out std_logic_vector(M-1 downto 0);
          w16          : out std_logic_vector(M-1 downto 0);
          w17          : out std_logic_vector(M-1 downto 0);
          w18          : out std_logic_vector(M-1 downto 0);
          w19          : out std_logic_vector(M-1 downto 0);
          w20          : out std_logic_vector(M-1 downto 0);
          w21          : out std_logic_vector(M-1 downto 0);
          w22          : out std_logic_vector(M-1 downto 0);
          w23          : out std_logic_vector(M-1 downto 0);
          w24          : out std_logic_vector(M-1 downto 0);
          w25          : out std_logic_vector(M-1 downto 0)
           );
end component;

component multi_adder is
  generic (
           Relu          : string := "yes"; --"no"/"yes"  -- nonlinear Relu function
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           TP            : string := "no";  --"no"/"yes"  -- Test pattern output
           CL_inputs     : integer := 3;    -- number of inputs features
           CL_outs       : integer := 6;    -- number of output features
           N             : integer := 8;    -- input data width
           W             : integer := 8;     -- output data width  
           SR            : integer := 2     -- data shift right before output
           );
  port    (
           clk         : in std_logic;
           rst         : in std_logic;
           d_in        : in vec(0 to CL_inputs*CL_outs -1)(N-1 downto 0);

           en_in       : in std_logic;
           sof_in      : in std_logic; -- start of frame

           d_out       : out vec(0 to CL_outs -1)(W-1 downto 0);
           en_out      : out std_logic;
           sof_out     : out std_logic);
end component;


signal w1         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w2         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w3         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w4         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w5         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w6         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w7         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w8         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w9         : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w10        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w11        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w12        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w13        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w14        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w15        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w16        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w17        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w18        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w19        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w20        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w21        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w22        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w23        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w24        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);
signal w25        : vec(0 to CL_outs*CL_inputs -1)(M-1 downto 0);



type t_data2conv is array (0 to CL_inputs-1) of std_logic_vector(N-1 downto 0);
signal data2conv1  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv2  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv3  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv4  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv5  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv6  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv7  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv8  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv9  : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv10 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv11 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv12 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv13 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv14 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv15 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv16 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv17 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv18 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv19 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv20 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv21 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv22 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv23 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv24 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);
signal data2conv25 : t_data2conv;                                   --std_logic_vector (N-1 downto 0);

signal en_s       : std_logic_vector(CL_inputs-1 downto 0);         -- std_logic;
signal sof_s      : std_logic_vector(CL_inputs-1 downto 0);         -- std_logic;

signal w_in_s     : std_logic_vector(M-1 downto 0);
signal w_num_s    : std_logic_vector(  4 downto 0);
--signal w_unit_en  : std_logic_vector (CL_outs-1 downto 0);
signal w_unit_input   : integer;
signal w_unit_output  : integer;

--type d_out_mat is array (natural range 0 to CL_inputs -1) of vec;
type d_out_vec is array (natural range 0 to CL_outs -1) of std_logic_vector(W-1 downto 0); --element;
type d_out_mat is array (natural range 0 to (CL_inputs -1)) of d_out_vec;
--signal d_out1     : d_out_mat;                                      --vec;
signal d_out1     : vec(0 to CL_inputs*CL_outs -1)(N + M +4  downto 0);                                      --vec;

signal d_sums     : vec(0 to CL_outs -1)(W-1 downto 0);
signal w_unit_en  : vec(0 to CL_inputs -1)(CL_outs-1 downto 0);

type t_mat is array (0 to CL_inputs-1) of std_logic_vector(CL_outs-1 downto 0); 
signal en_out1    : t_mat;                                            -- std_logic_vector (CL_outs-1 downto 0);
signal sof_out1   : t_mat;                                            -- std_logic_vector (CL_outs-1 downto 0);

signal countI      : std_logic_vector (9 downto 0);
signal countJ      : std_logic_vector (9 downto 0);

signal en_sums     : std_logic;
signal sof_sums    : std_logic;

begin

w_unit_input  <= conv_integer(unsigned('0' & w_unit_n( 7 downto 0)));
w_unit_output <= conv_integer(unsigned('0' & w_unit_n(15 downto 8)));

w_en_p : process (clk,rst)
--w_en_p : process (w_unit_ni)
begin
   if rst = '1' then
       w_unit_en     <= (others => (others => '0'));
   elsif rising_edge(clk) then
      w_in_s   <= w_in ;
      w_num_s  <= w_num;

      for j in 0 to CL_inputs-1 loop
         for i in 0 to CL_outs-1 loop
            if w_en = '1' then
               if w_unit_input = j and w_unit_output = i then 
                  w_unit_en(j)(i) <= '1';
               else 
                  w_unit_en(j)(i) <= '0';
               end if;
            else
               w_unit_en(j)(i) <= '0';
            end if;
         end loop;
      end loop;
   end if;
end process w_en_p;


gen_inCL: for J in 0 to CL_inputs-1 generate

CL_d_g: ConvLayer_data_gen 
          generic map (
           BP            => BP          ,
           mult_sum      => mult_sum    ,        
           Kernel_size   => Kernel_size ,
           zero_padding  => zero_padding,  
           stride        => stride      ,
           N             => N           , 
          -- M          =>M        ,
          -- W          =>W        ,
          -- SR         =>SR       ,
           in_row        => in_row      ,
           in_col        => in_col      ) 
          port map(
           clk         => clk       ,
           rst         => rst       , 
           d_in        => d_in(J)   ,
           en_in       => en_in     ,
           sof_in      => sof_in    ,

           data2conv1  => data2conv1 (J), 
           data2conv2  => data2conv2 (J), 
           data2conv3  => data2conv3 (J), 
           data2conv4  => data2conv4 (J), 
           data2conv5  => data2conv5 (J), 
           data2conv6  => data2conv6 (J), 
           data2conv7  => data2conv7 (J), 
           data2conv8  => data2conv8 (J), 
           data2conv9  => data2conv9 (J), 
           data2conv10 => data2conv10(J),
           data2conv11 => data2conv11(J),
           data2conv12 => data2conv12(J),
           data2conv13 => data2conv13(J),
           data2conv14 => data2conv14(J),
           data2conv15 => data2conv15(J),
           data2conv16 => data2conv16(J),
           data2conv17 => data2conv17(J),
           data2conv18 => data2conv18(J),
           data2conv19 => data2conv19(J),
           data2conv20 => data2conv20(J),
           data2conv21 => data2conv21(J),
           data2conv22 => data2conv22(J),
           data2conv23 => data2conv23(J),
           data2conv24 => data2conv24(J),
           data2conv25 => data2conv25(J),

           en_out      => en_s (J)      ,
           sof_out     => sof_s(J) 
  );

gen_CL: for I in 0 to CL_outs-1 generate

CL_w_g:  ConvLayer_weight_gen
  generic map (
           BP         => BP         ,
           M          => M          
           )
  port  map  (
           clk        => clk       ,
           rst        => rst       , 

           w_in       => w_in_s    ,
           w_num      => w_num_s   ,
           w_en       => w_unit_en(j)(i)     , --(i)   ,

           w1         => w1 (J*CL_outs + i) ,
           w2         => w2 (J*CL_outs + i) ,
           w3         => w3 (J*CL_outs + i) ,
           w4         => w4 (J*CL_outs + i) ,
           w5         => w5 (J*CL_outs + i) ,
           w6         => w6 (J*CL_outs + i) ,
           w7         => w7 (J*CL_outs + i) ,
           w8         => w8 (J*CL_outs + i) ,
           w9         => w9 (J*CL_outs + i) ,
           w10        => w10(J*CL_outs + i) ,  
           w11        => w11(J*CL_outs + i) ,  
           w12        => w12(J*CL_outs + i) ,  
           w13        => w13(J*CL_outs + i) ,  
           w14        => w14(J*CL_outs + i) ,  
           w15        => w15(J*CL_outs + i) ,  
           w16        => w16(J*CL_outs + i) ,  
           w17        => w17(J*CL_outs + i) ,  
           w18        => w18(J*CL_outs + i) ,  
           w19        => w19(J*CL_outs + i) ,  
           w20        => w20(J*CL_outs + i) ,  
           w21        => w21(J*CL_outs + i) ,  
           w22        => w22(J*CL_outs + i) ,  
           w23        => w23(J*CL_outs + i) ,  
           w24        => w24(J*CL_outs + i) ,  
           w25        => w25(J*CL_outs + i)   
         );


 CL_c:  ConvLayer_calc
  generic map (
          -- Relu       => Relu       ,
           BP         => BP         ,
           TP         => TP         ,
           mult_sum   => mult_sum   ,
           Kernel_size=> Kernel_size,
           N          => N          ,
           M          => M          ,
           W          => W           
           --SR         => SR        
           )
  port  map  ( 
           clk         => clk        ,
           rst         => rst        ,
           data2conv1  => data2conv1 (J),
           data2conv2  => data2conv2 (J),
           data2conv3  => data2conv3 (J),
           data2conv4  => data2conv4 (J),
           data2conv5  => data2conv5 (J),
           data2conv6  => data2conv6 (J),
           data2conv7  => data2conv7 (J),
           data2conv8  => data2conv8 (J),
           data2conv9  => data2conv9 (J),
           data2conv10 => data2conv10(J),
           data2conv11 => data2conv11(J),
           data2conv12 => data2conv12(J),
           data2conv13 => data2conv13(J),
           data2conv14 => data2conv14(J),
           data2conv15 => data2conv15(J),
           data2conv16 => data2conv16(J),
           data2conv17 => data2conv17(J),
           data2conv18 => data2conv18(J),
           data2conv19 => data2conv19(J),
           data2conv20 => data2conv20(J),
           data2conv21 => data2conv21(J),
           data2conv22 => data2conv22(J),
           data2conv23 => data2conv23(J),
           data2conv24 => data2conv24(J),
           data2conv25 => data2conv25(J),
           en_in      => en_s(0)        ,
           sof_in     => sof_s(0)       ,

           w1         => w1 (j*CL_outs + i)     ,
           w2         => w2 (j*CL_outs + i)     ,
           w3         => w3 (j*CL_outs + i)     ,
           w4         => w4 (j*CL_outs + i)     ,
           w5         => w5 (j*CL_outs + i)     ,
           w6         => w6 (j*CL_outs + i)     ,
           w7         => w7 (j*CL_outs + i)     ,
           w8         => w8 (j*CL_outs + i)     ,
           w9         => w9 (j*CL_outs + i)     ,
           w10        => w10(j*CL_outs + i)     ,  
           w11        => w11(j*CL_outs + i)     ,  
           w12        => w12(j*CL_outs + i)     ,  
           w13        => w13(j*CL_outs + i)     ,  
           w14        => w14(j*CL_outs + i)     ,  
           w15        => w15(j*CL_outs + i)     ,  
           w16        => w16(j*CL_outs + i)     ,  
           w17        => w17(j*CL_outs + i)     ,  
           w18        => w18(j*CL_outs + i)     ,  
           w19        => w19(j*CL_outs + i)     ,  
           w20        => w20(j*CL_outs + i)     ,  
           w21        => w21(j*CL_outs + i)     ,  
           w22        => w22(j*CL_outs + i)     ,  
           w23        => w23(j*CL_outs + i)     ,  
           w24        => w24(j*CL_outs + i)     ,  
           w25        => w25(j*CL_outs + i)     ,

           d_out      => d_out1  (j*CL_outs + i) ,
           en_out     => en_out1 (J)(i) ,
           sof_out    => sof_out1(J)(i)
         );

end generate gen_CL;


end generate gen_inCL;


adder: multi_adder
  generic map (
           Relu        => Relu          ,
           BP          => BP            ,
           TP          => TP            ,
           CL_inputs   => CL_inputs     , 
           CL_outs     => CL_outs       ,
           N           => N + M +5      ,
           W           => W             ,            
           SR          => SR            
           )
  port map   (
           clk         => clk           ,
           rst         => rst           ,
           d_in        => d_out1        ,

           en_in       => en_out1 (0)(0),
           sof_in      => sof_out1(0)(0),

           d_out       => d_sums        ,
           en_out      => en_sums       ,
           sof_out     => sof_sums
           );

d_out <= d_sums;
en_out  <= en_sums ;
sof_out <= sof_sums;

end a;