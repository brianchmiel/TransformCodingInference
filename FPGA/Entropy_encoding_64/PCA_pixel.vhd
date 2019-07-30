library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
library work;
use work.types_packege.all;

entity PCA_pixel is
    generic (
            number_output_features_g : positive := 64
        );
    port (
        reset          : in  std_logic;
        clock          : in  std_logic;
        sof            : in  std_logic;
        eof            : in  std_logic;
        data_in        : in  std_logic_vector(7 downto 0);
        data_in_valid  : in  std_logic;
        weight_in      : in  mat(0 to number_output_features_g - 1)(0 to number_output_features_g - 1);
        data_out       : out vec(0 to number_output_features_g - 1);
        data_out_valid : out std_logic
    ) ;
end PCA_pixel;

architecture PCA_pixel_arc of PCA_pixel is


    --type vec is array (natural range <>) of std_logic_vector(7 downto 0);


    signal partial_sums : vec (0 to number_output_features_g - 1);
    signal index        : natural range 0 to number_output_features_g - 1;
    signal data_out_int : std_logic_vector(7 + number_output_features_g downto 0);
begin

    -- multiply 
    process(reset, clock)
        variable temp_mult : std_logic_vector(15 downto 0);
    begin
        if reset = '1' then
            partial_sums <= (others => (others => '0'));
            index        <= 0;
        elsif rising_edge(clock) then
            data_out_valid <= '0';

            if sof = '1' then
                index <= 0;
                partial_sums <= (others => (others => '0'));
            elsif eof = '1' then
                for i in 0 to (number_output_features_g - 1) loop
                    data_out(i) <= partial_sums(i)(partial_sums(i)'left downto partial_sums(i)'left - 7);
                end loop;
                --data_out <= partial_sums;
                data_out_valid <= '1';
            end if;

            if data_in_valid = '1' then
                for i in 0 to (number_output_features_g - 1) loop
                    temp_mult       := data_in * weight_in(index)(i);
                    partial_sums(i) <= temp_mult(15 downto 8) + partial_sums(i);
                end loop;
                index <= index + 1;
                if index = (number_output_features_g - 1) then
                    index <= 0;
                end if;
            end if;
        end if;
    end process;

end  PCA_pixel_arc;