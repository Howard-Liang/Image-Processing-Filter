`timescale 1ns/100ps
`define CYCLE       9.0     // CLK period.
`define HCYCLE      (`CYCLE/2)
`define MAX_CYCLE   100000
`define RST_DELAY   2


`ifdef tb1
    `define INFILE "./pattern/indata1.dat"
    `define OPFILE "./pattern/opmode1.dat"
    `define GOLDEN "./pattern/golden1.dat"
    `define GOLDEN_LEN 248
`elsif tb2
    `define INFILE "./pattern/indata2.dat"
    `define OPFILE "./pattern/opmode2.dat"
    `define GOLDEN "./pattern/golden2.dat"
    `define GOLDEN_LEN 320
`elsif tb3
    `define INFILE "./pattern/indata3.dat"
    `define OPFILE "./pattern/opmode3.dat"
    `define GOLDEN "./pattern/golden3.dat"
    `define GOLDEN_LEN 164
`elsif hidden
    `define INFILE "./pattern/indata_hidden.dat"
    `define OPFILE "./pattern/opmode_hidden.dat"
    `define GOLDEN "./pattern/golden_hidden.dat"
    `define GOLDEN_LEN 2149
`else
    `define INFILE "./pattern/indata0.dat"
    `define OPFILE "./pattern/opmode0.dat"
    `define GOLDEN "./pattern/golden0.dat"
    `define GOLDEN_LEN 320
`endif

`define SDFFILE "./ipdc_pr.sdf"  // Modify your sdf file name


module testbed;

reg clk, rst_n;
reg        op_valid;
reg [ 3:0] op_mode;
wire        op_ready;
reg        in_valid;
reg [23:0] in_data;
wire        in_ready;
wire        out_valid;
wire [23:0] out_data;

reg [23:0] indata_mem [ 0:255];
reg [ 3:0] opmode_mem [ 0:260];
reg [23:0] golden_mem [ 0:2560];

// For gate-level simulation only
`ifdef SDF
    initial $sdf_annotate(`SDFFILE, u_ipdc);
    initial #1 $display("SDF File %s were used for this simulation.", `SDFFILE);
`endif

// Write out waveform file
initial begin
  $fsdbDumpfile("ipdc.fsdb");
  $fsdbDumpvars(3, "+mda");
end


ipdc u_ipdc (
	.i_clk(clk),
	.i_rst_n(rst_n),
	.i_op_valid(op_valid),
	.i_op_mode(op_mode),
    .o_op_ready(op_ready),
	.i_in_valid(in_valid),
	.i_in_data(in_data),
	.o_in_ready(in_ready),
	.o_out_valid(out_valid),
	.o_out_data(out_data)
);

// Read in test pattern and golden pattern
initial $readmemb(`INFILE, indata_mem);
initial $readmemb(`OPFILE, opmode_mem);
initial $readmemb(`GOLDEN, golden_mem);

// Clock generation
initial clk = 1'b0;
always begin #(`CYCLE/2) clk = ~clk; end

// Reset generation
initial begin
    rst_n = 1; # (               0.25 * `CYCLE);
    rst_n = 0; # ((`RST_DELAY - 0.25) * `CYCLE);
    rst_n = 1; # (         `MAX_CYCLE * `CYCLE);
    $display("Error! Runtime exceeded!");
    $finish;
end

integer err_cnt = 0;
integer indata_idx = -1;    // match timing
integer golden_idx = 0;
integer opmode_idx = 0;


initial begin
    op_valid = 0;
    op_mode = 0;
    in_valid = 0;
    in_data = 0;
    wait(op_ready == 1);
    @(negedge clk);
    #(`CYCLE);
    op_valid = 1;
    op_mode = opmode_mem[opmode_idx];
    opmode_idx = opmode_idx + 1;
    #(`CYCLE);
    op_valid = 0;
    op_mode = 0;
    in_valid = 1;
    while (indata_idx < 255) begin      // 256 - 1
        @(negedge clk);
        if (in_ready) begin
            indata_idx = indata_idx + 1;
        end
        else begin
            indata_idx = indata_idx;
        end
        in_data = indata_mem[indata_idx];
    end
    #(`CYCLE);
    in_data = 0;
    in_valid = 0;
    while (opmode_idx < 257) begin // 21
        wait(op_ready == 1);
        @(negedge clk);
        #(`CYCLE);
        op_valid = 1;
        op_mode = opmode_mem[opmode_idx];
        opmode_idx = opmode_idx + 1;
        #(`CYCLE);
        op_valid = 0;
        op_mode = 0;
    end
end


always @(negedge clk) begin
    if(golden_idx==`GOLDEN_LEN) begin
        if(err_cnt==0) begin
            $display("\n");
            $display("                      ****************************              ");
            $display("                      **                        **        /|__/|");
            $display("                      **  Congratulations !!    **      / O,O  |");
            $display("                      **                        **    /_____   |");
            $display("                      **  You pass this test!!  **   /^ ^ ^ \\  |");
            $display("                      **                        **  |^ ^ ^ ^ |w|");
            $display("                      ****************************   \\m___m__|_|");
            $display("\n");
            $finish;
        end
        else begin
            $display("\n");
            $display("                      ****************************              ");
            $display("                      **      *       *         **        /|__/|");
            $display("                      **        *   *           **      / O,O  |");
            $display("                      **          *             **    /_____   |");
            $display("                      **        *   *           **   /^ ^ ^ \\  |");
            $display("                      **      *       *         **  |^ ^ ^ ^ |w|");
            $display("                      ****************************   \\m___m__|_|");
            $display("\n");
            $display("There are %d errors in your results\n", err_cnt);
            $finish;      
        end
    end
    else begin
        if (out_valid===1) begin
            if (out_data == golden_mem[golden_idx]) begin
                //$display("number %d",golden_idx);
                err_cnt = err_cnt;
            end
            else begin
                err_cnt = err_cnt + 1;
                $display(" Error!", " golden is: %h", golden_mem[golden_idx], " Your: %h", out_data);
            end
        golden_idx = golden_idx + 1;
        end
    end
end

endmodule
