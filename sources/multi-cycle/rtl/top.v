`timescale 1ns / 1ps
// top.v
// Top
// Authors: Sebastian Garcia
//          Juliana Pineda


module top(
    input clk,

    // Peripherals
    input [15:0] sw,
    input [4:0] btn,
    input [3:0] ipin,

    output [15:0] led,
    output [3:0] opin,
    output [6:0] hex,
    output hex_dot,
    output [3:0] hex_sel
);

    ///////////////////////////////////////////
    // DECLARATIONS
    ///////////////////////////////////////////

    // CONTROL UNIT
    wire PCWrite;
    wire AdrSrc;
    wire MemWrite;
    wire IRWrite;
    wire [1:0] ResultSrc;
    wire [2:0] ALUControl;
    wire ALUSrcA;
    wire ALUSrcB;
    wire [2:0] ImmSrc;
    wire RegWrite;

    // MEMORY
    wire [11:0] Adr;
    wire [31:0] ReadData;
    reg [31:0] WriteData;
    wire [11:0] PCNext;
    reg [11:0] PC = 0;
    reg [11:0] OldPC = 0;
    reg [31:0] Instr = 0;
    reg [31:0] Data = 0;

    // REGISTER FILE
    wire [31:0] RD1;
    wire [31:0] RD2;
    reg [31:0] A;

    // EXTEND IMMEDIATE
    wire [31:0] ImmExt;

    // ALU
    wire [31:0] ALUResult;
    reg [31:0] SrcA;
    reg [31:0] SrcB;
    wire Zero;
    reg [31:0] ALUOut;

    // RESULT
    reg [31:0] Result;

    ///////////////////////////////////////////
    // INSTANTIATIONS
    ///////////////////////////////////////////

    // CONTROL UNIT
    // TODO: Add Control Unit    

    // INSTRUCTION MEMORY
    assign PCNext = Result[11:0];
    assign Adr = AdrSrc ? Result[11:0] : PC;

    always @(posedge clk) begin
        PC <= PCWrite ? PCNext : PC;
        
        OldPC <= IRWrite ? PC : OldPC;
        Instr <= IRWrite ? ReadData : Instr;

        Data <= ReadData;
    end

    memory memory(
        .clk(clk),
        .A(Adr),
        .WD(WriteData),
        .WE(MemWrite),
        .RD(ReadData),

        // Peripherals
        .sw(sw),
        .btn(btn),
        .ipin(ipin),
        .led(led),
        .opin(opin),
        .hex(hex),
        .hex_dot(hex_dot),
        .hex_sel(hex_sel)
    );

    // REGISTER FILE
    always @(posedge clk) begin
        A <= RD1;
        WriteData <= RD2;
    end

    register_file register_file(
        .clk(clk),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WE3(RegWrite),
        .WD3(Result),
        .RD1(RD1),
        .RD2(RD2)
    );

    // EXTEND IMMEDIATE
    extend extend(
        .imm(Instr[31:7]),
        .imm_src(ImmSrc),
        .imm_ext(ImmExt)
    );

    // ALU
    always @(*) begin
        case (ALUSrcA)
            2'b00: SrcA = PC;
            2'b01: SrcA = OldPC;
            2'b10: SrcA = A;
            default: SrcA = 0;
        endcase

        case (ALUSrcB)
            2'b00: SrcB = WriteData;
            2'b01: SrcB = ImmExt;
            2'b10: SrcB = 4;
            default: SrcB = 0;
        endcase
    end

    always @(posedge clk) begin
        ALUOut <= ALUResult;
    end

    ALU ALU(
        .A(SrcA),
        .B(SrcB),
        .alu_control(ALUControl),
        .alu_out(ALUResult),
        .zero(Zero)
    );

    // RESULT
    always @(*)
        case (ResultSrc)
            2'b00: Result = ALUOut;
            2'b01: Result = Data;
            2'b10: Result = ALUResult;
            // TODO: Add support for LUI
            default: Result = 0;
        endcase

endmodule