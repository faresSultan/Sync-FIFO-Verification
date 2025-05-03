
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
        @(negedge fifo_if.clk);
        ->finished_driving;
        @(finished_recording);
        fifo_if.wr_en = 1;
        fifo_if.data_in = 'b10;
        fifo_if.rst_n = 1;
        @(negedge fifo_if.clk);
        ->finished_driving;
        @(finished_recording);
        fifo_if.wr_en = 1;
        fifo_if.data_in = 'b01;
        fifo_if.rst_n = 1;
        @(negedge fifo_if.clk);
        ->finished_driving;
        @(finished_recording);


    
    //================Sequence 2: Constraint Random stimulus================

        test_finished = 1;
        ->finished_driving;
    end
    
endmodule