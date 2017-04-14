//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
      clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire[32-1:0] pc_in_i,pc_out_o;
wire[32-1:0] instr_o;
wire[32-1:0] add_1_o;

/**** ID stage ****/
wire[32-1:0] addpc_ifid,instr_ifid;
wire[32-1:0] RSdata_o,RTdata_o;
wire[32-1:0] Sign_Extend_o;
wire[28-1:0] jump_shift_left_two_o;
wire[32-1:0] jump_address;
//control signal
wire[3-1:0] ALU_op_o;
wire[2-1:0] MemToReg_o,BranchType_o;
wire        RegWrite_o,ALUSrc_o,RegDst_o,Branch_o,SinExt,Jump_o,MemRead_o,MemWrite_o;

/**** EX stage ****/
wire[32-1:0] shift_left_two_o;
wire[32-1:0] add_2_o;
wire[5-1:0] RT_idex,RD_idex;
wire[32-1:0] SignExt_idex;
wire[32-1:0] RTdata_idex,RSdata_idex;
wire[32-1:0] addpc_idex;
wire[32-1:0] jump_addr_idex;
wire[32-1:0] Mux_ALU_o;
wire[4-1:0] ALUCtrl_o;
wire Jr_o;
wire[32-1:0] ALU_res;
wire zero_o;
wire[32-1:0] jr_addr;
wire[5-1:0] mux_writereg;
//control signal
wire[3-1:0] ALU_op_idex;
wire[2-1:0] MemToReg_idex,BranchType_idex;
wire        RegWrite_idex,ALUSrc_idex,RegDst_idex,Branch_idex,
	         Jump_idex,MemRead_idex,MemWrite_idex;

/**** MEM stage ****/
wire[5-1:0] writereg_exmem;
wire Jr_exmem,zero_exmem;
wire[32-1:0] RTdata_exmem,ALUres_exmem,jr_addr_exmem,add_2_exmem,jump_addr_exmem;
wire[32-1:0] ReadData_o;
wire Branch_res;
wire branch_mux;
wire[32-1:0] PC_source1_o;
wire[32-1:0] Mux_Jump_o;
wire[32-1:0] SignExt_exmem;
//control signal
wire RegWrite_exmem,Jump_exmem,Branch_exmem,MemRead_exmem,MemWrite_exmem;
wire[2-1:0] MemToReg_exmem,BranchType_exmem;

/**** WB stage ****/
wire[32-1:0] RegSource_o;
wire[5-1:0] writereg_memwb;


wire[32-1:0] ALUres_memwb,SignExt_memwb,ReadData_memwb;

//control signal
wire RegWrite_memwb;
wire[2-1:0] MemToReg_memwb; 

/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage

		  
MUX_2to1 #(.size(32)) Mux_Return(
			.data0_i(add_1_o),
         .data1_i(add_2_exmem),
         .select_i(branch_mux),
         .data_o(pc_in_i)
			);
ProgramCounter PC(
		 .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in_i),   
	    .pc_out_o(pc_out_o) 
       );

Instruction_Memory IM(
		 .addr_i(pc_out_o),  
	    .instr_o(instr_o)    
	    );
			
Adder Add_pc(
		.src1_i(pc_out_o),     
	   .src2_i(32'd4),     
	   .sum_o(add_1_o)
		);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i({add_1_o,instr_o}),
		.data_o({addpc_ifid,instr_ifid})
		);
		
//Instantiate the components in ID stage
Reg_File RF(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(instr_ifid[25:21]),
		.RTaddr_i(instr_ifid[20:16]),
		.RDaddr_i(writereg_memwb),
		.RDdata_i(RegSource_o),
		.RegWrite_i(RegWrite_memwb),
		.RSdata_o(RSdata_o),
		.RTdata_o(RTdata_o)
		);

Decoder Control(
		.instr_op_i(instr_ifid[31:26]),
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
        .data_i(instr_ifid[25:0]),
        .data_o(jump_shift_left_two_o)
        ); 	
assign jump_address = {addpc_ifid[31:28],jump_shift_left_two_o[27:0]};

Sign_Extend Sign_Extend(
		.data_i(instr_ifid[15:0]),
		.select_i(SinExt),
		.data_o(Sign_Extend_o)
		);	

Pipe_Reg #(.size(184)) ID_EX(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i({instr_ifid[15:11],instr_ifid[20:16],Sign_Extend_o,RTdata_o,RSdata_o,addpc_ifid,
					RegWrite_o,ALU_op_o,ALUSrc_o,RegDst_o,Branch_o,BranchType_o,MemToReg_o,Jump_o,
					MemRead_o,MemWrite_o,jump_address}),
		.data_o({RD_idex,RT_idex,SignExt_idex,RTdata_idex,RSdata_idex,addpc_idex,
					RegWrite_idex,ALU_op_idex,ALUSrc_idex,RegDst_idex,Branch_idex,BranchType_idex,
					MemToReg_idex,Jump_idex,MemRead_idex,MemWrite_idex,jump_addr_idex})
		);
		
//Instantiate the components in EX stage
Shift_Left_Two_32 Shifter(
        .data_i(SignExt_idex),
        .data_o(shift_left_two_o)
        ); 	
		  
Adder Adder2(
       .src1_i(addpc_idex),     
	    .src2_i(shift_left_two_o),     
	    .sum_o(add_2_o)       
	    );	  
		 
ALU ALU(
		.src1_i(RSdata_idex),
		.src2_i(Mux_ALU_o),
		.ctrl_i(ALUCtrl_o),
		.srl_i(SignExt_idex[10:6]),
		.result_o(ALU_res),
		.zero_o(zero_o),
		.jr_addr(jr_addr)
		);
		
ALU_Ctrl ALU_Control(
		.funct_i(SignExt_idex[5:0]),
      .ALUOp_i(ALU_op_idex),
      .ALUCtrl_o(ALUCtrl_o),
		.Jr_o(Jr_o)
		);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
			.data0_i(RTdata_idex),
         .data1_i(SignExt_idex),
         .select_i(ALUSrc_idex),
         .data_o(Mux_ALU_o)
        );
		
MUX_2to1 #(.size(5)) Mux_Write_Reg(
			.data0_i(RT_idex),
         .data1_i(RD_idex),
         .select_i(RegDst_idex),
         .data_o(mux_writereg)
        );

Pipe_Reg #(.size(208)) EX_MEM(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i({mux_writereg,Jr_o,SignExt_idex,RTdata_idex,ALU_res,jr_addr,zero_o,add_2_o,
					jump_addr_idex,RegWrite_idex,MemToReg_idex,Jump_idex,Branch_idex,BranchType_idex,
					MemRead_idex,MemWrite_idex}),
		.data_o({writereg_exmem,Jr_exmem,SignExt_exmem,RTdata_exmem,ALUres_exmem,jr_addr_exmem,zero_exmem,add_2_exmem,
					jump_addr_exmem,RegWrite_exmem,MemToReg_exmem,Jump_exmem,Branch_exmem,BranchType_exmem,
					MemRead_exmem,MemWrite_exmem})
		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(
		 .clk_i(clk_i),
		 .addr_i(ALUres_exmem),
		 .data_i(RTdata_exmem),
		 .MemRead_i(MemRead_exmem),
		 .MemWrite_i(MemWrite_exmem),
		 .data_o(ReadData_o)
	    );
/*assign branch_mux = Branch_exmem & Branch_res;		 
Mux_4to1 Mux_Branch_Source(
		.data0_i(zero_exmem), //beq ==
		.data1_i(~ALUres_exmem[31]), //bgez >=0 // ALU_res = (src1 or 00001)
		.data2_i(ALUres_exmem[31]), //blt <
		.data3_i(~zero_exmem), //bnez !=0
		.select_i(BranchType_exmem),
		.data_o(Branch_res)
);*/
assign branch_mux=Branch_exmem & zero_exmem;


/*MUX_2to1 #(.size(32)) Mux_PC_Source1(
        .data0_i(addpc_exmem),
        .data1_i(add_2_exmem),
        .select_i(branch_mux),
        .data_o(PC_source1_o)
        );	
*/		  
/*MUX_2to1 #(.size(32)) Mux_Jump(
        .data0_i(PC_source1_o),
        .data1_i(jump_addr_exmem),
        .select_i(Jump_exmem),
        .data_o(Mux_Jump_o)
        );	
*/		  
Pipe_Reg #(.size(104)) MEM_WB(
      .clk_i(clk_i),
		.rst_i(rst_i),
		.data_i({writereg_exmem,ALUres_exmem,SignExt_exmem,ReadData_o,RegWrite_exmem,MemToReg_exmem}),
		.data_o({writereg_memwb,ALUres_memwb,SignExt_memwb,ReadData_memwb,RegWrite_memwb,MemToReg_memwb})
		);

//Instantiate the components in WB stage
MUX_3to1 Mux3(
		  .data0_i(ALUres_memwb),
		  .data1_i(ReadData_memwb),
		  .data2_i(SignExt_memwb),
		  .select_i(MemToReg_memwb),
		  .data_o(RegSource_o)
        );

/****************************************
signal assignment
****************************************/	
endmodule

