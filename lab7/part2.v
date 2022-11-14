


//
// This is the template for Part 2 of Lab 7.

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire oPlot;       // Pixel draw enable
	wire ld_x, ld_yc, enable;
	wire [3:0] counter;
   //
   // Your code goes here
   //
	control c0 (.iResetn(iResetn),.iClock(iClock),.iLoadX(iLoadX),.iPlotBox(iPlotBox),.counter(counter),.ld_x(ld_x),.ld_yc(ld_yc),.enable(enable),.oPlot(oPlot));
	datapath d0 (.iResetn(iResetn), .iClock(iClock), .iXY_Coord(iXY_Coord), .iColour(iColour), .ld_x(ld_x), .ld_yc(ld_yc), .enable(enable), .counter(counter), .oX(oX), .oY(oY), .oColour(oColour));
	
	
   
endmodule // part2

module control(iResetn, iClock, iLoadX, iPlotBox, counter, ld_x, ld_yc, enable, oPlot);
	input iResetn, iClock, iLoadX, iPlotBox;
	input [3:0] counter;
	output reg ld_x, ld_yc, enable, oPlot;
	reg [2:0] current_state, next_state;

	localparam S_LOAD_X = 3'd0,
				  S_LOAD_X_WAIT = 3'd1,
				  S_LOAD_Y = 3'd2,
				  S_LOAD_Y_WAIT = 3'd3,
				  S_DRAW = 3'd4,
				  S_DRAW_WAIT = 3'd5;
	//reset condition- active low			  
	always@(posedge iClock)
	begin
		if(!iResetn)
			current_state <= S_LOAD_X;
		else 
			current_state <= next_state;
	end
	//enable signals for datapath go here
	always@(*)
		begin				//begin: all signals are 0
			ld_x = 0;
			ld_yc = 0;
			enable = 0;
			case(current_state)
				S_LOAD_X:
				begin
					ld_x = 1'd1;
					oPlot = 0;
				end
				S_LOAD_Y: 
					begin
						ld_yc = 1'd1;
					end
				S_DRAW:
					begin
						enable = 1'd1;
						oPlot = 1'd1;
					end
			endcase
		end
				  
	always@(*)
		begin
			case(current_state)
				S_LOAD_X: next_state = iLoadX ? S_LOAD_X_WAIT : S_LOAD_X; 		//wait until x is loaded or proceed
				S_LOAD_X_WAIT: next_state = iLoadX ? S_LOAD_X_WAIT : S_LOAD_Y;//wait until x is released or proceed to y load
				S_LOAD_Y: next_state = iPlotBox ? S_LOAD_Y_WAIT : S_LOAD_Y;		//wait until y & color are loaded else proceed
				S_LOAD_Y_WAIT: next_state = iPlotBox ? S_LOAD_Y_WAIT : S_DRAW;
				S_DRAW : begin
					if (counter == 4'd15)		//when counter has fully counted proceed to next stage	
						next_state = S_DRAW_WAIT;
					else 
						next_state = S_DRAW;		//continue counting until counter has fully counted
					end
				S_DRAW_WAIT: next_state = S_LOAD_X;		
				default : next_state = S_LOAD_X;		//by default should be at start to avoid latches
			endcase
		end	
endmodule

module datapath (iResetn, iClock, iXY_Coord, iColour, ld_x, ld_yc, enable, counter, oX, oY, oColour);
	input iResetn, iClock, enable, ld_x, ld_yc;
	input [6:0] iXY_Coord;
	input [2:0] iColour;
	output reg [3:0] counter;
	output reg [7:0] oX;
	output reg [6:0] oY;
	output reg [2:0] oColour;
	reg [7:0] xPosition;
	reg [6:0] yPosition;
	reg [2:0] regcolor;
	//4bitcounter
	always@(posedge iClock)
	begin
		if (!iResetn)
			counter <= 4'b0;
		else if (counter == 4'd15)
			counter <= 4'd0;
		else if (enable)
			counter <= counter + 1;	
	end
	//loads in the offset values in this always block
	always@(posedge iClock)
		begin 
			if (iResetn==0)		//active low reset: all output values are 0
				begin
					oX <= 0;
					oY <= 0;
					oColour <= 0;
				end
			else 
				begin 
					if (ld_x)
						begin
							xPosition <= {1'b0, iXY_Coord};		//loads the value of x coordinate into current xPosition
						end
					else if (ld_yc)
						begin
							yPosition <= iXY_Coord;		//loads the value of x coordinate into current xPosition	
							regcolor <= iColour;
						end
					else if(enable)		//enable for counter is on: start incrementing x and y values
						begin
							oX <= xPosition + counter[1:0];		//LSB and LSB+1 of the 4 digit counter into oX
							oY <= yPosition + counter[3:2];		//MSB and MSB-1 of the 4 digit counter into oY
							oColour <= regcolor;			//load colour into output
						end
				end
			end
endmodule
