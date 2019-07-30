library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ConvLayer_weight_gen is
  generic (
           BP            : string := "no";  --"no"/"yes"  -- Bypass
           M             : integer := 8 -- input weight width
  	       );
  port    (
           clk         : in std_logic;
           rst         : in std_logic;

           w_in        : in  std_logic_vector(M-1 downto 0);
           w_num       : in  std_logic_vector(  4 downto 0);
           w_en        : in  std_logic;

          w1           : out std_logic_vector(M-1 downto 0); -- weight matrix
          w2           : out std_logic_vector(M-1 downto 0);
          w3           : out std_logic_vector(M-1 downto 0);
          w4           : out std_logic_vector(M-1 downto 0);
          w5           : out std_logic_vector(M-1 downto 0);
          w6           : out std_logic_vector(M-1 downto 0);
          w7           : out std_logic_vector(M-1 downto 0);
          w8           : out std_logic_vector(M-1 downto 0);
          w9           : out std_logic_vector(M-1 downto 0);
          w10          : out std_logic_vector(M-1 downto 0);
          w11          : out std_logic_vector(M-1 downto 0);
          w12          : out std_logic_vector(M-1 downto 0);
          w13          : out std_logic_vector(M-1 downto 0);
          w14          : out std_logic_vector(M-1 downto 0);
          w15          : out std_logic_vector(M-1 downto 0);
          w16          : out std_logic_vector(M-1 downto 0);
          w17          : out std_logic_vector(M-1 downto 0);
          w18          : out std_logic_vector(M-1 downto 0);
          w19          : out std_logic_vector(M-1 downto 0);
          w20          : out std_logic_vector(M-1 downto 0);
          w21          : out std_logic_vector(M-1 downto 0);
          w22          : out std_logic_vector(M-1 downto 0);
          w23          : out std_logic_vector(M-1 downto 0);
          w24          : out std_logic_vector(M-1 downto 0);
          w25          : out std_logic_vector(M-1 downto 0)
           );
end ConvLayer_weight_gen;

architecture a of ConvLayer_weight_gen is

begin

gen_no_BP: if BP = "no" generate 
-- weight update

  p_weight : process (clk)
  begin
    if rising_edge(clk) then
       if w_en = '1' then
          case w_num is
            when "00001"       =>  w1  <= w_in;
            when "00010"       =>  w2  <= w_in;
            when "00011"       =>  w3  <= w_in;
            when "00100"       =>  w4  <= w_in;
            when "00101"       =>  w5  <= w_in;
            when "00110"       =>  w6  <= w_in;
            when "00111"       =>  w7  <= w_in;
            when "01000"       =>  w8  <= w_in;
            when "01001"       =>  w9  <= w_in;
            when "01010"       =>  w10 <= w_in;
            when "01011"       =>  w11 <= w_in;
            when "01100"       =>  w12 <= w_in;
            when "01101"       =>  w13 <= w_in;
            when "01110"       =>  w14 <= w_in;
            when "01111"       =>  w15 <= w_in;
            when "10000"       =>  w16 <= w_in;
            when "10001"       =>  w17 <= w_in;
            when "10010"       =>  w18 <= w_in;
            when "10011"       =>  w19 <= w_in;
            when "10100"       =>  w20 <= w_in;
            when "10101"       =>  w21 <= w_in;
            when "10110"       =>  w22 <= w_in;
            when "10111"       =>  w23 <= w_in;
            when "11000"       =>  w24 <= w_in;
            when "11001"       =>  w25 <= w_in;
            when others    =>  null;
          end case;
       end if;
    end if;
  end process p_weight;

end generate; -- BP = yes

gen_BP: if BP = "yes" generate 

          w1 (w1 'left) <= '1'; w1 (w1 'left - 1 downto 0) <= (others => '0');
          w2 (w2 'left) <= '1'; w2 (w2 'left - 1 downto 0) <= (others => '0');
          w3 (w3 'left) <= '1'; w3 (w3 'left - 1 downto 0) <= (others => '0');
          w4 (w4 'left) <= '1'; w4 (w4 'left - 1 downto 0) <= (others => '0');
          w5 (w5 'left) <= '1'; w5 (w5 'left - 1 downto 0) <= (others => '0');
          w6 (w6 'left) <= '1'; w6 (w6 'left - 1 downto 0) <= (others => '0');
          w7 (w7 'left) <= '1'; w7 (w7 'left - 1 downto 0) <= (others => '0');
          w8 (w8 'left) <= '1'; w8 (w8 'left - 1 downto 0) <= (others => '0');
          w9 (w9 'left) <= '1'; w9 (w9 'left - 1 downto 0) <= (others => '0');
          w10(w10'left) <= '1'; w10(w10'left - 1 downto 0) <= (others => '0');
          w11(w11'left) <= '1'; w11(w11'left - 1 downto 0) <= (others => '0');
          w12(w12'left) <= '1'; w12(w12'left - 1 downto 0) <= (others => '0');
          w13(w13'left) <= '1'; w13(w13'left - 1 downto 0) <= (others => '0');
          w14(w14'left) <= '1'; w14(w14'left - 1 downto 0) <= (others => '0');
          w15(w15'left) <= '1'; w15(w15'left - 1 downto 0) <= (others => '0');
          w16(w16'left) <= '1'; w16(w16'left - 1 downto 0) <= (others => '0');
          w17(w17'left) <= '1'; w17(w17'left - 1 downto 0) <= (others => '0');
          w18(w18'left) <= '1'; w18(w18'left - 1 downto 0) <= (others => '0');
          w19(w19'left) <= '1'; w19(w19'left - 1 downto 0) <= (others => '0');
          w20(w20'left) <= '1'; w20(w20'left - 1 downto 0) <= (others => '0');
          w21(w21'left) <= '1'; w21(w21'left - 1 downto 0) <= (others => '0');
          w22(w22'left) <= '1'; w22(w22'left - 1 downto 0) <= (others => '0');
          w23(w23'left) <= '1'; w23(w23'left - 1 downto 0) <= (others => '0');
          w24(w24'left) <= '1'; w24(w24'left - 1 downto 0) <= (others => '0');
          w25(w25'left) <= '1'; w25(w25'left - 1 downto 0) <= (others => '0');

end generate;


end a;