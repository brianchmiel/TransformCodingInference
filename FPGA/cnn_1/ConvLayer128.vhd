library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ConvLayer128 is
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
end ConvLayer128;

architecture a of ConvLayer128 is

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
signal mem_line1_01, mem_line2_01 : t_Memory;
signal mem_line1_02, mem_line2_02 : t_Memory;
signal mem_line1_03, mem_line2_03 : t_Memory;
signal mem_line1_04, mem_line2_04 : t_Memory;
signal mem_line1_05, mem_line2_05 : t_Memory;
signal mem_line1_06, mem_line2_06 : t_Memory;
signal mem_line1_07, mem_line2_07 : t_Memory;
signal mem_line1_08, mem_line2_08 : t_Memory;
signal mem_line1_09, mem_line2_09 : t_Memory;
signal mem_line1_10, mem_line2_10 : t_Memory;
signal mem_line1_11, mem_line2_11 : t_Memory;
signal mem_line1_12, mem_line2_12 : t_Memory;
signal mem_line1_13, mem_line2_13 : t_Memory;
signal mem_line1_14, mem_line2_14 : t_Memory;
signal mem_line1_15, mem_line2_15 : t_Memory;
signal mem_line1_16, mem_line2_16 : t_Memory;
signal mem_line1_17, mem_line2_17 : t_Memory;
signal mem_line1_18, mem_line2_18 : t_Memory;
signal mem_line1_19, mem_line2_19 : t_Memory;
signal mem_line1_20, mem_line2_20 : t_Memory;
signal mem_line1_21, mem_line2_21 : t_Memory;
signal mem_line1_22, mem_line2_22 : t_Memory;
signal mem_line1_23, mem_line2_23 : t_Memory;
signal mem_line1_24, mem_line2_24 : t_Memory;
signal mem_line1_25, mem_line2_25 : t_Memory;
signal mem_line1_26, mem_line2_26 : t_Memory;
signal mem_line1_27, mem_line2_27 : t_Memory;
signal mem_line1_28, mem_line2_28 : t_Memory;
signal mem_line1_29, mem_line2_29 : t_Memory;
signal mem_line1_30, mem_line2_30 : t_Memory;
signal mem_line1_31, mem_line2_31 : t_Memory;
signal mem_line1_32, mem_line2_32 : t_Memory;
signal mem_line1_33, mem_line2_33 : t_Memory;
signal mem_line1_34, mem_line2_34 : t_Memory;
signal mem_line1_35, mem_line2_35 : t_Memory;
signal mem_line1_36, mem_line2_36 : t_Memory;
signal mem_line1_37, mem_line2_37 : t_Memory;
signal mem_line1_38, mem_line2_38 : t_Memory;
signal mem_line1_39, mem_line2_39 : t_Memory;
signal mem_line1_40, mem_line2_40 : t_Memory;
signal mem_line1_41, mem_line2_41 : t_Memory;
signal mem_line1_42, mem_line2_42 : t_Memory;
signal mem_line1_43, mem_line2_43 : t_Memory;
signal mem_line1_44, mem_line2_44 : t_Memory;
signal mem_line1_45, mem_line2_45 : t_Memory;
signal mem_line1_46, mem_line2_46 : t_Memory;
signal mem_line1_47, mem_line2_47 : t_Memory;
signal mem_line1_48, mem_line2_48 : t_Memory;
signal mem_line1_49, mem_line2_49 : t_Memory;
signal mem_line1_50, mem_line2_50 : t_Memory;
signal mem_line1_51, mem_line2_51 : t_Memory;
signal mem_line1_52, mem_line2_52 : t_Memory;
signal mem_line1_53, mem_line2_53 : t_Memory;
signal mem_line1_54, mem_line2_54 : t_Memory;
signal mem_line1_55, mem_line2_55 : t_Memory;
signal mem_line1_56, mem_line2_56 : t_Memory;
signal mem_line1_57, mem_line2_57 : t_Memory;
signal mem_line1_58, mem_line2_58 : t_Memory;
signal mem_line1_59, mem_line2_59 : t_Memory;
signal mem_line1_60, mem_line2_60 : t_Memory;
signal mem_line1_61, mem_line2_61 : t_Memory;
signal mem_line1_62, mem_line2_62 : t_Memory;
signal mem_line1_63, mem_line2_63 : t_Memory;
signal mem_line1_64, mem_line2_64 : t_Memory;

signal mem_line1_65,  mem_line2_65  : t_Memory;
signal mem_line1_66,  mem_line2_66  : t_Memory;
signal mem_line1_67,  mem_line2_67  : t_Memory;
signal mem_line1_68,  mem_line2_68  : t_Memory;
signal mem_line1_69,  mem_line2_69  : t_Memory;
signal mem_line1_70,  mem_line2_70  : t_Memory;
signal mem_line1_71,  mem_line2_71  : t_Memory;
signal mem_line1_72,  mem_line2_72  : t_Memory;
signal mem_line1_73,  mem_line2_73  : t_Memory;
signal mem_line1_74,  mem_line2_74  : t_Memory;
signal mem_line1_75,  mem_line2_75  : t_Memory;
signal mem_line1_76,  mem_line2_76  : t_Memory;
signal mem_line1_77,  mem_line2_77  : t_Memory;
signal mem_line1_78,  mem_line2_78  : t_Memory;
signal mem_line1_79,  mem_line2_79  : t_Memory;
signal mem_line1_80,  mem_line2_80  : t_Memory;
signal mem_line1_81,  mem_line2_81  : t_Memory;
signal mem_line1_82,  mem_line2_82  : t_Memory;
signal mem_line1_83,  mem_line2_83  : t_Memory;
signal mem_line1_84,  mem_line2_84  : t_Memory;
signal mem_line1_85,  mem_line2_85  : t_Memory;
signal mem_line1_86,  mem_line2_86  : t_Memory;
signal mem_line1_87,  mem_line2_87  : t_Memory;
signal mem_line1_88,  mem_line2_88  : t_Memory;
signal mem_line1_89,  mem_line2_89  : t_Memory;
signal mem_line1_90,  mem_line2_90  : t_Memory;
signal mem_line1_91,  mem_line2_91  : t_Memory;
signal mem_line1_92,  mem_line2_92  : t_Memory;
signal mem_line1_93,  mem_line2_93  : t_Memory;
signal mem_line1_94,  mem_line2_94  : t_Memory;
signal mem_line1_95,  mem_line2_95  : t_Memory;
signal mem_line1_96,  mem_line2_96  : t_Memory;
signal mem_line1_97,  mem_line2_97  : t_Memory;
signal mem_line1_98,  mem_line2_98  : t_Memory;
signal mem_line1_99,  mem_line2_99  : t_Memory;
signal mem_line1_100, mem_line2_100 : t_Memory;
signal mem_line1_101, mem_line2_101 : t_Memory;
signal mem_line1_102, mem_line2_102 : t_Memory;
signal mem_line1_103, mem_line2_103 : t_Memory;
signal mem_line1_104, mem_line2_104 : t_Memory;
signal mem_line1_105, mem_line2_105 : t_Memory;
signal mem_line1_106, mem_line2_106 : t_Memory;
signal mem_line1_107, mem_line2_107 : t_Memory;
signal mem_line1_108, mem_line2_108 : t_Memory;
signal mem_line1_109, mem_line2_109 : t_Memory;
signal mem_line1_110, mem_line2_110 : t_Memory;
signal mem_line1_111, mem_line2_111 : t_Memory;
signal mem_line1_112, mem_line2_112 : t_Memory;
signal mem_line1_113, mem_line2_113 : t_Memory;
signal mem_line1_114, mem_line2_114 : t_Memory;
signal mem_line1_115, mem_line2_115 : t_Memory;
signal mem_line1_116, mem_line2_116 : t_Memory;
signal mem_line1_117, mem_line2_117 : t_Memory;
signal mem_line1_118, mem_line2_118 : t_Memory;
signal mem_line1_119, mem_line2_119 : t_Memory;
signal mem_line1_120, mem_line2_120 : t_Memory;
signal mem_line1_121, mem_line2_121 : t_Memory;
signal mem_line1_122, mem_line2_122 : t_Memory;
signal mem_line1_123, mem_line2_123 : t_Memory;
signal mem_line1_124, mem_line2_124 : t_Memory;
signal mem_line1_125, mem_line2_125 : t_Memory;
signal mem_line1_126, mem_line2_126 : t_Memory;
signal mem_line1_127, mem_line2_127 : t_Memory;
signal mem_line1_128, mem_line2_128 : t_Memory;


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

signal feature_sw  : std_logic_vector (6 downto 0);
signal feature_sw_int  : integer;
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
  switch : process (clk,rst)
  begin
    if rst = '1' then
       feature_sw  <= (others => '0');
    elsif rising_edge(clk) then
       if en_in = '1' then
          feature_sw <= feature_sw + 1;
       end if;
    end if;
  end process switch;

feature_sw_int <= conv_integer('0' & feature_sw);
  fifo1 : process (clk)
  begin
    if rising_edge(clk) then
       if en_in = '1' then
        case feature_sw_int is
          when   0 => mem_line1_01(tail)  <= d_in3; mem_line2_01(tail)  <= d_mid3; d_mid1 <= mem_line1_01(head);  d_end1 <= mem_line2_01(head);
          when   1 => mem_line1_02(tail)  <= d_in3; mem_line2_02(tail)  <= d_mid3; d_mid1 <= mem_line1_02(head);  d_end1 <= mem_line2_02(head);
          when   2 => mem_line1_03(tail)  <= d_in3; mem_line2_03(tail)  <= d_mid3; d_mid1 <= mem_line1_03(head);  d_end1 <= mem_line2_03(head);
          when   3 => mem_line1_04(tail)  <= d_in3; mem_line2_04(tail)  <= d_mid3; d_mid1 <= mem_line1_04(head);  d_end1 <= mem_line2_04(head);
          when   4 => mem_line1_05(tail)  <= d_in3; mem_line2_05(tail)  <= d_mid3; d_mid1 <= mem_line1_05(head);  d_end1 <= mem_line2_05(head);
          when   5 => mem_line1_06(tail)  <= d_in3; mem_line2_06(tail)  <= d_mid3; d_mid1 <= mem_line1_06(head);  d_end1 <= mem_line2_06(head);
          when   6 => mem_line1_07(tail)  <= d_in3; mem_line2_07(tail)  <= d_mid3; d_mid1 <= mem_line1_07(head);  d_end1 <= mem_line2_07(head);
          when   7 => mem_line1_08(tail)  <= d_in3; mem_line2_08(tail)  <= d_mid3; d_mid1 <= mem_line1_08(head);  d_end1 <= mem_line2_08(head);
          when   8 => mem_line1_09(tail)  <= d_in3; mem_line2_09(tail)  <= d_mid3; d_mid1 <= mem_line1_09(head);  d_end1 <= mem_line2_09(head);
          when   9 => mem_line1_10(tail)  <= d_in3; mem_line2_10(tail)  <= d_mid3; d_mid1 <= mem_line1_10(head);  d_end1 <= mem_line2_10(head);
          when  10 => mem_line1_11(tail)  <= d_in3; mem_line2_11(tail)  <= d_mid3; d_mid1 <= mem_line1_11(head);  d_end1 <= mem_line2_11(head);
          when  11 => mem_line1_12(tail)  <= d_in3; mem_line2_12(tail)  <= d_mid3; d_mid1 <= mem_line1_12(head);  d_end1 <= mem_line2_12(head);
          when  12 => mem_line1_13(tail)  <= d_in3; mem_line2_13(tail)  <= d_mid3; d_mid1 <= mem_line1_13(head);  d_end1 <= mem_line2_13(head);
          when  13 => mem_line1_14(tail)  <= d_in3; mem_line2_14(tail)  <= d_mid3; d_mid1 <= mem_line1_14(head);  d_end1 <= mem_line2_14(head);
          when  14 => mem_line1_15(tail)  <= d_in3; mem_line2_15(tail)  <= d_mid3; d_mid1 <= mem_line1_15(head);  d_end1 <= mem_line2_15(head);
          when  15 => mem_line1_16(tail)  <= d_in3; mem_line2_16(tail)  <= d_mid3; d_mid1 <= mem_line1_16(head);  d_end1 <= mem_line2_16(head);
          when  16 => mem_line1_17(tail)  <= d_in3; mem_line2_17(tail)  <= d_mid3; d_mid1 <= mem_line1_17(head);  d_end1 <= mem_line2_17(head);
          when  17 => mem_line1_18(tail)  <= d_in3; mem_line2_18(tail)  <= d_mid3; d_mid1 <= mem_line1_18(head);  d_end1 <= mem_line2_18(head);
          when  18 => mem_line1_19(tail)  <= d_in3; mem_line2_19(tail)  <= d_mid3; d_mid1 <= mem_line1_19(head);  d_end1 <= mem_line2_19(head);
          when  19 => mem_line1_20(tail)  <= d_in3; mem_line2_20(tail)  <= d_mid3; d_mid1 <= mem_line1_20(head);  d_end1 <= mem_line2_20(head);
          when  20 => mem_line1_21(tail)  <= d_in3; mem_line2_21(tail)  <= d_mid3; d_mid1 <= mem_line1_21(head);  d_end1 <= mem_line2_21(head);
          when  21 => mem_line1_22(tail)  <= d_in3; mem_line2_22(tail)  <= d_mid3; d_mid1 <= mem_line1_22(head);  d_end1 <= mem_line2_22(head);
          when  22 => mem_line1_23(tail)  <= d_in3; mem_line2_23(tail)  <= d_mid3; d_mid1 <= mem_line1_23(head);  d_end1 <= mem_line2_23(head);
          when  23 => mem_line1_24(tail)  <= d_in3; mem_line2_24(tail)  <= d_mid3; d_mid1 <= mem_line1_24(head);  d_end1 <= mem_line2_24(head);
          when  24 => mem_line1_25(tail)  <= d_in3; mem_line2_25(tail)  <= d_mid3; d_mid1 <= mem_line1_25(head);  d_end1 <= mem_line2_25(head);
          when  25 => mem_line1_26(tail)  <= d_in3; mem_line2_26(tail)  <= d_mid3; d_mid1 <= mem_line1_26(head);  d_end1 <= mem_line2_26(head);
          when  26 => mem_line1_27(tail)  <= d_in3; mem_line2_27(tail)  <= d_mid3; d_mid1 <= mem_line1_27(head);  d_end1 <= mem_line2_27(head);
          when  27 => mem_line1_28(tail)  <= d_in3; mem_line2_28(tail)  <= d_mid3; d_mid1 <= mem_line1_28(head);  d_end1 <= mem_line2_28(head);
          when  28 => mem_line1_29(tail)  <= d_in3; mem_line2_29(tail)  <= d_mid3; d_mid1 <= mem_line1_29(head);  d_end1 <= mem_line2_29(head);
          when  29 => mem_line1_30(tail)  <= d_in3; mem_line2_30(tail)  <= d_mid3; d_mid1 <= mem_line1_30(head);  d_end1 <= mem_line2_30(head);
          when  30 => mem_line1_31(tail)  <= d_in3; mem_line2_31(tail)  <= d_mid3; d_mid1 <= mem_line1_31(head);  d_end1 <= mem_line2_31(head);
          when  31 => mem_line1_32(tail)  <= d_in3; mem_line2_32(tail)  <= d_mid3; d_mid1 <= mem_line1_32(head);  d_end1 <= mem_line2_32(head);
          when  32 => mem_line1_33(tail)  <= d_in3; mem_line2_33(tail)  <= d_mid3; d_mid1 <= mem_line1_33(head);  d_end1 <= mem_line2_33(head);
          when  33 => mem_line1_34(tail)  <= d_in3; mem_line2_34(tail)  <= d_mid3; d_mid1 <= mem_line1_34(head);  d_end1 <= mem_line2_34(head);
          when  34 => mem_line1_35(tail)  <= d_in3; mem_line2_35(tail)  <= d_mid3; d_mid1 <= mem_line1_35(head);  d_end1 <= mem_line2_35(head);
          when  35 => mem_line1_36(tail)  <= d_in3; mem_line2_36(tail)  <= d_mid3; d_mid1 <= mem_line1_36(head);  d_end1 <= mem_line2_36(head);
          when  36 => mem_line1_37(tail)  <= d_in3; mem_line2_37(tail)  <= d_mid3; d_mid1 <= mem_line1_37(head);  d_end1 <= mem_line2_37(head);
          when  37 => mem_line1_38(tail)  <= d_in3; mem_line2_38(tail)  <= d_mid3; d_mid1 <= mem_line1_38(head);  d_end1 <= mem_line2_38(head);
          when  38 => mem_line1_39(tail)  <= d_in3; mem_line2_39(tail)  <= d_mid3; d_mid1 <= mem_line1_39(head);  d_end1 <= mem_line2_39(head);
          when  39 => mem_line1_40(tail)  <= d_in3; mem_line2_40(tail)  <= d_mid3; d_mid1 <= mem_line1_40(head);  d_end1 <= mem_line2_40(head);
          when  40 => mem_line1_41(tail)  <= d_in3; mem_line2_41(tail)  <= d_mid3; d_mid1 <= mem_line1_41(head);  d_end1 <= mem_line2_41(head);
          when  41 => mem_line1_42(tail)  <= d_in3; mem_line2_42(tail)  <= d_mid3; d_mid1 <= mem_line1_42(head);  d_end1 <= mem_line2_42(head);
          when  42 => mem_line1_43(tail)  <= d_in3; mem_line2_43(tail)  <= d_mid3; d_mid1 <= mem_line1_43(head);  d_end1 <= mem_line2_43(head);
          when  43 => mem_line1_44(tail)  <= d_in3; mem_line2_44(tail)  <= d_mid3; d_mid1 <= mem_line1_44(head);  d_end1 <= mem_line2_44(head);
          when  44 => mem_line1_45(tail)  <= d_in3; mem_line2_45(tail)  <= d_mid3; d_mid1 <= mem_line1_45(head);  d_end1 <= mem_line2_45(head);
          when  45 => mem_line1_46(tail)  <= d_in3; mem_line2_46(tail)  <= d_mid3; d_mid1 <= mem_line1_46(head);  d_end1 <= mem_line2_46(head);
          when  46 => mem_line1_47(tail)  <= d_in3; mem_line2_47(tail)  <= d_mid3; d_mid1 <= mem_line1_47(head);  d_end1 <= mem_line2_47(head);
          when  47 => mem_line1_48(tail)  <= d_in3; mem_line2_48(tail)  <= d_mid3; d_mid1 <= mem_line1_48(head);  d_end1 <= mem_line2_48(head);
          when  48 => mem_line1_49(tail)  <= d_in3; mem_line2_49(tail)  <= d_mid3; d_mid1 <= mem_line1_49(head);  d_end1 <= mem_line2_49(head);
          when  49 => mem_line1_50(tail)  <= d_in3; mem_line2_50(tail)  <= d_mid3; d_mid1 <= mem_line1_50(head);  d_end1 <= mem_line2_50(head);
          when  50 => mem_line1_51(tail)  <= d_in3; mem_line2_51(tail)  <= d_mid3; d_mid1 <= mem_line1_51(head);  d_end1 <= mem_line2_51(head);
          when  51 => mem_line1_52(tail)  <= d_in3; mem_line2_52(tail)  <= d_mid3; d_mid1 <= mem_line1_52(head);  d_end1 <= mem_line2_52(head);
          when  52 => mem_line1_53(tail)  <= d_in3; mem_line2_53(tail)  <= d_mid3; d_mid1 <= mem_line1_53(head);  d_end1 <= mem_line2_53(head);
          when  53 => mem_line1_54(tail)  <= d_in3; mem_line2_54(tail)  <= d_mid3; d_mid1 <= mem_line1_54(head);  d_end1 <= mem_line2_54(head);
          when  54 => mem_line1_55(tail)  <= d_in3; mem_line2_55(tail)  <= d_mid3; d_mid1 <= mem_line1_55(head);  d_end1 <= mem_line2_55(head);
          when  55 => mem_line1_56(tail)  <= d_in3; mem_line2_56(tail)  <= d_mid3; d_mid1 <= mem_line1_56(head);  d_end1 <= mem_line2_56(head);
          when  56 => mem_line1_57(tail)  <= d_in3; mem_line2_57(tail)  <= d_mid3; d_mid1 <= mem_line1_57(head);  d_end1 <= mem_line2_57(head);
          when  57 => mem_line1_58(tail)  <= d_in3; mem_line2_58(tail)  <= d_mid3; d_mid1 <= mem_line1_58(head);  d_end1 <= mem_line2_58(head);
          when  58 => mem_line1_59(tail)  <= d_in3; mem_line2_59(tail)  <= d_mid3; d_mid1 <= mem_line1_59(head);  d_end1 <= mem_line2_59(head);
          when  59 => mem_line1_60(tail)  <= d_in3; mem_line2_60(tail)  <= d_mid3; d_mid1 <= mem_line1_60(head);  d_end1 <= mem_line2_60(head);
          when  60 => mem_line1_61(tail)  <= d_in3; mem_line2_61(tail)  <= d_mid3; d_mid1 <= mem_line1_61(head);  d_end1 <= mem_line2_61(head);
          when  61 => mem_line1_62(tail)  <= d_in3; mem_line2_62(tail)  <= d_mid3; d_mid1 <= mem_line1_62(head);  d_end1 <= mem_line2_62(head);
          when  62 => mem_line1_63(tail)  <= d_in3; mem_line2_63(tail)  <= d_mid3; d_mid1 <= mem_line1_63(head);  d_end1 <= mem_line2_63(head);
          when  63 => mem_line1_64(tail)  <= d_in3; mem_line2_64(tail)  <= d_mid3; d_mid1 <= mem_line1_64(head);  d_end1 <= mem_line2_64(head);

          when  64 => mem_line1_65 (tail) <= d_in3; mem_line2_65 (tail) <= d_mid3; d_mid1 <= mem_line1_65 (head); d_end1 <= mem_line2_65 (head);
          when  65 => mem_line1_66 (tail) <= d_in3; mem_line2_66 (tail) <= d_mid3; d_mid1 <= mem_line1_66 (head); d_end1 <= mem_line2_66 (head);
          when  66 => mem_line1_67 (tail) <= d_in3; mem_line2_67 (tail) <= d_mid3; d_mid1 <= mem_line1_67 (head); d_end1 <= mem_line2_67 (head);
          when  67 => mem_line1_68 (tail) <= d_in3; mem_line2_68 (tail) <= d_mid3; d_mid1 <= mem_line1_68 (head); d_end1 <= mem_line2_68 (head);
          when  68 => mem_line1_69 (tail) <= d_in3; mem_line2_69 (tail) <= d_mid3; d_mid1 <= mem_line1_69 (head); d_end1 <= mem_line2_69 (head);
          when  69 => mem_line1_70 (tail) <= d_in3; mem_line2_70 (tail) <= d_mid3; d_mid1 <= mem_line1_70 (head); d_end1 <= mem_line2_70 (head);
          when  70 => mem_line1_71 (tail) <= d_in3; mem_line2_71 (tail) <= d_mid3; d_mid1 <= mem_line1_71 (head); d_end1 <= mem_line2_71 (head);
          when  71 => mem_line1_72 (tail) <= d_in3; mem_line2_72 (tail) <= d_mid3; d_mid1 <= mem_line1_72 (head); d_end1 <= mem_line2_72 (head);
          when  72 => mem_line1_73 (tail) <= d_in3; mem_line2_73 (tail) <= d_mid3; d_mid1 <= mem_line1_73 (head); d_end1 <= mem_line2_73 (head);
          when  73 => mem_line1_74 (tail) <= d_in3; mem_line2_74 (tail) <= d_mid3; d_mid1 <= mem_line1_74 (head); d_end1 <= mem_line2_74 (head);
          when  74 => mem_line1_75 (tail) <= d_in3; mem_line2_75 (tail) <= d_mid3; d_mid1 <= mem_line1_75 (head); d_end1 <= mem_line2_75 (head);
          when  75 => mem_line1_76 (tail) <= d_in3; mem_line2_76 (tail) <= d_mid3; d_mid1 <= mem_line1_76 (head); d_end1 <= mem_line2_76 (head);
          when  76 => mem_line1_77 (tail) <= d_in3; mem_line2_77 (tail) <= d_mid3; d_mid1 <= mem_line1_77 (head); d_end1 <= mem_line2_77 (head);
          when  77 => mem_line1_78 (tail) <= d_in3; mem_line2_78 (tail) <= d_mid3; d_mid1 <= mem_line1_78 (head); d_end1 <= mem_line2_78 (head);
          when  78 => mem_line1_79 (tail) <= d_in3; mem_line2_79 (tail) <= d_mid3; d_mid1 <= mem_line1_79 (head); d_end1 <= mem_line2_79 (head);
          when  79 => mem_line1_80 (tail) <= d_in3; mem_line2_80 (tail) <= d_mid3; d_mid1 <= mem_line1_80 (head); d_end1 <= mem_line2_80 (head);
          when  80 => mem_line1_81 (tail) <= d_in3; mem_line2_81 (tail) <= d_mid3; d_mid1 <= mem_line1_81 (head); d_end1 <= mem_line2_81 (head);
          when  81 => mem_line1_82 (tail) <= d_in3; mem_line2_82 (tail) <= d_mid3; d_mid1 <= mem_line1_82 (head); d_end1 <= mem_line2_82 (head);
          when  82 => mem_line1_83 (tail) <= d_in3; mem_line2_83 (tail) <= d_mid3; d_mid1 <= mem_line1_83 (head); d_end1 <= mem_line2_83 (head);
          when  83 => mem_line1_84 (tail) <= d_in3; mem_line2_84 (tail) <= d_mid3; d_mid1 <= mem_line1_84 (head); d_end1 <= mem_line2_84 (head);
          when  84 => mem_line1_85 (tail) <= d_in3; mem_line2_85 (tail) <= d_mid3; d_mid1 <= mem_line1_85 (head); d_end1 <= mem_line2_85 (head);
          when  85 => mem_line1_86 (tail) <= d_in3; mem_line2_86 (tail) <= d_mid3; d_mid1 <= mem_line1_86 (head); d_end1 <= mem_line2_86 (head);
          when  86 => mem_line1_87 (tail) <= d_in3; mem_line2_87 (tail) <= d_mid3; d_mid1 <= mem_line1_87 (head); d_end1 <= mem_line2_87 (head);
          when  87 => mem_line1_88 (tail) <= d_in3; mem_line2_88 (tail) <= d_mid3; d_mid1 <= mem_line1_88 (head); d_end1 <= mem_line2_88 (head);
          when  88 => mem_line1_89 (tail) <= d_in3; mem_line2_89 (tail) <= d_mid3; d_mid1 <= mem_line1_89 (head); d_end1 <= mem_line2_89 (head);
          when  89 => mem_line1_90 (tail) <= d_in3; mem_line2_90 (tail) <= d_mid3; d_mid1 <= mem_line1_90 (head); d_end1 <= mem_line2_90 (head);
          when  90 => mem_line1_91 (tail) <= d_in3; mem_line2_91 (tail) <= d_mid3; d_mid1 <= mem_line1_91 (head); d_end1 <= mem_line2_91 (head);
          when  91 => mem_line1_92 (tail) <= d_in3; mem_line2_92 (tail) <= d_mid3; d_mid1 <= mem_line1_92 (head); d_end1 <= mem_line2_92 (head);
          when  92 => mem_line1_93 (tail) <= d_in3; mem_line2_93 (tail) <= d_mid3; d_mid1 <= mem_line1_93 (head); d_end1 <= mem_line2_93 (head);
          when  93 => mem_line1_94 (tail) <= d_in3; mem_line2_94 (tail) <= d_mid3; d_mid1 <= mem_line1_94 (head); d_end1 <= mem_line2_94 (head);
          when  94 => mem_line1_95 (tail) <= d_in3; mem_line2_95 (tail) <= d_mid3; d_mid1 <= mem_line1_95 (head); d_end1 <= mem_line2_95 (head);
          when  95 => mem_line1_96 (tail) <= d_in3; mem_line2_96 (tail) <= d_mid3; d_mid1 <= mem_line1_96 (head); d_end1 <= mem_line2_96 (head);
          when  96 => mem_line1_97 (tail) <= d_in3; mem_line2_97 (tail) <= d_mid3; d_mid1 <= mem_line1_97 (head); d_end1 <= mem_line2_97 (head);
          when  97 => mem_line1_98 (tail) <= d_in3; mem_line2_98 (tail) <= d_mid3; d_mid1 <= mem_line1_98 (head); d_end1 <= mem_line2_98 (head);
          when  98 => mem_line1_99 (tail) <= d_in3; mem_line2_99 (tail) <= d_mid3; d_mid1 <= mem_line1_99 (head); d_end1 <= mem_line2_99 (head);
          when  99 => mem_line1_100(tail) <= d_in3; mem_line2_100(tail) <= d_mid3; d_mid1 <= mem_line1_100(head); d_end1 <= mem_line2_100(head);
          when 100 => mem_line1_101(tail) <= d_in3; mem_line2_101(tail) <= d_mid3; d_mid1 <= mem_line1_101(head); d_end1 <= mem_line2_101(head);
          when 101 => mem_line1_102(tail) <= d_in3; mem_line2_102(tail) <= d_mid3; d_mid1 <= mem_line1_102(head); d_end1 <= mem_line2_102(head);
          when 102 => mem_line1_103(tail) <= d_in3; mem_line2_103(tail) <= d_mid3; d_mid1 <= mem_line1_103(head); d_end1 <= mem_line2_103(head);
          when 103 => mem_line1_104(tail) <= d_in3; mem_line2_104(tail) <= d_mid3; d_mid1 <= mem_line1_104(head); d_end1 <= mem_line2_104(head);
          when 104 => mem_line1_105(tail) <= d_in3; mem_line2_105(tail) <= d_mid3; d_mid1 <= mem_line1_105(head); d_end1 <= mem_line2_105(head);
          when 105 => mem_line1_106(tail) <= d_in3; mem_line2_106(tail) <= d_mid3; d_mid1 <= mem_line1_106(head); d_end1 <= mem_line2_106(head);
          when 106 => mem_line1_107(tail) <= d_in3; mem_line2_107(tail) <= d_mid3; d_mid1 <= mem_line1_107(head); d_end1 <= mem_line2_107(head);
          when 107 => mem_line1_108(tail) <= d_in3; mem_line2_108(tail) <= d_mid3; d_mid1 <= mem_line1_108(head); d_end1 <= mem_line2_108(head);
          when 108 => mem_line1_109(tail) <= d_in3; mem_line2_109(tail) <= d_mid3; d_mid1 <= mem_line1_109(head); d_end1 <= mem_line2_109(head);
          when 109 => mem_line1_110(tail) <= d_in3; mem_line2_110(tail) <= d_mid3; d_mid1 <= mem_line1_110(head); d_end1 <= mem_line2_110(head);
          when 110 => mem_line1_111(tail) <= d_in3; mem_line2_111(tail) <= d_mid3; d_mid1 <= mem_line1_111(head); d_end1 <= mem_line2_111(head);
          when 111 => mem_line1_112(tail) <= d_in3; mem_line2_112(tail) <= d_mid3; d_mid1 <= mem_line1_112(head); d_end1 <= mem_line2_112(head);
          when 112 => mem_line1_113(tail) <= d_in3; mem_line2_113(tail) <= d_mid3; d_mid1 <= mem_line1_113(head); d_end1 <= mem_line2_113(head);
          when 113 => mem_line1_114(tail) <= d_in3; mem_line2_114(tail) <= d_mid3; d_mid1 <= mem_line1_114(head); d_end1 <= mem_line2_114(head);
          when 114 => mem_line1_115(tail) <= d_in3; mem_line2_115(tail) <= d_mid3; d_mid1 <= mem_line1_115(head); d_end1 <= mem_line2_115(head);
          when 115 => mem_line1_116(tail) <= d_in3; mem_line2_116(tail) <= d_mid3; d_mid1 <= mem_line1_116(head); d_end1 <= mem_line2_116(head);
          when 116 => mem_line1_117(tail) <= d_in3; mem_line2_117(tail) <= d_mid3; d_mid1 <= mem_line1_117(head); d_end1 <= mem_line2_117(head);
          when 117 => mem_line1_118(tail) <= d_in3; mem_line2_118(tail) <= d_mid3; d_mid1 <= mem_line1_118(head); d_end1 <= mem_line2_118(head);
          when 118 => mem_line1_119(tail) <= d_in3; mem_line2_119(tail) <= d_mid3; d_mid1 <= mem_line1_119(head); d_end1 <= mem_line2_119(head);
          when 119 => mem_line1_120(tail) <= d_in3; mem_line2_120(tail) <= d_mid3; d_mid1 <= mem_line1_120(head); d_end1 <= mem_line2_120(head);
          when 120 => mem_line1_121(tail) <= d_in3; mem_line2_121(tail) <= d_mid3; d_mid1 <= mem_line1_121(head); d_end1 <= mem_line2_121(head);
          when 121 => mem_line1_122(tail) <= d_in3; mem_line2_122(tail) <= d_mid3; d_mid1 <= mem_line1_122(head); d_end1 <= mem_line2_122(head);
          when 122 => mem_line1_123(tail) <= d_in3; mem_line2_123(tail) <= d_mid3; d_mid1 <= mem_line1_123(head); d_end1 <= mem_line2_123(head);
          when 123 => mem_line1_124(tail) <= d_in3; mem_line2_124(tail) <= d_mid3; d_mid1 <= mem_line1_124(head); d_end1 <= mem_line2_124(head);
          when 124 => mem_line1_125(tail) <= d_in3; mem_line2_125(tail) <= d_mid3; d_mid1 <= mem_line1_125(head); d_end1 <= mem_line2_125(head);
          when 125 => mem_line1_126(tail) <= d_in3; mem_line2_126(tail) <= d_mid3; d_mid1 <= mem_line1_126(head); d_end1 <= mem_line2_126(head);
          when 126 => mem_line1_127(tail) <= d_in3; mem_line2_127(tail) <= d_mid3; d_mid1 <= mem_line1_127(head); d_end1 <= mem_line2_127(head);
          when 127 => mem_line1_128(tail) <= d_in3; mem_line2_128(tail) <= d_mid3; d_mid1 <= mem_line1_128(head); d_end1 <= mem_line2_128(head);
          when others => null;
          end case;
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
end generate;


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