package fifo_coverage_collector_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class fifo_coverage_collector extends uvm_component;
        `uvm_component_utils(fifo_coverage_collector)

        uvm_analysis_export #(fifo_seq_item) cov_a_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
        fifo_seq_item cov_seq_item;

        covergroup FIFO_coverage;

            write_enable : coverpoint cov_seq_item.wr_en iff(cov_seq_item.rst_n){
                bins wr_en_0 = {0};
                bins wr_en_1 = {1};
            }
            read_enable :coverpoint cov_seq_item.rd_en iff(cov_seq_item.rst_n){
                bins rd_en_0 = {0};
                bins rd_en_1 = {1};
            }
            full_flag:coverpoint cov_seq_item.full iff(cov_seq_item.rst_n){
                bins full_0 = {0};
                bins full_1 = {1};
            }
            almostfull_flag:coverpoint cov_seq_item.almostfull iff(cov_seq_item.rst_n){
                bins almostfull_0 = {0};
                bins almostfull_1 = {1};
            }
            empty_flag: coverpoint cov_seq_item.empty iff(cov_seq_item.rst_n){
                bins empty_0 = {0};
                bins empty_1 = {1};
            }
            almostempty_flag: coverpoint cov_seq_item.almostempty iff(cov_seq_item.rst_n){
                bins almostempty_0 = {0};
                bins almostempty_1 = {1};
            }
            overflow_flag :coverpoint cov_seq_item.overflow iff(cov_seq_item.rst_n){
                bins overflow_0 = {0};
                bins overflow_1 = {1};
            }
            underflow_flag:coverpoint cov_seq_item.underflow iff(cov_seq_item.rst_n){
                bins underflow_0 = {0};
                bins underflow_1 = {1};
            }
            write_ack_flag :coverpoint cov_seq_item.wr_ack iff(cov_seq_item.rst_n){
                bins wr_ack_0 = {0};
                bins wr_ack_1 = {1};
            }

            cross write_enable , read_enable , full_flag{
                illegal_bins full_1_rd_en1 = binsof(read_enable.rd_en_1) &&
                binsof (full_flag.full_1);
            }  // when rd_en is high, one element should be removed from the FIFO, so won't be full

            cross write_enable , read_enable , almostfull_flag;  

            cross write_enable , read_enable , empty_flag{
                illegal_bins empty_1_wr_en1 = binsof(write_enable.wr_en_1) &&
                binsof (empty_flag.empty_1);
            }  // when wr_en is high, one element should be Stored in the FIFO, so won't be Empty

            cross write_enable , read_enable , almostempty_flag;  

            cross write_enable , read_enable , overflow_flag{
                illegal_bins overflow1_wr_en0 = binsof(write_enable.wr_en_0) &&
                 binsof(overflow_flag.overflow_1);
            } // overflow only happens if there is a write operation, so if there is no write operation overflow can't go high

            cross write_enable , read_enable , underflow_flag{
                illegal_bins underflow1_wr_en0 = binsof(read_enable.rd_en_0) &&
                 binsof(underflow_flag.underflow_1);
            } // underflow only happens if there is a read operation, so if there is no read operation underflow can't go high

            cross write_enable , read_enable , write_ack_flag{
                illegal_bins write_ack_wr_en0 = binsof(write_enable.wr_en_0) &&
                binsof (write_ack_flag.wr_ack_1);
            } // write_ack only happens if there is a write operation, so if there is no write operation wr_ack can't go high
        
        endgroup



        function new(string name = "fifo_coverage_collector", uvm_component parent = null);
            super.new(name,parent);
            FIFO_coverage = new(); 
        endfunction


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            cov_a_export = new("cov_a_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            cov_a_export.connect(cov_fifo.analysis_export);          
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                cov_fifo.get(cov_seq_item);
                CovCode.sample();
            end           
        endtask

    endclass

    
endpackage