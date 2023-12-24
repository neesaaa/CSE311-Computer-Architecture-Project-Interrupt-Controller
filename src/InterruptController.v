module InterruptController (INTA, INT, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, RD, WR, A0, CS, DATABUS, CAS, SP_EN);

    input INTA, IR0, IR1, IR2, IR3, IR4, IR5, IR6, IR7, A0, RD, WR, CS, SP_EN;
    inout [2:0] CAS;
    inout [7:0] DATABUS;
    output INT;

    wire [7:0] vector_address, command_word, irr, isr, imr, icw3, icw4;
    wire reset_irr_bit, direction, wr, rd, a0, send_vector_address;
    wire [1:0] number_of_ack;
    assign imr = 8'h00;

    //inistantiations
    IRR IRR (
        .IR0(IR0),
        .IR1(IR1),
        .IR2(IR2),
        .IR3(IR3),
        .IR4(IR4),
        .IR5(IR5),
        .IR6(IR6),
        .IR7(IR7),
        .reset_irr_bit(reset_irr_bit),
        .imr(imr),
        .isr(isr),
        .irr(irr)
    );
    
    PriorityResolver PriorityResolver (
        .INTA(INTA),
        .irr(irr),
        .INT(INT),
        .reset_irr_bit(reset_irr_bit),
        .number_of_ack(number_of_ack),
        .isr(isr)
    );
    
    ControlLogic ControlLogic (
        .INTA(INTA),
        .wr(wr),
        .rd(rd),
        .a0(a0),
        .send_vector_address(send_vector_address),
        .number_of_ack(number_of_ack),
        .isr(isr),
        .command_word(command_word),
        .direction(direction),
        .vector_address(vector_address),
        .icw3(icw3),
        .icw4(icw4)
    );
    
    DataBusBuffer DataBusBuffer (
        .direction(direction),
        .vector_address(vector_address),
        .command_word(command_word),
        .DATABUS(DATABUS)
    );
    
    ReadWriteLogic ReadWriteLogic (
        .RD(RD),
        .WR(WR),
        .A0(A0),
        .CS(CS),
        .wr(wr),
        .rd(rd),
        .a0(a0)
    );

    Cascade Cascade(
        .CAS(CAS),
        .SP_EN(SP_EN),
        .isr(isr),
        .icw3(icw3),
        .icw4(icw4),
        .send_vector_address(send_vector_address)
    );

endmodule