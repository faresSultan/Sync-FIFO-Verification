
import FIFO_transaction_pkg::*;
import shared_pkg::*;
module TestBench(FIFO_IF.TEST fifo_if);

    FIFO_transaction txn;
    

    initial begin
        tnx = new;

    //=========Sequence 1: Assert_Reset================
        fifo_if.wr_en = 1;
        fifo_if.data_in = 'b11;
        fifo_if.rst_n = 0;
        @(negedge clk);
        finished_driving;

        test_finished = 1;
        finished_driving;
    end
    
endmodule