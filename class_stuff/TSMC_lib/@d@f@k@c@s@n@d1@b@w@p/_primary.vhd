library verilog;
use verilog.vl_types.all;
entity DFKCSND1BWP is
    port(
        D               : in     vl_logic;
        CP              : in     vl_logic;
        CN              : in     vl_logic;
        SN              : in     vl_logic;
        Q               : out    vl_logic;
        QN              : out    vl_logic
    );
end DFKCSND1BWP;
