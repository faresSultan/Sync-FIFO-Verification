package FIFO_scoreboard_pkg;

        import FIFO_transaction_pkg::*;

        class FIFO_scoreboard;
            logic [FIFO_WIDTH-1:0] data_out_ref;
            logic wr_ack_ref, overflow_ref;
            logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

            task check_data(FIFO_transaction F_txn);
                reference_model(F_txn);

                
            endtask

            function void reference_model(FIFO_transaction F_txn);

                
            endfunction        
        endclass
endpackage