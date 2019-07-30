library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ConvLayer1 is
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
end ConvLayer1;

architecture a of ConvLayer1 is

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

signal     en_in1, en_end2, en_end3 : std_logic_vector(1 downto 0) ;
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
signal c10         : std_logic_vector (N + M -1 downto 0);
signal c11         : std_logic_vector (N + M -1 downto 0);
signal c12         : std_logic_vector (N + M -1 downto 0);
signal c13         : std_logic_vector (N + M -1 downto 0);
signal c14         : std_logic_vector (N + M -1 downto 0);
signal c15         : std_logic_vector (N + M -1 downto 0);
signal c16         : std_logic_vector (N + M -1 downto 0);
signal c17         : std_logic_vector (N + M -1 downto 0);
signal c18         : std_logic_vector (N + M -1 downto 0);
signal c19         : std_logic_vector (N + M -1 downto 0);
signal c20         : std_logic_vector (N + M -1 downto 0);
signal c21         : std_logic_vector (N + M -1 downto 0);
signal c22         : std_logic_vector (N + M -1 downto 0);
signal c23         : std_logic_vector (N + M -1 downto 0);
signal c24         : std_logic_vector (N + M -1 downto 0);
signal c25         : std_logic_vector (N + M -1 downto 0);
signal c26         : std_logic_vector (N + M -1 downto 0);
signal c27         : std_logic_vector (N + M -1 downto 0);


signal c30         : std_logic_vector (N + M +1 downto 0);
signal c31         : std_logic_vector (N + M +1 downto 0);
signal c32         : std_logic_vector (N + M +1 downto 0);
signal c33         : std_logic_vector (N + M +1 downto 0);
signal c34         : std_logic_vector (N + M +1 downto 0);
signal c35         : std_logic_vector (N + M +1 downto 0);
signal c36         : std_logic_vector (N + M +1 downto 0);

signal c37         : std_logic_vector (N + M + 3 downto 0);
signal c38         : std_logic_vector (N + M + 3 downto 0);

signal c39         : std_logic_vector (N + M + 4 downto 0);

signal c39_relu    : std_logic_vector (N + M +4 downto 0);
signal c39_ovf     : std_logic_vector (N + M +4 downto 0);

--signal en_conv1, en_conv2, en_conv3, en_conv4, en_conv5, en_conv6    : std_logic_vector(1 downto 0);
signal en_relu, en_ovf     : std_logic_vector(1 downto 0);


begin

  insamp2 : process (clk,rst)
  begin
    if rst = '1' then
       en_in1  <= (others => '0');
       en_end2 <= (others => '0');
       en_end3 <= (others => '0');
    elsif rising_edge(clk) then
       if en_in = '1' then
          en_in1(EN_BIT)  <= en_in;
          en_in1(SOF_BIT) <= sof_in;


          en_end2 <= en_in1;
          --en_end3 <= en_end2;
          en_end3 <= en_end2;
       end if;
    end if;
  end process insamp2;

gen_Mults: if mult_sum = "mult" generate 
-- convolution
  p_conv_oper : process (clk)
  begin
    if rising_edge(clk) then
      c01 <= w1 * data2conv1;
      c02 <= w4 * data2conv2;
      c03 <= w7 * data2conv3;

      c04 <= w2 * data2conv1;
      c05 <= w5 * data2conv2;
      c06 <= w8 * data2conv3;

      c07 <= w3 * data2conv1;
      c08 <= w6 * data2conv2;
      c09 <= w9 * data2conv3;

      c10 <= w1 * data2conv4;
      c11 <= w4 * data2conv5;
      c12 <= w7 * data2conv6;

      c13 <= w2 * data2conv4;
      c14 <= w5 * data2conv5;
      c15 <= w8 * data2conv6;

      c16 <= w3 * data2conv4;
      c17 <= w6 * data2conv5;
      c18 <= w9 * data2conv6;

      c19 <= w1 * data2conv7;
      c20 <= w4 * data2conv8;
      c21 <= w7 * data2conv9;

      c22 <= w2 * data2conv7;
      c23 <= w5 * data2conv8;
      c24 <= w8 * data2conv9;

      c25 <= w3 * data2conv7;
      c26 <= w6 * data2conv8;
      c27 <= w9 * data2conv9;

      c30 <= (c01(c01'left) & c01(c01'left) & c01) + (c02(c02'left) & c02(c02'left) & c02) + (c03(c03'left) & c03(c03'left) & c03) + (c04(c04'left) & c04(c04'left) & c04);
      c31 <= (c05(c05'left) & c05(c05'left) & c05) + (c06(c06'left) & c06(c06'left) & c06) + (c07(c07'left) & c07(c07'left) & c07) + (c08(c08'left) & c08(c08'left) & c08);
      c32 <= (c09(c09'left) & c09(c09'left) & c09) + (c10(c10'left) & c10(c10'left) & c10) + (c11(c11'left) & c11(c11'left) & c11) + (c12(c12'left) & c12(c12'left) & c12);
      c33 <= (c13(c13'left) & c13(c13'left) & c13) + (c14(c14'left) & c14(c14'left) & c14) + (c15(c15'left) & c15(c15'left) & c15) + (c16(c16'left) & c16(c16'left) & c16);
      c34 <= (c17(c17'left) & c17(c17'left) & c17) + (c18(c18'left) & c18(c18'left) & c18) + (c19(c19'left) & c19(c19'left) & c19) + (c20(c20'left) & c20(c20'left) & c20);
      c35 <= (c21(c21'left) & c21(c21'left) & c21) + (c22(c22'left) & c22(c22'left) & c22) + (c23(c23'left) & c23(c23'left) & c23) + (c24(c24'left) & c24(c24'left) & c24);
      c36 <= (c25(c25'left) & c25(c25'left) & c25) + (c26(c26'left) & c26(c26'left) & c26) + (c27(c27'left) & c27(c27'left) & c27);

      c37 <= (c30(c30'left) & c30(c30'left) & c30) + (c31(c31'left) & c31(c31'left) & c31) + (c32(c32'left) & c32(c32'left) & c32) + (c33(c33'left) & c33(c33'left) & c33);
      c38 <= (c34(c34'left) & c34(c34'left) & c34) + (c35(c35'left) & c35(c35'left) & c35) + (c36(c36'left) & c36(c36'left) & c36);

      c39 <= (c37(c37'left) & c37) + (c38(c38'left) & c38);
    end if;
  end process p_conv_oper;
end generate;

gen_Adds: if mult_sum = "sum" generate 

  A01: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv1, Multiplicand => w1,d_out => c01, en_out => open);
  A02: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv2, Multiplicand => w4,d_out => c02, en_out => open);
  A03: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv3, Multiplicand => w7,d_out => c03, en_out => open);
  A04: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv1, Multiplicand => w2,d_out => c04, en_out => open);
  A05: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv2, Multiplicand => w5,d_out => c05, en_out => open);
  A06: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv3, Multiplicand => w8,d_out => c06, en_out => open);
  A07: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv1, Multiplicand => w3,d_out => c07, en_out => open);
  A08: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv2, Multiplicand => w6,d_out => c08, en_out => open);
  A09: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv3, Multiplicand => w9,d_out => c09, en_out => open);
  A10: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv4, Multiplicand => w1,d_out => c10, en_out => open);
  A11: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv5, Multiplicand => w4,d_out => c11, en_out => open);
  A12: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv6, Multiplicand => w7,d_out => c12, en_out => open);
  A13: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv4, Multiplicand => w2,d_out => c13, en_out => open);
  A14: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv5, Multiplicand => w5,d_out => c14, en_out => open);
  A15: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv6, Multiplicand => w8,d_out => c15, en_out => open);
  A16: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv4, Multiplicand => w3,d_out => c16, en_out => open);
  A17: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv5, Multiplicand => w6,d_out => c17, en_out => open);
  A18: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv6, Multiplicand => w9,d_out => c18, en_out => open);
  A19: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv7, Multiplicand => w1,d_out => c19, en_out => open);
  A20: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv8, Multiplicand => w4,d_out => c20, en_out => open);
  A21: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv9, Multiplicand => w7,d_out => c21, en_out => open);
  A22: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv7, Multiplicand => w2,d_out => c22, en_out => open);
  A23: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv8, Multiplicand => w5,d_out => c23, en_out => open);
  A24: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv9, Multiplicand => w8,d_out => c24, en_out => open);
  A25: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv7, Multiplicand => w3,d_out => c25, en_out => open);
  A26: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv8, Multiplicand => w6,d_out => c26, en_out => open);
  A27: Binary_adder8 generic map (N => N,M => M) port map (clk => clk,rst => rst,en_in => '0', Multiplier => data2conv9, Multiplicand => w9,d_out => c27, en_out => open);

  p_conv_oper : process (clk)
  begin
    if rising_edge(clk) then

      c30 <= (c01(c01'left) & c01(c01'left) & c01) + (c02(c02'left) & c02(c02'left) & c02) + (c03(c03'left) & c03(c03'left) & c03) + (c04(c04'left) & c04(c04'left) & c04);
      c31 <= (c05(c05'left) & c05(c05'left) & c05) + (c06(c06'left) & c06(c06'left) & c06) + (c07(c07'left) & c07(c07'left) & c07) + (c08(c08'left) & c08(c08'left) & c08);
      c32 <= (c09(c09'left) & c09(c09'left) & c09) + (c10(c10'left) & c10(c10'left) & c10) + (c11(c11'left) & c11(c11'left) & c11) + (c12(c12'left) & c12(c12'left) & c12);
      c33 <= (c13(c13'left) & c13(c13'left) & c13) + (c14(c14'left) & c14(c14'left) & c14) + (c15(c15'left) & c15(c15'left) & c15) + (c16(c16'left) & c16(c16'left) & c16);
      c34 <= (c17(c17'left) & c17(c17'left) & c17) + (c18(c18'left) & c18(c18'left) & c18) + (c19(c19'left) & c19(c19'left) & c19) + (c20(c20'left) & c20(c20'left) & c20);
      c35 <= (c21(c21'left) & c21(c21'left) & c21) + (c22(c22'left) & c22(c22'left) & c22) + (c23(c23'left) & c23(c23'left) & c23) + (c24(c24'left) & c24(c24'left) & c24);
      c36 <= (c25(c25'left) & c25(c25'left) & c25) + (c26(c26'left) & c26(c26'left) & c26) + (c27(c27'left) & c27(c27'left) & c27);

      c37 <= (c30(c30'left) & c30(c30'left) & c30) + (c31(c31'left) & c31(c31'left) & c31) + (c32(c32'left) & c32(c32'left) & c32) + (c33(c33'left) & c33(c33'left) & c33);
      c38 <= (c34(c34'left) & c34(c34'left) & c34) + (c35(c35'left) & c35(c35'left) & c35) + (c36(c36'left) & c36(c36'left) & c36);

      c39   <= (c37(c37'left) & c37) + (c38(c38'left) & c38);

    end if;
  end process p_conv_oper;
end generate;


 -- p_conv_oper2 : process (clk,rst)
 -- begin
 --   if rst = '1' then
 --     en_conv1 <= (others => '0');
 --     en_conv2 <= (others => '0');
 --     en_conv3 <= (others => '0');
 --     en_conv4 <= (others => '0');
 --     en_conv5 <= (others => '0');
 --     en_conv6 <= (others => '0');
 --   elsif rising_edge(clk) then
 --     en_conv1 <= en2conv; 
 --     en_conv2 <= en_conv1; 
 --     en_conv3 <= en_conv2;
 --     en_conv4 <= en_conv3;
 --     en_conv5 <= en_conv4;
 --     en_conv6 <= en_conv5;
 --   end if;
 -- end process p_conv_oper2;

-- RELU
  p_relu : process (clk)
  begin
    if rising_edge(clk) then
      relu_for: for i in 0 to c39'length-1  loop
        c39_relu(i) <= c39(i) and not c39(c39'left);
       end loop relu_for;
    end if;
  end process p_relu;

  p_relu_samp : process (clk,rst)
  begin
    if rst = '1' then
       en_relu <= (others => '0');
    elsif rising_edge(clk) then
       en_relu <= en_end3;
    end if;
  end process p_relu_samp;

 -- check overflow before shift and change value to maximum if overflow occurs
   p_ovf : process (clk)
  begin
    if rising_edge(clk) then
    if c39_relu(c39_relu'left downto W + SR ) = 0  then
       c39_ovf <= c39_relu;
    elsif rising_edge(clk) then
       c39_ovf <= (others => '1');
    end if;
    end if;
  end process p_ovf;

 p_ovf_samp : process (clk,rst)
  begin
    if rst = '1' then
       en_ovf <= (others => '0');
    elsif rising_edge(clk) then
       en_ovf <= en_relu;
    end if;
  end process p_ovf_samp;

en_out  <= en_ovf(EN_BIT);
sof_out <= en_ovf(SOF_BIT);
d_out   <= c39_ovf (W + SR - 1 downto SR);
end a;