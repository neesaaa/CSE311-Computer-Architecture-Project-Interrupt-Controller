module DataBusBuffer (
    inout [7:0] data, //internal bus when send ** output **  or bus from pc when read so **input** 
    input direction,  //1>>sending to pc
    input [7:0] Rx_data, //recieved data
    input [7:0] Tx_Data //sent data
);
 
assign data = direction ? Tx_Data : 8'bZ;
assign Rx_Data = data;

endmodule