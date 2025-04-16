`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 10:27:43 PM
// Design Name: 
// Module Name: debounce
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

module debounce(
    input clk,   
    input button_input,
    output button_output
    );
    
    reg r1, r2, r3;
    
    always @(posedge clk) begin
        r1 <= button_input;
        r2 <= r1;
        r3 <= r2;
    end
    
    assign button_output = r3;
    
endmodule