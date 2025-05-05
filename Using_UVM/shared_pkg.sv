package shared_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    bit test_finished = 0;
    event finished_driving;
    int error_count,correct_count;
endpackage