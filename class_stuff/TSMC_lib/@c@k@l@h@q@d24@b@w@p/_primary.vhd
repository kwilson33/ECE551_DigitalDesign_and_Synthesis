library verilog;
use verilog.vl_types.all;
entity CKLHQD24BWP is
    port(
        Q               : out    vl_logic;
        TE              : in     vl_logic;
        CPN             : in     vl_logic;
        E               : in     vl_logic
    );
end CKLHQD24BWP;
