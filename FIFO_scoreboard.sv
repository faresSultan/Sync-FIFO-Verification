package FIFO_scoreboard_pkg;

    import shared_pkg::*;
    import FIFO_transaction_pkg::*;
    class FIFO_scoreboard;
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic [FIFO_WIDTH-1 : 0] FIFO_ref[$];
        bit fifo_current_size = 0;

        function void check_data(FIFO_transaction F_txn);
            reference_model(F_txn);
            if(F_txn.rd_en && F_txn.rst_n) begin  // there is a read operation      
                if(!F_txn.empty && (data_out_ref != F_txn.data_out)) begin
                    $fatal("Invalid data_out: %0h, Expected: %0h",F_txn.data_out,data_out_ref);
                    error_count++;
                    //$stop;
                end
                else begin
                    correct_count++;
                end
            end
   //         else correct_count++;    
        endfunction
        function void reference_model(FIFO_transaction F_txn);
            if(!F_txn.rst_n) begin
                FIFO_ref.delete();
                fifo_current_size = 0;           
            end

            else begin

                if ({F_txn.wr_en,F_txn.rd_en} == 2'b11) begin
                    if (FIFO_ref.size() == 0) begin // fifo empty, only write
                        FIFO_ref.push_back(F_txn.data_in);
                    end
                    else if (FIFO_ref.size() == FIFO_DEPTH) begin // fifo full, only read
                        data_out_ref = FIFO_ref.pop_front();
                    end
                    else begin // read & write, count still the same
                        data_out_ref = FIFO_ref.pop_front();
                        FIFO_ref.push_back(F_txn.data_in);
                    end
                end

                else if ({F_txn.wr_en,F_txn.rd_en} == 2'b01) begin
                    if (FIFO_ref.size() > 0) begin
                        data_out_ref = FIFO_ref.pop_front();
                    end
                end

                else if ({F_txn.wr_en,F_txn.rd_en} == 2'b10) begin
                    if (FIFO_ref.size() < FIFO_DEPTH) begin
                        FIFO_ref.push_back(F_txn.data_in);
                    end
                end
                
            //    fifo_current_size = FIFO_ref.size();                
            end
        endfunction        
    endclass
endpackage