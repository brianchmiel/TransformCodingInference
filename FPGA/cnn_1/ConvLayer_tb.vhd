library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
library work;
use work.ConvLayer_types_package.all;

entity ConvLayer_tb is
    generic (
           Relu          : string := "yes"; --"no"/"yes"  -- nonlinear Relu function
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           TP            : string := "no";  --"no"/"yes"  -- Test pattern output
           mult_sum      : string := "mult"; --"sum"/"mult";
           Kernel_size   : integer := 5; -- 3/5
           zero_padding  : string := "yes";  --"no"/"yes"
           CL_inputs     : integer := 3; -- number of inputs features
           CL_outs       : integer := 2; -- number of output features
           all_width     : integer := 8;
           N             : integer := all_width; -- input data width
           M             : integer := 5; -- input weight width
           W             : integer := all_width; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 4; -- data shift right before output
           --bpp           : integer := 8; -- bit per pixel
           in_row        : integer := 7;
           in_col        : integer := 8
           );
end entity ConvLayer_tb;

architecture ConvLayer_tb of ConvLayer_tb is

component ConvLayer is
  generic (
           Relu          : string := "no"; --"no"/"yes"  -- nonlinear Relu function
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           TP            : string := "no";  --"no"/"yes"  -- Test pattern output
           mult_sum      : string := "sum";
           Kernel_size   : integer := 3; -- 3/5
           zero_padding  : string := "yes";  --"no"/"yes"
           CL_inputs     : integer := 14; -- number of inputs features
           CL_outs       : integer := 4; -- number of output features
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 2; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 2; -- data shift right before output
           in_row        : integer := 256;
           in_col        : integer := 256
           );
  port    (
           clk     : in std_logic;
           rst     : in std_logic;
           d_in    : in vec(0 to CL_inputs -1)(N-1 downto 0);
           en_in   : in std_logic;
           sof_in  : in std_logic; -- start of frame
           --sol     : in std_logic; -- start of line
           --eof     : in std_logic; -- end of frame

           w_unit_n: in std_logic_vector( 15 downto 0);
           w_in    : in std_logic_vector(M-1 downto 0);
           w_num   : in std_logic_vector(  4 downto 0);
           w_en    : in std_logic;

           d_out   : out std_logic_vector (W-1 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end component;

signal clk     : std_logic;
signal rst     : std_logic;
signal d_in    : vec(0 to CL_inputs -1)(N-1 downto 0); 
signal en_in   : std_logic;
signal sof_in  : std_logic; -- start of frame
--signal sol     : std_logic; -- start of line
--signal eof     : std_logic; -- end of frame

signal w_unit_n: std_logic_vector( 15 downto 0);
signal w_in    : std_logic_vector(M-1 downto 0);
signal w_num   : std_logic_vector(  4 downto 0);
signal w_en    : std_logic;
--signal w_en    : std_logic_vector(  9 downto 0);

signal d_out   : std_logic_vector (W-1 downto 0);
signal en_out  : std_logic;
signal sof_out : std_logic; -- start of frame

signal enreg   : std_logic_vector(  7 downto 0) := x"C7";


signal init_w_done : std_logic := '0';
begin




DUT: ConvLayer generic map (
      Relu     => Relu    ,
      BP       => BP      ,
      TP       => TP      ,
      mult_sum => mult_sum,
      Kernel_size   => Kernel_size ,
      zero_padding  => zero_padding,
      CL_inputs     => CL_inputs   ,
      CL_outs       => CL_outs     ,
      N        => N       , -- input data width
      M        => M       , -- input data width
      W        => W       ,-- output data width
      SR       => SR      ,-- output data shift right
      in_row   => in_row  ,
      in_col   => in_col
      )
port map (
      clk     => clk      ,
      rst     => rst      ,
      d_in    => d_in     ,
      en_in   => en_in    ,
      sof_in  => sof_in   ,
      --sol     => sol      ,
      --eof     => eof      ,

     w_unit_n => w_unit_n,
      w_in    => w_in     ,
      w_num   => w_num    ,
      w_en    => w_en     ,

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

process        
   begin   
--     wait for 2 ns;           w_unit_n <= conv_std_logic_vector( 0, w_unit_n'length);
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  1, w_num'length); w_in <= conv_std_logic_vector( 1, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  2, w_num'length); w_in <= conv_std_logic_vector( 2, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  3, w_num'length); w_in <= conv_std_logic_vector( 3, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  4, w_num'length); w_in <= conv_std_logic_vector( 4, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  5, w_num'length); w_in <= conv_std_logic_vector( 5, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  6, w_num'length); w_in <= conv_std_logic_vector( 6, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  7, w_num'length); w_in <= conv_std_logic_vector( 7, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  8, w_num'length); w_in <= conv_std_logic_vector( 8, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  9, w_num'length); w_in <= conv_std_logic_vector( 9, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 10, w_num'length); w_in <= conv_std_logic_vector(10, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 11, w_num'length); w_in <= conv_std_logic_vector(11, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 12, w_num'length); w_in <= conv_std_logic_vector(12, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 13, w_num'length); w_in <= conv_std_logic_vector(13, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 14, w_num'length); w_in <= conv_std_logic_vector(14, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 15, w_num'length); w_in <= conv_std_logic_vector(15, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 16, w_num'length); w_in <= conv_std_logic_vector(16, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 17, w_num'length); w_in <= conv_std_logic_vector(17, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 18, w_num'length); w_in <= conv_std_logic_vector(18, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 19, w_num'length); w_in <= conv_std_logic_vector(19, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 20, w_num'length); w_in <= conv_std_logic_vector(20, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 21, w_num'length); w_in <= conv_std_logic_vector(21, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 22, w_num'length); w_in <= conv_std_logic_vector(22, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 23, w_num'length); w_in <= conv_std_logic_vector(23, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 24, w_num'length); w_in <= conv_std_logic_vector(24, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 25, w_num'length); w_in <= conv_std_logic_vector(25, w_in'length); 
--wait for 10 ns;  w_en <= '0'; w_unit_n <= conv_std_logic_vector( 1, w_unit_n'length);
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  1, w_num'length); w_in <= conv_std_logic_vector( 2, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  2, w_num'length); w_in <= conv_std_logic_vector( 3, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  3, w_num'length); w_in <= conv_std_logic_vector( 4, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  4, w_num'length); w_in <= conv_std_logic_vector( 5, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  5, w_num'length); w_in <= conv_std_logic_vector( 6, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  6, w_num'length); w_in <= conv_std_logic_vector( 7, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  7, w_num'length); w_in <= conv_std_logic_vector( 8, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  8, w_num'length); w_in <= conv_std_logic_vector( 9, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector(  9, w_num'length); w_in <= conv_std_logic_vector(10, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 10, w_num'length); w_in <= conv_std_logic_vector(11, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 11, w_num'length); w_in <= conv_std_logic_vector(12, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 12, w_num'length); w_in <= conv_std_logic_vector(13, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 13, w_num'length); w_in <= conv_std_logic_vector(14, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 14, w_num'length); w_in <= conv_std_logic_vector(15, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 15, w_num'length); w_in <= conv_std_logic_vector(16, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 16, w_num'length); w_in <= conv_std_logic_vector(17, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 17, w_num'length); w_in <= conv_std_logic_vector(18, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 18, w_num'length); w_in <= conv_std_logic_vector(19, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 19, w_num'length); w_in <= conv_std_logic_vector(20, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 20, w_num'length); w_in <= conv_std_logic_vector(21, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 21, w_num'length); w_in <= conv_std_logic_vector(22, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 22, w_num'length); w_in <= conv_std_logic_vector(23, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 23, w_num'length); w_in <= conv_std_logic_vector(24, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 24, w_num'length); w_in <= conv_std_logic_vector(25, w_in'length); 
--     wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( 25, w_num'length); w_in <= conv_std_logic_vector(26, w_in'length); 
--wait for 10 ns;  w_en <= '0'; w_unit_n <= conv_std_logic_vector( 2, w_unit_n'length);
--    gen_3_in: for I in 1 to 25 loop
--        wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( I, w_num'length); w_in <= conv_std_logic_vector(I+2, w_in'length); 
--    end loop gen_3_in;


    gen_inputs: for k in 0 to CL_inputs-1 loop
       gen_outputs: for j in 0 to CL_outs-1 loop
          wait for 10 ns;  w_en <= '0'; w_unit_n <= conv_std_logic_vector( j*256+k, w_unit_n'length);
          gen_w: for i in 1 to 25 loop
              wait for 10 ns; w_en <= '1'; w_num <= conv_std_logic_vector( i, w_num'length); w_in <= conv_std_logic_vector(i+j+k, w_in'length); 
          end loop gen_w;
       end loop gen_outputs;
    end loop gen_inputs;

     wait for 10 ns; init_w_done <= '1';
wait for 1000 ns;  w_en <= '0'; 
end process;


process
begin
  en_in <= '0';
  sof_in <= '0';
--  w1  <= conv_std_logic_vector(17, w1'length);
--  w2  <= conv_std_logic_vector(18, w2'length);
--  w3  <= conv_std_logic_vector(19, w3'length);
--  w4  <= conv_std_logic_vector(20, w4'length);
--  w5  <= conv_std_logic_vector(21, w5'length);
--  w6  <= conv_std_logic_vector(22, w6'length);
--  w7  <= conv_std_logic_vector(23, w7'length);
--  w8  <= conv_std_logic_vector(24, w8'length);
--  w9  <= conv_std_logic_vector(25, w9'length);
--  data2conv1  <= conv_std_logic_vector(1, w1'length);
--  data2conv2  <= conv_std_logic_vector(2, w2'length);
--  data2conv3  <= conv_std_logic_vector(3, w3'length);
--  data2conv4  <= conv_std_logic_vector(4, w4'length);
--  data2conv5  <= conv_std_logic_vector(5, w5'length);
--  data2conv6  <= conv_std_logic_vector(6, w6'length);
--  data2conv7  <= conv_std_logic_vector(7, w7'length);
--  data2conv8  <= conv_std_logic_vector(8, w8'length);
--  data2conv9  <= conv_std_logic_vector(9, w9'length);

  --wait until rst = '0';
  wait until init_w_done = '1';
--    w_num <= conv_std_logic_vector( 0, w_num'length);
--    w_in  <= conv_std_logic_vector( 5, w_in'length);
 --   d_in <= conv_std_logic_vector( 13, d_in'length);
    gen_d_in: for I in 0 to CL_inputs-1 loop
       d_in(I) <= conv_std_logic_vector( 13 + 3*I, W);
    end loop gen_d_in;
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
    wait until rising_edge(clk); 
  while true loop
    sof_in <= '1';
    for i in 0 to 10 loop
      enreg <= enreg(enreg'left - 1 downto 0) & enreg(enreg'left);
      --en_in <= enreg(enreg'left); --'1';  
      en_in <= '1';
  --    w_in   <= w_in + 1;
  --    w_num   <= w_num + 1;
  --    w_en    <= '1';
    --  d_in <= d_in(d_in'left - 1 downto 0) & (d_in(d_in'left) xor d_in(d_in'left - 1));    
      gen2_d_in: for I in 0 to CL_inputs-1 loop
        d_in(I) <= d_in(I)(W-2 downto 0) & (d_in(I)(W-1) xor d_in(I)(W - 2));
      end loop gen2_d_in;
      wait until rising_edge(clk);
      sof_in <= '0';
    end loop;
  end loop;
end process;



--process        
--   begin   
--     wait for 5 ns;
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length); sof_in <= '0';

--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 201, d_in'length); sof_in <= '1';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 202, d_in'length); sof_in <= '0';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 203, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 204, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
---- Line 2
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 205, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 206, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 207, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 208, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

---- Line 3     
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(209, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(210, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(211, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(212, d_in'length);

---- Frame 1
---- Line 1
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 1, d_in'length); sof_in <= '1';
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 2, d_in'length); sof_in <= '0';
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 3, d_in'length);
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 4, d_in'length);
----
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
------ Line 2
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 5, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 6, d_in'length);
----
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 7, d_in'length);
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 8, d_in'length);
----
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
----
------ Line 3     
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 9, d_in'length);
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(10, d_in'length);
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(11, d_in'length);
----     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(12, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

---- Line 1234
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 1, d_in'length); sof_in <= '1';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 2, d_in'length); sof_in <= '0';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 3, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 4, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 5, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 6, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 7, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 8, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 9, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(10, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(11, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(12, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);


---- Line 1234
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 1, d_in'length); sof_in <= '1';
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length); sof_in <= '0';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 2, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 3, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 4, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 5, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 6, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 7, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 8, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 9, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(10, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(11, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(12, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

---- Frame 2
---- Line 1
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(101, d_in'length); sof_in <= '1';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(102, d_in'length); sof_in <= '0';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(103, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(104, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(105, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(106, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(107, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(108, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

---- Line 2
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(109, d_in'length); 
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(110, d_in'length); 
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(111, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(112, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(113, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(114, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(115, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(116, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

---- Line 3
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(117, d_in'length); sof_in <= '1';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(118, d_in'length); sof_in <= '0';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(119, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(120, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(121, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(122, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(123, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(124, d_in'length);

--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

---- Line 4
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(125, d_in'length); sof_in <= '1';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(126, d_in'length); sof_in <= '0';
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(127, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(128, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(129, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(130, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(131, d_in'length);
--     wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector(132, d_in'length);
     
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);
--     wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

--   end process;



end ConvLayer_tb;