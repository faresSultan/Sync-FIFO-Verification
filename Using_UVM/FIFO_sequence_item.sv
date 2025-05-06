
package fifo_seq_item_pkg;

    import uvm_pkg::*;
    import shared_pkg::*;
    `include "uvm_macros.svh"

    class fifo_seq_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_seq_item)

        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;
        bit [FIFO_WIDTH-1:0] new_data_in;
        bit new_rst_n, new_wr_en, new_rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        function new(string name = "fifo_seq_item");
            super.new(name);
        endfunction

        constraint transaction_constraints{
            rst_n dist{1:=95, 0:=5};
            wr_en dist{1:=WR_EN_ON_DIST, 0:=100-WR_EN_ON_DIST};
            rd_en dist{1:=RD_EN_ON_DIST, 0:=100-RD_EN_ON_DIST};
        }
       
    endclass
endpackage