
import FIFO_transaction_pkg::*;
import shared_pkg::*;
module TestBench(FIFO_IF.TEST fifo_if);

    FIFO_transaction txn;
    

    initial begin
        txn = new;

    //================Sequence 1: Assert_Reset================
        fifo_if.wr_en = 1;
        fifo_if.data_in = 'b11;
        fifo_if.rst_n = 0;
        ->finished_driving;
        @(negedge fifo_if.clk);
    
    //================Sequence 2: Constraint Random stimulus================
        repeat(2000) begin
            assert (txn.randomize());
            fifo_if.rst_n = txn.rst_n;
            fifo_if.wr_en = txn.wr_en;
            fifo_if.rd_en = txn.rd_en;
            fifo_if.data_in = txn.data_in;
            ->finished_driving;
            @(negedge fifo_if.clk);
        end
        
    //================Assert test_finished================
        test_finished = 1;
        ->finished_driving;
    end
    
endmodule