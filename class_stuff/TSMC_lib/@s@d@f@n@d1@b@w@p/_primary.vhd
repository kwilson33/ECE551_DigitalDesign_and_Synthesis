library verilog;
use verilog.vl_types.all;
entity SDFND1BWP is
    port(
        SI              : in     vl_logic;
        D               : in     vl_logic;
        SE              : in     vl_logic;
        CPN             : in     vl_logic;
        Q               : out    vl_logic;
        QN              : out    vl_logic
    );
end SDFND1BWP;
