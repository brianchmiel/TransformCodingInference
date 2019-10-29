library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
library work;
use work.ConvLayer_types_package.all;

entity multi_adder is
  generic (
           Relu          : string := "yes"; --"no"/"yes"  -- nonlinear Relu function
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           TP            : string := "no";  --"no"/"yes"  -- Test pattern output
           CL_inputs     : integer := 3;    -- number of inputs features
           CL_outs       : integer := 6;    -- number of output features
           N             : integer := 8;     -- input data width
           W             : integer := 8;     -- output data width  
           SR            : integer := 2      -- data shift right before output
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
end multi_adder;

architecture a of multi_adder is

constant max_input_num : integer := 256;
constant Np7 : integer := N+7;
constant Np5 : integer := N+5;
constant Np3 : integer := N+3;
constant Np1 : integer := N+1;
constant Nm1 : integer := N-1;

constant d_sumM  : integer := Np7;
constant d_reluM : integer := Np7;
constant d_ovfM  : integer := Np7;
signal  d_sum          : vec(0 to CL_outs -1)(d_sumM  downto 0); --(N-1 downto 0);
signal  d_relu         : vec(0 to CL_outs -1)(d_reluM downto 0); --(N-1 downto 0);
signal  d_ovf          : vec(0 to CL_outs -1)(d_ovfM  downto 0); --(N-1 downto 0);

signal  d_exten        : vec(0 to max_input_num * CL_outs -1)(N-1 downto 0);
signal  d_ext          : vec(0 to max_input_num * CL_outs -1)(Np7 downto 0);
--signal  d_4      : vec(0 to             4-1)(0 to CL_outs -1)(Np7 downto 0);
--signal  d_16     : mat(0 to            16-1)(0 to CL_outs -1)(Np7 downto 0);
--signal  d_64     : mat(0 to            64-1)(0 to CL_outs -1)(Np7 downto 0);
signal  d_4      : vec(0 to  4 * CL_outs -1)(Np7 downto 0);
signal  d_16     : vec(0 to 16 * CL_outs -1)(Np7 downto 0);
signal  d_64     : vec(0 to 64 * CL_outs -1)(Np7 downto 0);


signal  en4_in , en16_in , en64_in , en1_in , en_relu , en_ovf    : std_logic;
signal  sof4_in, sof16_in, sof64_in, sof1_in, sof_relu, sof_ovf   : std_logic; -- start of frame


--constant EN_BIT  : integer range 0 to 1 := 0;
--constant SOF_BIT : integer range 0 to 1 := 1;

--signal d01_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d02_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d03_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d04_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d05_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d06_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d07_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d08_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d09_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d10_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d11_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d12_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d13_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d14_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);
--signal d15_in_s        : in vec(0 to CL_inputs -1)(N-1 downto 0);

       
begin


input_copy: for i in 0 to CL_inputs*CL_outs-1 generate          
   d_exten(i) <= d_in(i);
end generate input_copy;

externtopn_zero: for i in CL_inputs*CL_outs to max_input_num*CL_outs -1 generate         
   d_exten(i) <= (others => '0');
end generate externtopn_zero;


add_i_0: for j in 0 to max_input_num*CL_outs-1 generate                         -- sign extention
--   add_j_0:   for i in 0 to CL_outs-1 generate
      d_ext(j)(N-1 downto 0) <=            d_exten(j);
      d_ext(j)(Np7 downto N) <= (others => d_exten(j)(N-1)); 
--   end generate add_j_0;
end generate add_i_0;

--  d20 <= (d01(d01'left) & d01(d01'left) & d01) + (d02(d02'left) & d02(d02'left) & d02) + (d03(d03'left) & d03(d03'left) & d03) + (d04(d04'left) & d04(d04'left) & d04);
---------------- basic total adder
----process (clk)
----
----variable tmp : vec(0 to CL_outs -1)(N-1 downto 0);
----
----begin
----   if rising_edge(clk) then
----      gen_inCL: for J in 0 to CL_inputs-1 loop
----      gen_CL: for I in 0 to CL_outs-1 loop
----         tmp(I) := tmp(I) + d_in(J)(I);
----      end loop gen_CL;
----      end loop gen_inCL;
----      
----      d_sum <= tmp;
----   end if;
----
----end process;

------------ extention total adder
---process (clk)
---
---variable tmp : vec(0 to CL_outs -1)(N-1 downto 0);
---
---begin
---   if rising_edge(clk) then
---      gen_inCL: for J in 0 to max_input_num-1 loop
---      gen_CL: for I in 0 to CL_outs-1 loop
---         tmp(I) := tmp(I) + d_exten(J)(I);
---      end loop gen_CL;
---      end loop gen_inCL;
---      
---      d_sum <= tmp;
---   end if;
---
---end process;

gen_d_64_full: if CL_inputs > 64 generate
process (clk,rst)
begin
  if rst = '1' then
     en64_in     <= '0';
     sof64_in    <= '0';
  elsif rising_edge(clk) then
     en64_in     <= en_in  ;
     sof64_in    <= sof_in ;
  end if;
end process;

process (clk)
begin
   if rising_edge(clk) then
      gen_CL: for I in 0 to CL_outs-1 loop
         d_64( 0 * CL_outs + I) <= d_ext(  0 * CL_outs + I) + 
                                   d_ext(  1 * CL_outs + I) + 
                                   d_ext(  2 * CL_outs + I) + 
                                   d_ext(  3 * CL_outs + I) ;
         d_64( 1 * CL_outs + I) <= d_ext(  4 * CL_outs + I) + 
                                   d_ext(  5 * CL_outs + I) + 
                                   d_ext(  6 * CL_outs + I) + 
                                   d_ext(  7 * CL_outs + I) ;
         d_64( 2 * CL_outs + I) <= d_ext(  8 * CL_outs + I) + 
                                   d_ext(  9 * CL_outs + I) + 
                                   d_ext( 10 * CL_outs + I) + 
                                   d_ext( 11 * CL_outs + I) ;
         d_64( 3 * CL_outs + I) <= d_ext( 12 * CL_outs + I) + 
                                   d_ext( 13 * CL_outs + I) + 
                                   d_ext( 14 * CL_outs + I) + 
                                   d_ext( 15 * CL_outs + I) ;
         d_64( 4 * CL_outs + I) <= d_ext( 16 * CL_outs + I) + 
                                   d_ext( 17 * CL_outs + I) + 
                                   d_ext( 18 * CL_outs + I) + 
                                   d_ext( 19 * CL_outs + I) ;
         d_64( 5 * CL_outs + I) <= d_ext( 20 * CL_outs + I) + 
                                   d_ext( 21 * CL_outs + I) + 
                                   d_ext( 22 * CL_outs + I) + 
                                   d_ext( 23 * CL_outs + I) ;
         d_64( 6 * CL_outs + I) <= d_ext( 24 * CL_outs + I) + 
                                   d_ext( 25 * CL_outs + I) + 
                                   d_ext( 26 * CL_outs + I) + 
                                   d_ext( 27 * CL_outs + I) ;
         d_64( 7 * CL_outs + I) <= d_ext( 28 * CL_outs + I) + 
                                   d_ext( 29 * CL_outs + I) + 
                                   d_ext( 30 * CL_outs + I) + 
                                   d_ext( 31 * CL_outs + I) ;
         d_64( 8 * CL_outs + I) <= d_ext( 32 * CL_outs + I) + 
                                   d_ext( 33 * CL_outs + I) + 
                                   d_ext( 34 * CL_outs + I) + 
                                   d_ext( 35 * CL_outs + I) ;
         d_64( 9 * CL_outs + I) <= d_ext( 36 * CL_outs + I) + 
                                   d_ext( 37 * CL_outs + I) + 
                                   d_ext( 38 * CL_outs + I) + 
                                   d_ext( 39 * CL_outs + I) ;
         d_64(10 * CL_outs + I) <= d_ext( 40 * CL_outs + I) + 
                                   d_ext( 41 * CL_outs + I) + 
                                   d_ext( 42 * CL_outs + I) + 
                                   d_ext( 43 * CL_outs + I) ;
         d_64(11 * CL_outs + I) <= d_ext( 44 * CL_outs + I) + 
                                   d_ext( 45 * CL_outs + I) + 
                                   d_ext( 46 * CL_outs + I) + 
                                   d_ext( 47 * CL_outs + I) ;
         d_64(12 * CL_outs + I) <= d_ext( 48 * CL_outs + I) + 
                                   d_ext( 49 * CL_outs + I) + 
                                   d_ext( 50 * CL_outs + I) + 
                                   d_ext( 51 * CL_outs + I) ;
         d_64(13 * CL_outs + I) <= d_ext( 52 * CL_outs + I) + 
                                   d_ext( 53 * CL_outs + I) + 
                                   d_ext( 54 * CL_outs + I) + 
                                   d_ext( 55 * CL_outs + I) ;
         d_64(14 * CL_outs + I) <= d_ext( 56 * CL_outs + I) + 
                                   d_ext( 57 * CL_outs + I) + 
                                   d_ext( 58 * CL_outs + I) + 
                                   d_ext( 59 * CL_outs + I) ;
         d_64(15 * CL_outs + I) <= d_ext( 60 * CL_outs + I) + 
                                   d_ext( 61 * CL_outs + I) + 
                                   d_ext( 62 * CL_outs + I) + 
                                   d_ext( 63 * CL_outs + I) ;
         d_64(16 * CL_outs + I) <= d_ext( 64 * CL_outs + I) + 
                                   d_ext( 65 * CL_outs + I) + 
                                   d_ext( 66 * CL_outs + I) + 
                                   d_ext( 67 * CL_outs + I) ;
         d_64(17 * CL_outs + I) <= d_ext( 68 * CL_outs + I) + 
                                   d_ext( 69 * CL_outs + I) + 
                                   d_ext( 70 * CL_outs + I) + 
                                   d_ext( 71 * CL_outs + I) ;
         d_64(18 * CL_outs + I) <= d_ext( 72 * CL_outs + I) + 
                                   d_ext( 73 * CL_outs + I) + 
                                   d_ext( 74 * CL_outs + I) + 
                                   d_ext( 75 * CL_outs + I) ;
         d_64(19 * CL_outs + I) <= d_ext( 76 * CL_outs + I) + 
                                   d_ext( 77 * CL_outs + I) + 
                                   d_ext( 78 * CL_outs + I) + 
                                   d_ext( 79 * CL_outs + I) ;
         d_64(20 * CL_outs + I) <= d_ext( 80 * CL_outs + I) + 
                                   d_ext( 81 * CL_outs + I) + 
                                   d_ext( 82 * CL_outs + I) + 
                                   d_ext( 83 * CL_outs + I) ;
         d_64(21 * CL_outs + I) <= d_ext( 84 * CL_outs + I) + 
                                   d_ext( 85 * CL_outs + I) + 
                                   d_ext( 86 * CL_outs + I) + 
                                   d_ext( 87 * CL_outs + I) ;
         d_64(22 * CL_outs + I) <= d_ext( 88 * CL_outs + I) + 
                                   d_ext( 89 * CL_outs + I) + 
                                   d_ext( 90 * CL_outs + I) + 
                                   d_ext( 91 * CL_outs + I) ;
         d_64(23 * CL_outs + I) <= d_ext( 92 * CL_outs + I) + 
                                   d_ext( 93 * CL_outs + I) + 
                                   d_ext( 94 * CL_outs + I) + 
                                   d_ext( 95 * CL_outs + I) ;
         d_64(24 * CL_outs + I) <= d_ext( 96 * CL_outs + I) + 
                                   d_ext( 97 * CL_outs + I) + 
                                   d_ext( 98 * CL_outs + I) + 
                                   d_ext( 99 * CL_outs + I) ;
         d_64(25 * CL_outs + I) <= d_ext(100 * CL_outs + I) + 
                                   d_ext(101 * CL_outs + I) + 
                                   d_ext(102 * CL_outs + I) + 
                                   d_ext(103 * CL_outs + I) ;
         d_64(26 * CL_outs + I) <= d_ext(104 * CL_outs + I) + 
                                   d_ext(105 * CL_outs + I) + 
                                   d_ext(106 * CL_outs + I) + 
                                   d_ext(107 * CL_outs + I) ;
         d_64(27 * CL_outs + I) <= d_ext(108 * CL_outs + I) + 
                                   d_ext(109 * CL_outs + I) + 
                                   d_ext(110 * CL_outs + I) + 
                                   d_ext(111 * CL_outs + I) ;
         d_64(28 * CL_outs + I) <= d_ext(112 * CL_outs + I) + 
                                   d_ext(113 * CL_outs + I) + 
                                   d_ext(114 * CL_outs + I) + 
                                   d_ext(115 * CL_outs + I) ;
         d_64(29 * CL_outs + I) <= d_ext(116 * CL_outs + I) + 
                                   d_ext(117 * CL_outs + I) + 
                                   d_ext(118 * CL_outs + I) + 
                                   d_ext(119 * CL_outs + I) ;
         d_64(30 * CL_outs + I) <= d_ext(120 * CL_outs + I) + 
                                   d_ext(121 * CL_outs + I) + 
                                   d_ext(122 * CL_outs + I) + 
                                   d_ext(123 * CL_outs + I) ;
         d_64(31 * CL_outs + I) <= d_ext(124 * CL_outs + I) + 
                                   d_ext(125 * CL_outs + I) + 
                                   d_ext(126 * CL_outs + I) + 
                                   d_ext(127 * CL_outs + I) ;
         d_64(32 * CL_outs + I) <= d_ext(128 * CL_outs + I) + 
                                   d_ext(129 * CL_outs + I) + 
                                   d_ext(130 * CL_outs + I) + 
                                   d_ext(131 * CL_outs + I) ;
         d_64(33 * CL_outs + I) <= d_ext(132 * CL_outs + I) + 
                                   d_ext(133 * CL_outs + I) + 
                                   d_ext(134 * CL_outs + I) + 
                                   d_ext(135 * CL_outs + I) ;
         d_64(34 * CL_outs + I) <= d_ext(136 * CL_outs + I) + 
                                   d_ext(137 * CL_outs + I) + 
                                   d_ext(138 * CL_outs + I) + 
                                   d_ext(139 * CL_outs + I) ;
         d_64(35 * CL_outs + I) <= d_ext(140 * CL_outs + I) + 
                                   d_ext(141 * CL_outs + I) + 
                                   d_ext(142 * CL_outs + I) + 
                                   d_ext(143 * CL_outs + I) ;
         d_64(36 * CL_outs + I) <= d_ext(144 * CL_outs + I) + 
                                   d_ext(145 * CL_outs + I) + 
                                   d_ext(146 * CL_outs + I) + 
                                   d_ext(147 * CL_outs + I) ;
         d_64(37 * CL_outs + I) <= d_ext(148 * CL_outs + I) + 
                                   d_ext(149 * CL_outs + I) + 
                                   d_ext(150 * CL_outs + I) + 
                                   d_ext(151 * CL_outs + I) ;
         d_64(38 * CL_outs + I) <= d_ext(152 * CL_outs + I) + 
                                   d_ext(153 * CL_outs + I) + 
                                   d_ext(154 * CL_outs + I) + 
                                   d_ext(155 * CL_outs + I) ;
         d_64(39 * CL_outs + I) <= d_ext(156 * CL_outs + I) + 
                                   d_ext(157 * CL_outs + I) + 
                                   d_ext(158 * CL_outs + I) + 
                                   d_ext(159 * CL_outs + I) ;
         d_64(40 * CL_outs + I) <= d_ext(160 * CL_outs + I) + 
                                   d_ext(161 * CL_outs + I) + 
                                   d_ext(162 * CL_outs + I) + 
                                   d_ext(163 * CL_outs + I) ;
         d_64(41 * CL_outs + I) <= d_ext(164 * CL_outs + I) + 
                                   d_ext(165 * CL_outs + I) + 
                                   d_ext(166 * CL_outs + I) + 
                                   d_ext(167 * CL_outs + I) ;
         d_64(42 * CL_outs + I) <= d_ext(168 * CL_outs + I) + 
                                   d_ext(169 * CL_outs + I) + 
                                   d_ext(170 * CL_outs + I) + 
                                   d_ext(171 * CL_outs + I) ;
         d_64(43 * CL_outs + I) <= d_ext(172 * CL_outs + I) + 
                                   d_ext(173 * CL_outs + I) + 
                                   d_ext(174 * CL_outs + I) + 
                                   d_ext(175 * CL_outs + I) ;
         d_64(44 * CL_outs + I) <= d_ext(176 * CL_outs + I) + 
                                   d_ext(177 * CL_outs + I) + 
                                   d_ext(178 * CL_outs + I) + 
                                   d_ext(179 * CL_outs + I) ;
         d_64(45 * CL_outs + I) <= d_ext(180 * CL_outs + I) + 
                                   d_ext(181 * CL_outs + I) + 
                                   d_ext(182 * CL_outs + I) + 
                                   d_ext(183 * CL_outs + I) ;
         d_64(46 * CL_outs + I) <= d_ext(184 * CL_outs + I) + 
                                   d_ext(185 * CL_outs + I) + 
                                   d_ext(186 * CL_outs + I) + 
                                   d_ext(187 * CL_outs + I) ;
         d_64(47 * CL_outs + I) <= d_ext(188 * CL_outs + I) + 
                                   d_ext(189 * CL_outs + I) + 
                                   d_ext(190 * CL_outs + I) + 
                                   d_ext(191 * CL_outs + I) ;
         d_64(48 * CL_outs + I) <= d_ext(192 * CL_outs + I) + 
                                   d_ext(193 * CL_outs + I) + 
                                   d_ext(194 * CL_outs + I) + 
                                   d_ext(195 * CL_outs + I) ;
         d_64(49 * CL_outs + I) <= d_ext(196 * CL_outs + I) + 
                                   d_ext(197 * CL_outs + I) + 
                                   d_ext(198 * CL_outs + I) + 
                                   d_ext(199 * CL_outs + I) ;
         d_64(50 * CL_outs + I) <= d_ext(200 * CL_outs + I) + 
                                   d_ext(201 * CL_outs + I) + 
                                   d_ext(202 * CL_outs + I) + 
                                   d_ext(203 * CL_outs + I) ;
         d_64(51 * CL_outs + I) <= d_ext(204 * CL_outs + I) + 
                                   d_ext(205 * CL_outs + I) + 
                                   d_ext(206 * CL_outs + I) + 
                                   d_ext(207 * CL_outs + I) ;
         d_64(52 * CL_outs + I) <= d_ext(208 * CL_outs + I) + 
                                   d_ext(209 * CL_outs + I) + 
                                   d_ext(210 * CL_outs + I) + 
                                   d_ext(211 * CL_outs + I) ;
         d_64(53 * CL_outs + I) <= d_ext(212 * CL_outs + I) + 
                                   d_ext(213 * CL_outs + I) + 
                                   d_ext(214 * CL_outs + I) + 
                                   d_ext(215 * CL_outs + I) ;
         d_64(54 * CL_outs + I) <= d_ext(216 * CL_outs + I) + 
                                   d_ext(217 * CL_outs + I) + 
                                   d_ext(218 * CL_outs + I) + 
                                   d_ext(219 * CL_outs + I) ;
         d_64(55 * CL_outs + I) <= d_ext(220 * CL_outs + I) + 
                                   d_ext(221 * CL_outs + I) + 
                                   d_ext(222 * CL_outs + I) + 
                                   d_ext(223 * CL_outs + I) ;
         d_64(56 * CL_outs + I) <= d_ext(224 * CL_outs + I) + 
                                   d_ext(225 * CL_outs + I) + 
                                   d_ext(226 * CL_outs + I) + 
                                   d_ext(227 * CL_outs + I) ;
         d_64(57 * CL_outs + I) <= d_ext(228 * CL_outs + I) + 
                                   d_ext(229 * CL_outs + I) + 
                                   d_ext(230 * CL_outs + I) + 
                                   d_ext(231 * CL_outs + I) ;
         d_64(58 * CL_outs + I) <= d_ext(232 * CL_outs + I) + 
                                   d_ext(233 * CL_outs + I) + 
                                   d_ext(234 * CL_outs + I) + 
                                   d_ext(235 * CL_outs + I) ;
         d_64(59 * CL_outs + I) <= d_ext(236 * CL_outs + I) + 
                                   d_ext(237 * CL_outs + I) + 
                                   d_ext(238 * CL_outs + I) + 
                                   d_ext(239 * CL_outs + I) ;
         d_64(60 * CL_outs + I) <= d_ext(240 * CL_outs + I) + 
                                   d_ext(241 * CL_outs + I) + 
                                   d_ext(242 * CL_outs + I) + 
                                   d_ext(243 * CL_outs + I) ;
         d_64(61 * CL_outs + I) <= d_ext(244 * CL_outs + I) + 
                                   d_ext(245 * CL_outs + I) + 
                                   d_ext(246 * CL_outs + I) + 
                                   d_ext(247 * CL_outs + I) ;
         d_64(62 * CL_outs + I) <= d_ext(248 * CL_outs + I) + 
                                   d_ext(249 * CL_outs + I) + 
                                   d_ext(250 * CL_outs + I) + 
                                   d_ext(251 * CL_outs + I) ;
         d_64(63 * CL_outs + I) <= d_ext(252 * CL_outs + I) + 
                                   d_ext(253 * CL_outs + I) + 
                                   d_ext(254 * CL_outs + I) + 
                                   d_ext(255 * CL_outs + I) ;
      end loop gen_CL;
   end if;
end process;
end generate gen_d_64_full;


gen_d_64_short: if (CL_inputs <= 64) and (CL_inputs > 16)  generate
      gen_CL: for I in 0 to 64 * CL_outs-1 generate
         en64_in     <= en_in  ;
         sof64_in    <= sof_in ;
         d_64(I)     <= d_ext(I);
--         d_64( 0)(I) <= d_ext( 0)(I);
--         d_64( 1)(I) <= d_ext( 1)(I);
--         d_64( 2)(I) <= d_ext( 2)(I);
--         d_64( 3)(I) <= d_ext( 3)(I);
--         d_64( 4)(I) <= d_ext( 4)(I);
--         d_64( 5)(I) <= d_ext( 5)(I);
--         d_64( 6)(I) <= d_ext( 6)(I);
--         d_64( 7)(I) <= d_ext( 7)(I);
--         d_64( 8)(I) <= d_ext( 8)(I);
--         d_64( 9)(I) <= d_ext( 9)(I);
--         d_64(10)(I) <= d_ext(10)(I);
--         d_64(11)(I) <= d_ext(11)(I);
--         d_64(12)(I) <= d_ext(12)(I);
--         d_64(13)(I) <= d_ext(13)(I);
--         d_64(14)(I) <= d_ext(14)(I);
--         d_64(15)(I) <= d_ext(15)(I);
--         d_64(16)(I) <= d_ext(16)(I);
--         d_64(17)(I) <= d_ext(17)(I);
--         d_64(18)(I) <= d_ext(18)(I);
--         d_64(19)(I) <= d_ext(19)(I);
--         d_64(20)(I) <= d_ext(20)(I);
--         d_64(21)(I) <= d_ext(21)(I);
--         d_64(22)(I) <= d_ext(22)(I);
--         d_64(23)(I) <= d_ext(23)(I);
--         d_64(24)(I) <= d_ext(24)(I);
--         d_64(25)(I) <= d_ext(25)(I);
--         d_64(26)(I) <= d_ext(26)(I);
--         d_64(27)(I) <= d_ext(27)(I);
--         d_64(28)(I) <= d_ext(28)(I);
--         d_64(29)(I) <= d_ext(29)(I);
--         d_64(30)(I) <= d_ext(30)(I);
--         d_64(31)(I) <= d_ext(31)(I);
--         d_64(32)(I) <= d_ext(32)(I);
--         d_64(33)(I) <= d_ext(33)(I);
--         d_64(34)(I) <= d_ext(34)(I);
--         d_64(35)(I) <= d_ext(35)(I);
--         d_64(36)(I) <= d_ext(36)(I);
--         d_64(37)(I) <= d_ext(37)(I);
--         d_64(38)(I) <= d_ext(38)(I);
--         d_64(39)(I) <= d_ext(39)(I);
--         d_64(40)(I) <= d_ext(40)(I);
--         d_64(41)(I) <= d_ext(41)(I);
--         d_64(42)(I) <= d_ext(42)(I);
--         d_64(43)(I) <= d_ext(43)(I);
--         d_64(44)(I) <= d_ext(44)(I);
--         d_64(45)(I) <= d_ext(45)(I);
--         d_64(46)(I) <= d_ext(46)(I);
--         d_64(47)(I) <= d_ext(47)(I);
--         d_64(48)(I) <= d_ext(48)(I);
--         d_64(49)(I) <= d_ext(49)(I);
--         d_64(50)(I) <= d_ext(50)(I);
--         d_64(51)(I) <= d_ext(51)(I);
--         d_64(52)(I) <= d_ext(52)(I);
--         d_64(53)(I) <= d_ext(53)(I);
--         d_64(54)(I) <= d_ext(54)(I);
--         d_64(55)(I) <= d_ext(55)(I);
--         d_64(56)(I) <= d_ext(56)(I);
--         d_64(57)(I) <= d_ext(57)(I);
--         d_64(58)(I) <= d_ext(58)(I);
--         d_64(59)(I) <= d_ext(59)(I);
--         d_64(60)(I) <= d_ext(60)(I);
--         d_64(61)(I) <= d_ext(61)(I);
--         d_64(62)(I) <= d_ext(62)(I);
--         d_64(63)(I) <= d_ext(63)(I);
      end generate gen_CL;
end generate gen_d_64_short;

------------------------------------------------------------------------------------------------------------------------
gen_d_16_full: if CL_inputs > 16 generate
process (clk,rst)
begin
  if rst = '1' then
     en16_in     <= '0';
     sof16_in    <= '0';
  elsif rising_edge(clk) then
     en16_in     <= en64_in  ;
     sof16_in    <= sof64_in ;
  end if;
end process;

process (clk)
begin
   if rising_edge(clk) then
      gen_CL: for I in 0 to CL_outs-1 loop
         d_16( 0 * CL_outs + I) <= d_64( 0 * CL_outs + I) + 
                                   d_64( 1 * CL_outs + I) + 
                                   d_64( 2 * CL_outs + I) + 
                                   d_64( 3 * CL_outs + I) ;
         d_16( 1 * CL_outs + I) <= d_64( 4 * CL_outs + I) + 
                                   d_64( 5 * CL_outs + I) + 
                                   d_64( 6 * CL_outs + I) + 
                                   d_64( 7 * CL_outs + I) ;
         d_16( 2 * CL_outs + I) <= d_64( 8 * CL_outs + I) + 
                                   d_64( 9 * CL_outs + I) + 
                                   d_64(10 * CL_outs + I) + 
                                   d_64(11 * CL_outs + I) ;
         d_16( 3 * CL_outs + I) <= d_64(12 * CL_outs + I) + 
                                   d_64(13 * CL_outs + I) + 
                                   d_64(14 * CL_outs + I) + 
                                   d_64(15 * CL_outs + I) ;
         d_16( 4 * CL_outs + I) <= d_64(16 * CL_outs + I) + 
                                   d_64(17 * CL_outs + I) + 
                                   d_64(18 * CL_outs + I) + 
                                   d_64(19 * CL_outs + I) ;
         d_16( 5 * CL_outs + I) <= d_64(20 * CL_outs + I) + 
                                   d_64(21 * CL_outs + I) + 
                                   d_64(22 * CL_outs + I) + 
                                   d_64(23 * CL_outs + I) ;
         d_16( 6 * CL_outs + I) <= d_64(24 * CL_outs + I) + 
                                   d_64(25 * CL_outs + I) + 
                                   d_64(26 * CL_outs + I) + 
                                   d_64(27 * CL_outs + I) ;
         d_16( 7 * CL_outs + I) <= d_64(28 * CL_outs + I) + 
                                   d_64(29 * CL_outs + I) + 
                                   d_64(30 * CL_outs + I) + 
                                   d_64(31 * CL_outs + I) ;
         d_16( 8 * CL_outs + I) <= d_64(32 * CL_outs + I) + 
                                   d_64(33 * CL_outs + I) + 
                                   d_64(34 * CL_outs + I) + 
                                   d_64(35 * CL_outs + I) ;
         d_16( 9 * CL_outs + I) <= d_64(36 * CL_outs + I) + 
                                   d_64(37 * CL_outs + I) + 
                                   d_64(38 * CL_outs + I) + 
                                   d_64(39 * CL_outs + I) ;
         d_16(10 * CL_outs + I) <= d_64(40 * CL_outs + I) + 
                                   d_64(41 * CL_outs + I) + 
                                   d_64(42 * CL_outs + I) + 
                                   d_64(43 * CL_outs + I) ;
         d_16(11 * CL_outs + I) <= d_64(44 * CL_outs + I) + 
                                   d_64(45 * CL_outs + I) + 
                                   d_64(46 * CL_outs + I) + 
                                   d_64(47 * CL_outs + I) ;
         d_16(12 * CL_outs + I) <= d_64(48 * CL_outs + I) + 
                                   d_64(49 * CL_outs + I) + 
                                   d_64(50 * CL_outs + I) + 
                                   d_64(51 * CL_outs + I) ;
         d_16(13 * CL_outs + I) <= d_64(52 * CL_outs + I) + 
                                   d_64(53 * CL_outs + I) + 
                                   d_64(54 * CL_outs + I) + 
                                   d_64(55 * CL_outs + I) ;
         d_16(14 * CL_outs + I) <= d_64(56 * CL_outs + I) + 
                                   d_64(57 * CL_outs + I) + 
                                   d_64(58 * CL_outs + I) + 
                                   d_64(59 * CL_outs + I) ;
         d_16(15 * CL_outs + I) <= d_64(60 * CL_outs + I) + 
                                   d_64(61 * CL_outs + I) + 
                                   d_64(62 * CL_outs + I) + 
                                   d_64(63 * CL_outs + I) ;
      end loop gen_CL;
   end if;
end process;
end generate gen_d_16_full;

gen_d_16_short: if (CL_inputs <= 16) and (CL_inputs > 4)  generate
      gen_CL: for I in 0 to 16 * CL_outs-1 generate
         en16_in     <= en_in  ;
         sof16_in    <= sof_in ;
         d_16(I)     <= d_ext(I);
         --d_16( 0)(I) <= d_ext( 0)(I);
         --d_16( 1)(I) <= d_ext( 1)(I);
         --d_16( 2)(I) <= d_ext( 2)(I);
         --d_16( 3)(I) <= d_ext( 3)(I);
         --d_16( 4)(I) <= d_ext( 4)(I);
         --d_16( 5)(I) <= d_ext( 5)(I);
         --d_16( 6)(I) <= d_ext( 6)(I);
         --d_16( 7)(I) <= d_ext( 7)(I);
         --d_16( 8)(I) <= d_ext( 8)(I);
         --d_16( 9)(I) <= d_ext( 9)(I);
         --d_16(10)(I) <= d_ext(10)(I);
         --d_16(11)(I) <= d_ext(11)(I);
         --d_16(12)(I) <= d_ext(12)(I); 
         --d_16(13)(I) <= d_ext(13)(I);
         --d_16(14)(I) <= d_ext(14)(I);
         --d_16(15)(I) <= d_ext(15)(I);
      end generate gen_CL;
end generate gen_d_16_short;


gen_d_4_full: if CL_inputs > 4 generate

process (clk,rst)
begin
  if rst = '1' then
     en4_in     <= '0';
     sof4_in    <= '0';
  elsif rising_edge(clk) then
     en4_in    <= en16_in  ;
     sof4_in   <= sof16_in ;
  end if;
end process;

process (clk)
begin
   if rising_edge(clk) then
      gen_CL: for I in 0 to CL_outs-1 loop
         d_4(0 * CL_outs + I) <= d_16( 0 * CL_outs + I) + 
                                 d_16( 1 * CL_outs + I) + 
                                 d_16( 2 * CL_outs + I) + 
                                 d_16( 3 * CL_outs + I) ;
         d_4(1 * CL_outs + I) <= d_16( 4 * CL_outs + I) + 
                                 d_16( 5 * CL_outs + I) + 
                                 d_16( 6 * CL_outs + I) + 
                                 d_16( 7 * CL_outs + I) ;
         d_4(2 * CL_outs + I) <= d_16( 8 * CL_outs + I) + 
                                 d_16( 9 * CL_outs + I) + 
                                 d_16(10 * CL_outs + I) + 
                                 d_16(11 * CL_outs + I) ;
         d_4(3 * CL_outs + I) <= d_16(12 * CL_outs + I) + 
                                 d_16(13 * CL_outs + I) + 
                                 d_16(14 * CL_outs + I) + 
                                 d_16(15 * CL_outs + I) ;
      end loop gen_CL;
   end if;
end process;
end generate gen_d_4_full;

gen_d_4_short: if CL_inputs <= 4 generate
--process (clk)
--begin
--   if rising_edge(clk) then
      gen_CL: for I in 0 to 4 * CL_outs-1 generate
         en4_in    <= en_in  ;
         sof4_in   <= sof_in ;
         d_4(I)    <= d_ext(I);
      end generate gen_CL;
--   end if;
--end process;
end generate gen_d_4_short;


process (clk,rst)
begin
  if rst = '1' then
     en1_in     <= '0';
     sof1_in    <= '0';
  elsif rising_edge(clk) then
     en1_in   <= en4_in  ;
     sof1_in  <= sof4_in ;
  end if;
end process;

process (clk)
   variable tmp : vec(0 to CL_outs -1)(N-1 downto 0);
begin
   if rising_edge(clk) then
      gen_CL: for I in 0 to CL_outs-1 loop
         d_sum(I) <= d_4(0 * CL_outs + I) + 
                     d_4(1 * CL_outs + I) + 
                     d_4(2 * CL_outs + I) + 
                     d_4(3 * CL_outs + I) ; 
      end loop gen_CL;
   end if;
end process;



process (clk,rst)
begin
  if rst = '1' then
    en_relu   <= '0';
    sof_relu  <= '0';
    en_ovf    <= '0';
    sof_ovf   <= '0';
  elsif rising_edge(clk) then
    en_relu   <= en1_in  ;
    sof_relu  <= sof1_in ;
    en_ovf    <= en_relu  ;
    sof_ovf   <= sof_relu ;
  end if;
end process;

p_relu : process (clk)
begin
  if rising_edge(clk) then
    if Relu = "yes" then
       relu_outs_for: for i in 0 to CL_outs-1 loop
          relu_bits_for: for j in 0 to Np7 loop
             --d_relu(i)(j) <= d_sum(i)(j) and not d_sum(i)(d_sum'left);    -- if MSB=1 (negative) thwen all bits are 0
             d_relu(i)(j) <= d_sum(i)(j) and not d_sum(i)(d_sumM);    -- if MSB=1 (negative) thwen all bits are 0 
          end loop relu_bits_for;
       end loop relu_outs_for;
    else
       d_relu <= d_sum;
    end if;
  end if;
end process p_relu;


 -- check overflow before shift and change value to maximum if overflow occurs
   p_ovf : process (clk)
  begin
    if rising_edge(clk) then
       ovf_for: for i in 0 to CL_outs-1 loop
          --if d_relu(i)(d_relu'left  downto W + SR -2) = 0  then 
          --if d_relu(i)(d_reluM  downto W + SR -2) = 0  then 
          if d_relu(i)(d_reluM  downto W + SR -1) = 0  then
             d_ovf(i) <= d_relu(i);
          else
             --d_ovf(i)( d_relu'left  downto W + SR -2 ) <= (others => '0'); 
             d_ovf(i)( d_ovfM  downto W + SR -1 ) <= (others => '0'); 
             d_ovf(i)( W + SR - 2   downto         0 ) <= (others => '1'); 
          end if;
       end loop ovf_for;
    end if;
  end process p_ovf;


out_cut_for: for i in 0 to CL_outs-1 generate
   d_out(i) <= d_ovf(i)(W + SR - 1 downto SR);
end generate out_cut_for;
en_out   <= en_ovf  ;
sof_out  <= sof_ovf ;

end a;