module encoder (
    input [7:0] in,
    output reg [2:0] out
);

always @(*) begin
    case (in)
        8'h01: out <= 3'b000;
        8'h02: out <= 3'b001;
        8'h04: out <= 3'b010;
        8'h08: out <= 3'b011;
        8'h10: out <= 3'b100;
        8'h20: out <= 3'b101;
        8'h40: out <= 3'b110;
        8'h80: out <= 3'b111;
        default: out <= 3'b000;
    endcase
end

endmodule