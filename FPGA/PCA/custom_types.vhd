-- custom package
library ieee;

package custom_types is
    use ieee.std_logic_1164.all;
    type std_logic_vector_vector is array (1 to 64) of std_logic_vector(7 downto 0);
end package;