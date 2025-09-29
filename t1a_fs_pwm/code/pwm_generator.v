
module pwm_generator(
    input clk_3125KHz,
    input [3:0] duty_cycle,
    output reg clk_195KHz, pwm_signal
);

initial begin
    clk_195KHz = 0; pwm_signal = 1;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [3:0] dummy_clk = 4'b0000;

always@(posedge clk_3125KHz) begin
	if (dummy_clk >= duty_cycle) begin
		pwm_signal <= 1'b0;
	end
	else begin
		pwm_signal <= 1'b1;
	end
	
	if (dummy_clk == 4'b1111) begin
		dummy_clk <= 0;
	end
	else begin
		dummy_clk <= dummy_clk + 1'b1;
	end
	
	if (dummy_clk > 4'b0111) begin
		clk_195KHz <= 1'b0;
	end
	
	else begin
		clk_195KHz <= 1'b1;
	end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
