`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 02/25/2016
// Design Name: 
// Module Name:    alu_top 
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
//0316056_0316038
module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           cout;
reg           result;
wire           a, b;

wire result_00, result_01, result_10, result_11;
wire tmp_cout;

assign tmp_cout = ( (a&b) | (a&cin) | (b&cin) );
assign  a = src1 ^ A_invert;
assign  b = src2 ^ B_invert;
assign  result_00 = a&b;
assign  result_01 = a|b;
assign  result_10 = a^b^cin;
assign  result_11 = less;

always@( * )
begin
  cout <= tmp_cout;
  case (operation)
	  4'b00: begin result <= result_00; end 
	  4'b01: begin result <= result_01; end
	  4'b10: begin result <= result_10; end   
	  4'b11: begin result <= result_11; end      
	endcase
end

endmodule
