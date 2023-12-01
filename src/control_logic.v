module control (
    output reg INT,
    input INTA,

    input [7:0] IRR,
    input [7:0] priority,
    output reg fromControlLogic_toPriorityResolver
);

wire isIntrupt;
integer numberOfAck = 0;
assign isIntrupt = |(IRR);


always @(negedge INTA) begin
    if (numberOfAck == 2) begin
        numberOfAck <= 0;
    end
    else 
    numberOfAck <= numberOfAck + 1;
end


always @(*) begin
    
    if (isIntrupt && numberOfAck==0) begin
        INT <= 1;
    end

    if (numberOfAck == 1) 
        fromControlLogic_toPriorityResolver <= 1;
    else 
        fromControlLogic_toPriorityResolver <= 0;

end
    
endmodule
module DataBusBuffer (
    inout [7:0] data, //internal bus when send ** output **  or bus from pc when read so **input** 
    input direction,  //1>>sending to pc
    input [7:0] Rx_data, //recieved data
    input [7:0] Tx_Data //sent data
);
 
assign data = direction ? Tx_Data : 8'bZ;
assign Rx_Data = data;

endmodule