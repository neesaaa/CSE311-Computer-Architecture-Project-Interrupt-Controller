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
