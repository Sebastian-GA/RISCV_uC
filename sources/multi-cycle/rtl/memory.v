// memory.v
// Memory
// Authors: Sebastian Garcia
//          Juliana Pineda


module memory(
    input clk,
    input [11:0] A,
    input [31:0] WD,
    input WE,

    output reg [31:0] RD,

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

    localparam INSTR_MEM_SIZE = 512;  // 128 instructions
    localparam DATA_MEM_SIZE = 256;
    localparam PERIPH_ADDR_START = 12'h700;

    // Internal memory arrays
    reg [7:0] instr_mem [0:INSTR_MEM_SIZE-1];
    reg [7:0] data_mem [0:DATA_MEM_SIZE-1];

    // Enable signals
    wire enable_peripherals;
    wire enable_instr_mem;
    wire enable_data_mem;

    assign enable_peripherals = (A >= PERIPH_ADDR_START);
    assign enable_instr_mem = (A < INSTR_MEM_SIZE);
    assign enable_data_mem = (A >= INSTR_MEM_SIZE) & (A < (INSTR_MEM_SIZE + DATA_MEM_SIZE));

    // Write data_mem
    always @(posedge clk)
        if (WE & enable_data_mem) begin
            data_mem[A - INSTR_MEM_SIZE] <= WD[31:24];
            data_mem[A+1 - INSTR_MEM_SIZE] <= WD[23:16];
            data_mem[A+2 - INSTR_MEM_SIZE] <= WD[15:8];
            data_mem[A+3 - INSTR_MEM_SIZE] <= WD[7:0];
        end
    
    // Initialize memory
    initial begin
        $readmemh("instr_memory.mem", instr_mem, 0, INSTR_MEM_SIZE-1);
        $readmemh("data_memory.mem", data_mem, 0, DATA_MEM_SIZE-1);
    end
    
    // Peripherals
    wire [31:0] RD_peripherals;
    wire [4:0] ADDR_peripherals;
    assign ADDR_peripherals = A - PERIPH_ADDR_START;

    peripherals peripherals(
        .clk(clk),
        .A(ADDR_peripherals),
        .WD(WD),
        .WE(WE & enable_peripherals),
        .RD(RD_peripherals),
        .sw(sw),
        .btn(btn),
        .ipin(ipin),
        .led(led),
        .opin(opin),
        .hex(hex),
        .hex_dot(hex_dot),
        .hex_sel(hex_sel)
    );

    // Assign data output
    always @(*)
        case ({enable_peripherals, enable_data_mem, enable_instr_mem})
            3'b001: RD = {instr_mem[A], instr_mem[A+1], instr_mem[A+2], instr_mem[A+3]};
            3'b010: RD = {data_mem[A - INSTR_MEM_SIZE], data_mem[A+1 - INSTR_MEM_SIZE], data_mem[A+2 - INSTR_MEM_SIZE], data_mem[A+3 - INSTR_MEM_SIZE]};
            3'b100: RD = RD_peripherals;
            default: RD = 0;
        endcase

endmodule
