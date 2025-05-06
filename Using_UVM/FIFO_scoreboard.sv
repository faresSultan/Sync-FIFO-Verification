package fifo_scoreboard_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)

        uvm_analysis_export #(fifo_seq_item) sb_a_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
        fifo_seq_item sb_seq_item;
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic [FIFO_WIDTH-1 : 0] FIFO_ref[$];


        function new(string name = "fifo_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            sb_a_export = new("sb_a_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            sb_a_export.connect(sb_fifo.analysis_export);          
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                sb_fifo.get(sb_seq_item);
            end           
        endtask

        function void check_data(fifo_seq_item F_txn);
            reference_model(F_txn);
            if(F_txn.rd_en && F_txn.rst_n) begin  // there is a read operation      
                if(!F_txn.empty && (data_out_ref != F_txn.data_out)) begin
                    `uvm_fatal("Golden model",$sformatf("Invalid data_out: %0h, Expected: %0h",F_txn.data_out,data_out_ref))
                    error_count++;
                    //$stop;
                end
                else begin
                    correct_count++;
                end
            end
            else correct_count++;    
        endfunction
        function void reference_model(fifo_seq_item F_txn);
            if(!F_txn.rst_n) begin
                FIFO_ref.delete();          
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
               
            end
        endfunction

    endclass

    
endpackage