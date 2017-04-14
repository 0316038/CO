`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 02/25/2016
// Design Name: 
// Module Name:    alu_Compare 
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
module alu_Compare(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
					equal,
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
					Compare_sel,
               result,     //1 bit result   (output)
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         equal;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;
input [2  :0] Compare_sel;

output        result;
output        cout;

reg           cout;
reg           result;
wire           a, b;
reg           comp_result;

wire result_00, result_01, result_10, result_11;
wire tmp_cout;

assign tmp_cout = ( (a&b) | (a&cin) | (b&cin) );
assign  a = src1 ^ A_invert;
assign  b = src2 ^ B_invert;
assign  result_00 = a&b;
assign  result_01 = a|b;
assign  result_10 = a^b^cin;
assign  result_11 = comp_result;


always@(*) 
begin
      case (Compare_sel)                                      // op         less / equal
		     3'b000:begin comp_result <= less&(~equal); end     // slt          1      0
			  3'b001:begin comp_result <= ~(less|equal); end     // sgt          0      0
			  3'b010:begin comp_result <= less|equal;    end     // sle (except) 0      0                
			  3'b011:begin comp_result <= ~less;         end     // sge          0     1/0    
			  3'b110:begin comp_result <= equal;         end     // seq          0      1
			  3'b100:begin comp_result <= ~equal;        end     // sne         1/0     0
		endcase
end

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