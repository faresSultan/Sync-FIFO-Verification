import shared_pkg::*;

module FIFO_SVA(FIFO_IF fifo_if);

    always_comb begin     
        if(!fifo_if.rst_n) begin 
            Reset: assert final (
                (FIFO.count =='b0 && FIFO.wr_ptr =='b0 && FIFO.rd_ptr == 'b0)
            )
            else $error("Assertion Reset failed!");
        end
    end

    sequence max_wr_ptr_valid_write;
		 fifo_if.wr_en && !fifo_if.full && (FIFO.wr_ptr == {Max_fifo_addr{1'b1}});
	endsequence

	sequence max_rd_ptr_valid_read;
		 fifo_if.rd_en && !fifo_if.empty && (FIFO.rd_ptr == {Max_fifo_addr{1'b1}});
	endsequence

	sequence reset_wr_ptr;
		(FIFO.wr_ptr == {Max_fifo_addr{1'b0}});
	endsequence

	sequence reset_rd_ptr;
		(FIFO.rd_ptr == {Max_fifo_addr{1'b0}});
	endsequence

	property Write_Acknowledge;
		@(posedge fifo_if.clk) (fifo_if.wr_en && !fifo_if.full) |=> ##1 $past(fifo_if.wr_ack);
	endproperty

	property Overflow_Detection;
		@(posedge fifo_if.clk) (fifo_if.wr_en && fifo_if.full) |=> ##1 $past(fifo_if.overflow);
	endproperty

	property Underflow_Detection;
		@(posedge fifo_if.clk) (fifo_if.rd_en && fifo_if.empty) |=> ##1 $past(fifo_if.underflow);
	endproperty

	property Empty_Flag_Assertion;
		@(posedge fifo_if.clk) (FIFO.count === 0) |=> $past(fifo_if.empty);
	endproperty

	property Almost_Empty_Flag_Assertion;
		@(posedge fifo_if.clk) (FIFO.count === 1) |=> $past(fifo_if.almostempty);
	endproperty

	property Full_Flag_Assertion;
		@(posedge fifo_if.clk) (FIFO.count === fifo_if.FIFO_DEPTH) |=> $past(fifo_if.full);
	endproperty

	property Almost_Full_Flag_Assertion;
		@(posedge fifo_if.clk) (FIFO.count === fifo_if.FIFO_DEPTH - 1) |=> $past(fifo_if.almostfull);
	endproperty

	property Write_Pointer_Wraparound;
		@(posedge fifo_if.clk) max_wr_ptr_valid_write |=> reset_wr_ptr; 
	endproperty

	property Read_Pointer_Wraparound;
		@(posedge fifo_if.clk) max_rd_ptr_valid_read |=> reset_rd_ptr; 
	endproperty

	property Write_Pointer_threshold;
		@(posedge fifo_if.clk) (FIFO.wr_ptr < fifo_if.FIFO_DEPTH);
	endproperty

	property Read_Pointer_threshold;
		@(posedge fifo_if.clk) (FIFO.rd_ptr < fifo_if.FIFO_DEPTH);
	endproperty

	property Counter_threshold;
		@(posedge fifo_if.clk) (FIFO.count <= fifo_if.FIFO_DEPTH);
	endproperty
	

	default disable iff (!fifo_if.rst_n);

	empty_Flag_Assertion: assert property (Empty_Flag_Assertion)
		else $fatal("Assertion Empty_Flag_Assertion failed!");
	cover property (Empty_Flag_Assertion);

	almost_Empty_Flag_Assertion: assert property (Almost_Empty_Flag_Assertion)
		else $fatal("Assertion Almost_Empty_Flag_Assertion failed!");
	cover property (Almost_Empty_Flag_Assertion);

	full_Flag_Assertion: assert property (Full_Flag_Assertion)
		else $fatal("Assertion Full_Flag_Assertion failed!");
	cover property (Full_Flag_Assertion);

	almost_Full_Flag_Assertion: assert property (Almost_Full_Flag_Assertion)
		else $fatal("Assertion Almost_Full_Flag_Assertion failed!");
	cover property (Almost_Full_Flag_Assertion);

	write_Acknowledge: assert property (Write_Acknowledge)
		else $fatal("Assertion Write_Acknowledge failed!");
	cover property (Write_Acknowledge);

	overflow_detection: assert property (Overflow_Detection)
		else $fatal("Assertion  Overflow_Detection failed!");
	cover property (Overflow_Detection);

	underflow_Detection: assert property (Underflow_Detection)
		else $fatal("Assertion Underflow_Detection failed!");
	cover property (Underflow_Detection);

	write_Pointer_Wraparound: assert property (Write_Pointer_Wraparound)
		else $fatal("Assertion Write_Pointer_Wraparound failed!");
	cover property (Write_Pointer_Wraparound);

	read_Pointer_Wraparound: assert property (Read_Pointer_Wraparound)
		else $fatal("Assertion Read_Pointer_Wraparound failed!");
	cover property (Read_Pointer_Wraparound);

	write_Pointer_threshold: assert property (Write_Pointer_threshold)
		else $fatal("Assertion Write_Pointer_threshold failed!");
	cover property (Write_Pointer_threshold);
	
	read_Pointer_threshold: assert property (Read_Pointer_threshold)
		else $fatal("Assertion Read_Pointer_threshold failed!");
	cover property (Read_Pointer_threshold);
	
	counter_threshold: assert property (Counter_threshold)
		else $fatal("Assertion Counter_threshold failed!");
	cover property (Counter_threshold);
endmodule