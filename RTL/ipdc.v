
module ipdc (                       
	input         i_clk,
	input         i_rst_n,
	input         i_op_valid,
	input  [ 3:0] i_op_mode,
    output        o_op_ready,
	input         i_in_valid,
	input  [23:0] i_in_data,
	output        o_in_ready,
	output        o_out_valid,
	output [23:0] o_out_data
);

integer i;
// ---------------------------------------------------------------------------
// SRAM instance
// ---------------------------------------------------------------------------
parameter SRAM_ADDRESS_WIDTH = 8;


wire [7:0] 					  o_from_sram_data1;
wire 						  sram_cen1;
wire  						  sram_wen1;
wire [SRAM_ADDRESS_WIDTH-1:0] sram_address1;
wire [7:0]					  i_to_sram_data1;

reg 						  sram_cen1_w, sram_cen1_r;
reg  						  sram_wen1_w, sram_wen1_r;
reg [SRAM_ADDRESS_WIDTH-1:0]  sram_address1_w, sram_address1_r;
reg [7:0]					  i_to_sram_data1_w, i_to_sram_data1_r;

assign sram_cen1 = sram_cen1_r;
assign sram_wen1 = sram_wen1_r;
assign sram_address1 = sram_address1_r;
assign i_to_sram_data1 = i_to_sram_data1_r;

sram_256x8 sram1 (
   .Q(o_from_sram_data1),
   .CLK(i_clk),
   .CEN(sram_cen1),
   .WEN(sram_wen1),
   .A(sram_address1),
   .D(i_to_sram_data1)
);


wire [7:0] 					  o_from_sram_data2;
wire 						  sram_cen2;
wire  						  sram_wen2;
wire [SRAM_ADDRESS_WIDTH-1:0] sram_address2;
wire [7:0]					  i_to_sram_data2;

reg 						  sram_cen2_w, sram_cen2_r;
reg  						  sram_wen2_w, sram_wen2_r;
reg [SRAM_ADDRESS_WIDTH-1:0]  sram_address2_w, sram_address2_r;
reg [7:0]					  i_to_sram_data2_w, i_to_sram_data2_r;

assign sram_cen2 = sram_cen2_r;
assign sram_wen2 = sram_wen2_r;
assign sram_address2 = sram_address2_r;
assign i_to_sram_data2 = i_to_sram_data2_r;

sram_256x8 sram2 (
   .Q(o_from_sram_data2),
   .CLK(i_clk),
   .CEN(sram_cen2),
   .WEN(sram_wen2),
   .A(sram_address2),
   .D(i_to_sram_data2)
);


wire [7:0] 					  o_from_sram_data3;
wire 						  sram_cen3;
wire  						  sram_wen3;
wire [SRAM_ADDRESS_WIDTH-1:0] sram_address3;
wire [7:0]					  i_to_sram_data3;

reg 						  sram_cen3_w, sram_cen3_r;
reg  						  sram_wen3_w, sram_wen3_r;
reg [SRAM_ADDRESS_WIDTH-1:0]  sram_address3_w, sram_address3_r;
reg [7:0]					  i_to_sram_data3_w, i_to_sram_data3_r;

assign sram_cen3 = sram_cen3_r;
assign sram_wen3 = sram_wen3_r;
assign sram_address3 = sram_address3_r;
assign i_to_sram_data3 = i_to_sram_data3_r;

sram_256x8 sram3 (
   .Q(o_from_sram_data3),
   .CLK(i_clk),
   .CEN(sram_cen3),
   .WEN(sram_wen3),
   .A(sram_address3),
   .D(i_to_sram_data3)
);


// ---------------------------------------------------------------------------

reg [3:0] state_w, state_r;

reg o_op_ready_w, o_op_ready_r;
reg	o_in_ready_w, o_in_ready_r; 		// *** maybe not necassary
reg o_out_valid_w, o_out_valid_r;
reg	[23:0] o_out_data_w, o_out_data_r;

assign o_op_ready = o_op_ready_r;
assign o_in_ready = o_in_ready_r;
assign o_out_valid = o_out_valid_r;
assign o_out_data = o_out_data_r;

reg [7:0] origin_w, origin_r;
reg [4:0] display_counter_w, display_counter_r;

reg [1:0] scale_w, scale_r;

wire [7:0] Y;
wire [10:0] Y1;
wire [10:0] Y21;
wire [10:0] Y22;
wire [10:0] Y2;
wire [10:0] Y_temp;
assign Y1 = { 2'b00, o_from_sram_data1, 1'b0 };
assign Y21 = { 1'b0, o_from_sram_data2, 2'b00 };
assign Y22 = { 3'b000, o_from_sram_data2 };
assign Y2 = Y21 + Y22;
assign Y_temp = Y1 + Y2;
assign Y = (Y_temp[2] == 1) ? Y_temp[10:3] + 1 : Y_temp[10:3];

wire [7:0] Cb;
wire [10:0] Cb1;
wire [10:0] Cb2;
wire [10:0] Cb3;
wire [10:0] Cb4;
wire [10:0] Cb_temp;
assign Cb1 = { 3'b111, ~o_from_sram_data1 } + 1;
assign Cb2 = { 2'b11, ~o_from_sram_data2, 1'b1 } + 1;
assign Cb3 = { 1'b0, o_from_sram_data3, 2'b00 };
assign Cb4 = 11'd1024;
assign Cb_temp = (Cb1 + Cb2) + (Cb3 + Cb4);
assign Cb = (Cb_temp[2] == 1) ? Cb_temp[10:3] + 1 : Cb_temp[10:3];

wire [7:0] Cr;
wire [10:0] Cr1;
wire [10:0] Cr21;
wire [10:0] Cr22;
wire [10:0] Cr2;
wire [10:0] Cr3;
wire [10:0] Cr4;
wire [10:0] Cr_temp;
assign Cr1 = { 1'b0, o_from_sram_data1, 2'b00 };
assign Cr21 = { 2'b00, o_from_sram_data2, 1'b0 };
assign Cr22 = { 3'b000, o_from_sram_data2 };
assign Cr2 = ~(Cr21 + Cr22) + 1;
assign Cr3 = { 3'b111, ~o_from_sram_data3 } + 1;
assign Cr4 = 11'd1024;
assign Cr_temp = (Cr1 + Cr2) + (Cr3 + Cr4);
assign Cr = (Cr_temp[2] == 1) ? Cr_temp[10:3] + 1 : Cr_temp[10:3];

reg [0:0] ycbcr_w, ycbcr_r;

reg [0:7] shreg1_w [8:0];
reg [0:7] shreg1_r [8:0];
reg [0:7] shreg2_w [8:0];
reg [0:7] shreg2_r [8:0];
reg [0:7] shreg3_w [8:0];
reg [0:7] shreg3_r [8:0];

reg [1:0] kernel_x_w, kernel_x_r;
reg [1:0] kernel_y_w, kernel_y_r;
reg [3:0] kernel_counter_w, kernel_counter_r;
reg [7:0] shift;

reg valid_buff1_w, valid_buff1_r;
reg valid_buff2_w, valid_buff2_r;
reg valid_buff3_w, valid_buff3_r;
reg valid_buff4_w, valid_buff4_r;

reg [1:0] kernel_x_buff1_w, kernel_x_buff1_r;
reg [1:0] kernel_x_buff2_w, kernel_x_buff2_r;
reg [1:0] kernel_y_buff1_w, kernel_y_buff1_r;
reg [1:0] kernel_y_buff2_w, kernel_y_buff2_r;
reg [3:0] kernel_counter_buff1_w, kernel_counter_buff1_r;
reg [3:0] kernel_counter_buff2_w, kernel_counter_buff2_r;
reg [7:0] origin_buff1_w, origin_buff1_r;
reg [7:0] origin_buff2_w, origin_buff2_r;


// ---------------------------------
reg [7:0] medin11, medin12, medin13;
reg [7:0] medin14, medin15, medin16;
reg [7:0] medin17, medin18, medin19;
wire [7:0] medout;

median_of_9 med1(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.in1(medin11),
	.in2(medin12),
	.in3(medin13),
	.in4(medin14),
	.in5(medin15),
	.in6(medin16),
	.in7(medin17),
	.in8(medin18),
	.in9(medin19),
	.median(medout)
);

always @(*) begin
	case({valid_buff1_r, valid_buff2_r, valid_buff3_r})
		3'b100: begin
			medin11 = shreg1_r[8];
			medin12 = shreg1_r[7];
			medin13 = shreg1_r[6];
			medin14 = shreg1_r[5];
			medin15 = shreg1_r[4];
			medin16 = shreg1_r[3];
			medin17 = shreg1_r[2];
			medin18 = shreg1_r[1];
			medin19 = shreg1_r[0];
		end
		3'b010: begin
			medin11 = shreg2_r[8];
			medin12 = shreg2_r[7];
			medin13 = shreg2_r[6];
			medin14 = shreg2_r[5];
			medin15 = shreg2_r[4];
			medin16 = shreg2_r[3];
			medin17 = shreg2_r[2];
			medin18 = shreg2_r[1];
			medin19 = shreg2_r[0];
		end
		3'b001: begin
			medin11 = shreg3_r[8];
			medin12 = shreg3_r[7];
			medin13 = shreg3_r[6];
			medin14 = shreg3_r[5];
			medin15 = shreg3_r[4];
			medin16 = shreg3_r[3];
			medin17 = shreg3_r[2];
			medin18 = shreg3_r[1];
			medin19 = shreg3_r[0];
		end
		default: begin
			medin11 = shreg1_r[8];
			medin12 = shreg1_r[7];
			medin13 = shreg1_r[6];
			medin14 = shreg1_r[5];
			medin15 = shreg1_r[4];
			medin16 = shreg1_r[3];
			medin17 = shreg1_r[2];
			medin18 = shreg1_r[1];
			medin19 = shreg1_r[0];
		end
	endcase
end
// --------------------------------

// --------------------------------
reg [7:0] ctin1, ctin2, ctin3;
reg [7:0] ctin4, ctin5, ctin6;
reg [7:0] ctin7, ctin8, ctin9;
wire [7:0] ctout;

CT ct(
	.in1(ctin1),
	.in2(ctin2),
	.in3(ctin3),
	.in4(ctin4),
	.in5(ctin5),
	.in6(ctin6),
	.in7(ctin7),
	.in8(ctin8),
	.in9(ctin9),
	.out(ctout)
);

always @(*) begin
	case({valid_buff1_r, valid_buff2_r, valid_buff3_r})
		3'b100: begin
			ctin1 = shreg1_r[0];
			ctin2 = shreg1_r[1];
			ctin3 = shreg1_r[2];
			ctin4 = shreg1_r[3];
			ctin5 = shreg1_r[4];
			ctin6 = shreg1_r[5];
			ctin7 = shreg1_r[6];
			ctin8 = shreg1_r[7];
			ctin9 = shreg1_r[8];
		end
		3'b010: begin
			ctin1 = shreg2_r[0];
			ctin2 = shreg2_r[1];
			ctin3 = shreg2_r[2];
			ctin4 = shreg2_r[3];
			ctin5 = shreg2_r[4];
			ctin6 = shreg2_r[5];
			ctin7 = shreg2_r[6];
			ctin8 = shreg2_r[7];
			ctin9 = shreg2_r[8];
		end
		3'b001: begin
			ctin1 = shreg3_r[0];
			ctin2 = shreg3_r[1];
			ctin3 = shreg3_r[2];
			ctin4 = shreg3_r[3];
			ctin5 = shreg3_r[4];
			ctin6 = shreg3_r[5];
			ctin7 = shreg3_r[6];
			ctin8 = shreg3_r[7];
			ctin9 = shreg3_r[8];
		end
		default: begin
			ctin1 = shreg1_r[0];
			ctin2 = shreg1_r[1];
			ctin3 = shreg1_r[2];
			ctin4 = shreg1_r[3];
			ctin5 = shreg1_r[4];
			ctin6 = shreg1_r[5];
			ctin7 = shreg1_r[6];
			ctin8 = shreg1_r[7];
			ctin9 = shreg1_r[8];
		end
	endcase
end


// --------------------------------


// ---------------------------------------------------------------------------
// Combinational Blocks
// ---------------------------------------------------------------------------
parameter S_IDLE = 1;
parameter S_MODE = 2;
parameter S_LOAD = 0;
parameter S_RSFT = 4;
parameter S_LSFT = 5;
parameter S_USFT = 6;
parameter S_DSFT = 7;
parameter S_DISP = 3;
parameter S_SCLD = 8;
parameter S_SCLU = 9;
parameter S_YCBR = 13;
parameter S_MDFT = 12;
parameter S_CSTF = 14;


always @(*) begin
	case(state_r)
		S_IDLE: begin
			state_w = S_MODE;
			o_op_ready_w = 1;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;
			
			origin_w = origin_r;
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_MODE: begin
			state_w = (i_op_valid) ? i_op_mode : S_MODE;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			origin_w = origin_r;
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_LOAD: begin
			state_w = (i_in_valid) ? S_LOAD : S_IDLE;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			origin_w = origin_r;
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_RSFT: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			case(scale_r)
				2'b11: begin
					origin_w = (&origin_r[3:2]) ? origin_r : origin_r + 1;
				end
				2'b10: begin
					origin_w = (&origin_r[3:2]) ? origin_r : origin_r + 8'd2;
				end
				2'b01: begin
					origin_w = (&origin_r[3:2]) ? origin_r : origin_r + 8'd4;
				end
				default: begin
					origin_w = origin_r;
				end
			endcase
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_LSFT: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			case(scale_r)
				2'b11: begin
					origin_w = (|origin_r[3:0]) ? origin_r - 1 : origin_r;
				end
				2'b10: begin
					origin_w = (|origin_r[3:1]) ? origin_r - 8'd2 : origin_r;
				end
				2'b01: begin
					origin_w = (|origin_r[3:2]) ? origin_r - 8'd4 : origin_r;
				end
				default: begin
					origin_w = origin_r;
				end
			endcase
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_USFT: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			case(scale_r)
				2'b11: begin
					origin_w = (|origin_r[7:4]) ? origin_r - 8'd16 : origin_r;
				end
				2'b10: begin
					origin_w = (|origin_r[7:5]) ? origin_r - 8'd32 : origin_r;
				end
				2'b01: begin
					origin_w = (|origin_r[7:6]) ? origin_r - 8'd64 : origin_r;
				end
				default: begin
					origin_w = origin_r;
				end
			endcase
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_DSFT: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			case(scale_r)
				2'b11: begin
					origin_w = (&origin_r[7:6]) ? origin_r : origin_r + 8'd16;
				end
				2'b10: begin
					origin_w = (&origin_r[7:6]) ? origin_r : origin_r + 8'd32;
				end
				2'b01: begin
					origin_w = (&origin_r[7:6]) ? origin_r : origin_r + 8'd64;
				end
				default: begin
					origin_w = origin_r;
				end
			endcase
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_SCLD: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			origin_w = origin_r;
			display_counter_w = 0;

			// if (scale_r[1]) begin
			// 	scale_w = scale_r - 2'b10;
			// end
			// else begin
			// 	if (scale_r[0]) begin
			// 		scale_w = scale_r - 1;
			// 	end
			// 	else begin
			// 		scale_w = scale_r;
			// 	end
			// end
			scale_w = (scale_r[1]) ? scale_r - 1 : scale_r;

			ycbcr_w = 0;
			
			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
		S_SCLU: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			origin_w = origin_r;
			display_counter_w = 0;

			if (scale_r == 2'b10) begin // 8x8
				if ( (origin_r[3:0]>4'd12) || (origin_r[7:4]>4'd12) ) begin // can't scale up
					scale_w = scale_r;
				end
				else begin
					// scale_w = scale_r + 2'b10;
					scale_w = scale_r + 1;
				end
			end
			else begin // 4x4 or 16x16
				if ( (&origin_r[3:1]) || (&origin_r[7:5]) ) begin // 4x4 can't scale up
					scale_w = scale_r;
				end
				else begin
					scale_w = (&scale_r) ? scale_r : scale_r + 1; // 16x16 can't scale up
				end
			end

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end

		S_YCBR: begin
			state_w = S_DISP;
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = 0;
			o_out_data_w = 0;

			origin_w = origin_r;
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 1;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end

		S_DISP: begin
			case(scale_r)
				2'b11: begin
					state_w = (display_counter_r == 5'd17) ? S_IDLE : S_DISP;
				end
				2'b10: begin
					state_w = (display_counter_r == 5'd5) ? S_IDLE : S_DISP;
				end
				2'b01: begin
					state_w = (display_counter_r == 5'd2) ? S_IDLE : S_DISP;
				end
				default: begin
					state_w = state_r;
				end
			endcase
			// state_w = (display_counter_r == 5'd17) ? S_IDLE : S_DISP; // *** 4'd15 seems wrong, maybe because sram need 2 cycle to output correct data
			o_op_ready_w = 0;
			o_in_ready_w = 1;
			o_out_valid_w = (display_counter_r <= 5'd1) ? 0 : 1;

			if (ycbcr_r == 0) begin
				o_out_data_w[23:16] = o_from_sram_data1;
				o_out_data_w[15: 8] = o_from_sram_data2;
				o_out_data_w[ 7: 0] = o_from_sram_data3;
			end
			else begin
				o_out_data_w[23:16] = Y;
				o_out_data_w[15: 8] = Cb;
				o_out_data_w[ 7: 0] = Cr;
			end

			origin_w = origin_r;
			display_counter_w = display_counter_r + 1;

			scale_w = scale_r;

			ycbcr_w = ycbcr_r;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end

		S_MDFT: begin
			case(scale_r)
				2'b11: begin
					state_w = (display_counter_r == 5'd16 && valid_buff4_r == 1) ? S_IDLE : S_MDFT;
				end
				2'b10: begin
					state_w = (display_counter_r == 5'd4 && valid_buff4_r == 1) ? S_IDLE : S_MDFT;
				end
				2'b01: begin
					state_w = (display_counter_r == 5'd1 && valid_buff4_r == 1) ? S_IDLE : S_MDFT;
				end
				default: begin
					state_w = state_r;
				end
			endcase
			o_op_ready_w = 0;
			o_in_ready_w = 1;

			origin_w = origin_r;

			scale_w = scale_r;

			ycbcr_w = 0;

			if (valid_buff2_r==1 || valid_buff1_r==1) begin
				for (i=1; i<9; i=i+1) begin
					shreg1_w[i] = shreg1_r[i];
					shreg2_w[i] = shreg2_r[i];
					shreg3_w[i] = shreg3_r[i];
				end
			end
			else begin
				for (i=0; i<8; i=i+1) begin
					shreg1_w[i+1] = shreg1_r[i];
					shreg2_w[i+1] = shreg2_r[i];
					shreg3_w[i+1] = shreg3_r[i];
				end
			end

			if (kernel_counter_r == 4'd10) begin
				case(scale_r)
					2'b11: begin
						kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6;
						kernel_x_w = kernel_x_r + 1;
						kernel_y_w = (kernel_x_r == 2'd3) ? kernel_y_r + 1 : kernel_y_r;
					end
					2'b10: begin
						kernel_counter_w = (kernel_x_r == 1) ? 0 : 4'd6;
						kernel_x_w = (kernel_x_r == 1) ? 0 : 1;
						kernel_y_w = (kernel_x_r == 1) ? 1 : kernel_y_r;
					end
					2'b01: begin
						kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6; //
						kernel_x_w = kernel_x_r;
						kernel_y_w = kernel_y_r;
					end
					default: begin
						kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6;
						kernel_x_w = kernel_x_r + 1;
						kernel_y_w = (kernel_x_r == 2'd3) ? kernel_y_r + 1 : kernel_y_r;
					end
				endcase
				display_counter_w = display_counter_r + 1;
				o_out_valid_w = valid_buff4_r;
				valid_buff4_w = valid_buff3_r;
				valid_buff3_w = valid_buff2_r;
				valid_buff2_w = valid_buff1_r;
				valid_buff1_w = 1;
			end
			else begin
				kernel_counter_w = kernel_counter_r + 1;
				kernel_y_w = kernel_y_r;
				kernel_x_w = kernel_x_r;
				display_counter_w = display_counter_r;
				o_out_valid_w = valid_buff4_r;
				valid_buff4_w = valid_buff3_r;
				valid_buff3_w = valid_buff2_r;
				valid_buff2_w = valid_buff1_r;
				valid_buff1_w = 0;
			end

			kernel_x_buff1_w = kernel_x_r;
			kernel_x_buff2_w = kernel_x_buff1_r;
			kernel_y_buff1_w = kernel_y_r;
			kernel_y_buff2_w = kernel_y_buff1_r;
			kernel_counter_buff1_w = kernel_counter_r;
			kernel_counter_buff2_w = kernel_counter_buff1_r;
			origin_buff1_w = origin_r;
			origin_buff2_w = origin_buff1_r;

			case(scale_r)
				2'b11: begin
					case(kernel_counter_buff2_r)
						4'd0: begin
							if ( !(|(origin_buff2_r[7:4]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd3: begin
							if ( !(|(origin_buff2_r[7:4]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd6: begin
							if ( !(|(origin_buff2_r[7:4]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd1: begin
							if ( !(|(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd4: begin
							shreg1_w[0] = o_from_sram_data1;
							shreg2_w[0] = o_from_sram_data2;
							shreg3_w[0] = o_from_sram_data3;
						end
						4'd7: begin
							if ( (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd2: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd5: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd8: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						default: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
					endcase
				end
				2'b10: begin
					case(kernel_counter_buff2_r)
						4'd0: begin
							if ( !(|(origin_buff2_r[7:5]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd3: begin
							if ( !(|(origin_buff2_r[7:5]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd6: begin
							if ( !(|(origin_buff2_r[7:5]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd1: begin
							if ( !(|(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd4: begin
							shreg1_w[0] = o_from_sram_data1;
							shreg2_w[0] = o_from_sram_data2;
							shreg3_w[0] = o_from_sram_data3;
						end
						4'd7: begin
							if ( (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd2: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd5: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd8: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						default: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
					endcase
				end
				2'b01: begin
					case(kernel_counter_buff2_r)
						4'd0: begin
							if ( !(|origin_buff2_r[7:6]) || !(|origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd3: begin
							if ( !(|origin_buff2_r[7:6]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd6: begin
							if ( !(|origin_buff2_r[7:6]) || (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd1: begin
							if ( !(|origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd4: begin
							shreg1_w[0] = o_from_sram_data1;
							shreg2_w[0] = o_from_sram_data2;
							shreg3_w[0] = o_from_sram_data3;
						end
						4'd7: begin
							if ( (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd2: begin
							if ( (&origin_buff2_r[7:6]) || !(|origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd5: begin
							if ( (&origin_buff2_r[7:6]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd8: begin
							if ( (&origin_buff2_r[7:6]) || (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						default: begin
							if ( (&origin_buff2_r[7:6]) || (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
					endcase
				end
				default: begin
					shreg1_w[0] = 0;
					shreg2_w[0] = 0;
					shreg3_w[0] = 0;
				end
			endcase

			case({valid_buff2_r, valid_buff3_r, valid_buff4_r})
				3'b100: begin
					o_out_data_w[23:16] = medout;
					o_out_data_w[15:8] = o_out_data_r[15:8];
					o_out_data_w[7:0] = o_out_data_r[7:0];
				end
				3'b010: begin
					o_out_data_w[23:16] = o_out_data_r[23:16];
					o_out_data_w[15:8] = medout;
					o_out_data_w[7:0] = o_out_data_r[7:0];
				end
				3'b001: begin
					o_out_data_w[23:16] = o_out_data_r[23:16];
					o_out_data_w[15:8] = o_out_data_r[15:8];
					o_out_data_w[7:0] = medout;
				end
				default: begin
					o_out_data_w[23:16] = medout;
					o_out_data_w[15:8] = o_out_data_r[15:8];
					o_out_data_w[7:0] = o_out_data_r[7:0];
				end
			endcase

		end

		S_CSTF: begin
			// state_w = (display_counter_r == 5'd16 && valid_buff3_r == 1) ? S_IDLE : S_CSTF;
			case(scale_r)
				2'b11: begin
					state_w = (display_counter_r == 5'd16 && valid_buff3_r == 1) ? S_IDLE : S_CSTF;
				end
				2'b10: begin
					state_w = (display_counter_r == 5'd4 && valid_buff3_r == 1) ? S_IDLE : S_CSTF;
				end
				2'b01: begin
					state_w = (display_counter_r == 5'd1 && valid_buff3_r == 1) ? S_IDLE : S_CSTF;
				end
				default: begin
					state_w = state_r;
				end
			endcase
			o_op_ready_w = 0;
			o_in_ready_w = 1;

			origin_w = origin_r;

			scale_w = scale_r;

			ycbcr_w = 0;

			if (valid_buff2_r==1 || valid_buff1_r==1) begin
				for (i=1; i<9; i=i+1) begin
					shreg1_w[i] = shreg1_r[i];
					shreg2_w[i] = shreg2_r[i];
					shreg3_w[i] = shreg3_r[i];
				end
			end
			else begin
				for (i=0; i<8; i=i+1) begin
					shreg1_w[i+1] = shreg1_r[i];
					shreg2_w[i+1] = shreg2_r[i];
					shreg3_w[i+1] = shreg3_r[i];
				end
			end

			if (kernel_counter_r == 4'd10) begin
				// kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6;
				case(scale_r)
					2'b11: begin
						kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6;
						kernel_x_w = kernel_x_r + 1;
						kernel_y_w = (kernel_x_r == 2'd3) ? kernel_y_r + 1 : kernel_y_r;
					end
					2'b10: begin
						kernel_counter_w = (kernel_x_r == 1) ? 0 : 4'd6;
						kernel_x_w = (kernel_x_r == 1) ? 0 : 1;
						kernel_y_w = (kernel_x_r == 1) ? 1 : kernel_y_r;
					end
					2'b01: begin
						kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6;
						kernel_x_w = kernel_x_r;
						kernel_y_w = kernel_y_r;
					end
					default: begin
						kernel_counter_w = (kernel_x_r == 2'd3) ? 0 : 4'd6;
						kernel_x_w = kernel_x_r + 1;
						kernel_y_w = (kernel_x_r == 2'd3) ? kernel_y_r + 1 : kernel_y_r;
					end
				endcase
				display_counter_w = display_counter_r + 1;
				o_out_valid_w = valid_buff3_r;
				valid_buff3_w = valid_buff2_r;
				valid_buff2_w = valid_buff1_r;
				valid_buff1_w = 1;
			end
			else begin
				kernel_counter_w = kernel_counter_r + 1;
				kernel_y_w = kernel_y_r;
				kernel_x_w = kernel_x_r;
				display_counter_w = display_counter_r;
				o_out_valid_w = valid_buff3_r;
				valid_buff3_w = valid_buff2_r;
				valid_buff2_w = valid_buff1_r;
				valid_buff1_w = 0;
			end
			valid_buff4_w = 0;

			kernel_x_buff1_w = kernel_x_r;
			kernel_x_buff2_w = kernel_x_buff1_r;
			kernel_y_buff1_w = kernel_y_r;
			kernel_y_buff2_w = kernel_y_buff1_r;
			kernel_counter_buff1_w = kernel_counter_r;
			kernel_counter_buff2_w = kernel_counter_buff1_r;
			origin_buff1_w = origin_r;
			origin_buff2_w = origin_buff1_r;

			case(scale_r)
				2'b11: begin
					case(kernel_counter_buff2_r)
						4'd0: begin
							if ( !(|(origin_buff2_r[7:4]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd3: begin
							if ( !(|(origin_buff2_r[7:4]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd6: begin
							if ( !(|(origin_buff2_r[7:4]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd1: begin
							if ( !(|(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd4: begin
							shreg1_w[0] = o_from_sram_data1;
							shreg2_w[0] = o_from_sram_data2;
							shreg3_w[0] = o_from_sram_data3;
						end
						4'd7: begin
							if ( (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd2: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd5: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd8: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						default: begin
							if ( (&(origin_buff2_r[7:4]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:0]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
					endcase
				end
				2'b10: begin
					case(kernel_counter_buff2_r)
						4'd0: begin
							if ( !(|(origin_buff2_r[7:5]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd3: begin
							if ( !(|(origin_buff2_r[7:5]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd6: begin
							if ( !(|(origin_buff2_r[7:5]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd1: begin
							if ( !(|(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd4: begin
							shreg1_w[0] = o_from_sram_data1;
							shreg2_w[0] = o_from_sram_data2;
							shreg3_w[0] = o_from_sram_data3;
						end
						4'd7: begin
							if ( (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd2: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) || !(|(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd5: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd8: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						default: begin
							if ( (&(origin_buff2_r[7:5]+kernel_y_buff2_r)) || (&(origin_buff2_r[3:1]+kernel_x_buff2_r)) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
					endcase
				end
				2'b01: begin
					case(kernel_counter_buff2_r)
						4'd0: begin
							if ( !(|origin_buff2_r[7:6]) || !(|origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd3: begin
							if ( !(|origin_buff2_r[7:6]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd6: begin
							if ( !(|origin_buff2_r[7:6]) || (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd1: begin
							if ( !(|origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd4: begin
							shreg1_w[0] = o_from_sram_data1;
							shreg2_w[0] = o_from_sram_data2;
							shreg3_w[0] = o_from_sram_data3;
						end
						4'd7: begin
							if ( (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd2: begin
							if ( (&origin_buff2_r[7:6]) || !(|origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd5: begin
							if ( (&origin_buff2_r[7:6]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						4'd8: begin
							if ( (&origin_buff2_r[7:6]) || (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
						default: begin
							if ( (&origin_buff2_r[7:6]) || (&origin_buff2_r[3:2]) ) begin
								shreg1_w[0] = 0;
								shreg2_w[0] = 0;
								shreg3_w[0] = 0;
							end
							else begin
								shreg1_w[0] = o_from_sram_data1;
								shreg2_w[0] = o_from_sram_data2;
								shreg3_w[0] = o_from_sram_data3;
							end
						end
					endcase
				end
				default: begin
					shreg1_w[0] = 0;
					shreg2_w[0] = 0;
					shreg3_w[0] = 0;
				end
			endcase

			case({valid_buff1_r, valid_buff2_r, valid_buff3_r})
				3'b100: begin
					o_out_data_w[23:16] = ctout;
					o_out_data_w[15:8] = o_out_data_r[15:8];
					o_out_data_w[7:0] = o_out_data_r[7:0];
				end
				3'b010: begin
					o_out_data_w[23:16] = o_out_data_r[23:16];
					o_out_data_w[15:8] = ctout;
					o_out_data_w[7:0] = o_out_data_r[7:0];
				end
				3'b001: begin
					o_out_data_w[23:16] = o_out_data_r[23:16];
					o_out_data_w[15:8] = o_out_data_r[15:8];
					o_out_data_w[7:0] = ctout;
				end
				default: begin
					o_out_data_w[23:16] = ctout;
					o_out_data_w[15:8] = o_out_data_r[15:8];
					o_out_data_w[7:0] = o_out_data_r[7:0];
				end
			endcase

		end

		default: begin
			state_w = state_r;
			o_op_ready_w = o_op_ready_r;
			o_in_ready_w = o_in_ready_r;
			o_out_valid_w = o_out_valid_r;
			o_out_data_w = o_out_data_r;

			origin_w = origin_r;
			display_counter_w = 0;

			scale_w = scale_r;

			ycbcr_w = 0;

			for (i=0; i<9; i=i+1) begin
				shreg1_w[i] = 0;
				shreg2_w[i] = 0;
				shreg3_w[i] = 0;
			end

			kernel_x_w = 0;
			kernel_y_w = 0;
			kernel_counter_w = 0;

			valid_buff4_w = 0;
			valid_buff3_w = 0;
			valid_buff2_w = 0;
			valid_buff1_w = 0;

			kernel_x_buff1_w = 0;
			kernel_x_buff2_w = 0;
			kernel_y_buff1_w = 0;
			kernel_y_buff2_w = 0;
			kernel_counter_buff1_w = 0;
			kernel_counter_buff2_w = 0;
			origin_buff1_w = 0;
			origin_buff2_w = 0;
		end
	endcase
end


always @(*) begin
	case(state_r)
		S_LOAD: begin
			if (i_in_valid) begin
				sram_cen1_w = 0;
				sram_wen1_w = 0;
				sram_address1_w = sram_address1_r + 1; //
				i_to_sram_data1_w = i_in_data[23:16];
				sram_cen2_w = 0;
				sram_wen2_w = 0;
				sram_address2_w = sram_address2_r + 1; //
				i_to_sram_data2_w = i_in_data[15:8];
				sram_cen3_w = 0;
				sram_wen3_w = 0;
				sram_address3_w = sram_address3_r + 1; //
				i_to_sram_data3_w = i_in_data[7:0];
			end
			else begin // to avoid rewrite address 0
				sram_cen1_w = 1; 
				sram_wen1_w = sram_wen1_r;
				sram_address1_w = sram_address1_r;
				i_to_sram_data1_w = i_to_sram_data1_r;
				sram_cen2_w = 1; 
				sram_wen2_w = sram_wen2_r;
				sram_address2_w = sram_address2_r;
				i_to_sram_data2_w = i_to_sram_data2_r;
				sram_cen3_w = 1; 
				sram_wen3_w = sram_wen3_r;
				sram_address3_w = sram_address3_r;
				i_to_sram_data3_w = i_to_sram_data3_r;
			end
		end
		S_DISP: begin
			sram_cen1_w = 0; 
			sram_wen1_w = 1;
			case(scale_r)
				2'b11: begin
					sram_address1_w = origin_r + {display_counter_r[3:2],2'd0,display_counter_r[1:0]};
					sram_address2_w = sram_address1_w;
					sram_address3_w = origin_r + {display_counter_r[3:2],2'd0,display_counter_r[1:0]};
				end
				2'b10: begin
					sram_address1_w = origin_r + {display_counter_r[1],3'd0,display_counter_r[0],1'd0};
					sram_address2_w = origin_r + {display_counter_r[1],3'd0,display_counter_r[0],1'd0};
					sram_address3_w = origin_r + {display_counter_r[1],3'd0,display_counter_r[0],1'd0};
				end
				2'b01: begin
					sram_address1_w = origin_r;
					sram_address2_w = origin_r;
					sram_address3_w = origin_r;
				end
				default: begin
					sram_address1_w = sram_address1_r;
					sram_address2_w = sram_address2_r;
					sram_address3_w = sram_address3_r;
				end
			endcase
			// sram_address1_w = origin_r + {display_counter_r[3:2],2'd0,display_counter_r[1:0]};
			i_to_sram_data1_w = i_to_sram_data1_r;
			sram_cen2_w = 0; 
			sram_wen2_w = 1;
			// sram_address2_w = origin_r + {display_counter_r[3:2],2'd0,display_counter_r[1:0]};
			i_to_sram_data2_w = i_to_sram_data2_r;
			sram_cen3_w = 0; 
			sram_wen3_w = 1;
			// sram_address3_w = origin_r + {display_counter_r[3:2],2'd0,display_counter_r[1:0]};
			i_to_sram_data3_w = i_to_sram_data3_r;
		end
		S_MDFT: begin
			case(scale_r)
				2'b11: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b11101111;
						4'd3: shift = 8'b11110000;
						4'd6: shift = 8'b11110001;
						4'd1: shift = 8'b11111111;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd1;
						4'd2: shift = 8'd15;
						4'd5: shift = 8'd16;
						4'd8: shift = 8'd17;
						default: shift = 8'd17;
					endcase
				end
				2'b10: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b11011110;
						4'd3: shift = 8'b11100000;
						4'd6: shift = 8'b11100010;
						4'd1: shift = 8'b11111110;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd2;
						4'd2: shift = 8'd30;
						4'd5: shift = 8'd32;
						4'd8: shift = 8'd34;
						default: shift = 8'd34;
					endcase
				end
				2'b01: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b10111100;
						4'd3: shift = 8'b11000000;
						4'd6: shift = 8'b11000100;
						4'd1: shift = 8'b11111100;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd4;
						4'd2: shift = 8'd60;
						4'd5: shift = 8'd64;
						4'd8: shift = 8'd68;
						default: shift = 8'd68;
					endcase
				end
				default: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b11101111;
						4'd3: shift = 8'b11110000;
						4'd6: shift = 8'b11110001;
						4'd1: shift = 8'b11111111;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd1;
						4'd2: shift = 8'd15;
						4'd5: shift = 8'd16;
						4'd8: shift = 8'd17;
						default: shift = 8'd17;
					endcase
				end
			endcase

			sram_cen1_w = 0;
			sram_wen1_w = 1;
			case(scale_r)
				2'b11: begin
					sram_address1_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
					sram_address2_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
					sram_address3_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
				end
				2'b10: begin
					sram_address1_w = origin_r + {1'd0, kernel_y_r, 5'd0} + {1'b0, kernel_x_r, 1'b0} + shift;
					sram_address2_w = origin_r + {1'd0, kernel_y_r, 5'd0} + {1'b0, kernel_x_r, 1'b0} + shift;
					sram_address3_w = origin_r + {1'd0, kernel_y_r, 5'd0} + {1'b0, kernel_x_r, 1'b0} + shift;
				end
				2'b01: begin
					sram_address1_w = origin_r + shift;
					sram_address2_w = origin_r + shift;
					sram_address3_w = origin_r + shift;
				end
				default: begin
					sram_address1_w = sram_address1_r;
					sram_address2_w = sram_address2_r;
					sram_address3_w = sram_address3_r;
				end
			endcase
			// sram_address1_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
			i_to_sram_data1_w = i_to_sram_data1_r;
			sram_cen2_w = 0;
			sram_wen2_w = 1;
			// sram_address2_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
			i_to_sram_data2_w = i_to_sram_data2_r;
			sram_cen3_w = 0;
			sram_wen3_w = 1;
			// sram_address3_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
			i_to_sram_data3_w = i_to_sram_data3_r;
		end
		S_CSTF: begin
			case(scale_r)
				2'b11: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b11101111;
						4'd3: shift = 8'b11110000;
						4'd6: shift = 8'b11110001;
						4'd1: shift = 8'b11111111;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd1;
						4'd2: shift = 8'd15;
						4'd5: shift = 8'd16;
						4'd8: shift = 8'd17;
						default: shift = 8'd17;
					endcase
				end
				2'b10: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b11011110;
						4'd3: shift = 8'b11100000;
						4'd6: shift = 8'b11100010;
						4'd1: shift = 8'b11111110;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd2;
						4'd2: shift = 8'd30;
						4'd5: shift = 8'd32;
						4'd8: shift = 8'd34;
						default: shift = 8'd34;
					endcase
				end
				2'b01: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b10111100;
						4'd3: shift = 8'b11000000;
						4'd6: shift = 8'b11000100;
						4'd1: shift = 8'b11111100;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd4;
						4'd2: shift = 8'd60;
						4'd5: shift = 8'd64;
						4'd8: shift = 8'd68;
						default: shift = 8'd68;
					endcase
				end
				default: begin
					case(kernel_counter_r)
						4'd0: shift = 8'b11101111;
						4'd3: shift = 8'b11110000;
						4'd6: shift = 8'b11110001;
						4'd1: shift = 8'b11111111;
						4'd4: shift = 8'd0;
						4'd7: shift = 8'd1;
						4'd2: shift = 8'd15;
						4'd5: shift = 8'd16;
						4'd8: shift = 8'd17;
						default: shift = 8'd17;
					endcase
				end
			endcase

			sram_cen1_w = 0;
			sram_wen1_w = 1;
			case(scale_r)
				2'b11: begin
					sram_address1_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
					sram_address2_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
					sram_address3_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
				end
				2'b10: begin
					sram_address1_w = origin_r + {1'd0, kernel_y_r, 5'd0} + {1'b0, kernel_x_r, 1'b0} + shift;
					sram_address2_w = origin_r + {1'd0, kernel_y_r, 5'd0} + {1'b0, kernel_x_r, 1'b0} + shift;
					sram_address3_w = origin_r + {1'd0, kernel_y_r, 5'd0} + {1'b0, kernel_x_r, 1'b0} + shift;
				end
				2'b01: begin
					sram_address1_w = origin_r + shift;
					sram_address2_w = origin_r + shift;
					sram_address3_w = origin_r + shift;
				end
				default: begin
					sram_address1_w = sram_address1_r;
					sram_address2_w = sram_address2_r;
					sram_address3_w = sram_address3_r;
				end
			endcase
			// sram_address1_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
			i_to_sram_data1_w = i_to_sram_data1_r;
			sram_cen2_w = 0;
			sram_wen2_w = 1;
			// sram_address2_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
			i_to_sram_data2_w = i_to_sram_data2_r;
			sram_cen3_w = 0;
			sram_wen3_w = 1;
			// sram_address3_w = origin_r + {2'd0, kernel_y_r, 4'd0} + kernel_x_r + shift;
			i_to_sram_data3_w = i_to_sram_data3_r;
		end
		default: begin
			sram_cen1_w = 1; 
			sram_wen1_w = sram_wen1_r;
			sram_address1_w = sram_address1_r;
			i_to_sram_data1_w = i_to_sram_data1_r;
			sram_cen2_w = 1; 
			sram_wen2_w = sram_wen2_r;
			sram_address2_w = sram_address2_r;
			i_to_sram_data2_w = i_to_sram_data2_r;
			sram_cen3_w = 1; 
			sram_wen3_w = sram_wen3_r;
			sram_address3_w = sram_address3_r;
			i_to_sram_data3_w = i_to_sram_data3_r;
		end	
	endcase
end


// ---------------------------------------------------------------------------
// Sequential Block
// ---------------------------------------------------------------------------
always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		state_r <= S_IDLE;
		o_op_ready_r <= 0;
		o_in_ready_r <= 1;  // *** may not be necessary
		o_out_valid_r <= 0;
		o_out_data_r <= 0;

		sram_cen1_r <= 0; // ***
		sram_wen1_r <= 0;
		sram_address1_r <= 8'd255;
		i_to_sram_data1_r <= 0;

		sram_cen2_r <= 0; // ***
		sram_wen2_r <= 0;
		sram_address2_r <= 8'd255;
		i_to_sram_data2_r <= 0;

		sram_cen3_r <= 0; // ***
		sram_wen3_r <= 0;
		sram_address3_r <= 8'd255;
		i_to_sram_data3_r <= 0;

		origin_r <= 0;
		display_counter_r <= 0;

		scale_r <= 2'b11; // 11 for 16, 10 for 8, 01 for 4

		ycbcr_r <= 0;

		for (i=0; i<9; i=i+1) begin
			shreg1_r[i] <= 0;
			shreg2_r[i] <= 0;
			shreg3_r[i] <= 0;
		end

		kernel_x_r <= 0;
		kernel_y_r <= 0;
		kernel_counter_r <= 0;

		valid_buff1_r <= 0;
		valid_buff2_r <= 0;
		valid_buff3_r <= 0;
		valid_buff4_r <= 0;

		kernel_x_buff1_r <= 0;
		kernel_x_buff2_r <= 0;
		kernel_y_buff1_r <= 0;
		kernel_y_buff2_r <= 0;
		kernel_counter_buff1_r <= 0;
		kernel_counter_buff2_r <= 0;
		origin_buff1_r <= 0;
		origin_buff2_r <= 0;

	end
	else begin
		state_r <= state_w;
		o_op_ready_r <= o_op_ready_w;
		o_in_ready_r <= o_in_ready_w;
		o_out_valid_r <= o_out_valid_w;
		o_out_data_r <= o_out_data_w;

		sram_cen1_r <= sram_cen1_w; // ***
		sram_wen1_r <= sram_wen1_w;
		sram_address1_r <= sram_address1_w;
		i_to_sram_data1_r <= i_to_sram_data1_w;

		sram_cen2_r <= sram_cen2_w; // ***
		sram_wen2_r <= sram_wen2_w;
		sram_address2_r <= sram_address2_w;
		i_to_sram_data2_r <= i_to_sram_data2_w;

		sram_cen3_r <= sram_cen3_w; // ***
		sram_wen3_r <= sram_wen3_w;
		sram_address3_r <= sram_address3_w;
		i_to_sram_data3_r <= i_to_sram_data3_w;

		origin_r <= origin_w;
		display_counter_r <= display_counter_w;

		scale_r <= scale_w;

		ycbcr_r <= ycbcr_w;

		for (i=0; i<9; i=i+1) begin
			shreg1_r[i] <= shreg1_w[i];
			shreg2_r[i] <= shreg2_w[i];
			shreg3_r[i] <= shreg3_w[i];
		end
		kernel_x_r <= kernel_x_w;
		kernel_y_r <= kernel_y_w;
		kernel_counter_r <= kernel_counter_w;

		valid_buff1_r <= valid_buff1_w;
		valid_buff2_r <= valid_buff2_w;
		valid_buff3_r <= valid_buff3_w;
		valid_buff4_r <= valid_buff4_w;

		kernel_x_buff1_r <= kernel_x_buff1_w;
		kernel_x_buff2_r <= kernel_x_buff2_w;
		kernel_y_buff1_r <= kernel_y_buff1_w;
		kernel_y_buff2_r <= kernel_y_buff2_w;
		kernel_counter_buff1_r <= kernel_counter_buff1_w;
		kernel_counter_buff2_r <= kernel_counter_buff2_w;
		origin_buff1_r <= origin_buff1_w;
		origin_buff2_r <= origin_buff2_w;

	end
end


endmodule


// ---------------------------------------------------------------------------
// median filter module
// ---------------------------------------------------------------------------
module median_of_3(
	in1,
	in2,
	in3,
	L,
	M,
	H
);

input [7:0] in1;
input [7:0] in2;
input [7:0] in3;
output [7:0] L;
output [7:0] M;
output [7:0] H;

reg [7:0] L1;
reg [7:0] H1;
reg [7:0] L2;
reg [7:0] L_w;
reg [7:0] M_w;
reg [7:0] H_w;

assign L = L_w;
assign M = M_w;
assign H = H_w;

always @(*) begin
	if (in1 > in2) begin
		H1 = in1;
		L1 = in2;
	end
	else begin
		H1 = in2;
		L1 = in1;
	end
	if (H1 > in3) begin
		H_w = H1;
		L2 = in3;
	end
	else begin
		H_w = in3;
		L2 = H1;
	end
	if (L1 > L2) begin
		M_w = L1;
		L_w = L2;
	end
	else begin
		M_w = L2;
		L_w = L1;
	end
end

endmodule

module median_of_9(
	i_clk,
	i_rst_n,
	in1,
	in2,
	in3,
	in4,
	in5,
	in6,
	in7,
	in8,
	in9,
	median
);

input i_clk;
input i_rst_n;
input [7:0] in1;
input [7:0] in2;
input [7:0] in3;
input [7:0] in4;
input [7:0] in5;
input [7:0] in6;
input [7:0] in7;
input [7:0] in8;
input [7:0] in9;
output [7:0] median;

wire [7:0] L1, M1, H1;
wire [7:0] L2, M2, H2;
wire [7:0] L3, M3, H3;
wire [7:0] L4, M4, H4;
wire [7:0] L5, M5, H5;
wire [7:0] L6, M6, H6;
wire [7:0] L7, M7, H7;

reg [7:0] H4_w, H4_r;
reg [7:0] M5_w, M5_r;
reg [7:0] L6_w, L6_r;

wire [7:0] H4_in, M5_in, L6_in;
assign H4_in = H4_r;
assign M5_in = M5_r;
assign L6_in = L6_r;

assign median = M7;

median_of_3 med1(
	.in1(in1),
	.in2(in2),
	.in3(in3),
	.L(L1),
	.M(M1),
	.H(H1)
);

median_of_3 med2(
	.in1(in4),
	.in2(in5),
	.in3(in6),
	.L(L2),
	.M(M2),
	.H(H2)
);

median_of_3 med3(
	.in1(in7),
	.in2(in8),
	.in3(in9),
	.L(L3),
	.M(M3),
	.H(H3)
);

median_of_3 med4(
	.in1(L1),
	.in2(L2),
	.in3(L3),
	.L(L4),
	.M(M4),
	.H(H4)
);

median_of_3 med5(
	.in1(M1),
	.in2(M2),
	.in3(M3),
	.L(L5),
	.M(M5),
	.H(H5)
);

median_of_3 med6(
	.in1(H1),
	.in2(H2),
	.in3(H3),
	.L(L6),
	.M(M6),
	.H(H6)
);

median_of_3 med7(
	.in1(H4_in),
	.in2(M5_in),
	.in3(L6_in),
	.L(L7),
	.M(M7),
	.H(H7)
);

always @(*) begin
	H4_w = H4;
	M5_w = M5;
	L6_w = L6;
end

always @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		H4_r <= 0;
		M5_r <= 0;
		L6_r <= 0;
	end
	else begin
		H4_r <= H4_w;
		M5_r <= M5_w;
		L6_r <= L6_w;
	end
end


endmodule

// ---------------------------------------------------------------------------
// Census Transform module
// ---------------------------------------------------------------------------
module CT(
	in1,
	in2,
	in3,
	in4,
	in5,
	in6,
	in7,
	in8,
	in9,
	out
);

input [7:0] in1;
input [7:0] in2;
input [7:0] in3;
input [7:0] in4;
input [7:0] in5;
input [7:0] in6;
input [7:0] in7;
input [7:0] in8;
input [7:0] in9;
output [7:0] out;

reg [7:0] out_w;
assign out = out_w;

always @(*) begin
	out_w[7] = (in9>in5);
	out_w[6] = (in6>in5);
	out_w[5] = (in3>in5);
	out_w[4] = (in8>in5);
	out_w[3] = (in2>in5);
	out_w[2] = (in7>in5);
	out_w[1] = (in4>in5);
	out_w[0] = (in1>in5);
end

endmodule
