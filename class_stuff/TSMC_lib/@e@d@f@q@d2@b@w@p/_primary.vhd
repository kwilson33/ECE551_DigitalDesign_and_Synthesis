library verilog;
use verilog.vl_types.all;
entity EDFQD2BWP is
    port(
        D               : in     vl_logic;
        E               : in     vl_logic;
        CP              : in     vl_logic;
        Q               : out    vl_logic
    );
end EDFQD2BWP;
