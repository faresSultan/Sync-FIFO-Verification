package fifo_sequence_pkg;
    import uvm_pkg::*;
    import fifo_seq_item_pkg::*;
    `include "uvm_macros.svh"


//=============================Reset Sequence===============================
    class fifo_reset_sequence extends uvm_sequence #(fifo_seq_item);
         `uvm_object_utils(fifo_reset_sequence)
         
        fifo_seq_item seq_item;

        function new(string name = "fifo_reset_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = fifo_seq_item::type_id::create("seq_item");
            start_item(seq_item);
                seq_item.wr_en = 1;
                seq_item.data_in = 'b11;
                seq_item.rst_n = 0;
            finish_item(seq_item);
        endtask
    endclass

//=============================High Write - Low read//=============================

    class Read_30_Write_70_sequence extends uvm_sequence #(fifo_seq_item); 
        `uvm_object_utils(Read_30_Write_70_sequence)
        fifo_seq_item seq_item;

        function new(string name = "fifo_sequence_1");
            super.new(name);
        endfunction

        task body;
            seq_item = fifo_seq_item::type_id::create("seq_item");
            seq_item.RD_EN_ON_DIST = 30;
            seq_item.WR_EN_ON_DIST = 70;
            repeat(2000) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end    
       endtask

    endclass  
    
//=============================Balanced Write/read//=============================

    class Read_50_Write_50_sequence extends uvm_sequence #(fifo_seq_item); 
        `uvm_object_utils(Read_50_Write_50_sequence)
        fifo_seq_item seq_item;

        function new(string name = "fifo_sequence_1");
            super.new(name);
        endfunction

        task body;
            seq_item = fifo_seq_item::type_id::create("seq_item");
            seq_item.RD_EN_ON_DIST = 50;
            seq_item.WR_EN_ON_DIST = 50;
            repeat(2000) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end    
       endtask

    endclass  

//=============================Write-only sequence//=============================
    class Write_only_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(Write_only_sequence)
        fifo_seq_item seq_item;

        function new(string name = "Write_only_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = fifo_seq_item::type_id::create("seq_item");

            seq_item.RD_EN_ON_DIST = 0;
            seq_item.WR_EN_ON_DIST = 90;
            repeat(20) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end
 
        endtask
    endclass 

//=============================Read-only sequence//=============================

    class Read_only_sequence extends uvm_sequence #(fifo_seq_item);
        `uvm_object_utils(Read_only_sequence)
        fifo_seq_item seq_item;

        function new(string name = "Read_only_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = fifo_seq_item::type_id::create("seq_item");

            seq_item.RD_EN_ON_DIST = 90;
            seq_item.WR_EN_ON_DIST = 0;
            repeat(10) begin
                start_item(seq_item);
                    seq_item.wr_en = 1;
                    seq_item.data_in = 'b11;
                    seq_item.rst_n = 1;  
                finish_item(seq_item);
            end

            repeat(20) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
        
    endclass  

endpackage