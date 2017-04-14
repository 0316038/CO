`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:24 05/15/2016 
// Design Name: 	0316056_½²©gªÚ 0316038_¥Û½@±Û
// Module Name:    Mux_4to1 
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
module Mux_4to1(
		data0_i,
		data1_i,
		data2_i,
		data3_i,
		select_i,
		data_o
    );
input    data0_i;          
input    data1_i;
input    data2_i;
input    data3_i;
input   [1:0]  select_i;
output   data_o; 

//Internal Signals
reg     data_o;

//Main function
always@(*)  begin
	if(select_i == 0)begin   
		data_o <= data0_i;
	end else if(select_i == 1)begin
		data_o <= data1_i;
	end else if(select_i == 2)begin
		data_o <= data2_i;
	end else if(select_i == 3) begin
		data_o <= data3_i;
	end
end
endmodule

