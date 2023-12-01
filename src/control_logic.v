module control (
INT,INTA,IRR,priority, ISR, dataBus, WR, RD, A0,Direction ,fromControlLogic_toPriorityResolver,vector_address,resetIRRbit );
input INTA;
input [7:0] IRR;
input [7:0] priority;
input [7:0] ISR;
input [7:0] dataBus;
input WR;
input RD;
input A0;
output reg Direction;
output reg fromControlLogic_toPriorityResolver;
output reg vector_address;
output reg resetIRRbit ;
output reg INT;

reg[7:0] icw1,icw2,icw3,icw4; 
wire [2:0] out ; // for encoder
//grey coded states for ICW FSM 
parameter idle=00;
parameter ICW2=01;
parameter ICW3=11;
parameter ICW4=10 ;
reg [1:0] currentstate=idle,nextstate ;
 
wire isIntrupt;
wire send_vector;
integer numberOfAck = 0;

//inistantiations
encoder isr_encoder (.out(out), .in(ISR));
DataBusBuffer m0(.Direction(Direction),.Rxdata(dataBus));
Read_write_logic m1(.WR_out(WR),.A0(A0),.RD_out(RD));



//  FSM to detect ICW
always@(negedge WR) begin   // State memory 
    currentstate<=nextstate;
end

always@(currentstate ,dataBus,A0 ) begin // next state logic 
    case (currentstate)
        idle:if (dataBus[4]==1 && A0==0)  // to check if it is ICW or not
                nextstate<=ICW2;
            else nextstate<=idle;
        ICW2: if (icw1[1] == 1 && icw1[0] == 0) // no icw3 and no icw4
                begin nextstate<=idle; end
            else if ( icw1[1] == 0) // there is icw3
                nextstate<=ICW3;
            else if ( icw1[0] == 1 && icw1[1] == 1) // there is icw4 and no icw3
                nextstate<=ICW4;
        ICW3:if(icw1[0]) // there is icw4
                nextstate<=ICW4;
            else nextstate<=idle ;
        ICW4: nextstate<=idle ; 
    endcase
end
always@(currentstate ,dataBus,A0) begin // output logic
   case(currentstate)
    idle:if (dataBus[4]==1 && A0==0) begin
         Direction=1;
         icw1<=dataBus;
    end
    ICW2: begin Direction=1; icw2<=dataBus;end
    ICW3:begin Direction=1; icw3<=dataBus;end
    ICW4: begin Direction=1; icw4<=dataBus;end
   endcase
   
end



// to count number of INTA pusles and send ISR vector adress and 
always @(negedge INTA) begin   
    if (numberOfAck == 2) begin
        numberOfAck <= 0;
        Direction=0;
        vector_address<={icw2[7:3],out} ;//concatinating number of interupt(out) with T7-T3
    end
    else
        numberOfAck<=numberOfAck+1;

end

// block to drive INT signal and reset the crosponding IRR bit and to set ISR bit
always @(*) begin
    if (numberOfAck==1) begin
        resetIRRbit=1;
        fromControlLogic_toPriorityResolver=1;
    end
    if (numberOfAck!=1) begin
        resetIRRbit=0;
        fromControlLogic_toPriorityResolver=0;
    end
    if ( |(IRR) && numberOfAck==0)
        INT <= 1;
    else
        INT <= 0;
 
end
    
endmodule

