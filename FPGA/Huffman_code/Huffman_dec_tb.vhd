library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Huffman_dec_tb is
    generic (
           N             : integer := 8; -- input data width
           M             : integer := 12; -- max code width
           W             : integer := 16;    -- dec output width
           Wh            : integer := 16;  -- Huffman unit output data width (Note W>=M)
           --Wb            : integer := 512; -- output buffer data width
           depth         : integer := 500; -- buffer depth
           burst         : integer := 10   -- buffer read burst
           );
end entity Huffman_dec_tb;

architecture Huffman_dec_tb of Huffman_dec_tb is

component Huffman is
  generic (
           N             : integer := 4; -- input data width
           M             : integer := 8; -- max code width
           W             : integer := 64 -- output data width
           );
  port    (
           clk           : in  std_logic;
           rst           : in  std_logic; 

           init_en       : in  std_logic;                         -- initialising convert table
           alpha_data    : in  std_logic_vector(M-1 downto 0);    
           alpha_code    : in  std_logic_vector(M-1 downto 0);    
           alpha_width   : in  std_logic_vector(  3 downto 0);

           d_in          : in  std_logic_vector (N-1 downto 0);   -- data to convert
           en_in         : in  std_logic;
           sof_in           : in  std_logic;                         -- start of frame
           eof_in           : in  std_logic;                         -- end of frame

           d_out         : out std_logic_vector (W-1 downto 0);
           en_out        : out std_logic;
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
  adr96,  adr97,  adr98,  adr99, adr100, adr101, adr102, adr103, adr104, adr105, adr106, adr107, adr108, adr109, adr110, adr111 : in integer range 0 to 255;
 adr112, adr113, adr114, adr115, adr116, adr117, adr118, adr119, adr120, adr121, adr122, adr123, adr124, adr125, adr126, adr127 : in integer range 0 to 255;
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
signal d_out         : std_logic_vector (Wh-1 downto 0);
signal en_out        : std_logic;                -- huffman codde output
signal eof_out       : std_logic;
signal buf_rd        : std_logic;
signal buf_num       : std_logic_vector (5      downto 0);

signal d_enc_out     : std_logic_vector (W-1 downto 0);
signal en_enc_out    : std_logic;
signal eof_enc_out   : std_logic;   

constant A00  : integer := 4;
constant A01  : integer := 1;
constant A02  : integer := 2;
constant A03  : integer := 3;
constant A04  : integer := 4;
constant A05  : integer := 5;
constant A06  : integer := 3;
constant A07  : integer := 4;
constant A08  : integer := 4;
constant A09  : integer := 4;
constant A10  : integer := 5;
constant A11  : integer := 4;
constant A12  : integer := 4;
constant A13  : integer := 4;
constant A14  : integer := 4;
constant A15  : integer := 4;

begin

DUT_en: Huffman generic map (
      N             => N          ,
      M             => 12 , --M          ,
      W             => Wh          
      )
port map (     
      clk           => clk        ,
      rst           => rst        ,
      init_en       => init_en    ,
      alpha_data    => x"000", -- alpha_data ,         FIX IT !!!!
      alpha_code    => alpha_code ,   
      alpha_width   => alpha_width,
      d_in          => d_in       ,
      en_in         => en_in      ,
      sof_in        => sof_in     ,
      eof_in        => eof_in     ,
      d_out         => d_out      ,
      en_out        => en_out     ,
      eof_out       => eof_out
    );



DUT_dec: Huffman_dec generic map (
           N => Wh  , -- input data width
           M => M   , -- max code width
  adr00=>A00,adr01=>A01,adr02=>A02,adr03=>A03,adr04=>A04,adr05=>A05,adr06=>A06,adr07=>A07,adr08=>A08,adr09=>A09,adr10=>A10,adr11=>A11,adr12=>A12,adr13=>A13,adr14=>A14,adr15=>A15,
  adr16=>0,  adr17=>0,  adr18=>0,  adr19=>0,  adr20=>0,  adr21=>0,  adr22=>0,  adr23=>0,  adr24=>0,  adr25=>0,  adr26=>0,  adr27=>0,  adr28=>0,  adr29=>0,  adr30=>0,  adr31=>0, 
  adr32=>0,  adr33=>0,  adr34=>0,  adr35=>0,  adr36=>0,  adr37=>0,  adr38=>0,  adr39=>0,  adr40=>0,  adr41=>0,  adr42=>0,  adr43=>0,  adr44=>0,  adr45=>0,  adr46=>0,  adr47=>0, 
  adr48=>0,  adr49=>0,  adr50=>0,  adr51=>0,  adr52=>0,  adr53=>0,  adr54=>0,  adr55=>0,  adr56=>0,  adr57=>0,  adr58=>0,  adr59=>0,  adr60=>0,  adr61=>0,  adr62=>0,  adr63=>0,
  adr64=>0,  adr65=>0,  adr66=>0,  adr67=>0,  adr68=>0,  adr69=>0,  adr70=>0,  adr71=>0,  adr72=>0,  adr73=>0,  adr74=>0,  adr75=>0,  adr76=>0,  adr77=>0,  adr78=>0,  adr79=>0,
  adr80=>0,  adr81=>0,  adr82=>0,  adr83=>0,  adr84=>0,  adr85=>0,  adr86=>0,  adr87=>0,  adr88=>0,  adr89=>0,  adr90=>0,  adr91=>0,  adr92=>0,  adr93=>0,  adr94=>0,  adr95=>0,
  adr96=>0,  adr97=>0,  adr98=>0,  adr99=>0, adr100=>0, adr101=>0, adr102=>0, adr103=>0, adr104=>0, adr105=>0, adr106=>0, adr107=>0, adr108=>0, adr109=>0, adr110=>0, adr111=>0,
 adr112=>0, adr113=>0, adr114=>0, adr115=>0, adr116=>0, adr117=>0, adr118=>0, adr119=>0, adr120=>0, adr121=>0, adr122=>0, adr123=>0, adr124=>0, adr125=>0, adr126=>0, adr127=>0,
 adr128=>0, adr129=>0, adr130=>0, adr131=>0, adr132=>0, adr133=>0, adr134=>0, adr135=>0, adr136=>0, adr137=>0, adr138=>0, adr139=>0, adr140=>0, adr141=>0, adr142=>0, adr143=>0, 
 adr144=>0, adr145=>0, adr146=>0, adr147=>0, adr148=>0, adr149=>0, adr150=>0, adr151=>0, adr152=>0, adr153=>0, adr154=>0, adr155=>0, adr156=>0, adr157=>0, adr158=>0, adr159=>0, 
 adr160=>0, adr161=>0, adr162=>0, adr163=>0, adr164=>0, adr165=>0, adr166=>0, adr167=>0, adr168=>0, adr169=>0, adr170=>0, adr171=>0, adr172=>0, adr173=>0, adr174=>0, adr175=>0, 
 adr176=>0, adr177=>0, adr178=>0, adr179=>0, adr180=>0, adr181=>0, adr182=>0, adr183=>0, adr184=>0, adr185=>0, adr186=>0, adr187=>0, adr188=>0, adr189=>0, adr190=>0, adr191=>0, 
 adr192=>0, adr193=>0, adr194=>0, adr195=>0, adr196=>0, adr197=>0, adr198=>0, adr199=>0, adr200=>0, adr201=>0, adr202=>0, adr203=>0, adr204=>0, adr205=>0, adr206=>0, adr207=>0, 
 adr208=>0, adr209=>0, adr210=>0, adr211=>0, adr212=>0, adr213=>0, adr214=>0, adr215=>0, adr216=>0, adr217=>0, adr218=>0, adr219=>0, adr220=>0, adr221=>0, adr222=>0, adr223=>0, 
 adr224=>0, adr225=>0, adr226=>0, adr227=>0, adr228=>0, adr229=>0, adr230=>0, adr231=>0, adr232=>0, adr233=>0, adr234=>0, adr235=>0, adr236=>0, adr237=>0, adr238=>0, adr239=>0, 
 adr240=>0, adr241=>0, adr242=>0, adr243=>0, adr244=>0, adr245=>0, adr246=>0, adr247=>0, adr248=>0, adr249=>0, adr250=>0, adr251=>0, adr252=>0, adr253=>0, adr254=>0, adr255=>0,
           W => W -- output data width (Note W>=M)
           )
  port map   (
           clk           => clk          ,
           rst           => rst          ,

           init_en       => init_en      ,                         -- initialising convert table
           alpha_data    => x"0000", --alpha_data   ,                                                                     FIX IT !!!!
           alpha_code    => alpha_code   ,    
           --alpha_width   : in  std_logic_vector(  3 downto 0);

           d_in          => d_out        ,   -- data to convert
           en_in         => en_out       ,
           sof_in        => '0'          ,                        -- start of frame
           eof_in        => '0'          ,                         -- end of frame

           d_out         => d_enc_out    ,
           en_out        => en_enc_out   ,
           eof_out       => eof_enc_out  );                        -- huffman codde output
  

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

wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 1, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 2, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 3, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 4, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 5, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 6, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 7, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 8, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 9, d_in'length);
wait for 10 ns; en_in <= '1'; d_in <= conv_std_logic_vector( 3, d_in'length);


     
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

end Huffman_dec_tb;