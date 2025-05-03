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

                if(F_txn.wr_en) begin  // there is a write operation

                    if (wr_ack_ref != F_txn.wr_ack) begin
                        $display("Invalid wr_ack: %0d, Expected: %0d",F_txn.wr_ack,wr_ack_ref);
                        error_count++;
                        $stop;
                    end
                    else if (overflow_ref != F_txn.overflow) begin
                        $display("Invalid overflow: %0d, Expected: %0d",F_txn.overflow,overflow_ref);
                        error_count++;
                        $stop;
                    end
                    else if (full_ref != F_txn.full) begin
                        $display("Invalid full: %0d, Expected: %0d",F_txn.full,full_ref);
                        error_count++;
                        $stop;
                    end
                    else if (almostfull_ref != F_txn.almostfull) begin
                        $display("Invalid almostfull: %0d, Expected: %0d",F_txn.almostfull,almostfull_ref);
                        error_count++;
                        $stop;
                    end
                    else if (empty_ref != F_txn.empty) begin
                        $display("Invalid empty: %0d, Expected: %0d",F_txn.empty,empty_ref);
                        error_count++;
                        $stop;
                    end
                    else if (almostempty_ref != F_txn.almostempty) begin
                        $display("Invalid almostempty: %0d, Expected: %0d",F_txn.almostempty,almostempty_ref);
                        error_count++;
                        $stop;
                    end
                    else begin
                        correct_count++;
                    end
                end


                if(F_txn.rd_en) begin  // there is a read operation
                    
                    if(data_out_ref != F_txn.data_out) begin
                        $display("Invalid data_out: %0d, Expected: %0d",F_txn.data_out,data_out_ref);
                        error_count++;
                        $stop;
                    end
                    else if (underflow_ref != F_txn.underflow) begin
                        $display("Invalid underflow: %0d, Expected: %0d",F_txn.underflow,underflow_ref);
                        error_count++;
                        $stop;
                    end
                    else if (full_ref != F_txn.full) begin
                        $display("Invalid full: %0d, Expected: %0d",F_txn.full,full_ref);
                        error_count++;
                        $stop;
                    end
                    else if (almostfull_ref != F_txn.almostfull) begin
                        $display("Invalid almostfull: %0d, Expected: %0d",F_txn.almostfull,almostfull_ref);
                        error_count++;
                        $stop;
                    end
                    else if (empty_ref != F_txn.empty) begin
                        $display("Invalid empty: %0d, Expected: %0d",F_txn.empty,empty_ref);
                        error_count++;
                        $stop;
                    end
                    else if (almostempty_ref != F_txn.almostempty) begin
                        $display("Invalid almostempty: %0d, Expected: %0d",F_txn.almostempty,almostempty_ref);
                        error_count++;
                        $stop;
                    end
                    else begin
                        correct_count++;
                    end
                end
                
  
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
                        overflow_ref <= 0;       
                    end 
                    else if(F_txn.wt_en && F_txn.full) begin // write operation while fifo is full
                        overflow_ref <= 1;
                        wr_ack_ref <= 0; 
                    end

                    if (F_txn.rd_en && !F_txn.empty) begin // normal read operation
                        data_out_ref <= FIFO_ref.pop_front();
                        underflow_ref <= 0;       
                    end 
                    else if(F_txn.rd_en && F_txn.empty) begin // read operation while fifo is empty
                        underflow_ref <= 1;
                    end
                end

                case (FIFO_ref.size())
                    0 : empty_ref = 1; 
                    1 : almostempty_ref = 1;
                    FIFO_DEPTH : full_ref = 1;
                    (FIFO_DEPTH-1) : almostfull_ref = 1;
                    default: begin
                        empty_ref = 0;
                        almostempty_ref = 0;
                        full_ref = 0;
                        almostfull_ref = 0;
                    end
                endcase
                
            endfunction        
        endclass
endpackage