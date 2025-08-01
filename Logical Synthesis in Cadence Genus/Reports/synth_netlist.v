
// Generated by Cadence Genus(TM) Synthesis Solution 21.14-s082_1
// Generated on: Jul 29 2025 09:32:24 IST (Jul 29 2025 04:02:24 UTC)

// Verification Directory fv/PROCESSOR 

module PROCESSOR(clock, reset, zero);
  input clock, reset;
  output zero;
  wire clock, reset;
  wire zero;
  wire [31:0] IFU_module_PC;
  wire [3:0] alu_control;
  wire [31:0] instruction_code;
  wire IFU_module_n_41, UNCONNECTED, UNCONNECTED0, UNCONNECTED1,
       datapath_module_reg_file_module_n_48, n_0, n_1, n_2;
  wire n_3, n_4, n_5, n_8, n_10, n_11, n_12, n_13;
  wire n_14, n_15, n_17, n_18, n_19, n_20, n_21, n_25;
  wire n_26, n_39;
  OAI2BB1XL g6704__2398(.A0N (IFU_module_PC[3]), .A1N (n_21), .B0
       (n_20), .Y (n_39));
  AOI2BB1XL g6706__5107(.A0N (IFU_module_PC[3]), .A1N
       (IFU_module_PC[2]), .B0 (IFU_module_PC[4]), .Y (n_21));
  OR2X1 g6707__6260(.A (IFU_module_PC[4]), .B (IFU_module_PC[3]), .Y
       (datapath_module_reg_file_module_n_48));
  NAND2XL g6708__4319(.A (IFU_module_PC[3]), .B (IFU_module_PC[4]), .Y
       (n_26));
  NAND2X1 g6709__8428(.A (IFU_module_PC[3]), .B (IFU_module_PC[2]), .Y
       (n_25));
  NAND2XL g6710__5526(.A (IFU_module_PC[4]), .B (n_19), .Y (n_20));
  INVX1 g6711(.A (IFU_module_PC[3]), .Y (n_19));
  OAI21XL g6907__6783(.A0 (n_17), .A1 (alu_control[2]), .B0 (n_18), .Y
       (zero));
  NAND4XL g6908__3680(.A (n_39), .B (alu_control[0]), .C
       (alu_control[1]), .D (alu_control[2]), .Y (n_18));
  MXI2XL g6909__1617(.S0 (alu_control[1]), .B (1'b0), .A
       (alu_control[0]), .Y (n_17));
  TLATNX1 \control_module_alu_control_reg[2] (.GN (n_15), .D (n_11), .Q
       (UNCONNECTED), .QN (alu_control[2]));
  TLATNX1 \control_module_alu_control_reg[0] (.GN (n_15), .D (n_8), .Q
       (alu_control[0]), .QN (UNCONNECTED0));
  TLATNX1 \control_module_alu_control_reg[1] (.GN (n_15), .D (n_14), .Q
       (alu_control[1]), .QN (UNCONNECTED1));
  NOR2XL g6914__2802(.A (n_13), .B (instruction_code[10]), .Y (n_15));
  OAI21XL g6915__1705(.A0 (n_5), .A1 (IFU_module_PC[4]), .B0 (n_13), .Y
       (n_14));
  NAND3XL g6916__5122(.A (datapath_module_reg_file_module_n_48), .B
       (n_12), .C (n_25), .Y (n_13));
  NAND2XL g6917__8246(.A (IFU_module_PC[4]), .B (IFU_module_n_41), .Y
       (n_12));
  INVX1 g6918(.A (n_10), .Y (n_11));
  AOI21XL g6919__7098(.A0 (n_3), .A1 (n_26), .B0 (n_5), .Y (n_10));
  OAI2BB1XL g6921__6131(.A0N (IFU_module_PC[4]), .A1N (n_26), .B0
       (n_25), .Y (n_8));
  OAI21XL g6922__1881(.A0 (n_2), .A1 (IFU_module_PC[2]), .B0 (n_4), .Y
       (IFU_module_n_41));
  MXI2X1 g6925__5115(.S0 (IFU_module_PC[4]), .B (n_3), .A (n_25), .Y
       (instruction_code[10]));
  INVX1 g6926(.A (n_4), .Y (n_5));
  NAND2X1 g6927__7482(.A (n_2), .B (IFU_module_PC[2]), .Y (n_4));
  INVX1 g6928(.A (n_25), .Y (n_3));
  INVX1 g6929(.A (IFU_module_PC[3]), .Y (n_2));
  DFFRHQX1 \IFU_module_PC_reg[2] (.RN (n_0), .CK (clock), .D (n_1), .Q
       (IFU_module_PC[2]));
  DFFRHQX1 \IFU_module_PC_reg[3] (.RN (n_0), .CK (clock), .D
       (IFU_module_n_41), .Q (IFU_module_PC[3]));
  DFFRHQX1 \IFU_module_PC_reg[4] (.RN (n_0), .CK (clock), .D
       (instruction_code[10]), .Q (IFU_module_PC[4]));
  INVXL g6611(.A (IFU_module_PC[2]), .Y (n_1));
  INVXL g6612(.A (reset), .Y (n_0));
endmodule

