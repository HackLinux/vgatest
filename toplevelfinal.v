module toplevelfinal(input clk, reset, 

                output [9:0] sprite_x, output [8:0] sprite_y, output [4:0] sprite_sel, 
  output sprite_attr, sprite_pos, sprite_vis, bck_ch_active,
  output font_ch_active, font_clr, font_en,
  output [10:0] font_addr,
  output [3:0] font_data,
  output [1:0] bck, input [1:0] interrupts,
  output [4:0] audioVol, output [3:0] audioSel, output audioEn,
input gun_data, input [7:0] controller_data, output cnt_int, output [3:0] PCD);
  
  parameter D_MEM = "data.txt";
  parameter I_MEM = "hour.txt";
  parameter D_W = 8;
  parameter I_W = 10;
  parameter IA1 = 32'h00000020;  //IO interrupt[0] assigned above
parameter IA2 = 32'h00000020; //IO interrupt[1] assigned above
parameter IA3 = 32'h00000009; //counter0
parameter IA4 = 32'h00000009; //counter1
  wire [31:0] instr_addr;
  wire [31:0] mem_addr;
  wire [31:0] mem_data; 
  wire [31:0] instr_data;
  wire [31:0] wr_data;
  wire [D_W-1:0] data_addr_in;
  wire [I_W-1:0] instr_addr_in;
  wire stallMem;  
	 
  mips #(IA1, IA2, IA3, IA4) proc (clk, reset, instr_addr, instr_data, wr_en, mem_addr, wr_data, mem_data, instr_ack, mem_ack,
  sprite_x,  sprite_y, sprite_sel,
   sprite_attr, sprite_pos, sprite_vis, bck_ch_active,
   font_ch_active, font_clr, font_en,
    font_addr,
    font_data,
   bck, interrupts, audioVol, audioSel, audioEn, stallMem,
   gun_data, controller_data, cnt_int, PCD);
  
  assign data_addr_in = mem_addr[D_W-1:0]; 
  assign instr_addr_in = instr_addr[I_W-1:0];
  
  memoryfinal #(D_W, D_MEM) data (clk, wr_en, data_addr_in, wr_data, mem_data, mem_ack, 1'b0); 

  memoryfinal #(I_W, I_MEM) instr (clk, 1'b0, instr_addr_in, 32'h0000, instr_data, instr_ack, stallMem);
  
endmodule
