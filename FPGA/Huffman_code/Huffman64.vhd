library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Huffman64 is
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
           d33_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d34_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d35_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d36_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d37_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d38_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d39_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d40_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d41_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d42_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d43_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d44_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d45_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d46_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d47_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d48_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d49_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d50_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d51_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d52_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d53_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d54_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d55_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d56_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d57_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d58_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d59_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d60_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d61_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d62_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d63_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           d64_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
  	       en_in         : in  std_logic;
  	       sof_in        : in  std_logic;                         -- start of frame
           eof_in        : in  std_logic;                         -- end of frame

           buf_rd        : in  std_logic;
           buf_num       : in  std_logic_vector (5      downto 0);
           d_out         : out std_logic_vector (Wb  -1 downto 0);
           en_out        : out std_logic_vector (64  -1 downto 0);
           eof_out       : out std_logic);                        -- huffman codde output
end Huffman64;

architecture a of Huffman64 is


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
signal h33_out     : std_logic_vector(Wh-1 downto 0);
signal h34_out     : std_logic_vector(Wh-1 downto 0);
signal h35_out     : std_logic_vector(Wh-1 downto 0);
signal h36_out     : std_logic_vector(Wh-1 downto 0);
signal h37_out     : std_logic_vector(Wh-1 downto 0);
signal h38_out     : std_logic_vector(Wh-1 downto 0);
signal h39_out     : std_logic_vector(Wh-1 downto 0);
signal h40_out     : std_logic_vector(Wh-1 downto 0);
signal h41_out     : std_logic_vector(Wh-1 downto 0);
signal h42_out     : std_logic_vector(Wh-1 downto 0);
signal h43_out     : std_logic_vector(Wh-1 downto 0);
signal h44_out     : std_logic_vector(Wh-1 downto 0);
signal h45_out     : std_logic_vector(Wh-1 downto 0);
signal h46_out     : std_logic_vector(Wh-1 downto 0);
signal h47_out     : std_logic_vector(Wh-1 downto 0);
signal h48_out     : std_logic_vector(Wh-1 downto 0);
signal h49_out     : std_logic_vector(Wh-1 downto 0);
signal h50_out     : std_logic_vector(Wh-1 downto 0);
signal h51_out     : std_logic_vector(Wh-1 downto 0);
signal h52_out     : std_logic_vector(Wh-1 downto 0);
signal h53_out     : std_logic_vector(Wh-1 downto 0);
signal h54_out     : std_logic_vector(Wh-1 downto 0);
signal h55_out     : std_logic_vector(Wh-1 downto 0);
signal h56_out     : std_logic_vector(Wh-1 downto 0);
signal h57_out     : std_logic_vector(Wh-1 downto 0);
signal h58_out     : std_logic_vector(Wh-1 downto 0);
signal h59_out     : std_logic_vector(Wh-1 downto 0);
signal h60_out     : std_logic_vector(Wh-1 downto 0);
signal h61_out     : std_logic_vector(Wh-1 downto 0);
signal h62_out     : std_logic_vector(Wh-1 downto 0);
signal h63_out     : std_logic_vector(Wh-1 downto 0);
signal h64_out     : std_logic_vector(Wh-1 downto 0);

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
signal h33_en     : std_logic;
signal h34_en     : std_logic;
signal h35_en     : std_logic;
signal h36_en     : std_logic;
signal h37_en     : std_logic;
signal h38_en     : std_logic;
signal h39_en     : std_logic;
signal h40_en     : std_logic;
signal h41_en     : std_logic;
signal h42_en     : std_logic;
signal h43_en     : std_logic;
signal h44_en     : std_logic;
signal h45_en     : std_logic;
signal h46_en     : std_logic;
signal h47_en     : std_logic;
signal h48_en     : std_logic;
signal h49_en     : std_logic;
signal h50_en     : std_logic;
signal h51_en     : std_logic;
signal h52_en     : std_logic;
signal h53_en     : std_logic;
signal h54_en     : std_logic;
signal h55_en     : std_logic;
signal h56_en     : std_logic;
signal h57_en     : std_logic;
signal h58_en     : std_logic;
signal h59_en     : std_logic;
signal h60_en     : std_logic;
signal h61_en     : std_logic;
signal h62_en     : std_logic;
signal h63_en     : std_logic;
signal h64_en     : std_logic;

signal buff01_out, buff02_out, buff03_out, buff04_out, buff05_out, buff06_out, buff07_out, buff08_out, buff09_out, buff10_out, buff11_out, buff12_out, buff13_out, buff14_out, buff15_out, buff16_out, buff17_out, buff18_out, buff19_out, buff20_out, buff21_out, buff22_out, buff23_out, buff24_out, buff25_out, buff26_out, buff27_out, buff28_out, buff29_out, buff30_out, buff31_out, buff32_out : std_logic_vector(Wb-1 downto 0);
signal buff33_out, buff34_out, buff35_out, buff36_out, buff37_out, buff38_out, buff39_out, buff40_out, buff41_out, buff42_out, buff43_out, buff44_out, buff45_out, buff46_out, buff47_out, buff48_out, buff49_out, buff50_out, buff51_out, buff52_out, buff53_out, buff54_out, buff55_out, buff56_out, buff57_out, buff58_out, buff59_out, buff60_out, buff61_out, buff62_out, buff63_out, buff64_out : std_logic_vector(Wb-1 downto 0);

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
   Huf33 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d33_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h33_out, en_out => h33_en, eof_out => open);
   Huf34 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d34_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h34_out, en_out => h34_en, eof_out => open);
   Huf35 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d35_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h35_out, en_out => h35_en, eof_out => open);
   Huf36 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d36_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h36_out, en_out => h36_en, eof_out => open);
   Huf37 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d37_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h37_out, en_out => h37_en, eof_out => open);
   Huf38 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d38_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h38_out, en_out => h38_en, eof_out => open);
   Huf39 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d39_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h39_out, en_out => h39_en, eof_out => open);
   Huf40 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d40_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h40_out, en_out => h40_en, eof_out => open);
   Huf41 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d41_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h41_out, en_out => h41_en, eof_out => open);
   Huf42 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d42_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h42_out, en_out => h42_en, eof_out => open);
   Huf43 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d43_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h43_out, en_out => h43_en, eof_out => open);
   Huf44 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d44_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h44_out, en_out => h44_en, eof_out => open);
   Huf45 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d45_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h45_out, en_out => h45_en, eof_out => open);
   Huf46 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d46_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h46_out, en_out => h46_en, eof_out => open);
   Huf47 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d47_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h47_out, en_out => h47_en, eof_out => open);
   Huf48 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d48_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h48_out, en_out => h48_en, eof_out => open);
   Huf49 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d49_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h49_out, en_out => h49_en, eof_out => open);
   Huf50 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d50_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h50_out, en_out => h50_en, eof_out => open);
   Huf51 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d51_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h51_out, en_out => h51_en, eof_out => open);
   Huf52 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d52_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h52_out, en_out => h52_en, eof_out => open);
   Huf53 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d53_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h53_out, en_out => h53_en, eof_out => open);
   Huf54 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d54_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h54_out, en_out => h54_en, eof_out => open);
   Huf55 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d55_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h55_out, en_out => h55_en, eof_out => open);
   Huf56 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d56_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h56_out, en_out => h56_en, eof_out => open);
   Huf57 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d57_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h57_out, en_out => h57_en, eof_out => open);
   Huf58 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d58_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h58_out, en_out => h58_en, eof_out => open);
   Huf59 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d59_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h59_out, en_out => h59_en, eof_out => open);
   Huf60 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d60_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h60_out, en_out => h60_en, eof_out => open);
   Huf61 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d61_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h61_out, en_out => h61_en, eof_out => open);
   Huf62 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d62_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h62_out, en_out => h62_en, eof_out => open);
   Huf63 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d63_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h63_out, en_out => h63_en, eof_out => open);
   Huf64 : Huffman generic map(N => N, M => M, W => Wh) port map( clk =>clk, rst =>rst , init_en => init_en, alpha_data => alpha_data, alpha_code => alpha_code, alpha_width => alpha_width, d_in  => d64_in, en_in => en_in, sof_in=> sof_in, eof_in=> eof_in, d_out => h64_out, en_out => h64_en, eof_out => open);
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
   h33_out(h33_out'left downto d33_in'left + 1) <= (others => '0');   h33_out(d33_in'left downto 0) <= d33_in;   h33_en <= en_in;
   h34_out(h34_out'left downto d34_in'left + 1) <= (others => '0');   h34_out(d34_in'left downto 0) <= d34_in;   h34_en <= en_in;
   h35_out(h35_out'left downto d35_in'left + 1) <= (others => '0');   h35_out(d35_in'left downto 0) <= d35_in;   h35_en <= en_in;
   h36_out(h36_out'left downto d36_in'left + 1) <= (others => '0');   h36_out(d36_in'left downto 0) <= d36_in;   h36_en <= en_in;
   h37_out(h37_out'left downto d37_in'left + 1) <= (others => '0');   h37_out(d37_in'left downto 0) <= d37_in;   h37_en <= en_in;
   h38_out(h38_out'left downto d38_in'left + 1) <= (others => '0');   h38_out(d38_in'left downto 0) <= d38_in;   h38_en <= en_in;
   h39_out(h39_out'left downto d39_in'left + 1) <= (others => '0');   h39_out(d39_in'left downto 0) <= d39_in;   h39_en <= en_in;
   h40_out(h40_out'left downto d40_in'left + 1) <= (others => '0');   h40_out(d40_in'left downto 0) <= d40_in;   h40_en <= en_in;
   h41_out(h41_out'left downto d41_in'left + 1) <= (others => '0');   h41_out(d41_in'left downto 0) <= d41_in;   h41_en <= en_in;
   h42_out(h42_out'left downto d42_in'left + 1) <= (others => '0');   h42_out(d42_in'left downto 0) <= d42_in;   h42_en <= en_in;
   h43_out(h43_out'left downto d43_in'left + 1) <= (others => '0');   h43_out(d43_in'left downto 0) <= d43_in;   h43_en <= en_in;
   h44_out(h44_out'left downto d44_in'left + 1) <= (others => '0');   h44_out(d44_in'left downto 0) <= d44_in;   h44_en <= en_in;
   h45_out(h45_out'left downto d45_in'left + 1) <= (others => '0');   h45_out(d45_in'left downto 0) <= d45_in;   h45_en <= en_in;
   h46_out(h46_out'left downto d46_in'left + 1) <= (others => '0');   h46_out(d46_in'left downto 0) <= d46_in;   h46_en <= en_in;
   h47_out(h47_out'left downto d47_in'left + 1) <= (others => '0');   h47_out(d47_in'left downto 0) <= d47_in;   h47_en <= en_in;
   h48_out(h48_out'left downto d48_in'left + 1) <= (others => '0');   h48_out(d48_in'left downto 0) <= d48_in;   h48_en <= en_in;
   h49_out(h49_out'left downto d49_in'left + 1) <= (others => '0');   h49_out(d49_in'left downto 0) <= d49_in;   h49_en <= en_in;
   h50_out(h50_out'left downto d50_in'left + 1) <= (others => '0');   h50_out(d50_in'left downto 0) <= d50_in;   h50_en <= en_in;
   h51_out(h51_out'left downto d51_in'left + 1) <= (others => '0');   h51_out(d51_in'left downto 0) <= d51_in;   h51_en <= en_in;
   h52_out(h52_out'left downto d52_in'left + 1) <= (others => '0');   h52_out(d52_in'left downto 0) <= d52_in;   h52_en <= en_in;
   h53_out(h53_out'left downto d53_in'left + 1) <= (others => '0');   h53_out(d53_in'left downto 0) <= d53_in;   h53_en <= en_in;
   h54_out(h54_out'left downto d54_in'left + 1) <= (others => '0');   h54_out(d54_in'left downto 0) <= d54_in;   h54_en <= en_in;
   h55_out(h55_out'left downto d55_in'left + 1) <= (others => '0');   h55_out(d55_in'left downto 0) <= d55_in;   h55_en <= en_in;
   h56_out(h56_out'left downto d56_in'left + 1) <= (others => '0');   h56_out(d56_in'left downto 0) <= d56_in;   h56_en <= en_in;
   h57_out(h57_out'left downto d57_in'left + 1) <= (others => '0');   h57_out(d57_in'left downto 0) <= d57_in;   h57_en <= en_in;
   h58_out(h58_out'left downto d58_in'left + 1) <= (others => '0');   h58_out(d58_in'left downto 0) <= d58_in;   h58_en <= en_in;
   h59_out(h59_out'left downto d59_in'left + 1) <= (others => '0');   h59_out(d59_in'left downto 0) <= d59_in;   h59_en <= en_in;
   h60_out(h60_out'left downto d60_in'left + 1) <= (others => '0');   h60_out(d60_in'left downto 0) <= d60_in;   h60_en <= en_in;
   h61_out(h61_out'left downto d61_in'left + 1) <= (others => '0');   h61_out(d61_in'left downto 0) <= d61_in;   h61_en <= en_in;
   h62_out(h62_out'left downto d62_in'left + 1) <= (others => '0');   h62_out(d62_in'left downto 0) <= d62_in;   h62_en <= en_in;
   h63_out(h63_out'left downto d63_in'left + 1) <= (others => '0');   h63_out(d63_in'left downto 0) <= d63_in;   h63_en <= en_in;
   h64_out(h64_out'left downto d64_in'left + 1) <= (others => '0');   h64_out(d64_in'left downto 0) <= d64_in;   h64_en <= en_in;
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
Buf33 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(32), enw=>h33_en, data_in=>h33_out, data_out=>buff33_out, burst_r=>en_out(32), fifo_empty=> open, fifo_full=> open ); 
Buf34 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(33), enw=>h34_en, data_in=>h34_out, data_out=>buff34_out, burst_r=>en_out(33), fifo_empty=> open, fifo_full=> open ); 
Buf35 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(34), enw=>h35_en, data_in=>h35_out, data_out=>buff35_out, burst_r=>en_out(34), fifo_empty=> open, fifo_full=> open ); 
Buf36 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(35), enw=>h36_en, data_in=>h36_out, data_out=>buff36_out, burst_r=>en_out(35), fifo_empty=> open, fifo_full=> open ); 
Buf37 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(36), enw=>h37_en, data_in=>h37_out, data_out=>buff37_out, burst_r=>en_out(36), fifo_empty=> open, fifo_full=> open ); 
Buf38 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(37), enw=>h38_en, data_in=>h38_out, data_out=>buff38_out, burst_r=>en_out(37), fifo_empty=> open, fifo_full=> open ); 
Buf39 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(38), enw=>h39_en, data_in=>h39_out, data_out=>buff39_out, burst_r=>en_out(38), fifo_empty=> open, fifo_full=> open ); 
Buf40 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(39), enw=>h40_en, data_in=>h40_out, data_out=>buff40_out, burst_r=>en_out(39), fifo_empty=> open, fifo_full=> open ); 
Buf41 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(40), enw=>h41_en, data_in=>h41_out, data_out=>buff41_out, burst_r=>en_out(40), fifo_empty=> open, fifo_full=> open ); 
Buf42 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(41), enw=>h42_en, data_in=>h42_out, data_out=>buff42_out, burst_r=>en_out(41), fifo_empty=> open, fifo_full=> open ); 
Buf43 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(42), enw=>h43_en, data_in=>h43_out, data_out=>buff43_out, burst_r=>en_out(42), fifo_empty=> open, fifo_full=> open ); 
Buf44 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(43), enw=>h44_en, data_in=>h44_out, data_out=>buff44_out, burst_r=>en_out(43), fifo_empty=> open, fifo_full=> open ); 
Buf45 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(44), enw=>h45_en, data_in=>h45_out, data_out=>buff45_out, burst_r=>en_out(44), fifo_empty=> open, fifo_full=> open ); 
Buf46 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(45), enw=>h46_en, data_in=>h46_out, data_out=>buff46_out, burst_r=>en_out(45), fifo_empty=> open, fifo_full=> open ); 
Buf47 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(46), enw=>h47_en, data_in=>h47_out, data_out=>buff47_out, burst_r=>en_out(46), fifo_empty=> open, fifo_full=> open ); 
Buf48 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(47), enw=>h48_en, data_in=>h48_out, data_out=>buff48_out, burst_r=>en_out(47), fifo_empty=> open, fifo_full=> open ); 
Buf49 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(48), enw=>h49_en, data_in=>h49_out, data_out=>buff49_out, burst_r=>en_out(48), fifo_empty=> open, fifo_full=> open ); 
Buf50 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(49), enw=>h50_en, data_in=>h50_out, data_out=>buff50_out, burst_r=>en_out(49), fifo_empty=> open, fifo_full=> open ); 
Buf51 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(50), enw=>h51_en, data_in=>h51_out, data_out=>buff51_out, burst_r=>en_out(50), fifo_empty=> open, fifo_full=> open ); 
Buf52 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(51), enw=>h52_en, data_in=>h52_out, data_out=>buff52_out, burst_r=>en_out(51), fifo_empty=> open, fifo_full=> open ); 
Buf53 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(52), enw=>h53_en, data_in=>h53_out, data_out=>buff53_out, burst_r=>en_out(52), fifo_empty=> open, fifo_full=> open ); 
Buf54 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(53), enw=>h54_en, data_in=>h54_out, data_out=>buff54_out, burst_r=>en_out(53), fifo_empty=> open, fifo_full=> open ); 
Buf55 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(54), enw=>h55_en, data_in=>h55_out, data_out=>buff55_out, burst_r=>en_out(54), fifo_empty=> open, fifo_full=> open ); 
Buf56 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(55), enw=>h56_en, data_in=>h56_out, data_out=>buff56_out, burst_r=>en_out(55), fifo_empty=> open, fifo_full=> open ); 
Buf57 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(56), enw=>h57_en, data_in=>h57_out, data_out=>buff57_out, burst_r=>en_out(56), fifo_empty=> open, fifo_full=> open ); 
Buf58 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(57), enw=>h58_en, data_in=>h58_out, data_out=>buff58_out, burst_r=>en_out(57), fifo_empty=> open, fifo_full=> open ); 
Buf59 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(58), enw=>h59_en, data_in=>h59_out, data_out=>buff59_out, burst_r=>en_out(58), fifo_empty=> open, fifo_full=> open ); 
Buf60 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(59), enw=>h60_en, data_in=>h60_out, data_out=>buff60_out, burst_r=>en_out(59), fifo_empty=> open, fifo_full=> open ); 
Buf61 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(60), enw=>h61_en, data_in=>h61_out, data_out=>buff61_out, burst_r=>en_out(60), fifo_empty=> open, fifo_full=> open ); 
Buf62 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(61), enw=>h62_en, data_in=>h62_out, data_out=>buff62_out, burst_r=>en_out(61), fifo_empty=> open, fifo_full=> open ); 
Buf63 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(62), enw=>h63_en, data_in=>h63_out, data_out=>buff63_out, burst_r=>en_out(62), fifo_empty=> open, fifo_full=> open ); 
Buf64 : fifo generic map(depth=>depth, burst=>burst, Win=>Wh, Wout=>Wb) port map(clk =>clk, rst =>rst, enr =>b_rd(63), enw=>h64_en, data_in=>h64_out, data_out=>buff64_out, burst_r=>en_out(63), fifo_empty=> open, fifo_full=> open ); 

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
         if conv_integer('0' & buf_num) =   33 then b_rd <= x"0000000200000000"; end if;
         if conv_integer('0' & buf_num) =   34 then b_rd <= x"0000000400000000"; end if;
         if conv_integer('0' & buf_num) =   35 then b_rd <= x"0000000800000000"; end if;
         if conv_integer('0' & buf_num) =   36 then b_rd <= x"0000001000000000"; end if;
         if conv_integer('0' & buf_num) =   37 then b_rd <= x"0000002000000000"; end if;
         if conv_integer('0' & buf_num) =   38 then b_rd <= x"0000004000000000"; end if;
         if conv_integer('0' & buf_num) =   39 then b_rd <= x"0000008000000000"; end if;
         if conv_integer('0' & buf_num) =   40 then b_rd <= x"0000010000000000"; end if;
         if conv_integer('0' & buf_num) =   41 then b_rd <= x"0000020000000000"; end if;
         if conv_integer('0' & buf_num) =   42 then b_rd <= x"0000040000000000"; end if;
         if conv_integer('0' & buf_num) =   43 then b_rd <= x"0000080000000000"; end if;
         if conv_integer('0' & buf_num) =   44 then b_rd <= x"0000100000000000"; end if;
         if conv_integer('0' & buf_num) =   45 then b_rd <= x"0000200000000000"; end if;
         if conv_integer('0' & buf_num) =   46 then b_rd <= x"0000400000000000"; end if;
         if conv_integer('0' & buf_num) =   47 then b_rd <= x"0000800000000000"; end if;
         if conv_integer('0' & buf_num) =   48 then b_rd <= x"0001000000000000"; end if;
         if conv_integer('0' & buf_num) =   49 then b_rd <= x"0002000000000000"; end if;
         if conv_integer('0' & buf_num) =   50 then b_rd <= x"0004000000000000"; end if;
         if conv_integer('0' & buf_num) =   51 then b_rd <= x"0008000000000000"; end if;
         if conv_integer('0' & buf_num) =   52 then b_rd <= x"0010000000000000"; end if;
         if conv_integer('0' & buf_num) =   53 then b_rd <= x"0020000000000000"; end if;
         if conv_integer('0' & buf_num) =   54 then b_rd <= x"0040000000000000"; end if;
         if conv_integer('0' & buf_num) =   55 then b_rd <= x"0080000000000000"; end if;
         if conv_integer('0' & buf_num) =   56 then b_rd <= x"0100000000000000"; end if;
         if conv_integer('0' & buf_num) =   57 then b_rd <= x"0200000000000000"; end if;
         if conv_integer('0' & buf_num) =   58 then b_rd <= x"0400000000000000"; end if;
         if conv_integer('0' & buf_num) =   59 then b_rd <= x"0800000000000000"; end if;
         if conv_integer('0' & buf_num) =   60 then b_rd <= x"1000000000000000"; end if;
         if conv_integer('0' & buf_num) =   61 then b_rd <= x"2000000000000000"; end if;
         if conv_integer('0' & buf_num) =   62 then b_rd <= x"4000000000000000"; end if;
         if conv_integer('0' & buf_num) =   63 then b_rd <= x"8000000000000000"; end if;
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
      if conv_integer('0' & buf_num) = 32 then d_out <= buff33_out; end if;
      if conv_integer('0' & buf_num) = 33 then d_out <= buff34_out; end if;
      if conv_integer('0' & buf_num) = 34 then d_out <= buff35_out; end if;
      if conv_integer('0' & buf_num) = 35 then d_out <= buff36_out; end if;
      if conv_integer('0' & buf_num) = 36 then d_out <= buff37_out; end if;
      if conv_integer('0' & buf_num) = 37 then d_out <= buff38_out; end if;
      if conv_integer('0' & buf_num) = 38 then d_out <= buff39_out; end if;
      if conv_integer('0' & buf_num) = 39 then d_out <= buff40_out; end if;
      if conv_integer('0' & buf_num) = 40 then d_out <= buff41_out; end if;
      if conv_integer('0' & buf_num) = 41 then d_out <= buff42_out; end if;
      if conv_integer('0' & buf_num) = 42 then d_out <= buff43_out; end if;
      if conv_integer('0' & buf_num) = 43 then d_out <= buff44_out; end if;
      if conv_integer('0' & buf_num) = 44 then d_out <= buff45_out; end if;
      if conv_integer('0' & buf_num) = 45 then d_out <= buff46_out; end if;
      if conv_integer('0' & buf_num) = 46 then d_out <= buff47_out; end if;
      if conv_integer('0' & buf_num) = 47 then d_out <= buff48_out; end if;
      if conv_integer('0' & buf_num) = 48 then d_out <= buff49_out; end if;
      if conv_integer('0' & buf_num) = 49 then d_out <= buff50_out; end if;
      if conv_integer('0' & buf_num) = 50 then d_out <= buff51_out; end if;
      if conv_integer('0' & buf_num) = 51 then d_out <= buff52_out; end if;
      if conv_integer('0' & buf_num) = 52 then d_out <= buff53_out; end if;
      if conv_integer('0' & buf_num) = 53 then d_out <= buff54_out; end if;
      if conv_integer('0' & buf_num) = 54 then d_out <= buff55_out; end if;
      if conv_integer('0' & buf_num) = 55 then d_out <= buff56_out; end if;
      if conv_integer('0' & buf_num) = 56 then d_out <= buff57_out; end if;
      if conv_integer('0' & buf_num) = 57 then d_out <= buff58_out; end if;
      if conv_integer('0' & buf_num) = 58 then d_out <= buff59_out; end if;
      if conv_integer('0' & buf_num) = 59 then d_out <= buff60_out; end if;
      if conv_integer('0' & buf_num) = 60 then d_out <= buff61_out; end if;
      if conv_integer('0' & buf_num) = 61 then d_out <= buff62_out; end if;
      if conv_integer('0' & buf_num) = 62 then d_out <= buff63_out; end if;
      if conv_integer('0' & buf_num) = 63 then d_out <= buff64_out; end if;
   end if;
end process p_rd_ctr;

end a;