module Read_write_logic (
    RD,WR,A0,CS,WR_out,RD_out,A0_out 
);
input RD,WR,A0,CS;
output RD_out,A0_out,WR_out;
assign RD_out=(~CS)?RD:1 ;
assign WR_out=(~CS )?WR:1 ;
assign A0_out=A0;


    
endmodule