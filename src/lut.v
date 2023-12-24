module lut (
    input [1:0] address,
    output reg [8:0] value
);
    
always @(*) begin

    case (address)
        2'b00: value <= 9'b0XXX11000;
        2'b01: value <= 9'b110101XXX;
        2'b10: value <= 9'b000000000;
        2'b11: value <= 9'b000000000;
        default: value <= 9'hXXX;
    endcase

end

endmodule
