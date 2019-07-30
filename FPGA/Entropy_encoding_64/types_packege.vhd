library ieee;
use ieee.std_logic_1164.all;

package TYPES_PACKEGE is
	subtype element is std_logic_vector(7 downto 0);
	type vec is array (natural range <>) of element;
	type mat is array (natural range <>) of vec;
end TYPES_PACKEGE;