`timescale 1ns/10ps
// controller.v — multicycle MIPS controller FSM
//
// States (matches Figure 3 in spec):
//   S0–S3  : Instruction Fetch (4 bytes, one per cycle)
//   S4     : Instruction Decode / Register Fetch
//   S5     : Memory Address Computation (LB/SB)
//   S6     : LB Memory Access
//   S7     : LB Write-back
//   S8     : SB Memory Access
//   S9     : R-type Execute
//   S10    : R-type Completion (RegWrite)
//   S11    : BEQ Branch Completion
//   S12    : Jump Completion
//
// ADDI: uses S9 path with aluop=11, then S10 with RegDst=0

module controller (clk, reset, op, zero,
                   memread, memwrite,
                   alusrca, memtoreg, iord, pcen,
                   regwrite, regdst,
                   pcsource, alusrcb, aluop, irwrite);

    // Inputs
    input        clk, reset;
    input  [5:0] op;
    input        zero;

    // Outputs
    output        alusrca;
    output [1:0]  alusrcb;
    output [1:0]  aluop;
    output        iord;
    output [3:0]  irwrite;
    output        memread;
    output        memwrite;
    output        memtoreg;
    output [1:0]  pcsource;
    output        regwrite;
    output        regdst;
    output        pcen;

    // Registered outputs
    reg        alusrca;
    reg [1:0]  alusrcb;
    reg [1:0]  aluop;
    reg        branch;
    reg        iord;
    reg [3:0]  irwrite;
    reg        memread;
    reg        memwrite;
    reg        memtoreg;
    reg [1:0]  pcsource;
    reg        regwrite;
    reg        regdst;
    reg        pcwrite, pcwritecond;

    // PCEn: write PC on unconditional pcwrite OR on branch taken
    assign pcen = pcwrite | (pcwritecond & zero);

    // State encoding
    parameter S0  = 4'd0;
    parameter S1  = 4'd1;
    parameter S2  = 4'd2;
    parameter S3  = 4'd3;
    parameter S4  = 4'd4;
    parameter S5  = 4'd5;
    parameter S6  = 4'd6;
    parameter S7  = 4'd7;
    parameter S8  = 4'd8;
    parameter S9  = 4'd9;
    parameter S10 = 4'd10;
    parameter S11 = 4'd11;
    parameter S12 = 4'd12;

    // Opcode parameters
    parameter OP_RTYPE = 6'b000000;
    parameter OP_ADDI  = 6'b001000;
    parameter OP_BEQ   = 6'b000100;
    parameter OP_J     = 6'b000010;
    parameter OP_LB    = 6'b100000;
    parameter OP_SB    = 6'b110000;

    // State registers
    reg [3:0] state, nextstate;

    // -------------------------
    // State register (sequential)
    // -------------------------
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= nextstate;
    end

    // -------------------------
    // Next-state logic
    // -------------------------
    always @(*) begin
        case (state)
            S0:  nextstate = S1;
            S1:  nextstate = S2;
            S2:  nextstate = S3;
            S3:  nextstate = S4;
            S4: begin
                case (op)
                    OP_LB:    nextstate = S5;
                    OP_SB:    nextstate = S5;
                    OP_RTYPE: nextstate = S9;
                    OP_ADDI:  nextstate = S9;
                    OP_BEQ:   nextstate = S11;
                    OP_J:     nextstate = S12;
                    default:  nextstate = S0;  // undefined — restart
                endcase
            end
            S5: begin
                if (op == OP_LB)
                    nextstate = S6;
                else
                    nextstate = S8;   // SB
            end
            S6:  nextstate = S7;
            S7:  nextstate = S0;
            S8:  nextstate = S0;
            S9:  nextstate = S10;
            S10: nextstate = S0;
            S11: nextstate = S0;
            S12: nextstate = S0;
            default: nextstate = S0;
        endcase
    end

    // -------------------------
    // Output logic (registered — Moore FSM)
    // -------------------------
    always @(*) begin
        // Safe defaults — all signals deasserted
        pcwrite     = 1'b0;
        pcwritecond = 1'b0;
        iord        = 1'b0;
        memread     = 1'b0;
        memwrite    = 1'b0;
        irwrite     = 4'b0000;
        regdst      = 1'b0;
        regwrite    = 1'b0;
        memtoreg    = 1'b0;
        alusrca     = 1'b0;
        alusrcb     = 2'b00;
        aluop       = 2'b00;
        pcsource    = 2'b00;
        branch      = 1'b0;

        case (state)
            // ---- Fetch byte 0 (IR[7:0]) ----
            S0: begin
                memread  = 1'b1;
                irwrite  = 4'b0001;   // write IR byte 0
                alusrca  = 1'b0;      // PC
                alusrcb  = 2'b01;     // constant 1 (increment)
                aluop    = 2'b00;     // ADD
                pcwrite  = 1'b1;
                pcsource = 2'b00;     // ALUResult (PC+1)
            end

            // ---- Fetch byte 1 (IR[15:8]) ----
            S1: begin
                memread  = 1'b1;
                irwrite  = 4'b0010;
                alusrca  = 1'b0;
                alusrcb  = 2'b01;
                aluop    = 2'b00;
                pcwrite  = 1'b1;
                pcsource = 2'b00;
            end

            // ---- Fetch byte 2 (IR[23:16]) ----
            S2: begin
                memread  = 1'b1;
                irwrite  = 4'b0100;
                alusrca  = 1'b0;
                alusrcb  = 2'b01;
                aluop    = 2'b00;
                pcwrite  = 1'b1;
                pcsource = 2'b00;
            end

            // ---- Fetch byte 3 (IR[31:24]) ----
            S3: begin
                memread  = 1'b1;
                irwrite  = 4'b1000;
                alusrca  = 1'b0;
                alusrcb  = 2'b01;
                aluop    = 2'b00;
                pcwrite  = 1'b1;
                pcsource = 2'b00;
            end

            // ---- Decode / Register Fetch ----
            // ALU computes PC + (Imm<<2) speculatively for branch
            S4: begin
                alusrca  = 1'b0;      // PC
                alusrcb  = 2'b11;     // Imm << 2
                aluop    = 2'b00;
            end

            // ---- Memory Address Computation (LB/SB) ----
            S5: begin
                alusrca  = 1'b1;      // register A
                alusrcb  = 2'b10;     // sign-extended immediate
                aluop    = 2'b00;     // ADD
            end

            // ---- LB Memory Read ----
            S6: begin
                memread  = 1'b1;
                iord     = 1'b1;      // address from ALUOut
            end

            // ---- LB Write-back ----
            S7: begin
                regdst   = 1'b0;      // destination = RT (instr[20:16])
                regwrite = 1'b1;
                memtoreg = 1'b1;      // write data from memory
            end

            // ---- SB Memory Write ----
            S8: begin
                memwrite = 1'b1;
                iord     = 1'b1;
            end

            // ---- Execute (R-type and ADDI) ----
            S9: begin
                alusrca  = 1'b1;       // register A
                alusrcb  = 2'b00;      // register B (R-type)
                // For ADDI: alusrcb should be immediate.
                // We distinguish via op in aluop assignment:
                aluop    = (op == OP_ADDI) ? 2'b00 : 2'b10;
                // Override srcb for ADDI
                alusrcb  = (op == OP_ADDI) ? 2'b10 : 2'b00;
            end

            // ---- R-type / ADDI Completion ----
            S10: begin
                regdst   = (op == OP_ADDI) ? 1'b0 : 1'b1; // RT for ADDI, RD for R-type
                regwrite = 1'b1;
                memtoreg = 1'b0;       // from ALUOut
            end

            // ---- BEQ Branch Completion ----
            S11: begin
                alusrca     = 1'b1;
                alusrcb     = 2'b00;
                aluop       = 2'b01;   // SUB for comparison
                branch      = 1'b1;
                pcwritecond = 1'b1;
                pcsource    = 2'b01;   // ALUOut (PC + imm<<2, computed in S4)
            end

            // ---- Jump Completion ----
            S12: begin
                pcwrite  = 1'b1;
                pcsource = 2'b10;      // constX4 (jump target)
            end

            default: begin
                // All outputs remain at safe defaults
            end
        endcase
    end

endmodule
