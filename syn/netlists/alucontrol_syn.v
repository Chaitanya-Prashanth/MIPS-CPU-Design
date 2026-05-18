/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Thu Apr 23 17:42:33 2026
/////////////////////////////////////////////////////////////


module alucontrol ( aluop, funct, alucont );
  input [1:0] aluop;
  input [5:0] funct;
  output [2:0] alucont;
  wire   n1, n2, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n25, n26, n27;

  AND2X2 U3 ( .A(n2), .B(n27), .Y(n12) );
  INVX2 U4 ( .A(n11), .Y(n1) );
  INVX2 U5 ( .A(aluop[0]), .Y(n2) );
  INVX2 U9 ( .A(funct[0]), .Y(n6) );
  OAI21X1 U10 ( .A(n27), .B(n2), .C(n7), .Y(alucont[2]) );
  NAND3X1 U11 ( .A(n1), .B(n6), .C(n8), .Y(n7) );
  NOR2X1 U12 ( .A(n25), .B(n23), .Y(n8) );
  OAI22X1 U13 ( .A(alucont[1]), .B(n6), .C(n9), .D(n10), .Y(alucont[0]) );
  NAND2X1 U14 ( .A(n19), .B(n1), .Y(n10) );
  NAND3X1 U15 ( .A(n21), .B(n17), .C(n12), .Y(n11) );
  NAND3X1 U16 ( .A(n22), .B(n24), .C(n6), .Y(n9) );
  OR2X1 U17 ( .A(n13), .B(n14), .Y(alucont[1]) );
  NAND3X1 U18 ( .A(n21), .B(n27), .C(n23), .Y(n14) );
  NAND3X1 U19 ( .A(n2), .B(n16), .C(n15), .Y(n13) );
  NOR2X1 U20 ( .A(n25), .B(n19), .Y(n15) );
  INVX2 U21 ( .A(funct[1]), .Y(n16) );
  INVX2 U22 ( .A(n16), .Y(n17) );
  INVX2 U23 ( .A(funct[3]), .Y(n18) );
  INVX2 U24 ( .A(n18), .Y(n19) );
  INVX2 U25 ( .A(funct[5]), .Y(n20) );
  INVX2 U26 ( .A(n20), .Y(n21) );
  INVX2 U27 ( .A(funct[2]), .Y(n22) );
  INVX2 U28 ( .A(n22), .Y(n23) );
  INVX2 U29 ( .A(funct[4]), .Y(n24) );
  INVX2 U30 ( .A(n24), .Y(n25) );
  INVX2 U31 ( .A(aluop[1]), .Y(n26) );
  INVX2 U32 ( .A(n26), .Y(n27) );
endmodule

