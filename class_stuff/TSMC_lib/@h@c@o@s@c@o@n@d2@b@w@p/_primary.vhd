library verilog;
use verilog.vl_types.all;
entity HCOSCOND2BWP is
    port(
        A               : in     vl_logic;
        CI              : in     vl_logic;
        CS              : in     vl_logic;
        S               : out    vl_logic;
        CON             : out    vl_logic
    );
end HCOSCOND2BWP;
