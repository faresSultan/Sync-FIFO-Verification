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
                (DUT.count =='b0 && DUT.wr_ptr =='b0 && DUT.rd_ptr == 'b0)
            )
            else $error("Assertion Reset failed!");
        end
    end
endmodule