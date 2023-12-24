module ControlLogic (INTA, isr, command_word, wr, rd, a0, direction, vector_address, number_of_ack,send_vector_address, icw3, icw4);

    input INTA, wr, rd, a0;
    input send_vector_address; // from cascade module 
    input [1:0] number_of_ack;
    input [7:0] isr, command_word;
    output reg direction;
    output [7:0] vector_address;
    output reg [7:0] icw3, icw4;
    
    reg [7:0] icw1, icw2, ocw1, ocw2, ocw3; 
    wire [2:0] out ; // for encoder

    //one hot coded states for ICW FSM 
    parameter idle = 5'b00001,
              ICW1 = 5'b00010,
              ICW2 = 5'b00100,
              ICW3 = 5'b01000,
              ICW4 = 5'b10000;
    reg [4:0] currentstate = idle, nextstate;

    assign vector_address = {icw2[7:3], out}; //concatinating number of interupt(out) with T7-T3

    Encoder Encoder (.out(out), .in(isr));

    //  FSM to detect ICW
    always @(negedge wr) begin   // State memory 
        currentstate <= nextstate;
    end

    always@(currentstate, command_word, a0) begin // next state logic 
        case (currentstate)
            idle:
                if (command_word[4] == 1 && a0 == 0)  // to check if it is ICW or not
                    nextstate <= ICW1;
                else
                    nextstate <= idle;
            ICW1: nextstate <= ICW2;
            ICW2:
                if (icw1[1] == 0) // there is icw3
                    nextstate <= ICW3;
                else if (icw1[0] == 1) // there is icw4
                    nextstate <= ICW4;
                else // no icw3 and no icw4
                    nextstate <= idle;
            ICW3:
                if (icw1[0] == 1) // there is icw4
                    nextstate <= ICW4;
                else
                    nextstate <= idle;
            ICW4:
                if (command_word[4] == 1 && a0 == 0)  // to check if it is ICW or not
                    nextstate <= ICW1;
                else
                    nextstate <= idle;
        endcase
    end

    always@(currentstate) begin // output logic
        case (currentstate)
            ICW1: icw1 <= command_word;
            ICW2: icw2 <= command_word;
            ICW3: icw3 <= command_word;
            ICW4: icw4 <= command_word;
        endcase
    end

    always @(negedge wr) begin // to detect OCW 
        if (nextstate == idle) begin
            if (a0 == 1)
                ocw1 <= command_word;
            else if (command_word[3] == 0)
                ocw2 <= command_word;
            else
                ocw3 <= command_word;
        end
    end

    // to open the tri-state buffer when sending the vector address 
    always @(number_of_ack, send_vector_address) begin   
        if (number_of_ack == 2 && send_vector_address)
            direction = 1;
        else
            direction = 0;
    end
    
endmodule