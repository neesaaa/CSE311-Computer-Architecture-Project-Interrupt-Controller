module control (
    output reg INT,
    input INTA,

    input [7:0] IRR,
    input [7:0] priority,
    input [7:0] ISR,
    output reg fromControlLogic_toPriorityResolver,
    output reg [7:0] vector_address
);

wire isIntrupt;
wire send_vector;
integer numberOfAck = 0;

assign isIntrupt = |(IRR);

encoder isr_encoder (.out(vector_address), .in(ISR));

always @(negedge INTA) begin
    if (numberOfAck == 2) begin
        numberOfAck <= 0;
    end
    numberOfAck <= numberOfAck + 1;
end

always @(*) begin
    
    if (isIntrupt && numberOfAck==0)
        INT <= 1;
    else (numberOfAck == 1)
        INT <= 0;

    if (numberOfAck == 1) 
        fromControlLogic_toPriorityResolver <= 1;
    else 
        fromControlLogic_toPriorityResolver <= 0;

    if (numberOfAck == 2)
        send_vector <= 1;
    else
        send_vector <= 0;

end
    
endmodule
