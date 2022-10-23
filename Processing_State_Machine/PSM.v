/* Processing State Machine (PSM).
	Developed by Cfir Aguston.
	Implements a state machine as follows:
					  _____________
	Clock		--->|					|	---> Ready
	Reset		--->|					|	---> Op1
	Din1[8]	--->|		PSM		|	---> Op2
	Din2[8]	--->|					|	---> Op3
	Start		--->|_____________|	---> Dout[8]
	
	State machine is as follows:
	
	Reset
		 \_
		   |
		  \|/      Start
			Idle------------>Op1
			 /|\              |
           |               | X cycles
 Z Cycles  |               |
			  |              \|/
			Op3<-------------Op2
	            Y cycles
*/				
module PSM (
	input Clock,
	input ResetN,
	input [7:0] Din1,
	input [7:0] Din2,
	input Start,
	output reg Ready,
	output reg Op1,
	output reg Op2,
	output reg Op3,
	output reg [7:0] Dout
);

// Define PSM 4 states.
localparam idle_state = 0;
localparam op1_state = 1;
localparam op2_state = 2;
localparam op3_state = 3;

// Define the clock cycles duration of each state.
/* ID = 0xxx7xxx5
	     ^   ^   ^
		  |   |   |
		  X   Y   Z */
// Clock frequency is 50MHz.
// 10 cycles = 1 seconds.
localparam op1_time = 50_000_000;	// X = 10 cycles = 1000ms.
localparam op2_time = 35_000_000;	// Y = 7 cycles = 700ms.
localparam op3_time = 25_000_000;	// Z = 5 cycles = 500ms.

//localparam op1_time = 100;
//localparam op2_time = 70;
//localparam op3_time = 50;

// Define the state and counter variables.
integer present_state, next_state;
integer present_counter, next_counter;

localparam PSM_not_ready = 1'b0;
localparam PSM_ready = 1'b1;

// Define sampled values for Din1 and Din2.
reg [7:0] sample1, sample2;

// Implementation of the asynchronous and the synchronous processes.
always @ (posedge Clock or negedge ResetN) begin
	// Asynchronous process.
	if (!ResetN) begin
		present_state <= idle_state;
		present_counter <= 0;
		sample1 <= 8'b0;
		sample2 <= 8'b0;
	end

	// Synchronous process.
	else begin
		present_state = next_state;
		present_counter = next_counter;
		if (present_state == idle_state) begin
			if (Start) begin
				present_state <= op1_state;
				present_counter <= 0;
				sample1 <= Din1;
				sample2 <= Din2;
			end
		end
	end
end

// Combinatorial logic to set the next state and next counter values.
always begin
	// Default values
	next_state = present_state;
	next_counter = present_counter + 1;
	
	case (present_state)
		idle_state: begin
			next_state = idle_state;
			next_counter = 0;
		end
		
		op1_state: begin
			if (next_counter >= op1_time) begin
				next_state = op2_state;
				next_counter = 0;
			end
		end
		
		op2_state: begin
			if (next_counter >= op2_time) begin
				next_state = op3_state;
				next_counter = 0;
			end
		end
		
		op3_state: begin
			if (next_counter >= op3_time) begin
				next_state = idle_state;
				next_counter = 0;
			end
		end
		
		default: begin
			// This case should neve be activated. If so go to idle state and wait for Start.
			next_state = idle_state;
			next_counter = 0;
		end
	endcase
end

// Combinatorical logic to set PSM outputs.
always begin
	// Set default values.
	Ready = PSM_ready;
	Op1 = 1'b0;
	Op2 = 1'b0;
	Op3 = 1'b0;
	Dout = 8'b0;
	
	case (present_state)
		idle_state: begin
			// Do nothing - all default values are initialized.
		end
		
		op1_state: begin
			Ready = PSM_not_ready;
			Op1 = 1'b1;
			Dout = sample1 | sample2;
		end
		
		op2_state: begin
			Ready = PSM_not_ready;
			Op2 = 1'b1;
			Dout = sample1 ^ sample2;
		end
			
		op3_state: begin
			Ready = PSM_not_ready;
			Op3 = 1'b1;
			Dout = ~((~sample1) & sample2);
		end
		
		default: begin
			// Do nothing - all default values are initialized.
		end
	endcase
	
end

endmodule
