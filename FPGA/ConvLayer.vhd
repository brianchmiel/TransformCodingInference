library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ConvLayer is
  generic (
  	       mult_sum      : string := "sum";
           N             : integer := 8; -- input data width
           M             : integer := 8; -- input weight width
           W             : integer := 8; -- output data width      (Note, W+SR <= N+M+4)
           SR            : integer := 2; -- data shift right before output
           --bpp           : integer := 8; -- bit per pixel
  	       in_row        : integer := 256;
  	       in_col        : integer := 256
  	       );
  port    (
           clk     : in std_logic;
           rst     : in std_logic;
  	       d_in    : in std_logic_vector (N-1 downto 0);
  	       en_in   : in std_logic;
  	       sof_in  : in std_logic; -- start of frame
  	       --sol     : in std_logic; -- start of line
  	       --eof     : in std_logic; -- end of frame

           w_in    : in std_logic_vector(M-1 downto 0);
           w_num   : in std_logic_vector(  3 downto 0);
           w_en    : in std_logic;

           d_out   : out std_logic_vector (W-1 downto 0);
           en_out  : out std_logic;
           sof_out : out std_logic);
end ConvLayer;

architecture a of ConvLayer is

constant EN_BIT  : integer range 0 to 1 := 0;
constant SOF_BIT : integer range 0 to 1 := 1;

signal w1      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w2      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w3      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w4      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w5      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w6      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w7      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w8      : std_logic_vector(M-1 downto 0); -- weight matrix
signal w9      : std_logic_vector(M-1 downto 0); -- weight matrix

signal d_in1,   d_in2,   d_in3   : std_logic_vector (N-1 downto 0);
signal d_mid1,  d_mid2,  d_mid3  : std_logic_vector (N-1 downto 0);
signal d_end1,  d_end2,  d_end3  : std_logic_vector (N-1 downto 0);
signal en_in1,  en_in2,  en_in3  : std_logic_vector(1 downto 0);
signal en_mid1, en_mid2, en_mid3 : std_logic_vector(1 downto 0);
signal en_end1, en_end2, en_end3 : std_logic_vector(1 downto 0);

--signal en_in1v,  en_in2v,  en_in3v  : std_logic_vector (N-1 downto 0);
--signal en_mid1v, en_mid2v, en_mid3v : std_logic_vector (N-1 downto 0);
--signal en_end1v, en_end2v, en_end3v : std_logic_vector (N-1 downto 0);

--constant fifo_depth : integer := in_col * N / bpp - 3;
constant fifo_depth : integer := in_col  - 3;
type t_Memory is array (0 to fifo_depth) of std_logic_vector(N-1 downto 0);
signal mem_line1 : t_Memory;
signal mem_line2 : t_Memory;


type t_datacontrol is array (0 to fifo_depth) of std_logic_vector(1 downto 0);
signal en_line1 : t_datacontrol;
signal en_line2 : t_datacontrol;

--signal head : std_logic_vector 
signal Head : natural range 0 to fifo_depth ;
signal Tail : natural range 0 to fifo_depth ;

signal row_num           : natural range 0 to in_row;
signal col_num           : natural range 0 to in_col;
signal start_pixel_count : natural range 0 to in_col + 1;
--signal start_sof_count   : natural range 0 to in_col + 1;
signal start_pixel_done  : std_logic;
signal start_sof_done    : std_logic;
--signal start_sof_count_en: std_logic;

signal line_first  ,line_first_d  : std_logic;
signal line_last   ,line_last_d   : std_logic;
signal pixel_first ,pixel_first_d : std_logic;
signal pixel_last  ,pixel_last_d  : std_logic;

signal en2conv     : std_logic_vector(1 downto 0);
signal en_count    : std_logic_vector(1 downto 0);

signal data2conv1  : std_logic_vector (N-1 downto 0);
signal data2conv2  : std_logic_vector (N-1 downto 0);
signal data2conv3  : std_logic_vector (N-1 downto 0);
signal data2conv4  : std_logic_vector (N-1 downto 0);
signal data2conv5  : std_logic_vector (N-1 downto 0);
signal data2conv6  : std_logic_vector (N-1 downto 0);
signal data2conv7  : std_logic_vector (N-1 downto 0);
signal data2conv8  : std_logic_vector (N-1 downto 0);
signal data2conv9  : std_logic_vector (N-1 downto 0);

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

signal c27_d       : std_logic_vector (N + M    downto 0);
signal c30         : std_logic_vector (N + M    downto 0);
signal c31         : std_logic_vector (N + M    downto 0);
signal c32         : std_logic_vector (N + M    downto 0);
signal c33         : std_logic_vector (N + M    downto 0);
signal c34         : std_logic_vector (N + M    downto 0);
signal c35         : std_logic_vector (N + M    downto 0);
signal c36         : std_logic_vector (N + M    downto 0);
signal c37         : std_logic_vector (N + M    downto 0);
signal c38         : std_logic_vector (N + M    downto 0);
signal c39         : std_logic_vector (N + M    downto 0);
signal c40         : std_logic_vector (N + M    downto 0);
signal c41         : std_logic_vector (N + M    downto 0);
signal c42         : std_logic_vector (N + M    downto 0);

signal c50         : std_logic_vector (N + M +1 downto 0);
signal c51         : std_logic_vector (N + M +1 downto 0);
signal c52         : std_logic_vector (N + M +1 downto 0);
signal c53         : std_logic_vector (N + M +1 downto 0);
signal c54         : std_logic_vector (N + M +1 downto 0);
signal c55         : std_logic_vector (N + M +1 downto 0);
signal c56         : std_logic_vector (N + M +1 downto 0);

signal c56_d       : std_logic_vector (N + M +2 downto 0);
signal c60         : std_logic_vector (N + M +2 downto 0);
signal c61         : std_logic_vector (N + M +2 downto 0);
signal c62         : std_logic_vector (N + M +2 downto 0);

signal c70         : std_logic_vector (N + M +3 downto 0);
signal c71         : std_logic_vector (N + M +3 downto 0);

signal c80         : std_logic_vector (N + M +4 downto 0);
signal c80_relu    : std_logic_vector (N + M +4 downto 0);
signal c80_ovf     : std_logic_vector (N + M +4 downto 0);

signal en_conv1, en_conv2, en_conv3, en_conv4, en_conv5, en_conv6    : std_logic_vector(1 downto 0);
signal en_relu, en_ovf     : std_logic_vector(1 downto 0);
begin

-- weight update

  p_weight : process (clk)
  begin
    if rising_edge(clk) then
       if w_en = '1' then
          case w_num is
            when x"1"      =>  w1 <= w_in;
            when x"2"      =>  w2 <= w_in;
            when x"3"      =>  w3 <= w_in;
            when x"4"      =>  w4 <= w_in;
            when x"5"      =>  w5 <= w_in;
            when x"6"      =>  w6 <= w_in;
            when x"7"      =>  w7 <= w_in;
            when x"8"      =>  w8 <= w_in;
            when x"9"      =>  w9 <= w_in;
            when others    =>  null;
          end case;
       end if;
    end if;
  end process p_weight;

-- 3 input samples

  insamp1 : process (clk)
  begin
    if rising_edge(clk) then
       if en_in = '1' then
          d_in1  <= d_in  ;
          d_in2  <= d_in1 ;
          d_in3  <= d_in2 ;

          d_mid2 <= d_mid1;
          d_mid3 <= d_mid2;

          d_end2 <= d_end1;
          d_end3 <= d_end2; 
       end if;
    end if;
  end process insamp1;

  insamp2 : process (clk,rst)
  begin
    if rst = '1' then
       en_in1  <= (others => '0');
       en_in2  <= (others => '0');
       en_in3  <= (others => '0');
       en_mid2 <= (others => '0');
       en_mid3 <= (others => '0');
       en_end2 <= (others => '0');
       en_end3 <= (others => '0');
    elsif rising_edge(clk) then
       if en_in = '1' then
          en_in1(EN_BIT)  <= en_in;
          en_in1(SOF_BIT) <= sof_in;
          en_in2  <= en_in1;
          en_in3  <= en_in2;

          en_mid2 <= en_mid1;
          en_mid3 <= en_mid2;

          en_end2 <= en_end1;
          --en_end3 <= en_end2;
          en_end3 <= en_end2;
       end if;
    end if;
  end process insamp2;

-- 2 lines

  fifo1 : process (clk)
  begin
    if rising_edge(clk) then
       if en_in = '1' then
          mem_line1(tail) <= d_in3;
          mem_line2(tail) <= d_mid3;
          d_mid1 <= mem_line1(head);
          d_end1 <= mem_line2(head);
       end if;
    end if;
  end process fifo1;

  en_shr1 : process (clk,rst)
  begin
    if rst = '1' then
       en_line1 <= (others => (others => '0'));
       en_line2 <= (others => (others => '0'));
       en_mid1  <= (others => '0');
       en_end1  <= (others => '0');
    elsif rising_edge(clk) then
       if en_in = '1' then
          en_line1(tail) <= en_in3;
          en_line2(tail) <= en_mid3;
          en_mid1 <= en_line1(head);
          en_end1 <= en_line2(head);
       end if;
    end if;
  end process en_shr1;


-- fifo control
  fifo_ctr : process (clk,rst)
  begin
    if rst = '1' then
       head <= 0;
       tail <= fifo_depth;
    elsif rising_edge(clk) then
       if en_in = '1' then
          if head =  fifo_depth then
             head <= 0;
          else
             head <= head + 1;
          end if;
          if tail =  fifo_depth then
             tail <= 0;
          else
             tail <= tail + 1;
          end if;
       end if;
    end if;
  end process fifo_ctr;

---- row/column counter
--  rc_cnt : process (clk,rst)
--  begin
--    if rst = '1' then
--       row_num  <= 0;
--       col_num  <= 0;
--    elsif rising_edge(clk) then
--       if en_in = '1' then
--          if sof = '1' then
--             row_num   <= 0;
--             col_num   <= 0;
--          else
--             if col_num =  in_col -1 then
--                col_num <= 0;
--                row_num <= row_num + 1;
--             else
--                col_num <= col_num + 1;
--             end if;
--          end if;
--       end if;
--    end if;
--  end process rc_cnt;

-- convolution padding control
  conv_ctr : process (clk,rst)
  begin
    if rst = '1' then
        row_num   <= 0;
        col_num   <= 0;
        en_count  <= (others => '0');
        start_pixel_count <=  0 ;
        start_pixel_done  <= '0';
        --start_sof_count   <=  0 ;
        --start_sof_done    <= '0';
    elsif rising_edge(clk) then
       if en_in = '1' then
          if en_mid1(SOF_BIT) = '1' then
             row_num   <= 0;
             col_num   <= 0;
             --en_count  <= '1';
          else
             --en_count(EN_BIT)   <= '0';
             if col_num =  in_col -1 then
                col_num <= 0;
                if row_num = in_row - 1 then
                   row_num   <= 0;
                   --start_sof_done <= '1';
                else
                   row_num <= row_num + 1;
                   --start_sof_done <= '0';
                end if;
             else
                col_num <= col_num + 1;
             end if;
          end if;
          if start_pixel_done = '0' then
             start_pixel_count <= start_pixel_count + 1;
             if start_pixel_count = in_col then
                start_pixel_done <= '1';
             end if;
          end if;

        --  if row_num  = 0 and col_num   = 0 then
        --    start_sof_count    <=  0;
        --    start_sof_count_en <= '1';
        --    start_sof_done <= '0';
        --  else
        --     if start_sof_count_en = '1' then
        --        start_sof_count <= start_sof_count + 1;
        --        if start_sof_count = in_col then
        --           start_sof_done <= '1';
        --           start_sof_count_en <= '0';
        --        end if;
        --     else
        --        start_sof_done <= '0';
        --     end if;
        --  end if;
        --  if row_num  = 0 and col_num   = 0 then
        --    start_sof_done <= '1';
        --  else
        --    start_sof_done <= '0';
        --  end if;

       else
          --start_sof_done <= '0';
       end if;
       en_count(EN_BIT)  <= en_in and start_pixel_done;
       en_count(SOF_BIT) <= start_sof_done ; --en_end3(SOF_BIT);
    end if;
  end process conv_ctr;
start_sof_done <= '1' when row_num  = 0 and col_num   = 0 else '0';

 conv_ctr2 : process (row_num, col_num)
  begin
     if col_num  = 0  then
        pixel_first <= '1';
        pixel_last  <= '0';
     elsif col_num =  in_col - 1 then
        pixel_first <= '0';
        pixel_last  <= '1';
      else
        pixel_first <= '0';
        pixel_last  <= '0';
     end if;

     if row_num = 0  then
        line_first <= '1';
        line_last  <= '0';
     elsif row_num =  in_row - 1 then
        line_first <= '0';
        line_last  <= '1';
      else
        line_first <= '0';
        line_last  <= '0';
     end if;
  end process conv_ctr2;

-- data sampling
--  in line 3->2->1
-- mid line 3->2->1  -- mid_2 - convolution point
-- end line 3->2->1

-- Boundary cases:
-- first line  | last line | 1st pixel | last pixel |  
--   V V V     |  0 0 0    |  V V 0    |  0 V V     |  
--   V V V     |  V V V    |  V V 0    |  0 V V     |  
--   0 0 0     |  V V V    |  V V 0    |  0 V V     |  

-- data conv numbering
--   1 2 3
--   4 5 6
--   7 8 9

  samp_conv : process (clk,rst)
  begin
    if rst = '1' then
       data2conv1 <= (others => '0');
       data2conv2 <= (others => '0');
       data2conv3 <= (others => '0');
       data2conv4 <= (others => '0');
       data2conv5 <= (others => '0');
       data2conv6 <= (others => '0');
       data2conv7 <= (others => '0');
       data2conv8 <= (others => '0');
       data2conv9 <= (others => '0');
       en2conv    <= (others => '0');      
    elsif rising_edge(clk) then   
       if line_first = '1' and pixel_first = '1'  then

          data2conv1 <= d_in1  ;
          data2conv2 <= d_in2  ;
          data2conv3 <= (others => '0');

          data2conv4 <= d_mid1 ;
          data2conv6 <= (others => '0');

          data2conv7 <= (others => '0');
          data2conv8 <= (others => '0');
          data2conv9 <= (others => '0');

       elsif line_first = '1' and pixel_last = '1' then

          data2conv1 <= (others => '0');
          data2conv2 <= d_in2;
          data2conv3 <= d_in3;

          data2conv4 <= (others => '0');
          data2conv6 <= d_mid3;

          data2conv7 <= (others => '0');
          data2conv8 <= (others => '0');
          data2conv9 <= (others => '0');

       elsif line_first = '1' then

          data2conv1 <= d_in1  ;
          data2conv2 <= d_in2  ;
          data2conv3 <= d_in3  ;

          data2conv4 <= d_mid1 ;
          data2conv6 <= d_mid3 ;

          data2conv7 <= (others => '0');
          data2conv8 <= (others => '0');
          data2conv9 <= (others => '0');

       elsif line_last = '1' and pixel_first = '1'  then

          data2conv1 <= (others => '0');
          data2conv2 <= (others => '0');
          data2conv3 <= (others => '0');

          data2conv4 <= d_mid1 ;
          data2conv6 <= (others => '0');

          data2conv7 <= d_end1;
          data2conv8 <= d_end2;
          data2conv9 <= (others => '0'); 

       elsif line_last = '1' and pixel_last = '1' then

          data2conv1 <= (others => '0');
          data2conv2 <= (others => '0');
          data2conv3 <= (others => '0'); 

          data2conv4 <= (others => '0');
          data2conv6 <= d_mid3;

          data2conv7 <= (others => '0');
          data2conv8 <= d_end2;
          data2conv9 <= d_end3; 

       elsif line_last = '1' then
          data2conv1 <= (others => '0');
          data2conv2 <= (others => '0');
          data2conv3 <= (others => '0');

          data2conv4 <= d_mid1 ;
          data2conv6 <= d_mid3 ;

          data2conv7 <= d_end1;
          data2conv8 <= d_end2;
          data2conv9 <= d_end3; 

       elsif pixel_first = '1' then
          data2conv1 <= d_in1  ;
          data2conv2 <= d_in2  ;
          data2conv3 <= (others => '0')  ;

          data2conv4 <= d_mid1 ;
          data2conv6 <= (others => '0');

          data2conv7 <= d_end1;
          data2conv8 <= d_end2;
          data2conv9 <= (others => '0');

       elsif pixel_last = '1' then
          data2conv1 <= (others => '0')  ;
          data2conv2 <= d_in2  ;
          data2conv3 <= d_in3  ;

          data2conv4 <= (others => '0');
          data2conv6 <= d_mid3 ;

          data2conv7 <= (others => '0');
          data2conv8 <= d_end2;
          data2conv9 <= d_end3;

       else
          data2conv1 <= d_in1  ;
          data2conv2 <= d_in2  ;
          data2conv3 <= d_in3  ;
          data2conv4 <= d_mid1 ;
          data2conv6 <= d_mid3 ;
          data2conv7 <= d_end1;
          data2conv8 <= d_end2;
          data2conv9 <= d_end3; 
       end if;
       data2conv5 <= d_mid2 ;
       en2conv    <= en_count;
    end if;
  end process samp_conv;

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

      c30 <= (c01(c01'left) & c01) + (c02(c02'left) & c02);
      c31 <= (c03(c03'left) & c03) + (c04(c04'left) & c04);
      c32 <= (c05(c05'left) & c05) + (c06(c06'left) & c06);
      c33 <= (c07(c07'left) & c07) + (c08(c08'left) & c08);
      c34 <= (c09(c09'left) & c09) + (c10(c10'left) & c10);
      c35 <= (c11(c11'left) & c11) + (c12(c12'left) & c12);
      c36 <= (c13(c13'left) & c13) + (c14(c14'left) & c14);
      c37 <= (c15(c15'left) & c15) + (c16(c16'left) & c16);
      c38 <= (c17(c17'left) & c17) + (c18(c18'left) & c18);
      c39 <= (c19(c19'left) & c19) + (c20(c20'left) & c20);
      c40 <= (c21(c21'left) & c21) + (c22(c22'left) & c22);
      c41 <= (c23(c23'left) & c23) + (c24(c24'left) & c24);
      c42 <= (c25(c25'left) & c25) + (c26(c26'left) & c26);
      c27_d <=c27(c27'left) & c27;

      c50 <= (c30(c30'left) & c30) + (c31(c31'left) & c31);
      c51 <= (c32(c32'left) & c32) + (c33(c33'left) & c33);
      c52 <= (c34(c34'left) & c34) + (c35(c35'left) & c35);
      c53 <= (c36(c36'left) & c36) + (c37(c37'left) & c37);
      c54 <= (c38(c38'left) & c38) + (c39(c39'left) & c39);
      c55 <= (c40(c40'left) & c40) + (c41(c41'left) & c41);
      c56 <= (c42(c42'left) & c42) + (c27_d(c27_d'left) & c27_d);

      c60   <= (c50(c50'left) & c50) + (c51(c51'left) & c51);
      c61   <= (c52(c52'left) & c52) + (c53(c53'left) & c53);
      c62   <= (c54(c54'left) & c54) + (c55(c55'left) & c55);
      c56_d <=  c56(c56'left) & c56;

      c70 <= (c60(c60'left) & c60) + (c61  (c61  'left) & c61  );
      c71 <= (c62(c62'left) & c62) + (c56_d(c56_d'left) & c56_d);

      c80 <= (c70(c70'left) & c70) + (c71(c71'left) & c71);
    end if;
  end process p_conv_oper;

  p_conv_oper2 : process (clk,rst)
  begin
    if rst = '1' then
      en_conv1 <= (others => '0');
      en_conv2 <= (others => '0');
      en_conv3 <= (others => '0');
      en_conv4 <= (others => '0');
      en_conv5 <= (others => '0');
      en_conv6 <= (others => '0');
    elsif rising_edge(clk) then
      en_conv1 <= en2conv; 
      en_conv2 <= en_conv1; 
      en_conv3 <= en_conv2;
      en_conv4 <= en_conv3;
      en_conv5 <= en_conv4;
      en_conv6 <= en_conv5;
    end if;
  end process p_conv_oper2;

-- RELU
  p_relu : process (clk)
  begin
    if rising_edge(clk) then
      relu_for: for i in 0 to c80'length-1  loop
        c80_relu(i) <= c80(i) and not c80(c80'left);
       end loop relu_for;
    end if;
  end process p_relu;

  p_relu_samp : process (clk,rst)
  begin
    if rst = '1' then
       en_relu <= (others => '0');
    elsif rising_edge(clk) then
       en_relu <= en_conv6;
    end if;
  end process p_relu_samp;

 -- check overflow before shift and change value to maximum if overflow occurs
   p_ovf : process (clk)
  begin
    if rising_edge(clk) then
    if c80_relu(c80_relu'left downto W + SR ) = 0  then
       c80_ovf <= c80_relu;
    elsif rising_edge(clk) then
       c80_ovf <= (others => '1');
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
d_out   <= c80_ovf (W + SR - 1 downto SR);
end a;