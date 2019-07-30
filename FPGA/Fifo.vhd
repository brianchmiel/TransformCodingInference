library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo is
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
end fifo;

architecture Behavioral of fifo is

type memory_type is array (0 to depth-1) of std_logic_vector(Wout-1 downto 0);
signal memory : memory_type :=(others => (others => '0'));   --memory for queue.
signal readptr,writeptr : integer := 0;  --read and write pointers.
signal empty,full : std_logic := '0';

signal data2fifo    : std_logic_vector(Wout-1 downto 0);
signal enw2fifo     : std_logic          ;
signal count2fifo   : integer            ;
constant WidthMult  : integer := Wout/Win;

signal dbg_num_elem : integer;  

begin

p_regshift : process(Clk,rst)
--this is the number of elements stored in fifo at a time.
--this variable is used to decide whether the fifo is empty or full.
begin
if(rst = '1') then
    data2fifo  <= (others => '0');
    enw2fifo   <= '0';
    count2fifo <=  1;
elsif(rising_edge(Clk)) then
    if enw = '1' then
        if count2fifo = WidthMult then
            enw2fifo   <= '1';
            count2fifo <=  1 ;
        else
            enw2fifo   <= '0';
            count2fifo <= count2fifo + 1;
        end if;
        data2fifo(  data_in'left downto               0) <= data_in;
        data2fifo(data2fifo'left downto data_in'left +1) <= data2fifo((data2fifo'left - Win) downto 0);
    else
        enw2fifo <= '0';
    end if; 
end if; 
end process p_regshift;

fifo_empty <= empty;
fifo_full <= full;

process(Clk,rst)
--this is the number of elements stored in fifo at a time.
--this variable is used to decide whether the fifo is empty or full.
variable num_elem : integer := 0;  
begin
if(rst = '1') then
    data_out <= (others => '0');
    burst_r  <= '0';
    empty    <= '0';
    full     <= '0';
    readptr  <=  0 ;
    writeptr <=  0 ;
    num_elem :=  0 ;
elsif(rising_edge(Clk)) then
    if(enr = '1' and empty = '0') then  --read
        data_out <= memory(readptr);
        readptr <= readptr + 1;      
        num_elem := num_elem-1;
    end if;
    if(enw2fifo ='1' and full = '0') then    --write
        memory(writeptr) <= data2fifo;
        writeptr <= writeptr + 1;  
        num_elem := num_elem+1;
    end if;
    --rolling over of the indices.
    if(readptr = depth-1) then      --resetting read pointer.
        readptr <= 0;
    end if;
    if(writeptr = depth-1) then        --resetting write pointer.
        writeptr <= 0;
    end if; 
    --setting empty and full flags.
    if(num_elem = 0) then
        empty <= '1';
    else
        empty <= '0';
    end if;
    if(num_elem = depth) then
        full <= '1';
    else
        full <= '0';
    end if;

    if(num_elem >= burst) then
        burst_r <= '1';
    else
        burst_r <= '0';
    end if;
dbg_num_elem <= num_elem;
end if; 
end process;

end Behavioral;