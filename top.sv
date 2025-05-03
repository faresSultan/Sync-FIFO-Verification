module top();
    bit clk = 0;

    always #2 clk = ~clk;

    FIFO_IF fifo_if (clk);

    FIFO DUT (fifo_if);
    TestBench tb (fifo_if);
    FIFO_monitor monitor (fifo_if); 
endmodule