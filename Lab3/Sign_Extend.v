//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0316056_���g�� 0316038_�۽@��
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
	 select_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
input            select_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always @ (*) begin
	data_o <= select_i ? {{16{data_i[15]}}, data_i} :
                        {{16{1'b0}}, data_i};
end
endmodule      
     