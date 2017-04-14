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
wire [32-1:0] pc_in_i, pc_out_o,add_1_o,add_2_o,instr_o,RSdata_o,RTdata_o,Sign_Extend_o,Mux_ALU_o,ALU_res,shift_left_two_o,PC_source1_o,RegSource_o,ReadData_o, jump_address;
wire [28-1:0] jump_shift_left_two_o;
wire [5-1:0]  RDaddr_i;
wire [3-1:0]  ALU_op_o;
wire [4-1:0]  ALUCtrl_o;
wire [2-1:0]  MemToReg_o, BranchType_o;
wire           RegDst_o,RegWrite_o,ALUSrc_o,Branch_o,zero_o,cout,overflow,SinExt,Jump_o,MemRead_o,MemWrite_o, branch_mux,Branch_res;
wire  [31:0]  jr_a;
wire  [31:0]  alu_jc;
wire   		  jr;
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
       .addr_i(pc_out_o),  
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
        .RDdata_i(RegSource_o)  ,
		  .PC_added(add_1_o),	
		  .instruction(instr_o),
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
		 .Branch_o(Branch_o),
		 .BranchType_o(BranchType_o),
		 .SinExt_o(SinExt),
		 .MemToReg_o(MemToReg_o),
		 .Jump_o(Jump_o),
		 .MemRead_o(MemRead_o),
		 .MemWrite_o(MemWrite_o)
	    );
Shift_Left_Two_28 J_Shifter(
        .data_i(instr_o[25:0]),
        .data_o(jump_shift_left_two_o)
        ); 	
ALU_Ctrl AC(
        .funct_i(instr_o[5:0]), 		  
        .ALUOp_i(ALU_op_o),   
        .ALUCtrl_o(ALUCtrl_o),
		  .Jr_o(jr)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
		  .select_i(SinExt),
        .data_o(Sign_Extend_o)
        );
Data_Memory Data_Memory(
		 .clk_i(clk_i),
	    .addr_i(ALU_res),
	    .data_i(RTdata_o),
	    .MemRead_i(MemRead_o),
	    .MemWrite_i(MemWrite_o),
	    .data_o(ReadData_o)
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
		 .zero_o(zero_o),
		 .jr_addr(jr_a)
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
Mux_ToReg_Source Mux_3to1(
		.data0_i(ALU_res),
		.data1_i(ReadData_o),
		.data2_i(Sign_Extend_o),
		.select_i(MemToReg_o),
		.data_o(RegSource_o)
);		  
//assign branch_mux = (Branch_bne_o&(~Branch_beq_o)&(~zero_o)|(~Branch_bne_o)&Branch_beq_o&zero_o);
assign branch_mux = Branch_o & Branch_res;
MUX_2to1 #(.size(32)) Mux_PC_Source1(
        .data0_i(add_1_o),
        .data1_i(add_2_o),
        .select_i(branch_mux),
        .data_o(PC_source1_o)
        );	

assign jump_address = {add_1_o[31:28],jump_shift_left_two_o[27:0]};
MUX_2to1 #(.size(32)) Mux_PC_Source2(
        .data0_i(PC_source1_o),
        .data1_i(jump_address),
        .select_i(Jump_o),
        .data_o(alu_jc)
        );	
MUX_2to1 #(.size(32)) Mux_PC_Source3(
        .data0_i (alu_jc),
        .data1_i (jr_a),
        .select_i(jr),
        .data_o(pc_in_i)
        );
Mux_4to1 Mux_Branch_Source(
		.data0_i(zero_o), //beq ==
		.data1_i(~ALU_res[31]), //bgez >=0 // ALU_res = (src1 or 00001)
		.data2_i(ALU_res[31]), //blt <
		.data3_i(~zero_o), //bnez !=0
		.select_i(BranchType_o),
		.data_o(Branch_res)
);
endmodule
		  


