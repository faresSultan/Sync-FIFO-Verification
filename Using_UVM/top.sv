
import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top();
    bit clk = 0;

    always #2 clk = ~clk;

    FIFO_IF fifo_if (clk);
    FIFO DUT (fifo_if);

    initial begin
        uvm_config_db#(virtual FIFO_IF)::set(null,"uvm_test_top","FIFO_IF",fifo_if);
        run_test("fifo_test");
    end
endmodule