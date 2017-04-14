//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0316056_½²©gªÚ 0316038_¥Û½@±Û
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
      clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_in_i, pc_out_o,add_1_o,add_2_o,instr_o,RSdata_o,RTdata_o,Sign_Extend_o,Mux_ALU_o,ALU_res,shift_left_two_o;
wire [5-1:0]  RDaddr_i;
wire [3-1:0]  ALU_op_o;
wire [4-1:0]  ALUCtrl_o;
wire           RegDst_o,RegWrite_o,ALUSrc_o,Branch_o,zero_o,cout,overflow,SinExt,Branch_beq_o,Branch_bne_o,branch_mux;
//Greate componentes
ProgramCounter PC(
       .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in_i) ,   
	    .pc_out_o(pc_out_o) 
	    );
	
Adder Adder1(
       .src1_i(pc_out_o),     
	    .src2_i(32'd4),     
	    .sum_o(add_1_o)    
	    );
	
Instr_Memory IM(
       .pc_addr_i(pc_out_o),  
	    .instr_o(instr_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst_o),
        .data_o(RDaddr_i)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	     .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(RDaddr_i) ,  
        .RDdata_i(ALU_res)  , 
        .RegWrite_i (RegWrite_o),
        .RSdata_o(RSdata_o) ,  
        .RTdata_o(RTdata_o)   
        );
	
Decoder Decoder(
       .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite_o), 
	    .ALU_op_o(ALU_op_o),   
	    .ALUSrc_o(ALUSrc_o),   
	    .RegDst_o(RegDst_o),   
		 .Branch_bne_o(Branch_bne_o),
		 .Branch_beq_o(Branch_beq_o),
		 .SinExt_o(SinExt)		 
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]), 		  
        .ALUOp_i(ALU_op_o),   
        .ALUCtrl_o(ALUCtrl_o) 
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
		  .select_i(SinExt),
        .data_o(Sign_Extend_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata_o),
        .data1_i(Sign_Extend_o),
        .select_i(ALUSrc_o),
        .data_o(Mux_ALU_o)
        );	
		 
ALU ALU(
		 .src1_i(RSdata_o),
	    .src2_i(Mux_ALU_o),
	    .ctrl_i(ALUCtrl_o),
		 .srl_i(instr_o[10:6]),
	    .result_o(ALU_res),
		 .zero_o(zero_o)
	    );
		
Adder Adder2(
       .src1_i(add_1_o),     
	    .src2_i(shift_left_two_o),     
	    .sum_o(add_2_o)       
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(Sign_Extend_o),
        .data_o(shift_left_two_o)
        ); 		
assign branch_mux = (Branch_bne_o&(~Branch_beq_o)&(~zero_o)|(~Branch_bne_o)&Branch_beq_o&zero_o);
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(add_1_o),
        .data1_i(add_2_o),
        .select_i(branch_mux),
        .data_o(pc_in_i)
        );	

endmodule
		  


