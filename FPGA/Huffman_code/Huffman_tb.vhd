library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Huffman_tb is
    generic (
           N             : integer := 4; -- input data width
           M             : integer := 12; -- max code width
           Wh            : integer := 16;  -- Huffman unit output data width (Note W>=M)
           Wb            : integer := 512; -- output buffer data width
           depth         : integer := 500; -- buffer depth
           burst         : integer := 10   -- buffer read burst
           );
end entity Huffman_tb;

architecture Huffman_tb of Huffman_tb is

--component Huffman is
--  generic (
--           N             : integer := 4; -- input data width
--           M             : integer := 8; -- max code width
--           W             : integer := 64 -- output data width
--           );
--  port    (
--           clk           : in  std_logic;
--           rst           : in  std_logic; 
--
--           init_en       : in  std_logic;                         -- initialising convert table
--           alpha_data    : in  std_logic_vector(N-1 downto 0);    
--           alpha_code    : in  std_logic_vector(M-1 downto 0);    
--           alpha_width   : in  std_logic_vector(  3 downto 0);
--
--           d_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
--           en_in         : in  std_logic;
--           sof_in           : in  std_logic;                         -- start of frame
--           eof_in           : in  std_logic;                         -- end of frame
--
--           d_out         : out std_logic_vector (W-1 downto 0);
--           en_out        : out std_logic;
--           eof_out       : out std_logic);                        -- huffman codde output
--end component;

component Huffman64 is
  generic (
           N             : integer := 4; -- input data width
           M             : integer := 8;  -- max code width
           Wh            : integer := 16;  -- Huffman unit output data width (Note W>=M)
           Wb            : integer := 512; -- output buffer data width
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
           buf_num       : in  std_logic_vector (5    downto 0);
           d_out         : out std_logic_vector (Wb-1 downto 0);
           en_out        : out std_logic_vector (64  -1 downto 0);
           eof_out       : out std_logic);                        -- huffman codde output
end component;


component Huffman_dec is
  generic (
           N             : integer := 4; -- input data width
           M             : integer := 8; -- max code width
  adr00,  adr01,  adr02,  adr03,  adr04,  adr05,  adr06,  adr07,  adr08,  adr09,  adr10,  adr11,  adr12,  adr13,  adr14,  adr15 : in integer range 0 to 255;
  adr16,  adr17,  adr18,  adr19,  adr20,  adr21,  adr22,  adr23,  adr24,  adr25,  adr26,  adr27,  adr28,  adr29,  adr30,  adr31 : in integer range 0 to 255; 
  adr32,  adr33,  adr34,  adr35,  adr36,  adr37,  adr38,  adr39,  adr40,  adr41,  adr42,  adr43,  adr44,  adr45,  adr46,  adr47 : in integer range 0 to 255; 
  adr48,  adr49,  adr50,  adr51,  adr52,  adr53,  adr54,  adr55,  adr56,  adr57,  adr58,  adr59,  adr60,  adr61,  adr62,  adr63 : in integer range 0 to 255;
  adr64,  adr65,  adr66,  adr67,  adr68,  adr69,  adr70,  adr71,  adr72,  adr73,  adr74,  adr75,  adr76,  adr77,  adr78,  adr79 : in integer range 0 to 255;
  adr80,  adr81,  adr82,  adr83,  adr84,  adr85,  adr86,  adr87,  adr88,  adr89,  adr90,  adr91,  adr92,  adr93,  adr94,  adr95 : in integer range 0 to 255;
  adr96,  adr97,  adr98,  adr99, adr100, adr101, adr102, adr103, adr104, adr105, adr106, adr107, adr108, adr109, adr100, adr111 : in integer range 0 to 255;
 adr112, adr113, adr114, adr115, adr116, adr117, adr118, adr119, adr120, adr121, adr122, adr123, adr124, adr125, adr126, adr127 : in integer range 0 to 255:
 adr128, adr129, adr130, adr131, adr132, adr133, adr134, adr135, adr136, adr137, adr138, adr139, adr140, adr141, adr142, adr143 : in integer range 0 to 255; 
 adr144, adr145, adr146, adr147, adr148, adr149, adr150, adr151, adr152, adr153, adr154, adr155, adr156, adr157, adr158, adr159 : in integer range 0 to 255; 
 adr160, adr161, adr162, adr163, adr164, adr165, adr166, adr167, adr168, adr169, adr170, adr171, adr172, adr173, adr174, adr175 : in integer range 0 to 255; 
 adr176, adr177, adr178, adr179, adr180, adr181, adr182, adr183, adr184, adr185, adr186, adr187, adr188, adr189, adr190, adr191 : in integer range 0 to 255; 
 adr192, adr193, adr194, adr195, adr196, adr197, adr198, adr199, adr200, adr201, adr202, adr203, adr204, adr205, adr206, adr207 : in integer range 0 to 255; 
 adr208, adr209, adr210, adr211, adr212, adr213, adr214, adr215, adr216, adr217, adr218, adr219, adr220, adr221, adr222, adr223 : in integer range 0 to 255; 
 adr224, adr225, adr226, adr227, adr228, adr229, adr230, adr231, adr232, adr233, adr234, adr235, adr236, adr237, adr238, adr239 : in integer range 0 to 255; 
 adr240, adr241, adr242, adr243, adr244, adr245, adr246, adr247, adr248, adr249, adr250, adr251, adr252, adr253, adr254, adr255 : in integer range 0 to 255;
           W             : integer := 10 -- output data width (Note W>=M)
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           init_en       : in  std_logic;                         -- initialising convert table
           alpha_data    : in  std_logic_vector(N-1 downto 0);    
           alpha_code    : in  std_logic_vector(M-1 downto 0);    
           --alpha_width   : in  std_logic_vector(  3 downto 0);

           d_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           en_in         : in  std_logic;
           sof_in        : in  std_logic;                         -- start of frame
           eof_in        : in  std_logic;                         -- end of frame

           d_out         : out std_logic_vector (W-1 downto 0);
           en_out        : out std_logic;
           eof_out       : out std_logic);                        -- huffman codde output
end component;

signal clk           : std_logic;
signal rst           : std_logic;
signal init_en       : std_logic;                         -- initialising convert table
signal alpha_data    : std_logic_vector(N-1 downto 0);    
signal alpha_code    : std_logic_vector(M-1 downto 0);    
signal alpha_width   : std_logic_vector(  3 downto 0);
signal d_in          : std_logic_vector (N-1 downto 0);   -- data to convert
signal en_in         : std_logic;
signal sof_in        : std_logic;                         -- start of frame
signal eof_in        : std_logic;                         -- end of frame
signal d_out         : std_logic_vector (Wb-1 downto 0);
signal en_out        : std_logic_vector (64  -1 downto 0);                -- huffman codde output
signal eof_out       : std_logic;
signal buf_rd        : std_logic;
signal buf_num       : std_logic_vector (5      downto 0);


signal d01_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d02_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d03_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d04_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d05_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d06_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d07_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d08_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d09_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d10_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d11_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d12_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d13_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d14_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d15_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d16_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d17_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d18_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d19_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d20_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d21_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d22_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d23_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d24_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d25_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d26_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d27_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d28_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d29_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d30_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d31_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d32_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d33_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d34_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d35_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d36_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d37_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d38_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d39_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d40_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d41_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d42_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d43_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d44_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d45_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d46_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d47_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d48_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d49_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d50_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d51_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d52_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d53_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d54_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d55_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d56_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d57_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d58_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d59_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d60_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d61_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d62_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d63_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert
signal d64_in        : std_logic_vector (N-1 downto 0) := conv_std_logic_vector( 4 , N);   -- data to convert

begin

--DUT: Huffman generic map (
--      N             => N          ,
--      M             => M          ,
--      W             => W          
--      )
--port map (     
--      clk           => clk        ,
--      rst           => rst        ,
--      init_en       => init_en    ,
--      alpha_data    => alpha_data , 
--      alpha_code    => alpha_code ,   
--      alpha_width   => alpha_width,
--      d_in          => d_in       ,
--      en_in         => en_in      ,
--      sof_in        => sof_in     ,
--      eof_in        => eof_in     ,
--      d_out         => d_out      ,
--      en_out        => en_out     ,
--      eof_out       => eof_out
--    );



DUT: Huffman64 generic map (
      N             => N          ,
      M             => M          ,
      Wh            => Wh          ,   
      Wb            => Wb          , 
      depth         => depth      ,
      burst         => burst                      
      )
port map (     
      clk           => clk        ,
      rst           => rst        ,
      init_en       => init_en    ,
      alpha_data    => alpha_data , 
      alpha_code    => alpha_code ,   
      alpha_width   => alpha_width,
      d01_in        => d01_in ,
      d02_in        => d02_in ,
      d03_in        => d03_in ,
      d04_in        => d04_in ,
      d05_in        => d05_in ,
      d06_in        => d06_in ,
      d07_in        => d07_in ,
      d08_in        => d08_in ,
      d09_in        => d09_in ,
      d10_in        => d10_in ,
      d11_in        => d11_in ,
      d12_in        => d12_in ,
      d13_in        => d13_in ,
      d14_in        => d14_in ,
      d15_in        => d15_in ,
      d16_in        => d16_in ,
      d17_in        => d17_in ,
      d18_in        => d18_in ,
      d19_in        => d19_in ,
      d20_in        => d20_in ,
      d21_in        => d21_in ,
      d22_in        => d22_in ,
      d23_in        => d23_in ,
      d24_in        => d24_in ,
      d25_in        => d25_in ,
      d26_in        => d26_in ,
      d27_in        => d27_in ,
      d28_in        => d28_in ,
      d29_in        => d29_in ,
      d30_in        => d30_in ,
      d31_in        => d31_in ,
      d32_in        => d32_in ,
      d33_in        => d33_in ,
      d34_in        => d34_in ,
      d35_in        => d35_in ,
      d36_in        => d36_in ,
      d37_in        => d37_in ,
      d38_in        => d38_in ,
      d39_in        => d39_in ,
      d40_in        => d40_in ,
      d41_in        => d41_in ,
      d42_in        => d42_in ,
      d43_in        => d43_in ,
      d44_in        => d44_in ,
      d45_in        => d45_in ,
      d46_in        => d46_in ,
      d47_in        => d47_in ,
      d48_in        => d48_in ,
      d49_in        => d49_in ,
      d50_in        => d50_in ,
      d51_in        => d51_in ,
      d52_in        => d52_in ,
      d53_in        => d53_in ,
      d54_in        => d54_in ,
      d55_in        => d55_in ,
      d56_in        => d56_in ,
      d57_in        => d57_in ,
      d58_in        => d58_in ,
      d59_in        => d59_in ,
      d60_in        => d60_in ,
      d61_in        => d61_in ,
      d62_in        => d62_in ,
      d63_in        => d63_in ,
      d64_in        => d64_in ,

      en_in         => en_in      ,
      sof_in        => sof_in     ,
      eof_in        => eof_in     ,

      buf_rd        => buf_rd     ,
      buf_num       => buf_num    ,
      d_out         => d_out      ,
      en_out        => en_out     ,
      eof_out       => eof_out
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
     wait for  5 ns; en_in <= '0'; init_en <= '0'; eof_in <= '0';
     wait for 14 ns; 

-- Init
wait for 10 ns; init_en <= '1'; 
                alpha_data <= conv_std_logic_vector( 1, alpha_data'length); alpha_width<= x"1"; alpha_code<= conv_std_logic_vector(  1, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 2, alpha_data'length); alpha_width<= x"2"; alpha_code<= conv_std_logic_vector(  2, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 3, alpha_data'length); alpha_width<= x"3"; alpha_code<= conv_std_logic_vector(  4, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 4, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 5, alpha_data'length); alpha_width<= x"5"; alpha_code<= conv_std_logic_vector( 16, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 6, alpha_data'length); alpha_width<= x"3"; alpha_code<= conv_std_logic_vector(  4, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 7, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 8, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector( 9, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector(10, alpha_data'length); alpha_width<= x"5"; alpha_code<= conv_std_logic_vector( 16, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector(11, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector(12, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector(13, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector(14, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; alpha_data <= conv_std_logic_vector(15, alpha_data'length); alpha_width<= x"4"; alpha_code<= conv_std_logic_vector(  8, alpha_code'length);
wait for 10 ns; init_en <= '0';
wait for 10 ns; 

wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 1, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 2, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 3, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 4, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 5, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 6, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 7, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 8, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 9, d01_in'length);
wait for 10 ns; en_in <= '1'; d01_in <= conv_std_logic_vector( 3, d01_in'length);


     
wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);eof_in <= '0';
wait for 10 ns; en_in <= '0'; d_in <= conv_std_logic_vector( 0, d_in'length);

   end process;

process        
   begin   
    buf_rd <= '0';
    buf_num <= conv_std_logic_vector( 0, buf_num'length);
     wait for 1400 ns; buf_rd <= '1';
     wait for 100 ns;  buf_rd <= '1';buf_num <= conv_std_logic_vector( 2, buf_num'length);
     wait for 100 ns;   buf_rd <= '0';

wait for 1000 ns; 

wait for 10 ns; 

   end process;

end Huffman_tb;