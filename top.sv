module top();
    bit clk = 0;

    always #2 clk = ~clk;

    FIFO_IF fifo_if (clk);
    FIFO DUT (fifo_if);
    TestBench tb (fifo_if);
    FIFO_monitor monitor (fifo_if);

    always_comb begin
        if(!fifo_if.rst_n) begin 
            Reset: assert final (
                !(fifo_if.wr_ack || fifo_if.underflow || fifo_if.overflow || fifo_if.almostempty||
                    fifo_if.almostfull || fifo_if.full) && fifo_if.empty
            )
            else $fatal("Assertion Reset failed!");
        end
    end
endmodule