localparam CPU_DATA_WIDTH = 32; // 32-bit CPU
localparam RF_DATA_WIDTH = CPU_DATA_WIDTH;
localparam RF_WORDS = 16; // 16 registers
localparam RF_ADDR_WIDTH = $clog2(RF_WORDS);
localparam IM_ADDR_WIDTH = CPU_DATA_WIDTH;
localparam IM_DATA_WIDTH = 32; // Instructions are 32-bit long for both ARM64 and ARM32.
localparam IM_WORDS = 64; // 64 instructions total
localparam DM_DATA_WIDTH = CPU_DATA_WIDTH;
localparam DM_BYTES = 128;
localparam DM_ADDR_WIDTH = CPU_DATA_WIDTH;

// Zero register
localparam XZR = 13;

// CSRP
localparam CPSR_N = 31;
localparam CPSR_Z = 30;
localparam CPSR_C = 29;
localparam CPSR_V = 28;