// ============================================================
// RV32I ALU Core — Datapath + Control
// Supported: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
// ============================================================

// ------------------------------------------------------------
// 1. ALU DATAPATH
//    Takes two 32-bit operands and a 4-bit control signal.
//    Produces a 32-bit result and a zero flag.
// ------------------------------------------------------------
module alu (
    input  [31:0] a,          // operand 1 (rs1)
    input  [31:0] b,          // operand 2 (rs2 or immediate)
    input  [ 3:0] alu_ctrl,   // operation select (from control path)
    output reg [31:0] result, // computed result
    output zero               // 1 if result == 0 (used for branches)
);

    // ALU operation encodings
    localparam ADD  = 4'b0000;
    localparam SUB  = 4'b0001;
    localparam AND  = 4'b0010;
    localparam OR   = 4'b0011;
    localparam XOR  = 4'b0100;
    localparam SLL  = 4'b0101;  // shift left logical
    localparam SRL  = 4'b0110;  // shift right logical
    localparam SRA  = 4'b0111;  // shift right arithmetic
    localparam SLT  = 4'b1000;  // set less than (signed)
    localparam SLTU = 4'b1001;  // set less than (unsigned)

    always @(*) begin
        case (alu_ctrl)
            ADD  : result = a + b;
            SUB  : result = a - b;
            AND  : result = a & b;
            OR   : result = a | b;
            XOR  : result = a ^ b;
            SLL  : result = a << b[4:0];
            SRL  : result = a >> b[4:0];
            SRA  : result = $signed(a) >>> b[4:0];
            SLT  : result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLTU : result = (a < b) ? 32'd1 : 32'd0;
            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule


// ------------------------------------------------------------
// 2. CONTROL PATH
//    Decodes the RV32I opcode + funct3 + funct7 into alu_ctrl.
//    Also outputs signals for register write, memory, branches.
// ------------------------------------------------------------
module control (
    input  [ 6:0] opcode,     // instruction[6:0]
    input  [ 2:0] funct3,     // instruction[14:12]
    input         funct7_5,   // instruction[30] — differentiates ADD/SUB, SRL/SRA
    output reg [ 3:0] alu_ctrl,
    output reg reg_write,     // 1 = write result to rd
    output reg mem_read,      // 1 = load instruction
    output reg mem_write,     // 1 = store instruction
    output reg mem_to_reg,    // 1 = writeback from memory, 0 = from ALU
    output reg branch,        // 1 = branch instruction
    output reg alu_src        // 1 = second operand is immediate, 0 = rs2
);

    // RV32I opcode definitions
    localparam OP_REG    = 7'b0110011; // R-type  (ADD, SUB, AND, OR ...)
    localparam OP_IMM    = 7'b0010011; // I-type  (ADDI, ANDI, ORI ...)
    localparam OP_LOAD   = 7'b0000011; // I-type  (LW, LH, LB)
    localparam OP_STORE  = 7'b0100011; // S-type  (SW, SH, SB)
    localparam OP_BRANCH = 7'b1100011; // B-type  (BEQ, BNE, BLT ...)

    always @(*) begin
        // safe defaults
        alu_ctrl  = 4'b0000; // ADD
        reg_write = 0;
        mem_read  = 0;
        mem_write = 0;
        mem_to_reg= 0;
        branch    = 0;
        alu_src   = 0;

        case (opcode)

            // --------------------------------------------------
            // R-TYPE: register-register operations
            // --------------------------------------------------
            OP_REG: begin
                reg_write = 1;
                alu_src   = 0; // use rs2
                case (funct3)
                    3'b000: alu_ctrl = funct7_5 ? 4'b0001 : 4'b0000; // SUB : ADD
                    3'b111: alu_ctrl = 4'b0010; // AND
                    3'b110: alu_ctrl = 4'b0011; // OR
                    3'b100: alu_ctrl = 4'b0100; // XOR
                    3'b001: alu_ctrl = 4'b0101; // SLL
                    3'b101: alu_ctrl = funct7_5 ? 4'b0111 : 4'b0110; // SRA : SRL
                    3'b010: alu_ctrl = 4'b1000; // SLT
                    3'b011: alu_ctrl = 4'b1001; // SLTU
                    default: alu_ctrl = 4'b0000;
                endcase
            end

            // --------------------------------------------------
            // I-TYPE: register-immediate operations
            // --------------------------------------------------
            OP_IMM: begin
                reg_write = 1;
                alu_src   = 1; // use immediate
                case (funct3)
                    3'b000: alu_ctrl = 4'b0000; // ADDI
                    3'b111: alu_ctrl = 4'b0010; // ANDI
                    3'b110: alu_ctrl = 4'b0011; // ORI
                    3'b100: alu_ctrl = 4'b0100; // XORI
                    3'b001: alu_ctrl = 4'b0101; // SLLI
                    3'b101: alu_ctrl = funct7_5 ? 4'b0111 : 4'b0110; // SRAI : SRLI
                    3'b010: alu_ctrl = 4'b1000; // SLTI
                    3'b011: alu_ctrl = 4'b1001; // SLTIU
                    default: alu_ctrl = 4'b0000;
                endcase
            end

            // --------------------------------------------------
            // LOAD: ALU computes address = rs1 + imm
            // --------------------------------------------------
            OP_LOAD: begin
                reg_write  = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                alu_src    = 1;
                alu_ctrl   = 4'b0000; // ADD for address
            end

            // --------------------------------------------------
            // STORE: ALU computes address = rs1 + imm
            // --------------------------------------------------
            OP_STORE: begin
                mem_write = 1;
                alu_src   = 1;
                alu_ctrl  = 4'b0000; // ADD for address
            end

            // --------------------------------------------------
            // BRANCH: ALU does SUB, checks zero flag
            // --------------------------------------------------
            OP_BRANCH: begin
                branch   = 1;
                alu_src  = 0;
                alu_ctrl = 4'b0001; // SUB — zero flag tells us if equal
            end

        endcase
    end

endmodule


// ------------------------------------------------------------
// 3. TOP LEVEL — wires datapath and control together
// ------------------------------------------------------------
module alu_core (
    input  [31:0] instruction, // full 32-bit RV32I instruction
    input  [31:0] rs1_data,    // value read from register rs1
    input  [31:0] rs2_data,    // value read from register rs2
    input  [31:0] imm,         // sign-extended immediate (from outside)
    output [31:0] alu_result,  // final computed value
    output        zero,        // branch condition flag
    output        reg_write,   // to register file: enable write
    output        mem_read,    // to memory: enable read
    output        mem_write,   // to memory: enable write
    output        mem_to_reg,  // writeback mux select
    output        branch       // to PC logic: branch taken?
);

    // decode instruction fields
    wire [6:0] opcode   = instruction[6:0];
    wire [2:0] funct3   = instruction[14:12];
    wire       funct7_5 = instruction[30];

    // internal wires
    wire [3:0] alu_ctrl;
    wire       alu_src;
    wire [31:0] alu_b;  // second operand mux output

    // control path instance
    control ctrl (
        .opcode    (opcode),
        .funct3    (funct3),
        .funct7_5  (funct7_5),
        .alu_ctrl  (alu_ctrl),
        .reg_write (reg_write),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .mem_to_reg(mem_to_reg),
        .branch    (branch),
        .alu_src   (alu_src)
    );

    // operand B mux: rs2 or immediate
    assign alu_b = alu_src ? imm : rs2_data;

    // datapath instance
    alu datapath (
        .a        (rs1_data),
        .b        (alu_b),
        .alu_ctrl (alu_ctrl),
        .result   (alu_result),
        .zero     (zero)
    );

endmodule
