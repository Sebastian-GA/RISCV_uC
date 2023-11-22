`timescale 1ns / 1ps
// main_fsm.v
// Main FSM
// Authors: Sebastian Garcia
//          Juliana Pineda


module main_fsm(
    input clk,
    input [6:0] op,

    output reg branch,
    output reg pc_update,
    output reg reg_write,
    output reg mem_write,
    output reg ir_write,
    output reg [1:0] result_src,
    output reg [1:0] alu_srcA,
    output reg [1:0] alu_srcB,
    output reg adr_src,
    output reg [1:0] alu_op
);

    // State encoding
    parameter Fetch = 4'b0000;
    parameter Decode = 4'b0001;
    parameter MemAdr = 4'b0010;
    parameter MemRead = 4'b0011;
    parameter MemWB = 4'b0100;
    parameter MemWrite = 4'b0101;
    parameter ExecuteR = 4'b0110;
    parameter ExecuteI = 4'b0111;    
    parameter ALUWB = 4'b1000;
    parameter BEQ = 4'b1001;
    parameter JAL = 4'b1010;

    // State registers
    reg [3:0] present_state = Fetch;
    reg [3:0] next_state;

    // Update state
    always @(posedge clk)
        present_state <= next_state;

    // Next state logic
    always @(*)
        case(present_state)
            Fetch: 
                next_state = Decode;
            Decode:
                case(op)
                    7'b0000011: next_state = MemAdr; // lw
                    7'b0100011: next_state = MemAdr; // sw
                    7'b0110011: next_state = ExecuteR; // R-type
                    7'b0010011: next_state = ExecuteI; // I-type
                    7'b1101111: next_state = JAL; // jal
                    7'b1100011: next_state = BEQ; // beq
                    // 7'b0110111: next_state = ALUWB; // U-type TODO: check
                    default: next_state = Fetch; // Fault recovery
                endcase
            MemAdr:
                case(op)
                    7'b0000011: next_state = MemRead; // lw
                    7'b0100011: next_state = MemWrite; // sw
                    default: next_state = Fetch; // Fault recovery
                endcase
            MemRead:
                next_state = MemWB;
            MemWB:
                next_state = Fetch;
            MemWrite:
                next_state = Fetch;
            ExecuteR:
                next_state = ALUWB;
            ExecuteI:
                next_state = ALUWB;
            ALUWB:
                next_state = Fetch;
            BEQ:
                next_state = Fetch;
            JAL:
                next_state = ALUWB;
            default:
                next_state = Fetch; // Fault recovery
        endcase

    // Outputs logic
    always @(*)
        case(present_state)
            Fetch:
                begin
                    adr_src = 0;
                    ir_write = 1;
                    alu_srcA = 2'b00;
                    alu_srcB = 2'b10;
                    alu_op = 2'b00;
                    result_src = 2'b10;
                    pc_update = 1;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                end
            Decode:
                begin
                    alu_srcA = 2'b01;
                    alu_srcB = 2'b01;
                    alu_op = 2'b00;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    result_src = 2'b00;
                    adr_src = 0;
                    pc_update = 0;
                end
            MemAdr:
                begin
                    alu_srcA = 2'b10;
                    alu_srcB = 2'b01;
                    alu_op = 2'b00;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    result_src = 2'b00;
                    adr_src = 0;
                    pc_update = 0;
                end
            MemRead:
                begin
                    result_src = 2'b00;
                    adr_src = 1;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    alu_srcA = 2'b00;
                    alu_srcB = 2'b00;
                    alu_op = 2'b00;
                    pc_update = 0;
                end
            MemWB:
                begin
                    result_src = 2'b01;
                    reg_write = 1;

                    // Other outputs
                    branch = 0;
                    mem_write = 0;
                    ir_write = 0;
                    alu_srcA = 2'b00;
                    alu_srcB = 2'b00;
                    alu_op = 2'b00;
                    adr_src = 0;
                    pc_update = 0;
                end
            MemWrite:
                begin
                    result_src = 2'b00;
                    adr_src = 1;
                    mem_write = 1;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    ir_write = 0;
                    alu_srcA = 2'b00;
                    alu_srcB = 2'b00;
                    alu_op = 2'b00;
                    pc_update = 0;
                end
            ExecuteR:
                begin
                    alu_srcA = 2'b10;
                    alu_srcB = 2'b00;
                    alu_op = 2'b10;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    result_src = 2'b00;
                    adr_src = 0;
                    pc_update = 0;
                end
            ExecuteI:
                begin
                    alu_srcA = 2'b10;
                    alu_srcB = 2'b01;
                    alu_op = 2'b10;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    result_src = 2'b00;
                    adr_src = 0;
                    pc_update = 0;
                end
            ALUWB:
                begin
                    result_src = 2'b00;
                    reg_write = 1;

                    // Other outputs
                    branch = 0;
                    mem_write = 0;
                    ir_write = 0;
                    alu_srcA = 2'b00;
                    alu_srcB = 2'b00;
                    alu_op = 2'b00;
                    adr_src = 0;
                    pc_update = 0;
                end
            BEQ:
                begin
                    alu_srcA = 2'b10;
                    alu_srcB = 2'b00;
                    alu_op = 2'b01;
                    result_src = 2'b00;
                    branch = 1;

                    // Other outputs
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    adr_src = 0;
                    pc_update = 0;
                end
            JAL:
                begin
                    alu_srcA = 2'b01;
                    alu_srcB = 2'b10;
                    alu_op = 2'b00;
                    result_src = 2'b00;
                    pc_update = 1;

                    // Other outputs
                    branch = 0;
                    reg_write = 0;
                    mem_write = 0;
                    ir_write = 0;
                    adr_src = 0;
                end
            // default:
        endcase

endmodule
