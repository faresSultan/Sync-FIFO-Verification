package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;

    class FIFO_coverage;

        FIFO_transaction F_cvg_txn;


        covergroup FIFO_coverage;

        write_enable : coverpoint F_cvg_txn.wr_en iff(F_cvg_txn.rst_n){
            bins wr_en_0 = {0};
            bins wr_en_1 = {1};
        }
        read_enable :coverpoint F_cvg_txn.rd_en iff(F_cvg_txn.rst_n){
            bins rd_en_0 = {0};
            bins rd_en_1 = {1};
        }
        full_flag:coverpoint F_cvg_txn.full iff(F_cvg_txn.rst_n){
            bins full_0 = {0};
            bins full_1 = {1};
        }
        almostfull_flag:coverpoint F_cvg_txn.almostfull iff(F_cvg_txn.rst_n){
            bins almostfull_0 = {0};
            bins almostfull_1 = {1};
        }
        empty_flag: coverpoint F_cvg_txn.empty iff(F_cvg_txn.rst_n){
            bins empty_0 = {0};
            bins empty_1 = {1};
        }
        almostempty_flag: coverpoint F_cvg_txn.almostempty iff(F_cvg_txn.rst_n){
            bins almostempty_0 = {0};
            bins almostempty_1 = {1};
        }
        overflow_flag :coverpoint F_cvg_txn.overflow iff(F_cvg_txn.rst_n){
            bins overflow_0 = {0};
            bins overflow_1 = {1};
        }
        underflow_flag:coverpoint F_cvg_txn.underflow iff(F_cvg_txn.rst_n){
            bins underflow_0 = {0};
            bins underflow_1 = {1};
        }
        write_ack_flag :coverpoint F_cvg_txn.wr_ack iff(F_cvg_txn.rst_n){
            bins wr_ack_0 = {0};
            bins wr_ack_1 = {1};
        }
            
            cross write_enable , read_enable , full_flag{
                illegal_bins full_1_rd_en1 = binsof(read_enable.rd_en_1) &&
                binsof (full_flag.full_1);
            }  
            cross write_enable , read_enable , almostfull_flag;  
            
            cross write_enable , read_enable , empty_flag{
                illegal_bins empty_1_wr_en1 = binsof(write_enable.wr_en_1) &&
                binsof (empty_flag.empty_1);
            }  
            cross write_enable , read_enable , almostempty_flag;  
 
            cross write_enable , read_enable , overflow_flag{
                illegal_bins overflow1_wr_en0 = binsof(write_enable.wr_en_0) &&
                 binsof(overflow_flag.overflow_1);
            }  
            cross write_enable , read_enable , underflow_flag{
                illegal_bins underflow1_wr_en0 = binsof(read_enable.rd_en_0) &&
                 binsof(underflow_flag.underflow_1);
            }

            cross write_enable , read_enable , write_ack_flag{
                illegal_bins write_ack_wr_en0 = binsof(write_enable.wr_en_0) &&
                binsof (write_ack_flag.wr_ack_1);
            } 


        endgroup

        function new();
            FIFO_coverage = new;
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = new F_txn;
            FIFO_coverage.sample();
        endfunction
        
    endclass
endpackage