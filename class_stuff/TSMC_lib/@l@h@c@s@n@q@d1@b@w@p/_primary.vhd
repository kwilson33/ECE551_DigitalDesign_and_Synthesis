library verilog;
use verilog.vl_types.all;
entity LHCSNQD1BWP is
    port(
        D               : in     vl_logic;
        E               : in     vl_logic;
        CDN             : in     vl_logic;
        SDN             : in     vl_logic;
        Q               : out    vl_logic
    );
end LHCSNQD1BWP;
