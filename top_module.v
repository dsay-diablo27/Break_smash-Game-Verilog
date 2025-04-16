`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 10:26:24 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk_100MHz,      
    input reset,            
    input left,               
    input  right,            
    output hsync,         
    output vsync,           
    output [11:0] rgb      
    );
    
    wire w_reset, REAL_left, REAL_right, w_vid_on, w_p_tick;
    wire [9:0] REAL_x, REAL_y;
    reg [11:0] REAL_rgb_reg;
    wire [11:0] REAL_rgb_next;
    
    vga_controller vga(.clk_100MHz(clk_100MHz), .reset(w_reset), .video_on(w_vid_on),
                       .hsync(hsync), .vsync(vsync), .p_tick(w_p_tick), .x(REAL_x), .y(REAL_y));
                       
    mechanism model(.clk(clk_100MHz), .reset(w_reset), .left(REAL_left), .right(REAL_right), 
                 .video_on(w_vid_on), .x(REAL_x), .y(REAL_y), .rgb(REAL_rgb_next));
                 
    debounce Reset(.clk(clk_100MHz), .button_input(reset), .button_output(w_reset));
    debounce Left(.clk(clk_100MHz), .button_input(left), .button_output(REAL_left));
    debounce Right(.clk(clk_100MHz), .button_input(right), .button_output(REAL_right));
    
   
    always @(posedge clk_100MHz)
        if(w_p_tick)
            REAL_rgb_reg <=  REAL_rgb_next;
            
    assign rgb = REAL_rgb_reg;
    
endmodule
