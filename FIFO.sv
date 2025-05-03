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
	end
	else if (fifo_if.wr_en && count < fifo_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full & fifo_if.wr_en)    //**
			fifo_if.overflow <= 1;
		else
			fifo_if.overflow <= 0;
	end
end


always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;   //**
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
	end
end

assign fifo_if.full = (count == fifo_if.FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; //**
assign almostfifo_if.full = (count == fifo_if.FIFO_DEPTH-2)? 1 : 0; 
assign almostfifo_if.empty = (count == 1)? 1 : 0;


//===================== Assertions to check flags functionalities ===========================
`ifdef SIM

	sequence valid_write;
		 fifo_if.wr_en && !fifo_if.full;
	endsequence

	sequence valid_read;
		 fifo_if.rd_en && !fifo_if.empty;
	endsequence

	property Write_Acknowledge;
		@(posedge clk) (fifo_if.wr_en && !fifo_if.full) |=> ##1 (fifo_if.wr_ack);
	endproperty

	property Overflow_Detection;
		@(posedge clk) (fifo_if.wr_en && fifo_if.full) |=> ##1 (fifo_if.overflow);
	endproperty

	property Underflow_Detection;
		@(posedge clk) (fifo_if.rd_en && fifo_if.empty) |=> ##1 (fifo_if.underflow);
	endproperty

	property Empty_Flag_Assertion;
		@(posedge clk) (count == 0) |=> (fifo_if.empty);
	endproperty

	property Almost_Empty_Flag_Assertion;
		@(posedge clk) (count == 1) |=> (fifo_if.almostempty);
	endproperty

	property Full_Flag_Assertion;
		@(posedge clk) (count == FIFO_DEPTH) |=> (fifo_if.full);
	endproperty

	property Almost_Full_Flag_Assertion;
		@(posedge clk) (count == FIFO_DEPTH - 1) |=> (fifo_if.almostfull);
	endproperty

	property Write_Pointer_Wraparound;
		@(posedge clk) (wr_ptr == {max_fifo_addr{1'b1}}) valid_write |=> (wr_ptr == {max_fifo_addr{1'b0}}); 
	endproperty

	property Read_Pointer_Wraparound;
		@(posedge clk) (rd_ptr == {max_fifo_addr{1'b1}}) valid_read |=> (rd_ptr == {max_fifo_addr{1'b0}}); 
	endproperty

	property counter_Wraparound;
		@(posedge clk) (count == FIFO_DEPTH) valid_write |=> (count == 0);
	endproperty

	property Write_Pointer_threshold;
		@(posedge clk) (wr_ptr <= FIFO_DEPTH);
	endproperty

	property Read_Pointer_threshold;
		@(posedge clk) (rd_ptr <= FIFO_DEPTH);
	endproperty

	property Counter_threshold;
		@(posedge clk) (count <= FIFO_DEPTH);
	endproperty

	Write_Acknowledge: assert property (Write_Acknowledge)
		else $fatal("Assertion Write_Acknowledge failed!");
	cover property (Write_Acknowledge);

	Overflow_Detection: assert property (Overflow_Detection)
		else $fatal("Assertion  Overflow_Detection failed!");
	cover property (Overflow_Detection);

	Underflow_Detection: assert property (Underflow_Detection)
		else $fatal("Assertion Underflow_Detection failed!");
	cover property (Underflow_Detection);

	Empty_Flag_Assertion: assert property (Empty_Flag_Assertion)
		else $fatal("Assertion Empty_Flag_Assertion failed!");
	cover property (Empty_Flag_Assertion);

	Almost_Empty_Flag_Assertion: assert property (Almost_Empty_Flag_Assertion)
		else $fatal("Assertion Almost_Empty_Flag_Assertion failed!");
	cover property (Almost_Empty_Flag_Assertion);

	Full_Flag_Assertion: assert property (Full_Flag_Assertion)
		else $fatal("Assertion Full_Flag_Assertion failed!");
	cover property (Full_Flag_Assertion);

	Almost_Full_Flag_Assertion: assert property (Almost_Full_Flag_Assertion)
		else $fatal("Assertion Almost_Full_Flag_Assertion failed!");
	cover property (Almost_Full_Flag_Assertion);

	Write_Pointer_Wraparound: assert property (Write_Pointer_Wraparound)
		else $fatal("Assertion Write_Pointer_Wraparound failed!");
	cover property (Write_Pointer_Wraparound);

	Read_Pointer_Wraparound: assert property (Read_Pointer_Wraparound)
		else $fatal("Assertion Read_Pointer_Wraparound failed!");
	cover property (Read_Pointer_Wraparound);

	counter_Wraparound: assert property (counter_Wraparound)
		else $fatal("Assertion counter_Wraparound failed!");
	cover property (counter_Wraparound);

	Write_Pointer_threshold: assert property (Write_Pointer_threshold)
		else $fatal("Assertion Write_Pointer_threshold failed!");
	cover property (Write_Pointer_threshold);
	
	Read_Pointer_threshold: assert property (Read_Pointer_threshold)
		else $fatal("Assertion Read_Pointer_threshold failed!");
	cover property (Read_Pointer_threshold);
	
	Counter_threshold: assert property (Counter_threshold)
		else $fatal("Assertion Counter_threshold failed!");
	cover property (Counter_threshold);

`endif

endmodule