library verilog;
use verilog.vl_types.all;
entity EDFD1BWP is
    port(
        D               : in     vl_logic;
        E               : in     vl_logic;
        CP              : in     vl_logic;
        Q               : out    vl_logic;
        QN              : out    vl_logic
    );
end EDFD1BWP;
