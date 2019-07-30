library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Huffman32 is
  generic (
           N             : integer := 4;  -- input data width
           M             : integer := 8;  -- max code width
           Wh            : integer := 16;  -- Huffman unit output data width (Note W>=M)
           Wb            : integer := 512; -- output buffer data width
           Huff_enc_en   : boolean := TRUE; -- Huffman encoder Enable/Bypass
           depth         : integer := 500; -- buffer depth
           burst         : integer := 10   -- buffer read burst
  	       );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           init_en       : in  std_logic;                         -- initialising convert table
           alpha_data    : in  std_logic_vector(N-1 downto 0);    
           alpha_code    : in  std_logic_vector(M-1 downto 0);    
           alpha_width   : in  std_logic_vector(  3 downto 0);

  	       d01_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d02_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d03_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d04_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d05_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d06_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d07_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d08_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d09_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d10_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d11_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d12_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d13_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d14_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d15_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d16_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d17_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d18_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d19_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d20_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d21_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d22_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d23_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d24_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d25_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d26_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d27_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d28_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d29_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d30_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d31_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d32_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
  	       en_in         : in  std_logic;
  	       sof_in        : in  std_logic;                         -- start of frame
           eof_in        : in  std_logic;                         -- end of frame

           buf_rd        : in  std_logic;
           buf_num       : in  std_logic_vector (5      downto 0);
           d_out         : out std_logic_vector (Wb  -1 downto 0);
           en_out        : out std_logic_vector (64  -1 downto 0);
           eof_out       : out std_logic);                        -- huffman codde output
end Huffman32;

architecture a of Huffman32 is


component Huffman is
  generic (
           N             : integer := 4; -- input data width
           M             : integer := 8; -- max code width
           W             : integer := 10 -- output data width (Note W>=M)
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           init_en       : in  std_logic;                         -- initialising convert table
           alpha_data    : in  std_logic_vector(N-1 downto 0);    
           alpha_code    : in  std_logic_vector(M-1 downto 0);    
           alpha_width   : in  std_logic_vector(  3 downto 0);

           d_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           en_in         : in  std_logic;
           sof_in        : in  std_logic;                         -- start of frame
           eof_in        : in  std_logic;                         -- end of frame

           d_out         : out std_logic_vector (W-1 downto 0);
           en_out        : out std_logic;
           eof_out       : out std_logic);                        -- huffman codde output
end component;

component fifo is
generic (depth   : integer := 16 ;
         burst   : integer := 10 ;  -- indication for burst read (Note, depth>burst) 
         Win     : integer := 16 ;
         Wout    : integer := 64 );  --depth of fifo
port (    clk        : in std_logic;
          rst        : in std_logic;
          enr        : in std_logic;   --enable read,should be '0' when not in use.
          enw        : in std_logic;    --enable write,should be '0' when not in use.
          data_in    : in std_logic_vector  (Win -1 downto 0);     --input data
          data_out   : out std_logic_vector(Wout-1 downto 0);    --output data
          burst_r    : out std_logic;   --set as '1' when the queue is ready for burst transaction
          fifo_empty : out std_logic;   --set as '1' when the queue is empty
          fifo_full  : out std_logic     --set as '1' when the queue is full
         );
end component;

signal h01_out     : std_logic_vector(Wh-1 downto 0);
signal h02_out     : std_logic_vector(Wh-1 downto 0);
signal h03_out     : std_logic_vector(Wh-1 downto 0);
signal h04_out     : std_logic_vector(Wh-1 downto 0);
signal h05_out     : std_logic_vector(Wh-1 downto 0);
signal h06_out     : std_logic_vector(Wh-1 downto 0);
signal h07_out     : std_logic_vector(Wh-1 downto 0);
signal h08_out     : std_logic_vector(Wh-1 downto 0);
signal h09_out     : std_logic_vector(Wh-1 downto 0);
signal h10_out     : std_logic_vector(Wh-1 downto 0);
signal h11_out     : std_logic_vector(Wh-1 downto 0);
signal h12_out     : std_logic_vector(Wh-1 downto 0);
signal h13_out     : std_logic_vector(Wh-1 downto 0);
signal h14_out     : std_logic_vector(Wh-1 downto 0);
signal h15_out     : std_logic_vector(Wh-1 downto 0);
signal h16_out     : std_logic_vector(Wh-1 downto 0);
signal h17_out     : std_logic_vector(Wh-1 downto 0);
signal h18_out     : std_logic_vector(Wh-1 downto 0);
signal h19_out     : std_logic_vector(Wh-1 downto 0);
signal h20_out     : std_logic_vector(Wh-1 downto 0);
signal h21_out     : std_logic_vector(Wh-1 downto 0);
signal h22_out     : std_logic_vector(Wh-1 downto 0);
signal h23_out     : std_logic_vector(Wh-1 downto 0);
signal h24_out     : std_logic_vector(Wh-1 downto 0);
signal h25_out     : std_logic_vector(Wh-1 downto 0);
signal h26_out     : std_logic_vector(Wh-1 downto 0);
signal h27_out     : std_logic_vector(Wh-1 downto 0);
signal h28_out     : std_logic_vector(Wh-1 downto 0);
signal h29_out     : std_logic_vector(Wh-1 downto 0);
signal h30_out     : std_logic_vector(Wh-1 downto 0);
signal h31_out     : std_logic_vector(Wh-1 downto 0);
signal h32_out     : std_logic_vector(Wh-1 downto 0);

signal h01_en     : std_logic;
signal h02_en     : std_logic;
signal h03_en     : std_logic;
signal h04_en     : std_logic;
signal h05_en     : std_logic;
signal h06_en     : std_logic;
signal h07_en     : std_logic;
signal h08_en     : std_logic;
signal h09_en     : std_logic;
signal h10_en     : std_logic;
signal h11_en     : std_logic;
signal h12_en     : std_logic;
signal h13_en     : std_logic;
signal h14_en     : std_logic;
signal h15_en     : std_logic;
signal h16_en     : std_logic;
signal h17_en     : std_logic;
signal h18_en     : std_logic;
signal h19_en     : std_logic;
signal h20_en     : std_logic;
signal h21_en     : std_logic;
signal h22_en     : std_logic;
signal h23_en     : std_logic;
signal h24_en     : std_logic;
signal h25_en     : std_logic;
signal h26_en     : std_logic;
signal h27_en     : std_logic;
signal h28_en     : std_logic;
signal h29_en     : std_logic;
signal h30_en     : std_logic;
signal h31_en     : std_logic;
signal h32_en     : std_logic;
signal h64_en     : std_logic;

signal buff01_out, buff02_out, buff03_out, buff04_out, buff05_out, buff06_out, buff07_out, buff08_out, buff09_out, buff10_out, buff11_out, buff12_out, buff13_out, buff14_out, buff15_out, buff16_out, buff17_out, buff18_out, buff19_out, buff20_out, buff21_out, buff22_out, buff23_out, buff24_out, buff25_out, buff26_out, buff27_out, buff28_out, buff29_out, buff30_out, buff31_out, buff32_out : std_logic_vector(Wb-1 downto 0);

signal b_rd : std_logic_vector (64-1 downto 0);

begin

g_Huff_enc_en: if Huff_enc_en = TRUE generate
   Huf01 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d01_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h01_out, en_out => h01_en, eof_out => eof_out);
   Huf02 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d02_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h02_out, en_out => h02_en, eof_out => open);
   Huf03 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d03_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h03_out, en_out => h03_en, eof_out => open);
   Huf04 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d04_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h04_out, en_out => h04_en, eof_out => open);
   Huf05 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d05_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h05_out, en_out => h05_en, eof_out => open);
   Huf06 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d06_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h06_out, en_out => h06_en, eof_out => open);
   Huf07 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d07_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h07_out, en_out => h07_en, eof_out => open);
   Huf08 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d08_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h08_out, en_out => h08_en, eof_out => open);
   Huf09 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d09_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h09_out, en_out => h09_en, eof_out => open);
   Huf10 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d10_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h10_out, en_out => h10_en, eof_out => open);
   Huf11 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d11_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h11_out, en_out => h11_en, eof_out => open);
   Huf12 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d12_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h12_out, en_out => h12_en, eof_out => open);
   Huf13 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d13_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h13_out, en_out => h13_en, eof_out => open);
   Huf14 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d14_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h14_out, en_out => h14_en, eof_out => open);
   Huf15 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d15_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h15_out, en_out => h15_en, eof_out => open);
   Huf16 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d16_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h16_out, en_out => h16_en, eof_out => open);
   Huf17 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d17_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h17_out, en_out => h17_en, eof_out => open);
   Huf18 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d18_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h18_out, en_out => h18_en, eof_out => open);
   Huf19 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d19_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h19_out, en_out => h19_en, eof_out => open);
   Huf20 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d20_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h20_out, en_out => h20_en, eof_out => open);
   Huf21 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d21_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h21_out, en_out => h21_en, eof_out => open);
   Huf22 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d22_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h22_out, en_out => h22_en, eof_out => open);
   Huf23 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d23_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h23_out, en_out => h23_en, eof_out => open);
   Huf24 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d24_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h24_out, en_out => h24_en, eof_out => open);
   Huf25 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d25_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h25_out, en_out => h25_en, eof_out => open);
   Huf26 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d26_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h26_out, en_out => h26_en, eof_out => open);
   Huf27 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d27_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h27_out, en_out => h27_en, eof_out => open);
   Huf28 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d28_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h28_out, en_out => h28_en, eof_out => open);
   Huf29 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d29_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h29_out, en_out => h29_en, eof_out => open);
   Huf30 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d30_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h30_out, en_out => h30_en, eof_out => open);
   Huf31 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d31_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h31_out, en_out => h31_en, eof_out => open);
   Huf32 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d32_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h32_out, en_out => h32_en, eof_out => open);
end generate g_Huff_enc_en;

g_Huff_enc_dis: if Huff_enc_en = FALSE generate
   h01_out(h01_out'left downto d01_in'left + 1) <= (others => '0');   h01_out(d01_in'left downto 0) <= d01_in;   h01_en <= en_in;
   h02_out(h02_out'left downto d02_in'left + 1) <= (others => '0');   h02_out(d02_in'left downto 0) <= d02_in;   h02_en <= en_in;
   h03_out(h03_out'left downto d03_in'left + 1) <= (others => '0');   h03_out(d03_in'left downto 0) <= d03_in;   h03_en <= en_in;
   h04_out(h04_out'left downto d04_in'left + 1) <= (others => '0');   h04_out(d04_in'left downto 0) <= d04_in;   h04_en <= en_in;
   h05_out(h05_out'left downto d05_in'left + 1) <= (others => '0');   h05_out(d05_in'left downto 0) <= d05_in;   h05_en <= en_in;
   h06_out(h06_out'left downto d06_in'left + 1) <= (others => '0');   h06_out(d06_in'left downto 0) <= d06_in;   h06_en <= en_in;
   h07_out(h07_out'left downto d07_in'left + 1) <= (others => '0');   h07_out(d07_in'left downto 0) <= d07_in;   h07_en <= en_in;
   h08_out(h08_out'left downto d08_in'left + 1) <= (others => '0');   h08_out(d08_in'left downto 0) <= d08_in;   h08_en <= en_in;
   h09_out(h09_out'left downto d09_in'left + 1) <= (others => '0');   h09_out(d09_in'left downto 0) <= d09_in;   h09_en <= en_in;
   h10_out(h10_out'left downto d10_in'left + 1) <= (others => '0');   h10_out(d10_in'left downto 0) <= d10_in;   h10_en <= en_in;
   h11_out(h11_out'left downto d11_in'left + 1) <= (others => '0');   h11_out(d11_in'left downto 0) <= d11_in;   h11_en <= en_in;
   h12_out(h12_out'left downto d12_in'left + 1) <= (others => '0');   h12_out(d12_in'left downto 0) <= d12_in;   h12_en <= en_in;
   h13_out(h13_out'left downto d13_in'left + 1) <= (others => '0');   h13_out(d13_in'left downto 0) <= d13_in;   h13_en <= en_in;
   h14_out(h14_out'left downto d14_in'left + 1) <= (others => '0');   h14_out(d14_in'left downto 0) <= d14_in;   h14_en <= en_in;
   h15_out(h15_out'left downto d15_in'left + 1) <= (others => '0');   h15_out(d15_in'left downto 0) <= d15_in;   h15_en <= en_in;
   h16_out(h16_out'left downto d16_in'left + 1) <= (others => '0');   h16_out(d16_in'left downto 0) <= d16_in;   h16_en <= en_in;
   h17_out(h17_out'left downto d17_in'left + 1) <= (others => '0');   h17_out(d17_in'left downto 0) <= d17_in;   h17_en <= en_in;
   h18_out(h18_out'left downto d18_in'left + 1) <= (others => '0');   h18_out(d18_in'left downto 0) <= d18_in;   h18_en <= en_in;
   h19_out(h19_out'left downto d19_in'left + 1) <= (others => '0');   h19_out(d19_in'left downto 0) <= d19_in;   h19_en <= en_in;
   h20_out(h20_out'left downto d20_in'left + 1) <= (others => '0');   h20_out(d20_in'left downto 0) <= d20_in;   h20_en <= en_in;
   h21_out(h21_out'left downto d21_in'left + 1) <= (others => '0');   h21_out(d21_in'left downto 0) <= d21_in;   h21_en <= en_in;
   h22_out(h22_out'left downto d22_in'left + 1) <= (others => '0');   h22_out(d22_in'left downto 0) <= d22_in;   h22_en <= en_in;
   h23_out(h23_out'left downto d23_in'left + 1) <= (others => '0');   h23_out(d23_in'left downto 0) <= d23_in;   h23_en <= en_in;
   h24_out(h24_out'left downto d24_in'left + 1) <= (others => '0');   h24_out(d24_in'left downto 0) <= d24_in;   h24_en <= en_in;
   h25_out(h25_out'left downto d25_in'left + 1) <= (others => '0');   h25_out(d25_in'left downto 0) <= d25_in;   h25_en <= en_in;
   h26_out(h26_out'left downto d26_in'left + 1) <= (others => '0');   h26_out(d26_in'left downto 0) <= d26_in;   h26_en <= en_in;
   h27_out(h27_out'left downto d27_in'left + 1) <= (others => '0');   h27_out(d27_in'left downto 0) <= d27_in;   h27_en <= en_in;
   h28_out(h28_out'left downto d28_in'left + 1) <= (others => '0');   h28_out(d28_in'left downto 0) <= d28_in;   h28_en <= en_in;
   h29_out(h29_out'left downto d29_in'left + 1) <= (others => '0');   h29_out(d29_in'left downto 0) <= d29_in;   h29_en <= en_in;
   h30_out(h30_out'left downto d30_in'left + 1) <= (others => '0');   h30_out(d30_in'left downto 0) <= d30_in;   h30_en <= en_in;
   h31_out(h31_out'left downto d31_in'left + 1) <= (others => '0');   h31_out(d31_in'left downto 0) <= d31_in;   h31_en <= en_in;
   h32_out(h32_out'left downto d32_in'left + 1) <= (others => '0');   h32_out(d32_in'left downto 0) <= d32_in;   h32_en <= en_in;
end generate g_Huff_enc_dis;  
                                                                                                  
Buf01 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 0), enw=>h01_en, data_in=>h01_out, data_out=>buff01_out, burst_r=>en_out( 0), fifo_empty=> open, fifo_full=> open ); 
Buf02 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 1), enw=>h02_en, data_in=>h02_out, data_out=>buff02_out, burst_r=>en_out( 1), fifo_empty=> open, fifo_full=> open ); 
Buf03 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 2), enw=>h03_en, data_in=>h03_out, data_out=>buff03_out, burst_r=>en_out( 2), fifo_empty=> open, fifo_full=> open ); 
Buf04 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 3), enw=>h04_en, data_in=>h04_out, data_out=>buff04_out, burst_r=>en_out( 3), fifo_empty=> open, fifo_full=> open ); 
Buf05 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 4), enw=>h05_en, data_in=>h05_out, data_out=>buff05_out, burst_r=>en_out( 4), fifo_empty=> open, fifo_full=> open ); 
Buf06 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 5), enw=>h06_en, data_in=>h06_out, data_out=>buff06_out, burst_r=>en_out( 5), fifo_empty=> open, fifo_full=> open ); 
Buf07 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 6), enw=>h07_en, data_in=>h07_out, data_out=>buff07_out, burst_r=>en_out( 6), fifo_empty=> open, fifo_full=> open ); 
Buf08 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 7), enw=>h08_en, data_in=>h08_out, data_out=>buff08_out, burst_r=>en_out( 7), fifo_empty=> open, fifo_full=> open ); 
Buf09 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 8), enw=>h09_en, data_in=>h09_out, data_out=>buff09_out, burst_r=>en_out( 8), fifo_empty=> open, fifo_full=> open ); 
Buf10 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd( 9), enw=>h10_en, data_in=>h10_out, data_out=>buff10_out, burst_r=>en_out( 9), fifo_empty=> open, fifo_full=> open ); 
Buf11 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(10), enw=>h11_en, data_in=>h11_out, data_out=>buff11_out, burst_r=>en_out(10), fifo_empty=> open, fifo_full=> open ); 
Buf12 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(11), enw=>h12_en, data_in=>h12_out, data_out=>buff12_out, burst_r=>en_out(11), fifo_empty=> open, fifo_full=> open ); 
Buf13 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(12), enw=>h13_en, data_in=>h13_out, data_out=>buff13_out, burst_r=>en_out(12), fifo_empty=> open, fifo_full=> open ); 
Buf14 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(13), enw=>h14_en, data_in=>h14_out, data_out=>buff14_out, burst_r=>en_out(13), fifo_empty=> open, fifo_full=> open ); 
Buf15 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(14), enw=>h15_en, data_in=>h15_out, data_out=>buff15_out, burst_r=>en_out(14), fifo_empty=> open, fifo_full=> open ); 
Buf16 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(15), enw=>h16_en, data_in=>h16_out, data_out=>buff16_out, burst_r=>en_out(15), fifo_empty=> open, fifo_full=> open ); 
Buf17 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(16), enw=>h17_en, data_in=>h17_out, data_out=>buff17_out, burst_r=>en_out(16), fifo_empty=> open, fifo_full=> open ); 
Buf18 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(17), enw=>h18_en, data_in=>h18_out, data_out=>buff18_out, burst_r=>en_out(17), fifo_empty=> open, fifo_full=> open ); 
Buf19 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(18), enw=>h19_en, data_in=>h19_out, data_out=>buff19_out, burst_r=>en_out(18), fifo_empty=> open, fifo_full=> open ); 
Buf20 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(19), enw=>h20_en, data_in=>h20_out, data_out=>buff20_out, burst_r=>en_out(19), fifo_empty=> open, fifo_full=> open ); 
Buf21 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(20), enw=>h21_en, data_in=>h21_out, data_out=>buff21_out, burst_r=>en_out(20), fifo_empty=> open, fifo_full=> open ); 
Buf22 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(21), enw=>h22_en, data_in=>h22_out, data_out=>buff22_out, burst_r=>en_out(21), fifo_empty=> open, fifo_full=> open ); 
Buf23 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(22), enw=>h23_en, data_in=>h23_out, data_out=>buff23_out, burst_r=>en_out(22), fifo_empty=> open, fifo_full=> open ); 
Buf24 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(23), enw=>h24_en, data_in=>h24_out, data_out=>buff24_out, burst_r=>en_out(23), fifo_empty=> open, fifo_full=> open ); 
Buf25 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(24), enw=>h25_en, data_in=>h25_out, data_out=>buff25_out, burst_r=>en_out(24), fifo_empty=> open, fifo_full=> open ); 
Buf26 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(25), enw=>h26_en, data_in=>h26_out, data_out=>buff26_out, burst_r=>en_out(25), fifo_empty=> open, fifo_full=> open ); 
Buf27 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(26), enw=>h27_en, data_in=>h27_out, data_out=>buff27_out, burst_r=>en_out(26), fifo_empty=> open, fifo_full=> open ); 
Buf28 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(27), enw=>h28_en, data_in=>h28_out, data_out=>buff28_out, burst_r=>en_out(27), fifo_empty=> open, fifo_full=> open ); 
Buf29 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(28), enw=>h29_en, data_in=>h29_out, data_out=>buff29_out, burst_r=>en_out(28), fifo_empty=> open, fifo_full=> open ); 
Buf30 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(29), enw=>h30_en, data_in=>h30_out, data_out=>buff30_out, burst_r=>en_out(29), fifo_empty=> open, fifo_full=> open ); 
Buf31 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(30), enw=>h31_en, data_in=>h31_out, data_out=>buff31_out, burst_r=>en_out(30), fifo_empty=> open, fifo_full=> open ); 
Buf32 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(31), enw=>h32_en, data_in=>h32_out, data_out=>buff32_out, burst_r=>en_out(31), fifo_empty=> open, fifo_full=> open ); 
--b_rd <= x"0000000000000001"; -- one Huffman
--d_out <= buff01_out;         -- one Huffman
p_rd_ctr :     process (clk, rst)
begin
   if ( rst = '1') then
      b_rd <= conv_std_logic_vector(0, b_rd'length);
   elsif(rising_edge(clk)) then   
      if buf_rd = '1' then
         --case
         if conv_integer('0' & buf_num) =    0 then b_rd <= x"0000000000000001"; end if;
         if conv_integer('0' & buf_num) =    1 then b_rd <= x"0000000000000002"; end if;
         if conv_integer('0' & buf_num) =    2 then b_rd <= x"0000000000000004"; end if;
         if conv_integer('0' & buf_num) =    3 then b_rd <= x"0000000000000008"; end if;
         if conv_integer('0' & buf_num) =    4 then b_rd <= x"0000000000000010"; end if;
         if conv_integer('0' & buf_num) =    5 then b_rd <= x"0000000000000020"; end if;
         if conv_integer('0' & buf_num) =    6 then b_rd <= x"0000000000000040"; end if;
         if conv_integer('0' & buf_num) =    7 then b_rd <= x"0000000000000080"; end if;
         if conv_integer('0' & buf_num) =    8 then b_rd <= x"0000000000000100"; end if;
         if conv_integer('0' & buf_num) =    9 then b_rd <= x"0000000000000200"; end if;
         if conv_integer('0' & buf_num) =   10 then b_rd <= x"0000000000000400"; end if;
         if conv_integer('0' & buf_num) =   11 then b_rd <= x"0000000000000800"; end if;
         if conv_integer('0' & buf_num) =   12 then b_rd <= x"0000000000001000"; end if;
         if conv_integer('0' & buf_num) =   13 then b_rd <= x"0000000000002000"; end if;
         if conv_integer('0' & buf_num) =   14 then b_rd <= x"0000000000004000"; end if;
         if conv_integer('0' & buf_num) =   15 then b_rd <= x"0000000000008000"; end if;
         if conv_integer('0' & buf_num) =   16 then b_rd <= x"0000000000010000"; end if;
         if conv_integer('0' & buf_num) =   17 then b_rd <= x"0000000000020000"; end if;
         if conv_integer('0' & buf_num) =   18 then b_rd <= x"0000000000040000"; end if;
         if conv_integer('0' & buf_num) =   19 then b_rd <= x"0000000000080000"; end if;
         if conv_integer('0' & buf_num) =   20 then b_rd <= x"0000000000100000"; end if;
         if conv_integer('0' & buf_num) =   21 then b_rd <= x"0000000000200000"; end if;
         if conv_integer('0' & buf_num) =   22 then b_rd <= x"0000000000400000"; end if;
         if conv_integer('0' & buf_num) =   23 then b_rd <= x"0000000000800000"; end if;
         if conv_integer('0' & buf_num) =   24 then b_rd <= x"0000000001000000"; end if;
         if conv_integer('0' & buf_num) =   25 then b_rd <= x"0000000002000000"; end if;
         if conv_integer('0' & buf_num) =   26 then b_rd <= x"0000000004000000"; end if;
         if conv_integer('0' & buf_num) =   27 then b_rd <= x"0000000008000000"; end if;
         if conv_integer('0' & buf_num) =   28 then b_rd <= x"0000000010000000"; end if;
         if conv_integer('0' & buf_num) =   29 then b_rd <= x"0000000020000000"; end if;
         if conv_integer('0' & buf_num) =   30 then b_rd <= x"0000000040000000"; end if;
         if conv_integer('0' & buf_num) =   31 then b_rd <= x"0000000080000000"; end if;
         if conv_integer('0' & buf_num) =   32 then b_rd <= x"0000000100000000"; end if;
            --for i in 0 to (2**C_INPUT_SIZE)-1 generate
            ----begin
            --    when (i = conv_integer(buf_num)) => b_rd <= conv_std_logic_vector((i*2), b_rd'length);        
            --end generate;
            --when others => b_rd <= conv_std_logic_vector(0, b_rd'length);
         --end case;
      end if;
      if conv_integer('0' & buf_num) =  0 then d_out <= buff01_out; end if;
      if conv_integer('0' & buf_num) =  1 then d_out <= buff02_out; end if;
      if conv_integer('0' & buf_num) =  2 then d_out <= buff03_out; end if;
      if conv_integer('0' & buf_num) =  3 then d_out <= buff04_out; end if;
      if conv_integer('0' & buf_num) =  4 then d_out <= buff05_out; end if;
      if conv_integer('0' & buf_num) =  5 then d_out <= buff06_out; end if;
      if conv_integer('0' & buf_num) =  6 then d_out <= buff07_out; end if;
      if conv_integer('0' & buf_num) =  7 then d_out <= buff08_out; end if;
      if conv_integer('0' & buf_num) =  8 then d_out <= buff09_out; end if;
      if conv_integer('0' & buf_num) =  9 then d_out <= buff10_out; end if;
      if conv_integer('0' & buf_num) = 10 then d_out <= buff11_out; end if;
      if conv_integer('0' & buf_num) = 11 then d_out <= buff12_out; end if;
      if conv_integer('0' & buf_num) = 12 then d_out <= buff13_out; end if;
      if conv_integer('0' & buf_num) = 13 then d_out <= buff14_out; end if;
      if conv_integer('0' & buf_num) = 14 then d_out <= buff15_out; end if;
      if conv_integer('0' & buf_num) = 15 then d_out <= buff16_out; end if;
      if conv_integer('0' & buf_num) = 16 then d_out <= buff17_out; end if;
      if conv_integer('0' & buf_num) = 17 then d_out <= buff18_out; end if;
      if conv_integer('0' & buf_num) = 18 then d_out <= buff19_out; end if;
      if conv_integer('0' & buf_num) = 19 then d_out <= buff20_out; end if;
      if conv_integer('0' & buf_num) = 20 then d_out <= buff21_out; end if;
      if conv_integer('0' & buf_num) = 21 then d_out <= buff22_out; end if;
      if conv_integer('0' & buf_num) = 22 then d_out <= buff23_out; end if;
      if conv_integer('0' & buf_num) = 23 then d_out <= buff24_out; end if;
      if conv_integer('0' & buf_num) = 24 then d_out <= buff25_out; end if;
      if conv_integer('0' & buf_num) = 25 then d_out <= buff26_out; end if;
      if conv_integer('0' & buf_num) = 26 then d_out <= buff27_out; end if;
      if conv_integer('0' & buf_num) = 27 then d_out <= buff28_out; end if;
      if conv_integer('0' & buf_num) = 28 then d_out <= buff29_out; end if;
      if conv_integer('0' & buf_num) = 29 then d_out <= buff30_out; end if;
      if conv_integer('0' & buf_num) = 30 then d_out <= buff31_out; end if;
      if conv_integer('0' & buf_num) = 31 then d_out <= buff32_out; end if;
   end if;
end process p_rd_ctr;

end a;