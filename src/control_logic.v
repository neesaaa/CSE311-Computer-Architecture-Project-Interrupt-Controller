module control (
    output reg INT,
    input INTA,

    input [7:0] IRR,
    input [7:0] priority,
    input [7:0] ISR,
    output  Direction ;
    input [7:0] dataBus
    output reg fromControlLogic_toPriorityResolver,
    output reg [7:0] vector_address
    reg flag ;
    reg[7:0] icw1,icw2,icw3,icw4;
);

wire isIntrupt;
wire send_vector;
integer numberOfAck = 0;

assign isIntrupt = |(IRR);
encoder isr_encoder (.out(vector_address), .in(ISR));
DataBusBuffer m0(.Direction(Direction),.Rxdata(dataBus));
()// intatiate read write logic to take WR signal and A0 (alert)!!

always @(negedge WR) begin //count icw words
if (dataBus[4]==1 & A0==0) begin
    flag<=1 ;
    count<=1 ;
    ICW1<=dataBus;
end
else if (flag) begin
    count <= count + 1;
    if (count == 2)
        icw2 <= dataBus;
    else if (count == 3 & icw1[1] == 1 & icw1[0] == 0) // no icw3 and no icw4
        flag <= 0;
    else if (count == 3 & icw1[1] == 0) // there is icw3
        icw3 <= dataBus;
    else if (count == 3 & icw1[0] == 1) // there is icw4
        icw4 <= dataBus;
    else if (count == 4 & ~(icw1[1] == 1 & icw1[0] == 0)) // there is only one icw3 or icw4
        flag <= 0;
    else if (count == 4) //ther is icw4 and icw3
        icw4 <= dataBus;
        flag <= 0;
end

end

always @(negedge INTA) begin
    if (numberOfAck == 2) begin
        numberOfAck <= 0;
        vector_address<={icw2[7:3],out} //concatinating number of interupt with T7-T3
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

 

end
    
endmodule
