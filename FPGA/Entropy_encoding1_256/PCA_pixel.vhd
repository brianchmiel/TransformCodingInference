library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;       -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
library work;
--use work.types_packege.all;
use work.ConvLayer_types_package.all;

entity PCA_pixel is
    generic (
        CL_outs        : integer := 64; -- number of output features
        N              : integer := 8; -- input/output data width
        M              : integer := 8; -- input weight width
        SR             : integer := 1;  -- data shift right before output (deleted LSBs)
        in_row         : integer := 3;
        in_col         : integer := 6
        );
    port (
        rst            : in  std_logic;
        clk            : in  std_logic;
        sof            : in  std_logic;
        eof            : in  std_logic;
        data_in        : in  std_logic_vector(N-1 downto 0);
        data_in_valid  : in  std_logic;
        --weight_in      : in  vec(0 to in_row - 1)(M-1 downto 0);
        weight_in      : in  std_logic_vector(in_row * M-1 downto 0);
        data_out       : out vec(0 to CL_outs - 1)(N-1 downto 0);
        data_out_valid : out std_logic
    ) ;
end PCA_pixel;

architecture PCA_pixel_arc of PCA_pixel is

constant sign_ext : integer  :=  8; -- TBD 9;  -- max 512 inputs
constant ones     : std_logic_vector(sign_ext-1 downto 0) := (others => '1');
constant zeros    : std_logic_vector(sign_ext-1 downto 0) := (others => '0');
constant col_bits : integer  :=  8;  -- max 256 columns
    --type vec is array (natural range <>) of std_logic_vector(7 downto 0);

type sums_t     is array (natural range <>) of std_logic_vector(in_row*(N+M+ sign_ext)-1 downto 0);
    signal partial_sums   : sums_t (0 to in_col - 1);
    signal mem_sums       : sums_t (0 to in_col - 1);
    signal mem_data_wr    : std_logic_vector     (in_row*(N+M+ sign_ext)-1 downto 0);
    signal mem_data_rd    : std_logic_vector     (in_row*(N+M+ sign_ext)-1 downto 0);
    signal data_in_d      : std_logic;
    signal init, init_d   : std_logic;

    --signal partial_sums : vec (0 to in_row*(N + M + sign_ext) - 1)(N+M-1+ sign_ext downto 0);
    signal index, index_d, mem_index : natural range 0 to in_col  - 1;
    signal index_out                 : natural range 0 to CL_outs - 1;
    signal data_out_int   : std_logic_vector(7 + in_row downto 0);
    --signal count        : std_logic_vector(col_bits-1 downto 0);
signal temp_mult0 : std_logic_vector(N + M - 1 + sign_ext downto 0);
signal temp_mult1 : std_logic_vector(N + M - 1 + sign_ext downto 0);
signal temp_mult2 : std_logic_vector(N + M - 1 + sign_ext downto 0);
signal temp_mult3 : std_logic_vector(N + M - 1 + sign_ext downto 0);

begin

    -- multiply 
    process(rst, clk)
        variable temp_mult : std_logic_vector(N + M - 1 + sign_ext downto 0);
    begin
        if rst = '1' then
            partial_sums <= (others => (others => '0'));
            index        <= 0;
            index_d      <= 0;
            index_out    <= 0;
            data_in_d    <= '0';
            init         <= '1';
            init_d       <= '1';
        elsif rising_edge(clk) then
            data_out_valid <= '0';
            data_in_d      <= data_in_valid;
            init_d         <= init;
            index_d        <= index;
            if sof = '1' then
                index <= 0;
                index_out <= 0;
                partial_sums <= (others => (others => '0'));
            elsif eof = '1' then
             --   for i in 0 to (in_row - 1) loop
             --      data_out(i) <= mem_sums(index)((i+1)*(N + M + sign_ext) -1  downto i*(N + M + sign_ext));
             --      --data_out(i) <= partial_sums(i)(SR + 7 downto SR);
             --   end loop;
                --data_out <= partial_sums;
                data_out(index_out) <= mem_data_rd(index*(N+M+ sign_ext)+SR+N-1 downto index*(N+M+ sign_ext)+SR);
                data_out_valid <= '1';
            end if;
            if init = '1' then
               mem_data_wr <= (others => '0');
               if index = (in_col - 1) then
                   index <=  0 ;
                   init  <= '0';
               else
                   index <= index + 1;
               end if;
            elsif data_in_valid = '1' then
               for i in 0 to (in_row - 1) loop
                  if data_in(data_in'left) = '1' then
                     temp_mult := ones  & (data_in * weight_in((i+1)*M-1 downto i*M));
                  else
                     temp_mult := zeros & (data_in * weight_in((i+1)*M-1 downto i*M));
                  end if;
                  if data_in(data_in'left) = '1' then
                     temp_mult0 <= ones  & (data_in * weight_in(1*M-1 downto 0*M));
                     temp_mult1 <= ones  & (data_in * weight_in(2*M-1 downto 1*M));
                     temp_mult2 <= ones  & (data_in * weight_in(3*M-1 downto 2*M));
                  --   temp_mult3 <= ones  & (data_in * weight_in(3)(M-1 downto 0));
                  else
                     temp_mult0 <= zeros & (data_in * weight_in(1*M-1 downto 0*M));
                     temp_mult1 <= zeros & (data_in * weight_in(2*M-1 downto 1*M));
                     temp_mult2 <= zeros & (data_in * weight_in(3*M-1 downto 2*M));
                  --   temp_mult3 <= zeros & (data_in * weight_in(3)(M-1 downto 0));
                  end if;
                  --partial_sums(index)(((i+1)*(N + M + sign_ext)-1) downto i*(N + M + sign_ext)) <= temp_mult + partial_sums(index)(((i+1)*(N + M + sign_ext)-1) downto i*(N + M + sign_ext));
                  mem_data_wr(((i+1)*(N + M + sign_ext)-1) downto i*(N + M + sign_ext)) <= temp_mult + mem_data_rd(((i+1)*(N + M + sign_ext)-1) downto i*(N + M + sign_ext));
               end loop;
               if index = (in_col - 1) then
                  index <=  0 ;
               else
                  index <= index + 1;
               end if;

               if index_out = (CL_outs - 1) then
                  index_out <=  0 ;
               else
                  index_out <= index_out + 1;
               end if;

            end if;

            --if data_in_d = '1' or init = '1' then
            --   mem_sums(index_d) <= mem_data_wr;
            --end if;
            if data_in_valid = '1' or init = '1' then
               mem_sums(mem_index) <= mem_data_wr;
            end if;
        end if;
    end process;

mem_index   <= index_d when init = '1' else index;
mem_data_rd <= mem_sums(index);

end  PCA_pixel_arc;