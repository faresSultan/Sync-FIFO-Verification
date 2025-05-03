module top();
    bit clk = 0;

    always #1 clk = ~clk;

    FIFO_IF fifo_if (clk);
    
    
endmodule