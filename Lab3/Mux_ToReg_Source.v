`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:47:07 05/15/2016 
// Design Name: 		0316056_½²©gªÚ 0316038_¥Û½@±Û
// Module Name:    Mux_ToReg_Source 
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
module Mux_ToReg_Source(
		data0_i,
		data1_i,
		data2_i,
		select_i,
		data_o
    );
//I/O ports               
input   [31:0] data0_i;          
input   [31:0] data1_i;
input   [31:0] data2_i;
input   [1:0]  select_i;
output  [31:0] data_o; 

//Internal Signals
reg     [31:0] data_o;

//Main function
always@(*)  begin
	if(select_i == 0)begin   
		data_o <= data0_i;
	end else if(select_i == 1)begin
		data_o <= data1_i;
	end else begin
		data_o <= data2_i;
	end
end
endmodule
