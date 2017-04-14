//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:     0316056_½²©gªÚ 0316038_¥Û½@±Û 
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
			 Jr_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
output     Jr_o;     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg		   Jr_o;
//Parameter

       
//Select exact operation
always @ (*) begin
  case (ALUOp_i)
    3'b000: ALUCtrl_o <= 4'b0010; //add :for lw,sw,addi
    3'b001: ALUCtrl_o <= 4'b0110; //sub :for beq
    3'b010: 
      case (funct_i)//R-type
          6'b100000: ALUCtrl_o <= 4'b0010; //R-type Add
          6'b100010: ALUCtrl_o <= 4'b0110; //R-type Subtract
          6'b100100: ALUCtrl_o <= 4'b0000; //R-type AND
          6'b100101: ALUCtrl_o <= 4'b0001; //R-type OR
          6'b101010: ALUCtrl_o <= 4'b0111; //R-type slt
          6'b000010: ALUCtrl_o <= 4'b1001; // SRL
          6'b000110: ALUCtrl_o <= 4'b1011; // SRL V
			 6'b011000: ALUCtrl_o <= 4'b1000; //mult
			 6'b001000: ALUCtrl_o <= 4'b0011; //jr
          default:   ALUCtrl_o <= 4'bxxxx;
      endcase
    3'b100: ALUCtrl_o <= 4'b0111;	//slti
	 3'b101: ALUCtrl_o <= 4'b1111;		//lui
    3'b110: ALUCtrl_o <= 4'b0001;	//ori
	 3'b111: ALUCtrl_o <= 4'b0001;	//bgez
    default: ALUCtrl_o <= 4'bxxxx;
  endcase
end
always@(*)  begin
	if(ALUOp_i==3'b010 && funct_i==6'b001000)begin
		Jr_o <= 1;
	end 
	else Jr_o <= 0;
end
endmodule     





                    
                    