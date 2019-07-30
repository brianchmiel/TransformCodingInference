library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Huffman_dec is
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
end Huffman_dec;

architecture a of Huffman_dec is

constant depth : integer := 10;
constant burst : integer := 20;

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

constant alphabet_depth : integer := 2**N - 1;
type t_Huf_code  is array (0 to alphabet_depth) of std_logic_vector(N-1 downto 0);
type t_Huf_width is array (0 to alphabet_depth) of std_logic_vector(  3 downto 0);
signal Huf_code_m    : t_Huf_code;
signal Huf_width_m   : t_Huf_width;

signal reg_shift     : integer range (  M - 1) downto 0;
signal shift_point   : integer range (2*M - 1) downto 0;

signal reg_buf       : std_logic_vector(2*M-1 downto 0);
signal fifo_out      : std_logic_vector(  W-1 downto 0);
signal dec_data      : std_logic_vector(  M-1 downto 0);
signal dec_out       : std_logic_vector(  M-1 downto 0);

signal reg_rd        : std_logic;
signal match1        : std_logic;
signal matched       : std_logic_vector(255 downto 0);
signal d1_out, d2_out, d3_out, d4_out, d5_out, d6_out, d7_out, d8_out : std_logic_vector(W-1 downto 0); 

begin

-- Huffman table initialisation
  init : process (clk)
  begin
    if rising_edge(clk) then
       if init_en = '1' then
           Huf_code_m (conv_integer('0' & alpha_data)) <= alpha_code ;
           --Huf_width_m(conv_integer('0' & alpha_data)) <= alpha_width; 
       end if;
    end if;
  end process init;

---- conversion
--  conv : process (clk)
--  begin
--    if rising_edge(clk) then
--       if en_in = '1' then
--          Huf_coded  <= Huf_code_m (conv_integer('0' & d_in));
--          Huf_width  <= Huf_width_m(conv_integer('0' & d_in));
--       end if;
--    end if;
--  end process conv;

-- out control

Buf_in : fifo 
  generic map(depth=>depth, burst=>burst, Win=>N, Wout=>N) 
  port map(clk        => clk     ,
           rst        => rst     ,
           enr        => reg_rd  , 
           enw        => en_in   , 
           data_in    => d_in    , 
           data_out   => fifo_out,
           burst_r    => open    , 
           fifo_empty => open    , 
           fifo_full  => open    ); 


  p_fifo_samp : process (clk,rst)
  begin
    if rst = '1' then
       reg_buf     <= (others => '0');
       shift_point <= 2*M - 1;
       reg_rd      <= '0';
    elsif rising_edge(clk) then
       if matched /= 0 then
         shift_point <= shift_point - reg_shift;
         if shift_point + reg_shift >= M then
           reg_buf(reg_buf'left - reg_shift downto 0)  <= reg_buf(reg_buf'left downto reg_shift);
           reg_rd                                      <= '0';
         else
           reg_buf(reg_buf'left downto M) <= fifo_out;
           reg_rd                         <= '1';
         end if;
       else
         reg_rd <= '0';
       end if;
    end if;
  end process p_fifo_samp;

  p_detect : process (clk,rst)
  begin
    if rst = '1' then
       matched <= (others => '0');
    elsif rising_edge(clk) then
        if Huf_code_m( 0)(adr00 downto 0) = reg_buf(adr00 downto 0) then dec_data <= Huf_code_m( 0); matched( 0) <= '1'; reg_shift <= adr00; else matched( 0) <= '0'; end if;
        if Huf_code_m( 1)(adr01 downto 0) = reg_buf(adr01 downto 0) then dec_data <= Huf_code_m( 1); matched( 1) <= '1'; reg_shift <= adr01; else matched( 1) <= '0'; end if;
        if Huf_code_m( 2)(adr02 downto 0) = reg_buf(adr02 downto 0) then dec_data <= Huf_code_m( 2); matched( 2) <= '1'; reg_shift <= adr02; else matched( 2) <= '0'; end if;
        if Huf_code_m( 3)(adr03 downto 0) = reg_buf(adr03 downto 0) then dec_data <= Huf_code_m( 3); matched( 3) <= '1'; reg_shift <= adr03; else matched( 3) <= '0'; end if;
        if Huf_code_m( 4)(adr04 downto 0) = reg_buf(adr04 downto 0) then dec_data <= Huf_code_m( 4); matched( 4) <= '1'; reg_shift <= adr04; else matched( 4) <= '0'; end if;
        if Huf_code_m( 5)(adr05 downto 0) = reg_buf(adr05 downto 0) then dec_data <= Huf_code_m( 5); matched( 5) <= '1'; reg_shift <= adr05; else matched( 5) <= '0'; end if;
        if Huf_code_m( 6)(adr06 downto 0) = reg_buf(adr06 downto 0) then dec_data <= Huf_code_m( 6); matched( 6) <= '1'; reg_shift <= adr06; else matched( 6) <= '0'; end if;
        if Huf_code_m( 7)(adr07 downto 0) = reg_buf(adr07 downto 0) then dec_data <= Huf_code_m( 7); matched( 7) <= '1'; reg_shift <= adr07; else matched( 7) <= '0'; end if;
        if Huf_code_m( 8)(adr08 downto 0) = reg_buf(adr08 downto 0) then dec_data <= Huf_code_m( 8); matched( 8) <= '1'; reg_shift <= adr08; else matched( 8) <= '0'; end if;
        if Huf_code_m( 9)(adr09 downto 0) = reg_buf(adr09 downto 0) then dec_data <= Huf_code_m( 9); matched( 9) <= '1'; reg_shift <= adr09; else matched( 9) <= '0'; end if;
        if Huf_code_m(10)(adr10 downto 0) = reg_buf(adr10 downto 0) then dec_data <= Huf_code_m(10); matched(10) <= '1'; reg_shift <= adr10; else matched(10) <= '0'; end if;
        if Huf_code_m(11)(adr11 downto 0) = reg_buf(adr11 downto 0) then dec_data <= Huf_code_m(11); matched(11) <= '1'; reg_shift <= adr11; else matched(11) <= '0'; end if;
        if Huf_code_m(12)(adr12 downto 0) = reg_buf(adr12 downto 0) then dec_data <= Huf_code_m(12); matched(12) <= '1'; reg_shift <= adr12; else matched(12) <= '0'; end if;
        if Huf_code_m(13)(adr13 downto 0) = reg_buf(adr13 downto 0) then dec_data <= Huf_code_m(13); matched(13) <= '1'; reg_shift <= adr13; else matched(13) <= '0'; end if;
        if Huf_code_m(14)(adr14 downto 0) = reg_buf(adr14 downto 0) then dec_data <= Huf_code_m(14); matched(14) <= '1'; reg_shift <= adr14; else matched(14) <= '0'; end if;
        if Huf_code_m(15)(adr15 downto 0) = reg_buf(adr15 downto 0) then dec_data <= Huf_code_m(15); matched(15) <= '1'; reg_shift <= adr15; else matched(15) <= '0'; end if;
        if Huf_code_m(16)(adr16 downto 0) = reg_buf(adr16 downto 0) then dec_data <= Huf_code_m(16); matched(16) <= '1'; reg_shift <= adr16; else matched(16) <= '0'; end if;
        if Huf_code_m(17)(adr17 downto 0) = reg_buf(adr17 downto 0) then dec_data <= Huf_code_m(17); matched(17) <= '1'; reg_shift <= adr17; else matched(17) <= '0'; end if;
        if Huf_code_m(18)(adr18 downto 0) = reg_buf(adr18 downto 0) then dec_data <= Huf_code_m(18); matched(18) <= '1'; reg_shift <= adr18; else matched(18) <= '0'; end if;
        if Huf_code_m(19)(adr19 downto 0) = reg_buf(adr19 downto 0) then dec_data <= Huf_code_m(19); matched(19) <= '1'; reg_shift <= adr19; else matched(19) <= '0'; end if;
        if Huf_code_m(20)(adr20 downto 0) = reg_buf(adr20 downto 0) then dec_data <= Huf_code_m(20); matched(20) <= '1'; reg_shift <= adr20; else matched(20) <= '0'; end if;
        if Huf_code_m(21)(adr21 downto 0) = reg_buf(adr21 downto 0) then dec_data <= Huf_code_m(21); matched(21) <= '1'; reg_shift <= adr21; else matched(21) <= '0'; end if;
        if Huf_code_m(22)(adr22 downto 0) = reg_buf(adr22 downto 0) then dec_data <= Huf_code_m(22); matched(22) <= '1'; reg_shift <= adr22; else matched(22) <= '0'; end if;
        if Huf_code_m(23)(adr23 downto 0) = reg_buf(adr23 downto 0) then dec_data <= Huf_code_m(23); matched(23) <= '1'; reg_shift <= adr23; else matched(23) <= '0'; end if;
        if Huf_code_m(24)(adr24 downto 0) = reg_buf(adr24 downto 0) then dec_data <= Huf_code_m(24); matched(24) <= '1'; reg_shift <= adr24; else matched(24) <= '0'; end if;
        if Huf_code_m(25)(adr25 downto 0) = reg_buf(adr25 downto 0) then dec_data <= Huf_code_m(25); matched(25) <= '1'; reg_shift <= adr25; else matched(25) <= '0'; end if;
        if Huf_code_m(26)(adr26 downto 0) = reg_buf(adr26 downto 0) then dec_data <= Huf_code_m(26); matched(26) <= '1'; reg_shift <= adr26; else matched(26) <= '0'; end if;
        if Huf_code_m(27)(adr27 downto 0) = reg_buf(adr27 downto 0) then dec_data <= Huf_code_m(27); matched(27) <= '1'; reg_shift <= adr27; else matched(27) <= '0'; end if;
        if Huf_code_m(28)(adr28 downto 0) = reg_buf(adr28 downto 0) then dec_data <= Huf_code_m(28); matched(28) <= '1'; reg_shift <= adr28; else matched(28) <= '0'; end if;
        if Huf_code_m(29)(adr29 downto 0) = reg_buf(adr29 downto 0) then dec_data <= Huf_code_m(29); matched(29) <= '1'; reg_shift <= adr29; else matched(29) <= '0'; end if;
        if Huf_code_m(30)(adr30 downto 0) = reg_buf(adr30 downto 0) then dec_data <= Huf_code_m(30); matched(30) <= '1'; reg_shift <= adr30; else matched(30) <= '0'; end if;
        if Huf_code_m(31)(adr31 downto 0) = reg_buf(adr31 downto 0) then dec_data <= Huf_code_m(31); matched(31) <= '1'; reg_shift <= adr31; else matched(31) <= '0'; end if; 
    end if;
  end process p_detect;

  p_data_out : process (clk,rst)
  begin
    if rst = '1' then
       d_out  <= (others => '0');
       en_out <= '0';
       dec_out<= (others => '0');
       match1 <= '0';
    elsif rising_edge(clk) then
       dec_out<= dec_data;
       d_out  <= dec_out;
       if matched = 0 then 
         match1 <= '1';
       else
         match1 <= '0';
       end if;
       en_out <= match1;
    end if;
  end process p_data_out;

end a;