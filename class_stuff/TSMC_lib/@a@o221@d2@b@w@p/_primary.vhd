library verilog;
use verilog.vl_types.all;
entity AO221D2BWP is
    port(
        A1              : in     vl_logic;
        A2              : in     vl_logic;
        B1              : in     vl_logic;
        B2              : in     vl_logic;
        C               : in     vl_logic;
        Z               : out    vl_logic
    );
end AO221D2BWP;
