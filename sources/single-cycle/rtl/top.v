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
    
    localparam INST_MEM_N = 9;  // 128 instructions
    localparam DATA_MEM_N = 8;  // 256 Bytes

    // CONTROL UNIT
    wire Zero;
    wire PCSrc;
    wire [1:0] ResultSrc;
    wire MemWrite;
    wire [2:0] ALUControl;
    wire ALUSrcA;
    wire ALUSrcB;
    wire [2:0] ImmSrc;
    wire RegWrite;

    // INSTRUCTION MEMORY
    wire [31:0] Instr;
    wire [INST_MEM_N-1:0] PCNext;
    reg [INST_MEM_N-1:0] PC = 0;
    wire [INST_MEM_N-1:0] PCPlus4;
    wire [INST_MEM_N-1:0] PCTarget;

    // REGISTER FILE
    wire [31:0] RD2;

    // EXTEND IMMEDIATE
    wire [31:0] ImmExt;

    // ALU
    wire [31:0] ALUResult;
    wire [31:0] SrcA;
    wire [31:0] SrcB;

    // DATA MEMORY
    wire [31:0] ReadData;
    wire [31:0] ReadPeri;
    reg [31:0] ReadMemPeri;
    wire [DATA_MEM_N-1:0] ADDR_Data;
    wire [4:0] ADDR_peripherals;
    wire enable_data_mem;
    wire enable_peripherals;

    // RESULT
    reg [31:0] Result;

    ///////////////////////////////////////////
    // INSTANTIATIONS
    ///////////////////////////////////////////

    // CONTROL UNIT
    control_unit control_unit(
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7_5(Instr[30]),
        .zero(Zero),

        .pc_src(PCSrc),
        .result_src(ResultSrc),
        .mem_write(MemWrite),
        .alu_control(ALUControl),
        .alu_srcA(ALUSrcA),
        .alu_srcB(ALUSrcB),
        .imm_src(ImmSrc),
        .reg_write(RegWrite)
    );

    // INSTRUCTION MEMORY
    assign PCPlus4 = PC + 4;
    assign PCTarget = PC + ImmExt[INST_MEM_N-1:0];
    assign PCNext = PCSrc ? PCTarget : PCPlus4;

    always @(posedge clk) begin
        PC <= PCNext;
    end

    instruction_memory #(INST_MEM_N) instruction_memory(
        .A(PC),
        .RD(Instr)
    );

    // REGISTER FILE
    register_file register_file(
        .clk(clk),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WE3(RegWrite),
        .WD3(Result),
        .RD1(SrcA),
        .RD2(RD2)
    );

    // EXTEND IMMEDIATE
    extend extend(
        .imm(Instr[31:7]),
        .imm_src(ImmSrc),
        .imm_ext(ImmExt)
    );

    // ALU
    assign SrcB = ALUSrcB ? ImmExt : RD2;

    ALU ALU(
        .A(SrcA),
        .B(SrcB),
        .alu_control(ALUControl),
        .alu_out(ALUResult),
        .zero(Zero)
    );


    // Select Data Memory or Peripherals
    assign enable_data_mem = (ALUResult >= 2**INST_MEM_N) & (ALUResult < (2**INST_MEM_N + 2**DATA_MEM_N));
    assign enable_peripherals = (ALUResult >= 12'h700);
    
    assign ADDR_Data = ALUResult - 2**INST_MEM_N;
    assign ADDR_peripherals = ALUResult - 12'h700;
    
    always @(*)
        case ({enable_peripherals, enable_data_mem})
            2'b01: ReadMemPeri = ReadData;
            2'b10: ReadMemPeri = ReadPeri;
            default: ReadMemPeri = 0;
        endcase

    // DATA MEMORY
    data_memory #(DATA_MEM_N) data_memory(
        .clk(clk),
        .A(ADDR_Data),
        .WD(RD2),
        .WE(MemWrite & enable_data_mem),
        .RD(ReadData)
    );

    // PERIPHERALS
    peripherals peripherals(
        .clk(clk),
        .A(ADDR_peripherals),
        .WD(RD2),
        .WE(MemWrite & enable_peripherals),
        .RD(ReadPeri),
        .sw(sw),
        .btn(btn),
        .ipin(ipin),
        .led(led),
        .opin(opin),
        .hex(hex),
        .hex_dot(hex_dot),
        .hex_sel(hex_sel)
    );

    // RESULT
    always @(*) begin
        case (ResultSrc)
            2'b00: Result = ALUResult;
            2'b01: Result = ReadMemPeri;
            2'b10: Result = PCPlus4;
            2'b11: Result = ImmExt;
        endcase
    end

endmodule