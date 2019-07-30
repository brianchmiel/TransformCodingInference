library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ConvLayer_calc is
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

           d_out       : out std_logic_vector (N + M +4 downto 0);
           en_out      : out std_logic;
           sof_out     : out std_logic);
end ConvLayer_calc;

architecture a of ConvLayer_calc is

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

component generic_mult is
generic (N: integer; 
         M: integer
         );
port ( 
       clk    :  in  std_logic;
       rst    :  in  std_logic; 
       a      :  in  std_logic_vector(N-1 downto 0);
       b      :  in  std_logic_vector(M-1 downto 0);
       prod   :  out std_logic_vector(M+N-1 downto 0) );
end component;

signal     en_in1, en_end2, en_end3, en_end4, en_sum : std_logic_vector(1 downto 0) ;
--signal en_in1v,  en_in2v,  en_in3v  : std_logic_vector (N-1 downto 0);
--signal en_mid1v, en_mid2v, en_mid3v : std_logic_vector (N-1 downto 0);
--signal en_end1v, en_end2v, en_end3v : std_logic_vector (N-1 downto 0);

--constant fifo_depth : integer := in_col * N / bpp - 3;
--constant fifo_depth : integer := in_col  - 3;
--type t_Memory is array (0 to fifo_depth) of std_logic_vector(N-1 downto 0);
--signal mem_line1_01, mem_line2_01 : t_Memory;



--type t_datacontrol is array (0 to fifo_depth) of std_logic_vector(1 downto 0);
--signal en_line1 : t_datacontrol;
--signal en_line2 : t_datacontrol;

----signal head : std_logic_vector 
--signal Head : natural range 0 to fifo_depth ;
--signal Tail : natural range 0 to fifo_depth ;




signal en2conv     : std_logic_vector(1 downto 0);
signal en_count    : std_logic_vector(1 downto 0);



signal c01         : std_logic_vector (N + M -1 downto 0);
signal c02         : std_logic_vector (N + M -1 downto 0);
signal c03         : std_logic_vector (N + M -1 downto 0);
signal c04         : std_logic_vector (N + M -1 downto 0);
signal c05         : std_logic_vector (N + M -1 downto 0);
signal c06         : std_logic_vector (N + M -1 downto 0);
signal c07         : std_logic_vector (N + M -1 downto 0);
signal c08         : std_logic_vector (N + M -1 downto 0);
signal c09         : std_logic_vector (N + M -1 downto 0);

signal c10         : std_logic_vector (N + M +1 downto 0);
signal c11         : std_logic_vector (N + M +1 downto 0);
signal c12         : std_logic_vector (N + M +1 downto 0);

signal c13         : std_logic_vector (N + M +3 downto 0);

-- kernel 5
signal d01         : std_logic_vector (N + M -1 downto 0);
signal d02         : std_logic_vector (N + M -1 downto 0);
signal d03         : std_logic_vector (N + M -1 downto 0);
signal d04         : std_logic_vector (N + M -1 downto 0);
signal d05         : std_logic_vector (N + M -1 downto 0);
signal d06         : std_logic_vector (N + M -1 downto 0);
signal d07         : std_logic_vector (N + M -1 downto 0);
signal d08         : std_logic_vector (N + M -1 downto 0);
signal d09         : std_logic_vector (N + M -1 downto 0);
signal d10         : std_logic_vector (N + M -1 downto 0);
signal d11         : std_logic_vector (N + M -1 downto 0);
signal d12         : std_logic_vector (N + M -1 downto 0);
signal d13         : std_logic_vector (N + M -1 downto 0);
signal d14         : std_logic_vector (N + M -1 downto 0);
signal d15         : std_logic_vector (N + M -1 downto 0);
signal d16         : std_logic_vector (N + M -1 downto 0);


signal d20         : std_logic_vector (N + M +1 downto 0);
signal d21         : std_logic_vector (N + M +1 downto 0);
signal d22         : std_logic_vector (N + M +1 downto 0);
signal d23         : std_logic_vector (N + M +1 downto 0);
signal d24         : std_logic_vector (N + M +3 downto 0);

signal d_ker       : std_logic_vector (N + M +4 downto 0);

signal d_relu      : std_logic_vector (N + M +4 downto 0);
signal d_ovf       : std_logic_vector (N + M +4 downto 0);

--signal en_conv1, en_conv2, en_conv3, en_conv4, en_conv5, en_conv6    : std_logic_vector(1 downto 0);
signal en_relu, en_ovf     : std_logic_vector(1 downto 0);
signal d_tp        : std_logic_vector (W-1 downto 0);

begin

gen_no_BP: if BP = "no" and TP = "no" generate 

--  insamp2 : process (clk,rst)
--  begin
--    if rst = '1' then
--       en_in1  <= (others => '0');
--       en_end2 <= (others => '0');
--       en_end3 <= (others => '0');
--    elsif rising_edge(clk) then
--       --if en_in = '1' then
--          en_in1(EN_BIT)  <= en_in;
--          en_in1(SOF_BIT) <= sof_in;
--
--
--          en_end2 <= en_in1;
--          --en_end3 <= en_end2;
--          en_end3 <= en_end2;
--       --end if;
--    end if;
--  end process insamp2;

gen_Mults: if mult_sum = "mult" generate 
-- convolution
  p_conv_oper : process (clk)
  begin
    if rising_edge(clk) then
      c01 <= w1 * data2conv1;
      c02 <= w2 * data2conv2;
      c03 <= w3 * data2conv3;
      c04 <= w4 * data2conv4;
      c05 <= w5 * data2conv5;
      c06 <= w6 * data2conv6;
      c07 <= w7 * data2conv7;
      c08 <= w8 * data2conv8;
      c09 <= w9 * data2conv9;
      if Kernel_size = 5 then
         d01 <= w10 * data2conv10 ;
         d02 <= w11 * data2conv11 ;
         d03 <= w12 * data2conv12 ;
         d04 <= w13 * data2conv13 ;
         d05 <= w14 * data2conv14 ;
         d06 <= w15 * data2conv15 ;
         d07 <= w16 * data2conv16 ;
         d08 <= w17 * data2conv17 ;
         d09 <= w18 * data2conv18 ;
         d10 <= w19 * data2conv19 ;
         d11 <= w20 * data2conv20 ;
         d12 <= w21 * data2conv21 ;
         d13 <= w22 * data2conv22 ;
         d14 <= w23 * data2conv23 ;
         d15 <= w24 * data2conv24 ;
         d16 <= w25 * data2conv25 ;
      end if;

    end if;
  end process p_conv_oper;



  p_mult : process (clk,rst)
  begin
    if rst = '1' then
       en_in1  <= (others => '0');
    elsif rising_edge(clk) then
       en_in1(EN_BIT)  <= en_in;     -- c01-c09/d01-d16 out  
       en_in1(SOF_BIT) <= sof_in;
    end if;
  end process p_mult;

end generate;  -- mult

gen_Adds: if mult_sum = "sum" generate 

  --A01: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv1, Multiplicand => w1,d_out => c01, en_out => open);
  --A02: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv2, Multiplicand => w4,d_out => c02, en_out => open);
  --A03: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv3, Multiplicand => w7,d_out => c03, en_out => open);
  --A04: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv1, Multiplicand => w2,d_out => c04, en_out => open);
  --A05: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv2, Multiplicand => w5,d_out => c05, en_out => open);
  --A06: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv3, Multiplicand => w8,d_out => c06, en_out => open);
  --A07: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv1, Multiplicand => w3,d_out => c07, en_out => open);
  --A08: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv2, Multiplicand => w6,d_out => c08, en_out => open);
  --A09: Binary_adder generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv3, Multiplicand => w9,d_out => c09, en_out => open);

  A1: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv1,  b  => w1,  prod => c01);
  A2: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv2,  b  => w2,  prod => c02);
  A3: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv3,  b  => w3,  prod => c03);
  A4: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv4,  b  => w4,  prod => c04);
  A5: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv5,  b  => w5,  prod => c05);
  A6: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv6,  b  => w6,  prod => c06);
  A7: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv7,  b  => w7,  prod => c07);
  A8: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv8,  b  => w8,  prod => c08);
  A9: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv9,  b  => w9,  prod => c09);

sum_kernel5: if Kernel_size = 5 generate
  A10: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv10,b  => w10,  prod => d01);
  A11: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv11,b  => w11,  prod => d02);
  A12: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv12,b  => w12,  prod => d03);
  A13: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv13,b  => w13,  prod => d04);
  A14: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv14,b  => w14,  prod => d05);
  A15: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv15,b  => w15,  prod => d06);
  A16: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv16,b  => w16,  prod => d07);
  A17: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv17,b  => w17,  prod => d08);
  A18: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv18,b  => w18,  prod => d09);
  A19: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv19,b  => w19,  prod => d10);
  A20: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv20,b  => w20,  prod => d11);
  A21: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv21,b  => w21,  prod => d12);
  A22: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv22,b  => w22,  prod => d13);
  A23: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv23,b  => w23,  prod => d14);
  A24: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv24,b  => w24,  prod => d15);
  A25: generic_mult generic map (N => N,M => M) port map ( clk => clk,rst => rst, a => data2conv25,b  => w25,  prod => d16);
end generate;

  p_mult : process (clk,rst)
  begin
    if rst = '1' then
       en_sum  <= (others => '0');
       en_in1  <= (others => '0');
    elsif rising_edge(clk) then
       en_sum(EN_BIT)  <= en_in;
       en_sum(SOF_BIT) <= sof_in;
       en_in1          <= en_sum;
    end if;
  end process p_mult;

end generate; -- sum

  p_conv_oper : process (clk)
  begin
    if rising_edge(clk) then

      c10 <= (c01(c01'left) & c01(c01'left) & c01) + (c02(c02'left) & c02(c02'left) & c02) + (c03(c03'left) & c03(c03'left) & c03);
      c11 <= (c04(c04'left) & c04(c04'left) & c04) + (c05(c05'left) & c05(c05'left) & c05) + (c06(c06'left) & c06(c06'left) & c06);
      c12 <= (c07(c07'left) & c07(c07'left) & c07) + (c08(c08'left) & c08(c08'left) & c08) + (c09(c09'left) & c09(c09'left) & c09);

      c13 <= (c10(c10'left) & c10(c10'left) & c10) + (c11(c11'left) & c11(c11'left) & c11) + (c12(c12'left) & c12(c12'left) & c12);
      if Kernel_size = 5 then
         d20 <= (d01(d01'left) & d01(d01'left) & d01) + (d02(d02'left) & d02(d02'left) & d02) + (d03(d03'left) & d03(d03'left) & d03) + (d04(d04'left) & d04(d04'left) & d04);
         d21 <= (d05(d05'left) & d05(d05'left) & d05) + (d06(d06'left) & d06(d06'left) & d06) + (d07(d07'left) & d07(d07'left) & d07) + (d08(d08'left) & d08(d08'left) & d08);
         d22 <= (d09(d09'left) & d09(d09'left) & d09) + (d10(d10'left) & d10(d10'left) & d10) + (d11(d11'left) & d11(d11'left) & d11) + (d12(d12'left) & d12(d12'left) & d12);
         d23 <= (d13(d13'left) & d13(d13'left) & d13) + (d14(d14'left) & d14(d14'left) & d14) + (d15(d15'left) & d15(d15'left) & d15) + (d16(d16'left) & d16(d16'left) & d16);

         d24 <= (d20(d20'left) & d20(d20'left) & d20) + (d21(d21'left) & d21(d21'left) & d21) + (d22(d22'left) & d22(d22'left) & d22) + (d23(d23'left) & d23(d23'left) & d23);

      end if;

    end if;
  end process p_conv_oper;

--add_kernel5: if Kernel_size = 5 generate
--  p_conv_oper2 : process (clk)
--  begin
--    if rising_edge(clk) then
--      d20 <= (d01(d01'left) & d01(d01'left) & d01) + (d02(d02'left) & d02(d02'left) & d02) + (d03(d03'left) & d03(d03'left) & d03) + (d04(d04'left) & d04(d04'left) & d04);
--      d21 <= (d05(d05'left) & d05(d05'left) & d05) + (d06(d06'left) & d06(d06'left) & d06) + (d07(d07'left) & d07(d07'left) & d07) + (d08(d08'left) & d08(d08'left) & d08);
--      d22 <= (d09(d09'left) & d09(d09'left) & d09) + (d10(d10'left) & d10(d10'left) & d10) + (d11(d11'left) & d11(d11'left) & d11) + (d12(d12'left) & d12(d12'left) & d12);
--      d23 <= (d13(d13'left) & d13(d13'left) & d13) + (d14(d14'left) & d14(d14'left) & d14) + (d15(d15'left) & d15(d15'left) & d15) + (d16(d16'left) & d16(d16'left) & d16);
--
--      d24 <= (d20(d20'left) & d20(d20'left) & d20) + (d21(d21'left) & d21(d21'left) & d21) + (d22(d22'left) & d22(d22'left) & d22) + (d23(d23'left) & d23(d23'left) & d23);
--
--    end if;
--  end process p_conv_oper2;

--end generate;

  insamp2 : process (clk,rst)
  begin
    if rst = '1' then
       en_end2 <= (others => '0');
       en_end3 <= (others => '0');
       en_end4 <= (others => '0');
    elsif rising_edge(clk) then
       en_end2 <= en_in1;
       en_end3 <= en_end2;
       en_end4 <= en_end3;
    end if;
  end process insamp2;

  p_ker : process (clk)
  begin
    if rising_edge(clk) then
       if Kernel_size = 5 then
          d_ker <= (c13(c13'left) & c13) + (d24(d24'left) & d24) ;
       else
          d_ker <= c13(c13'left) & c13;
       end if;
    end if;
  end process p_ker;

--  p_relu : process (clk)
--  begin
--    if rising_edge(clk) then
--      if Relu = "yes" then
--         relu_for: for i in 0 to d_ker'length-1  loop
--           d_relu(i) <= d_ker(i) and not d_ker(d_ker'left);    -- if MSB=1 (negative) thwen all bits are 0
--         end loop relu_for;
--      else
--         d_relu <= d_ker;
--      end if;
--    end if;
--  end process p_relu;
--
--  p_relu_samp : process (clk,rst)
--  begin
--    if rst = '1' then
--       en_relu <= (others => '0');
--    elsif rising_edge(clk) then
--       en_relu <= en_end4;
--    end if;
--  end process p_relu_samp;
--
-- -- check overflow before shift and change value to maximum if overflow occurs
--   p_ovf : process (clk)
--  begin
--    if rising_edge(clk) then
--       --if SR = 0 then
--       --   d_ovf <= d_relu;
--       --else
--          --if d_relu(d_relu'left  downto d_relu'left - SR ) = 0  then
--          if d_relu(d_relu'left  downto W + SR -2) = 0  then
--             d_ovf <= d_relu;
--          else
--             d_ovf( d_relu'left  downto W + SR -2 ) <= (others => '0'); 
--             d_ovf( W + SR - 3   downto         0 ) <= (others => '1'); 
--          end if;
--       --end if;
--    end if;
--  end process p_ovf;
--
-- p_ovf_samp : process (clk,rst)
--  begin
--    if rst = '1' then
--       en_ovf <= (others => '0');
--    elsif rising_edge(clk) then
--       en_ovf <= en_relu;
--    end if;
--  end process p_ovf_samp;

en_out  <= en_end4(EN_BIT);
sof_out <= en_end4(SOF_BIT);
d_out   <= d_ker; 

end generate; -- BP = "no" and TP = "no"

gen_TP_out: if BP = "no" and TP = "yes" generate 
   p_tg_gen : process (clk,rst)
  begin
    if rst = '1' then
       d_tp <= (others => '0');
    elsif rising_edge(clk) then
       if en_in = '1' then
          d_tp <= d_tp + 1;
       end if;
       en_out  <= en_in;
       sof_out <= sof_in;
    end if;
  end process p_tg_gen;
  d_out   <= d_tp;
  
end generate; -- TP = "yes"

gen_BP: if BP = "yes" generate 
 --process (data2conv1, en_in, sof_in)
 --begin
 --   --if d_out'left > data2conv1'left then
 --   ----if W > N then
 --   --   d_out(data2conv1'left downto 0)   <= data2conv1(data2conv1'left downto 0);
 --   --   d_out(d_out'left downto data2conv1'left + 1) <= (others => '0');
 --   --elsif d_out'left = data2conv1'left then
 --   --   d_out <= data2conv1;
 --   --else
 --   --   d_out <= data2conv1(d_out'left downto 0);
 --   --end if;
 --end process ;
    Out_w: if d_out'left > data2conv1'left generate
       d_out(data2conv1'left downto 0)   <= data2conv1(data2conv1'left downto 0);
       d_out(d_out'left downto data2conv1'left + 1) <= (others => '0');
    end generate Out_w;

    InOut_e: if d_out'left = data2conv1'left generate
       d_out <= data2conv1;
    end generate InOut_e;

    In_w: if d_out'left < data2conv1'left generate
       d_out <= data2conv1(d_out'left downto 0);
    end generate In_w;

    en_out  <= en_in;
    sof_out <= sof_in;
 --end process ;

end generate; --  BP = "yes"

end a;