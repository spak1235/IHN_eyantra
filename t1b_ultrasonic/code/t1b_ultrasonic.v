/*
Module HC_SR04 Ultrasonic Sensor

This module will detect objects present in front of the range, and give the distance in mm.

Input:  clk_50M - 50 MHz clock
        reset   - reset input signal (Use negative reset)
        echo_rx - receive echo from the sensor

Output: trig    - trigger sensor for the sensor
        op     -  output signal to indicate object is present.
        distance_out - distance in mm, if object is present.
*/

// module Declaration
module t1b_ultrasonic(
    input clk_50M, reset, echo_rx,
    output reg trig,
    output op,
    output wire [15:0] distance_out
);

initial begin
    trig = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [5:0] counter_1 = 0;
reg [23:0] counter_2 = 0;
reg [8:0] counter_trigger = 0;
reg [31:0] echo_count = 0;
reg [15:0] dist = 0;
reg echo_meta = 0;
reg echo_sync = 0;
reg echo_prev = 0;
wire echo_rise;
wire echo_fall;
reg init = 0;

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam WRITE = 3'b010;
localparam LOAD = 3'b011;
localparam CLEANUP = 3'b101;

reg [2:0] STATE = IDLE;

always@(posedge clk_50M) begin
	echo_meta <= echo_rx;
	echo_sync <= echo_meta;
	echo_prev <= echo_sync;
	if (~reset) begin
		counter_1 <= 0;
		counter_2 <= 0;
		counter_trigger <= 0;
		echo_count <= 0;
		echo_meta <= 0;
		echo_sync <= 0;
		echo_prev <= 0;
		STATE <= IDLE;
		init <= 0;
		dist <= 0;
	end
	else begin
		case (STATE)
			IDLE: begin
				if (~init) begin
					if (counter_1 == 6'b110010) begin
						counter_1 <= 0;
						init <= 1'b1;
						STATE <= START;
					end
					else begin
						counter_1 <= counter_1 + 1'b1;
						STATE <= IDLE;
					end
				end
				else begin
					STATE <= START;
				end
			end
			START: begin
				if (counter_trigger == 9'd501) begin
					trig <= 1'b0;
					STATE <= WRITE;
					echo_count <= 0;
				end
				else begin
					trig <= 1'b1;
					counter_trigger <= counter_trigger + 1;
				end
							end
			WRITE: begin
				if (counter_2 == 24'h927C0+6'b110100) begin
					counter_2 <= 0;
					STATE <= CLEANUP;
				end
				else begin
					counter_2 <= counter_2 + 1'b1;
					STATE <= WRITE;
					if (echo_rise) begin
						 echo_count <= 0;
					end 
					else if (echo_sync) begin
						 echo_count <= echo_count + 1'b1;
					end 
					else if (echo_fall && echo_count != 0) begin
						 dist <= ((echo_count + 9'd145) / 9'd290)-3'b100;
					end
				end
			end
			CLEANUP: begin
				counter_1 <= 0;
				counter_2 <= 0;
				counter_trigger <= 0;
				echo_count <= 0;
				STATE <= IDLE;
			end
		endcase
	end
end
	
assign distance_out = dist;
assign op = (dist < 70);
assign echo_rise = (echo_sync) & (~echo_prev);
assign echo_fall = (~echo_sync) & (echo_prev);

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
