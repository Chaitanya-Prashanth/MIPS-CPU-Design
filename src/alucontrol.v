`timescale 1ns/10ps
// alucontrol.v — decodes aluop + funct into 3-bit alucont signal
//
// aluop encoding (from controller):
//   00 = ADD  (fetch/decode PC increment, memory address)
//   01 = SUB  (branch comparison: BEQ)
//   10 = R-type (look at funct field)
//   11 = ADD  (addi — immediate add)
//
// funct field encoding (R-type only):
//   100000 = add
//   100010 = sub
//   100100 = and
//   100101 = or
//   101010 = slt
//
// alucont output:
//   000 = AND
//   001 = OR
//   010 = ADD
//   110 = SUB
//   111 = SLT

module alucontrol (aluop, funct, alucont);
    input  [1:0] aluop;
    input  [5:0] funct;
    output [2:0] alucont;

    reg [2:0] alucont;

    always @(*) begin
        case (aluop)
            2'b00: alucont = 3'b010;   // ADD (memory addr, PC+1)
            2'b01: alucont = 3'b110;   // SUB (beq comparison)
            2'b11: alucont = 3'b010;   // ADD (addi)
            2'b10: begin               // R-type: decode funct
                case (funct)
                    6'b100000: alucont = 3'b010; // add
                    6'b100010: alucont = 3'b110; // sub
                    6'b100100: alucont = 3'b000; // and
                    6'b100101: alucont = 3'b001; // or
                    6'b101010: alucont = 3'b111; // slt
                    default:   alucont = 3'b010; // default add
                endcase
            end
            default: alucont = 3'b010;
        endcase
    end
endmodule
