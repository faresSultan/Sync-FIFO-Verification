
import shared_pkg::*;
interface FIFO_IF(input bit clk);
    

    bit [FIFO_WIDTH-1:0] data_in;
    bit rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    modport DUT (
        input clk,rst_n,wr_en,rd_en,data_in,
        output data_out, wr_ack, overflow, underflow, full, almostfull, empty, almostempty
    );

    modport TEST (
        input clk, data_out, wr_ack, overflow, underflow, full, almostfull, empty, almostempty,
        output rst_n,wr_en,rd_en,data_in
    );

    modport Monitor (
        input clk, data_out, wr_ack, overflow, underflow, full, almostfull, 
        empty, almostempty,rst_n,wr_en,rd_en,data_in
    );

endinterface