library verilog;
use verilog.vl_types.all;
entity LNCNQD2BWP is
    port(
        D               : in     vl_logic;
        EN              : in     vl_logic;
        CDN             : in     vl_logic;
        Q               : out    vl_logic
    );
end LNCNQD2BWP;
