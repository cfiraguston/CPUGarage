module Traffic_lights_controller (
	input clk, reset,
	output reg red, yellow, green);

// Define the 4 states of ther Traffic lights.
localparam red_state = 0;
localparam red_yellow_state = 1;
localparam green_state = 2;
localparam yellow_state = 3;

// Define the clock cycles duration of each state.
localparam red_time = 1;
localparam red_yellow_time = 2;
localparam green_time = 3;
localparam yellow_time = 4;

// Define the state and counter variables.
integer present_state, next_state;
integer present_counter, next_counter;

// Implementation of the asynchronous and the synchronous processes.
always @ (posedge clk or posedge reset) begin
	// Asynchronous process.
	if (reset) begin
		present_state <= red_state;
		present_counter <= 0;
	end
		
	// Synchronous process.
	else begin
		present_state <= next_state;
		present_counter <= next_counter;
	end
end

// Combinatorial logic to set the next state and next counter values.
always begin
	// Default values
	next_state = present_state;
	next_counter = present_counter + 1;
	
	case (present_state)
		red_state: begin
			if (next_counter >= red_time) begin
				next_state = red_yellow_state;
				next_counter = 0;
			end
		end
		
		red_yellow_state: begin
			if (next_counter >= red_yellow_time) begin
				next_state = green_state;
				next_counter = 0;
			end
		end
		
		green_state: begin
			if (next_counter >= green_time) begin
				next_state = yellow_state;
				next_counter = 0;
			end
		end
		
		yellow_state: begin
			if (next_counter >= yellow_time) begin
				next_state = red_state;
				next_counter = 0;
			end
		end
	endcase
end

// Combinatorical logic to set the output lights.
always begin
	// Default values.
	red = 1'b0;
	yellow = 1'b0;
	green = 1'b0;
	
	case (present_state)
		red_state: begin
			red = 1'b1;
		end
		
		red_yellow_state: begin
			red = 1'b1;
			yellow = 1'b1;
		end
		
		green_state: begin
			green = 1'b1;
		end
		
		yellow_state: begin
			yellow = 1'b1;
		end
	endcase
end

endmodule
