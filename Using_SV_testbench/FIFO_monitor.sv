
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;

module FIFO_monitor( FIFO_IF.Monitor IF);

    FIFO_transaction txn;
    FIFO_scoreboard sb;
    FIFO_coverage cvg;

    initial begin
        txn = new;
        sb = new;
        cvg = new;


        forever begin
            @(finished_driving);
            @(negedge IF.clk);
            txn.rst_n = IF.rst_n;
            txn.wr_en = IF.wr_en;
            txn.rd_en = IF.rd_en;
            txn.data_in = IF.data_in;
            txn.data_out = IF.data_out;
            txn.wr_ack = IF.wr_ack;
            txn.overflow = IF.overflow;
            txn.underflow = IF.underflow;
            txn.empty = IF.empty;
            txn.almostempty = IF.almostempty;
            txn.full = IF.full;
            txn.almostfull = IF.almostfull;

            
            fork
                begin
                    cvg.sample_data(txn);    
                end

                begin     
                    sb.check_data(txn);
                    // txn.rst_n = txn.new_rst_n;
                    // txn.wr_en = txn.new_wr_en;
                    // txn.rd_en = txn.new_rd_en;
                    // txn.data_in = txn.new_data_in;
                end
            join

            -> finished_recording;
            if(test_finished) begin
                $display("Correct Count: %0d",correct_count);
                $display("Error Count: %0d",error_count);
                $stop;
            end

        end
    end    
endmodule