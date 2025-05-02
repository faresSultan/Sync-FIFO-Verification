package FIFO_scoreboard_pkg;

        import shared_pkg::*;
        import FIFO_transaction_pkg::*;

        class FIFO_scoreboard;
            logic [FIFO_WIDTH-1:0] data_out_ref;
            logic [FIFO_WIDTH-1 : 0] FIFO_ref[$];
            logic wr_ack_ref, overflow_ref;
            logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

            task check_data(FIFO_transaction F_txn);
                reference_model(F_txn);
  
            endtask

            function void reference_model(FIFO_transaction F_txn);

                if(!F_txn.rst_n) begin
                    data_out_ref = 'b0;
                    wr_ack_ref = 0;
                    overflow_ref = 0;
                    underflow_ref = 0;
                    full_ref = 0;
                    almostfull_ref = 0;
                    almostempty_ref = 0;
                    empty_ref = 1;
                end
                else begin  // Reset is not asserted

                    if (F_txn.wt_en && !F_txn.full) begin // normal write operation
                        FIFO_ref.push_back(data_in);
                        wr_ack_ref <= 1;       
                    end 
                    else if(F_txn.wt_en && F_txn.full) begin // write operation while fifo is full
                        overflow_ref <= 1;
                    end

                    if (F_txn.rd_en && !F_txn.empty) begin // normal read operation
                        data_out_ref <= FIFO_ref.pop_front();       
                    end 
                    else if(F_txn.rd_en && F_txn.empty) begin // read operation while fifo is empty
                        underflow_ref <= 1;
                    end
                end
                
            endfunction        
        endclass
endpackage