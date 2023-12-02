// instruction_memory.v
// Instrcution Memory
// Authors: Sebastian Garcia
//          Juliana Pineda


module instruction_memory
# (parameter N = 9)(
    input [N-1:0] A,

    output [31:0] RD
);

    // byte-based memory
    reg [7:0] memory [0:(2**N)-1]; // Memory array (depth x width): 2^6= 64_rows x 8_bits

    // Read data from memory (big-endian)
    assign RD = {memory[A], memory[A+1], memory[A+2], memory[A+3]};

    initial
    $readmemh("instruction_memory.mem", memory, 0, (2**N)-1);

endmodule
