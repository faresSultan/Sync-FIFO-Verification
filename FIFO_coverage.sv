package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;

    class FIFO_coverage;

        FIFO_transaction F_cvg_txn;

        function void new();
            FIFO_coverage = new;
        endfunction

        covergroup FIFO_coverage;
            
            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.full;  
            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.almostfull;

            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.empty;  
            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.almostempty;  

            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.overflow;  
            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.underflow;  

            cross F_cvg_txn.wr_en , F_cvg_txn.rd_en , F_cvg_txn.wr_ack;  

        endgroup

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = new F_txn;
            FIFO_coverage.sample();
        endfunction
        
    endclass
endpackage