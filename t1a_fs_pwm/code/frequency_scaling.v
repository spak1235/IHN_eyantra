module frequency_scaling (
    input clk_50M,
    output reg clk_3125KHz
);

initial begin
    clk_3125KHz = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [3:0] dummy_clk = 4'b0000;

always@(posedge clk_50M) begin
	if (dummy_clk == 4'b1111) begin
		dummy_clk <= 0;
	end
	else begin
		dummy_clk <= dummy_clk + 1'b1;
	end
	if (dummy_clk > 4'b0111) begin
		clk_3125KHz <= 1'b0;
	end
	else begin
		clk_3125KHz <= 1'b1;
	end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
