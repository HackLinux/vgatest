`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:13:32 04/08/2010 
// Design Name: 
// Module Name:    vga_driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_driver(clk_100mhz, rst, clk_25mhz, blank, comp_sync, hsync, vsync, pixel_r, pixel_g, pixel_b);
    input clk_100mhz;
    input rst;
	 output clk_25mhz;
	 output blank;
	 output comp_sync;
    output hsync;
    output vsync;
    output [7:0] pixel_r;
    output [7:0] pixel_g;
    output [7:0] pixel_b;

	 wire load_pos, bchange_active, fchange_active, fwenable;
	 wire [1:0] background_sel;
	 reg [9:0] x;
	 reg [8:0] y;
	 wire [3:0] fwdata;
	 wire [10:0] fwaddr;
	 reg next_load_att, load_att, next_visable, visable;
	 reg [4:0] sprite_sel, next_sprite_sel;
	 reg [24:0] next_counter, counter;
	 reg [1:0] state, next_state;
	 
	 vgamult vga(clk_100mhz, rst, clk_25mhz, blank, comp_sync, hsync, vsync, pixel_r, pixel_g, pixel_b, x, y, visable, load_pos, load_att, sprite_sel, 
				bchange_active, background_sel, fchange_active, fwdata, fwaddr, fwenable, clk);
					
	 always@(posedge clk)begin
	  if(rst) begin
		counter <= 0;
		state <= 0;
		sprite_sel = 5'b00010;
		visable = 1'b0;
		load_att = 1'b0;
		end
	  else begin
		counter <= next_counter;
		state <= next_state;
		sprite_sel = next_sprite_sel;
		visable = next_visable;
		load_att = next_load_att;
		end
	end
		
	 always@(counter, state) begin
	  next_sprite_sel = sprite_sel;
		next_visable = 1'b0;
		next_load_att = 1'b0;
		next_state = 2'b00;
		next_counter = counter + 1;
		x[0] = 1'b0;
		y[0] = 1'b0;
	 
		case(state)
			2'b00 : begin
					next_sprite_sel = 5'b00010;
					next_visable = 1'b1;
					next_load_att = 1'b1;
					next_state = 2'b01;
			end
			
			2'b01 : begin
					if(counter == 25'd25000000) begin
						next_state = 2'b10;
						next_load_att = 1'b1;
					end
						
					else
						next_state = 2'b01;
				end
				
			2'b10 : begin
					next_sprite_sel = {sprite_sel[4:1], ~sprite_sel[0]};
					next_visable = 1'b1;
					next_load_att = 1'b1;
					next_state = 2'b01;
					next_counter = 0;
					end
		endcase
	end
endmodule
