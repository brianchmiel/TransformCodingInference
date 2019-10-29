library ieee;
use ieee.std_logic_1164.all;

package ConvLayer_types_package is
--    constant CL_inputs  : integer := 3; -- number of data inputs
--    constant CL_outs   : integer := 6; -- number of CL units per input
        --constant W          : integer := 8; -- data output width
	--subtype element is std_logic_vector(W-1 downto 0);
	--type vec is array (natural range <>) of element;
	--type invec is array (natural range <>) of element;
	--type mat is array (natural range <>) of vec;
	--type vec is array (natural range <>) of element;
	--type mat is array (natural range <>) of vec;
--type int_array is array (0 to 3) of integer range 0 to 15;
type vec is array (natural range <>) of std_logic_vector;
type mat is array (natural range <>) of vec;
--type int_array is array(natural range <>) of integer;

end ConvLayer_types_package;	
