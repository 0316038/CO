//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0316056_½²©gªÚ 0316038_¥Û½@±Û
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
   src1_i,
	src2_i,
	ctrl_i,
	srl_i,
	result_o,
	zero_o,
	jr_addr
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [5-1:0]   srl_i;
output [32-1:0]	 result_o;
output           zero_o;
output [32-1:0]  jr_addr;
//Internal signals
reg    [32-1:0]  result_o;
reg    [32-1:0]  srl_tmp;
reg     [32-1:0]  jr_addr;
integer          x;
wire             zero_o;
wire   [32-1:0]  src2_complement;
wire   [32-1:0]  and_w, or_w, add_w, sub_w, slt_w, beq_w, srl_w, srlv_w, lui_w, mult_w;

integer i;
//Parameter
assign zero_o = (result_o==0)?1:0;
assign src2_complement = ~(src2_i) + 1;
assign and_w = src1_i & src2_i;
assign or_w  = src1_i | src2_i;
assign add_w = src1_i + src2_i;
assign sub_w = src1_i + src2_complement;
assign slt_w = (sub_w[31]==1'b1)? 32'b1 :32'b0;
assign beq_w = ~(src1_i | src2_i);
assign srl_w = srl_tmp;
assign srlv_w = src2_i>>src1_i;
assign lui_w = src2_i<<16;
assign mult_w = src1_i * src2_i;
//Main function
always @(*) begin
   case(ctrl_i)
	   4'b0000: result_o <= and_w; //AND
		4'b0001: result_o <= or_w;  //OR
		4'b0010: result_o <= add_w; //ADD
		4'b0110: result_o <= sub_w; //SUBTRACT
		4'b0111: result_o <= slt_w; //SLT
		4'b1000: result_o <= mult_w; //MULT
		4'b1001: result_o <= src2_i>>srl_i; //SRL
		4'b1011: result_o <= srlv_w; //SRLV
		4'b1100: result_o <= beq_w; //NOR
		4'b1111: result_o <= {src2_i[15:0],16'b0}; //LUI
		
		default: result_o <= 32'b0;
	endcase
end
always@(*)  begin
	if(ctrl_i==4'b0011)begin  //Jr
		jr_addr <= src1_i;
end 
end
endmodule
