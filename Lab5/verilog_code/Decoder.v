//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0316056_½²©gªÚ 0316038_¥Û½@±Û
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
   instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	BranchType_o,
	SinExt_o,
	MemToReg_o,
	Jump_o,
	MemRead_o,
	MemWrite_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output [2-1:0] BranchType_o;
output         SinExt_o;
output [2-1:0]	MemToReg_o;
output      	Jump_o;
output      	MemRead_o;
output      	MemWrite_o;
//Internal Signals
reg            RegWrite_o;
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegDst_o;
reg            Branch_o;
reg    [2-1:0] BranchType_o;
reg            SinExt_o;
reg    [2-1:0]	MemToReg_o; //0:ALU_result 1:ReadData 2:instruction
reg         	Jump_o;
reg         	MemRead_o;
reg         	MemWrite_o;

//Parameter


//Main function
always @(*) begin
    case (instr_op_i)
		  6'b100011: begin //lw
				RegWrite_o = 1;
				ALU_op_o = 3'b000;
				ALUSrc_o = 1;
				RegDst_o = 0;
				Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 1;
				MemToReg_o = 2'b01;
				Jump_o = 0;
				MemRead_o = 1;
				MemWrite_o = 0;
		  end
		  6'b101011: begin //sw
				RegWrite_o = 0;
				ALU_op_o = 3'b000;
				ALUSrc_o = 1;
				RegDst_o = 1'bx;
				Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 1;
				MemToReg_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 1;
		  end
        6'b000000: begin // R-type
            RegWrite_o = 1;
				ALU_op_o = 3'b010;
            ALUSrc_o = 0;
            RegDst_o = 1;
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 1;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end
		  6'b000100: begin // beq
            RegWrite_o = 0;
				ALU_op_o = 3'b001;
            ALUSrc_o = 0;
            RegDst_o = 1'bx; 
            Branch_o = 1;
				BranchType_o = 2'b00;
				SinExt_o = 1;
				MemToReg_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end
        6'b000101: begin // bnez
            RegWrite_o = 0;
            ALU_op_o = 3'b001;
            ALUSrc_o = 0;
            RegDst_o = 0;
            Branch_o = 1;
				BranchType_o = 2'b11;
				SinExt_o = 1;
				MemToReg_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end
        6'b001000: begin // addi
            RegWrite_o = 1;            
				ALU_op_o = 3'b000;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'b00;				
				SinExt_o = 1;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end 
        6'b001010: begin // slti
            RegWrite_o = 1;           
				ALU_op_o = 3'b100;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 1;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end
        6'b001111: begin // lui
            RegWrite_o = 1;
				ALU_op_o = 3'b101;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 0;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end
        6'b001101: begin // ori
            RegWrite_o = 1;
				ALU_op_o = 3'b110;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 0;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end
		  /*6'b000010: begin //srl
				RegWrite_o = 1;
				ALU_op_o = 3'b010;
            ALUSrc_o = 0;
            RegDst_o = 1;
            Branch_o = 0;
				SinExt_o = 1;
		  end*/
		  /*6'b000110: begin //srlv
				RegWrite_o = 1;
				ALU_op_o = 3'b010;
            ALUSrc_o = 0;
            RegDst_o = 1;
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 1;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
		  end*/
		  6'b000010: begin //jump
				RegWrite_o = 0;
				ALU_op_o = 3'bxxx;
            ALUSrc_o = 0;
            RegDst_o = 1'b0; 
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 0;
				MemToReg_o = 2'bxx;
				Jump_o = 1'b1;
				MemRead_o = 0;
				MemWrite_o = 0;
		  end
		  6'b000011: begin //jal
				RegWrite_o = 0;
				ALU_op_o = 3'bxxx;
            ALUSrc_o = 0;
            RegDst_o = 1'b0; 
            Branch_o = 0;
				BranchType_o = 2'b00;
				SinExt_o = 0;
				MemToReg_o = 2'bxx;
				Jump_o = 1'b1;
				MemRead_o = 0;
				MemWrite_o = 0;
		  end
		  6'b000110: begin //blt
				RegWrite_o = 0;
				ALU_op_o = 3'b001;
            ALUSrc_o = 0;
            RegDst_o = 1'bx; 
            Branch_o = 1'b1;
				BranchType_o = 2'b10;
				SinExt_o = 1;
				MemToReg_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
		  end
		  6'b000001: begin //bgez
				RegWrite_o = 0;
				ALU_op_o = 3'b111;
            ALUSrc_o = 0;
            RegDst_o = 1'bx; 
            Branch_o = 1'b1;
				BranchType_o = 2'b01;
				SinExt_o = 1;
				MemToReg_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
		  end
		  6'b001111: begin // li
            RegWrite_o = 1;            
				ALU_op_o = 3'b000;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'b00;				
				SinExt_o = 1;
				MemToReg_o = 2'b00;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
        end 
        default: begin
            RegWrite_o = 1'bx;
				ALU_op_o = 3'bxxx;
            ALUSrc_o = 1'bx;
            RegDst_o = 1'bx;
            BranchType_o = 2'bxx;
				SinExt_o = 1'bx;
				MemToReg_o = 2'bxx;
				Jump_o = 1'bx;
				MemRead_o = 1'bx;
				MemWrite_o = 1'bx;
        end
    endcase
end
endmodule





                    
                    