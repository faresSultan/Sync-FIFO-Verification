package shared_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
    parameter Max_fifo_addr = $clog2(FIFO_DEPTH);
    int error_count,correct_count;
endpackage