module priorityResolver(ir,prioritized_interrupt);

input [7:0]ir;
assign ir = 'b00010100;
output reg[3:0] prioritized_interrupt;
integer i;

initial begin
$monitor("%d",prioritized_interrupt);
end

always@(ir)begin 
  prioritized_interrupt = 'd4;
  for(i=0;i<8;i = i + 1)begin
    if(ir[i] == 1)begin
      prioritized_interrupt = i;
      i = 8;  //to end for loop
    end
  end
end

endmodule


