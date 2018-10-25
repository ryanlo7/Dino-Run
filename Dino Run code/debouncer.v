module debouncer(button, clk, button_state);
	input clk;
	input button;
	
	output button_state;
	
	reg[7:0] counter;
	reg bounce_state_temp;
	
	always @(posedge clk) 
	begin
		if (button == 0) begin
			bounce_state_temp <= 0;
			counter <= 0;
		end
		else 
		begin
			counter <= counter + 1'b1;
			if (counter == 8'hff)
			begin
				counter <= 0;
				bounce_state_temp <= ~button_state;
			end
		end
	end
	
	assign button_state = bounce_state_temp;
endmodule 