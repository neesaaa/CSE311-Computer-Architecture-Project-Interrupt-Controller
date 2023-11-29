module  IRR (
    //inputs
    IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7,
IMR,
//output
IRR    
);
input IR0,IR1,IR2,IR3,IR4,IR5,IR6,IR7;
input [7:0]IMR;
output reg [7:0] IRR;

always @(posedge ) begin
    IRR<={IR7&~IMR[7],IR6&~IMR[6],IR5&~IMR[5],IR4&~IMR[4],IR3&~IMR[3],IR2&~IMR[2],IR1&~IMR[1],IR0&~IMR[0]}
end

    
endmodule