////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_IF.DUT fifo_if);

 
localparam max_fifo_addr = $clog2(fifo_if.FIFO_DEPTH);

reg [fifo_if.FIFO_WIDTH-1:0] mem [fifo_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;  //**

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin 
		wr_ptr <= 0;
		fifo_if.wr_ack <= 0;
		fifo_if.overflow <= 0;
	end
	else if (fifo_if.wr_en && count < fifo_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		fifo_if.overflow <= 0;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full && fifo_if.wr_en)    //was bitwise and (&)
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end


always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		fifo_if.underflow <= 0;
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		fifo_if.underflow <= 0;
		rd_ptr <= rd_ptr + 1;   //**
	end
	else if (fifo_if.rd_en && fifo_if.empty == 1) begin   // underflow is sequential, should be assigned in always block
		fifo_if.underflow <= 1; 
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
		else if (({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && !fifo_if.full && fifo_if.empty)  // was missing
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && !fifo_if.empty && fifo_if.full) // was missing
			count <= count - 1;
	end
end

assign fifo_if.full = (count === fifo_if.FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count === 0)? 1 : 0;
assign fifo_if.almostfull = (count === fifo_if.FIFO_DEPTH-1)? 1 : 0; // was FIFO_DEPTH-2
assign fifo_if.almostempty = (count === 1)? 1 : 0;
//assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; //**


//===================== Assertions to check flags functionalities ===========================
`ifdef SIM

	sequence max_wr_ptr_valid_write;
		 fifo_if.wr_en && !fifo_if.full && (wr_ptr == {max_fifo_addr{1'b1}});
	endsequence

	sequence max_rd_ptr_valid_read;
		 fifo_if.rd_en && !fifo_if.empty && (rd_ptr == {max_fifo_addr{1'b1}});
	endsequence

	sequence reset_wr_ptr;
		(wr_ptr == {max_fifo_addr{1'b0}});
	endsequence

	sequence reset_rd_ptr;
		(rd_ptr == {max_fifo_addr{1'b0}});
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
		@(posedge fifo_if.clk) (count === 0) |=> $past(fifo_if.empty);
	endproperty

	property Almost_Empty_Flag_Assertion;
		@(posedge fifo_if.clk) (count === 1) |=> $past(fifo_if.almostempty);
	endproperty

	property Full_Flag_Assertion;
		@(posedge fifo_if.clk) (count === fifo_if.FIFO_DEPTH) |=> $past(fifo_if.full);
	endproperty

	property Almost_Full_Flag_Assertion;
		@(posedge fifo_if.clk) (count === fifo_if.FIFO_DEPTH - 1) |=> $past(fifo_if.almostfull);
	endproperty

	property Write_Pointer_Wraparound;
		@(posedge fifo_if.clk) max_wr_ptr_valid_write |=> reset_wr_ptr; 
	endproperty

	property Read_Pointer_Wraparound;
		@(posedge fifo_if.clk) max_rd_ptr_valid_read |=> reset_rd_ptr; 
	endproperty


	property Write_Pointer_threshold;
		@(posedge fifo_if.clk) (wr_ptr < fifo_if.FIFO_DEPTH);
	endproperty

	property Read_Pointer_threshold;
		@(posedge fifo_if.clk) (rd_ptr < fifo_if.FIFO_DEPTH);
	endproperty

	property Counter_threshold;
		@(posedge fifo_if.clk) (count <= fifo_if.FIFO_DEPTH);
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



`endif

endmodule