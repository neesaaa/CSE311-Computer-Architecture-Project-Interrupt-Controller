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
  input wire direction,    //1 read from pc 0 write on pc
  input wire [7:0] from_pc,
  input wire [7:0] from_pic,
  output wire [7:0] Rxdata,
  output reg [7:0] Txdata,
);

  reg [7:0] buffer;         

  
  always @(*) begin
    if (direction) begin
    Txdata <= 8'bzzzzzzzz; 
    buffer <= from_pc;
    end      
  end
  assign Rxdata = buffer; //reading
  assign Txdata = from_pic;

endmodule
