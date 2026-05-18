/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Sat Apr 25 12:27:21 2026
/////////////////////////////////////////////////////////////


module mips ( clk, reset, memdata, memread, memwrite, adr, writedata );
  input [7:0] memdata;
  output [7:0] adr;
  output [7:0] writedata;
  input clk, reset;
  output memread, memwrite;
  wire   dp_n20, dp_n19, dp_n18, dp_n17, dp_n16, dp_n15, dp_n14, dp_n13,
         dp_n12, dp_n11, dp_n10, n445, n446, n447, n448, n449, n450, n451,
         n452, n453, n454, n455, n456, n457, n458, n459, n460, n461, n462,
         n463, n464, n465, n466, n467, n468, n469, n470, n471, n472, n473,
         n474, n475, n476, n477, n478, n479, n480, n481, n482, n483, n484,
         n485, n486, n487, n488, n489, n490, n491, n492, n493, n494, n495,
         n496, n497, n498, n499, n500, n501, n502, n503, n504, n505, n506,
         n507, n508, n509, n510, n511, n512, n513, n514, n515, n516, n517,
         n518, n519, n520, n521, n522, n523, n524, n525, n526, n527, n528,
         n529, n530, n531, n532, n533, n534, n535, n536, n537, n538, n539,
         n540, n541, n542, n543, n544, n545, n546, n547, n548, n549, n550,
         n551, n552, n553, n554, n555, n556, n557, n558, n559, n560, n561,
         n562, n563, n564, n565, n566, n567, n568, n569, n570, n571, n572,
         n573, n574, n575, n576, n577, n578, n579, n580, n581, n582, n583,
         n584, n585, n586, n587, n588, n589, n590, n591, n592, n593, n594,
         n595, n596, n597, n598, n599, n600, n601, n602, n603, n604, n605,
         n606, n607, n608, n609, n610, n611, n612, n613, n614, n615, n616,
         n617, n618, n619, n620, n621, n622, n623, n624, n625, n626, n627,
         n628, n629, n630, n631, n632, n633, n634, n635, n636, n637, n638,
         n639, n640, n641, n642, n643, n644, n645, n646, n647, n648, n649,
         n650, n651, n652, n653, n654, n655, n656, n657, n658, n659, n660,
         n661, n662, n663, n664, n665, n666, n667, n668, n669, n670, n671,
         n672, n673, n674, n675, n676, n677, n678, n679, n680, n681, n682,
         n683, n684, n685, n686, n687, n688, n689, n690, n691, n692, n693,
         n694, n695, n696, n697, n698, n699, n700, n701, n702, n703, n704,
         n705, n706, n707, n708, n709, n710, n711, n712, n713, n714, n715,
         n716, n717, n718, n719, n720, n721, n722, n723, n724, n725, n726,
         n727, n728, n729, n730, n731, n732, n733, n734, n735, n736, n737,
         n738, n739, n740, n741, n742, n743, n744, n745, n746, n747, n748,
         n749, n750, n751, n752, n753, n754, n755, n756, n757, n758, n759,
         n760, n761, n762, n763, n764, n765, n766, n767, n768, n769, n770,
         n771, n772, n773, n774, n775, n776, n777, n778, n779, n780, n781,
         n782, n783, n784, n785, n786, n787, n788, n789, n790, n791, n792,
         n793, n794, n795, n796, n797, n798, n799, n800, n801, n802, n803,
         n804, n805, n806, n807, n808, n809, n810, n811, n812, n813, n814,
         n815, n816, n817, n818, n819, n820, n821, n822, n823, n824, n825,
         n826, n827, n828, n829, n830, n831, n832, n833, n834, n835, n836,
         n837, n838, n839, n840, n841, n842, n843, n844, n845, n846, n847,
         n848, n849, n850, n851, n852, n853, n854, n855, n856, n857, n858,
         n859, n860, n861, n862, n863, n864, n865, n866, n867, n868, n869,
         n870, n871, n872, n873, n874, n875, n876, n877, n878, n879, n880,
         n881, n882, n883, n884, n885, n886, n887, n888, n889, n890, n891,
         n892, n893, n894, n895, n896, n897, n898, n899, n900, n901, n902,
         n903, n904, n905, n906, n907, n908, n909, n910, n911, n912, n913,
         n914, n915, n916, n917, n918, n919, n920, n921, n922, n923, n924,
         n925, n926, n927, n928, n929, n930, n931, n932, n933, n934, n935,
         n936, n937, n938, n939, n940, n941, n942, n943, n944, n945, n946,
         n947, n948, n949, n950, n951, n952, n953, n954, n955, n956, n957,
         n958, n959, n960, n961, n962, n963, n964, n965, n966, n967, n968,
         n969, n970, n971, n972, n973, n974, n975, n976, n977, n978, n979,
         n980, n981, n982, n983, n984, n985, n986, n987, n988, n989, n990,
         n991, n992, n993, n994, n995, n996, n997, n998, n999, n1000, n1001,
         n1002, n1003, n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011,
         n1012, n1013, n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021;
  wire   [31:0] instr;
  wire   [3:0] cont_nextstate;
  wire   [3:0] cont_state;
  wire   [7:0] dp_aluout;
  wire   [7:0] dp_rd2;
  wire   [7:0] dp_a;
  wire   [7:0] dp_rd1;
  wire   [7:0] dp_md;
  wire   [7:0] dp_pc;
  wire   [55:0] dp_rf_REGS;

  DFFPOSX1 dp_ir0_q_reg_7_ ( .D(n468), .CLK(clk), .Q(instr[31]) );
  DFFPOSX1 dp_ir0_q_reg_2_ ( .D(n467), .CLK(clk), .Q(instr[26]) );
  DFFPOSX1 dp_ir0_q_reg_3_ ( .D(n466), .CLK(clk), .Q(instr[27]) );
  DFFPOSX1 dp_ir0_q_reg_4_ ( .D(n465), .CLK(clk), .Q(instr[28]) );
  DFFPOSX1 dp_ir0_q_reg_5_ ( .D(n464), .CLK(clk), .Q(instr[29]) );
  DFFPOSX1 dp_ir0_q_reg_6_ ( .D(n463), .CLK(clk), .Q(instr[30]) );
  DFFPOSX1 dp_ir3_q_reg_0_ ( .D(n462), .CLK(clk), .Q(instr[0]) );
  DFFPOSX1 dp_ir3_q_reg_1_ ( .D(n461), .CLK(clk), .Q(instr[1]) );
  DFFPOSX1 dp_ir3_q_reg_2_ ( .D(n460), .CLK(clk), .Q(instr[2]) );
  DFFPOSX1 dp_ir3_q_reg_3_ ( .D(n459), .CLK(clk), .Q(instr[3]) );
  DFFPOSX1 dp_ir3_q_reg_4_ ( .D(n458), .CLK(clk), .Q(instr[4]) );
  DFFPOSX1 dp_ir3_q_reg_5_ ( .D(n457), .CLK(clk), .Q(instr[5]) );
  DFFPOSX1 dp_ir3_q_reg_6_ ( .D(n456), .CLK(clk), .Q(dp_n20) );
  DFFPOSX1 dp_ir3_q_reg_7_ ( .D(n455), .CLK(clk), .Q(dp_n19) );
  DFFPOSX1 dp_ir2_q_reg_3_ ( .D(n454), .CLK(clk), .Q(dp_n18) );
  DFFPOSX1 dp_ir2_q_reg_4_ ( .D(n453), .CLK(clk), .Q(dp_n17) );
  DFFPOSX1 dp_ir2_q_reg_5_ ( .D(n452), .CLK(clk), .Q(dp_n16) );
  DFFPOSX1 dp_ir1_q_reg_0_ ( .D(n451), .CLK(clk), .Q(dp_n15) );
  DFFPOSX1 dp_ir1_q_reg_1_ ( .D(n450), .CLK(clk), .Q(dp_n14) );
  DFFPOSX1 dp_ir1_q_reg_2_ ( .D(n449), .CLK(clk), .Q(dp_n13) );
  DFFPOSX1 dp_ir1_q_reg_5_ ( .D(n448), .CLK(clk), .Q(dp_n12) );
  DFFPOSX1 dp_ir1_q_reg_6_ ( .D(n447), .CLK(clk), .Q(dp_n11) );
  DFFPOSX1 dp_ir1_q_reg_7_ ( .D(n446), .CLK(clk), .Q(dp_n10) );
  DFFSR cont_state_reg_3_ ( .D(cont_nextstate[3]), .CLK(clk), .R(n445), .S(
        1'b1), .Q(cont_state[3]) );
  DFFSR cont_state_reg_2_ ( .D(cont_nextstate[2]), .CLK(clk), .R(n445), .S(
        1'b1), .Q(cont_state[2]) );
  DFFSR cont_state_reg_1_ ( .D(cont_nextstate[1]), .CLK(clk), .R(n445), .S(
        1'b1), .Q(cont_state[1]) );
  DFFSR cont_state_reg_0_ ( .D(cont_nextstate[0]), .CLK(clk), .R(n445), .S(
        1'b1), .Q(cont_state[0]) );
  DFFPOSX1 dp_mdr_q_reg_0_ ( .D(n542), .CLK(clk), .Q(dp_md[0]) );
  DFFPOSX1 dp_mdr_q_reg_1_ ( .D(n544), .CLK(clk), .Q(dp_md[1]) );
  DFFPOSX1 dp_mdr_q_reg_2_ ( .D(n556), .CLK(clk), .Q(dp_md[2]) );
  DFFPOSX1 dp_mdr_q_reg_3_ ( .D(n546), .CLK(clk), .Q(dp_md[3]) );
  DFFPOSX1 dp_mdr_q_reg_4_ ( .D(n548), .CLK(clk), .Q(dp_md[4]) );
  DFFPOSX1 dp_mdr_q_reg_5_ ( .D(n550), .CLK(clk), .Q(dp_md[5]) );
  DFFPOSX1 dp_mdr_q_reg_6_ ( .D(n552), .CLK(clk), .Q(dp_md[6]) );
  DFFPOSX1 dp_mdr_q_reg_7_ ( .D(n554), .CLK(clk), .Q(dp_md[7]) );
  DFFPOSX1 dp_areg_q_reg_7_ ( .D(dp_rd1[7]), .CLK(clk), .Q(dp_a[7]) );
  DFFPOSX1 dp_res_q_reg_7_ ( .D(n540), .CLK(clk), .Q(dp_aluout[7]) );
  DFFPOSX1 dp_rf_REGS_reg_7__7_ ( .D(n483), .CLK(clk), .Q(dp_rf_REGS[55]) );
  DFFPOSX1 dp_rf_REGS_reg_6__7_ ( .D(n482), .CLK(clk), .Q(dp_rf_REGS[47]) );
  DFFPOSX1 dp_rf_REGS_reg_5__7_ ( .D(n481), .CLK(clk), .Q(dp_rf_REGS[39]) );
  DFFPOSX1 dp_rf_REGS_reg_4__7_ ( .D(n480), .CLK(clk), .Q(dp_rf_REGS[31]) );
  DFFPOSX1 dp_rf_REGS_reg_3__7_ ( .D(n479), .CLK(clk), .Q(dp_rf_REGS[23]) );
  DFFPOSX1 dp_rf_REGS_reg_2__7_ ( .D(n478), .CLK(clk), .Q(dp_rf_REGS[15]) );
  DFFPOSX1 dp_rf_REGS_reg_1__7_ ( .D(n477), .CLK(clk), .Q(dp_rf_REGS[7]) );
  DFFPOSX1 dp_wrd_q_reg_7_ ( .D(dp_rd2[7]), .CLK(clk), .Q(writedata[7]) );
  DFFPOSX1 dp_pcreg_q_reg_0_ ( .D(n476), .CLK(clk), .Q(dp_pc[0]) );
  DFFPOSX1 dp_res_q_reg_0_ ( .D(n533), .CLK(clk), .Q(dp_aluout[0]) );
  DFFPOSX1 dp_rf_REGS_reg_7__0_ ( .D(n532), .CLK(clk), .Q(dp_rf_REGS[48]) );
  DFFPOSX1 dp_rf_REGS_reg_6__0_ ( .D(n531), .CLK(clk), .Q(dp_rf_REGS[40]) );
  DFFPOSX1 dp_rf_REGS_reg_5__0_ ( .D(n530), .CLK(clk), .Q(dp_rf_REGS[32]) );
  DFFPOSX1 dp_rf_REGS_reg_4__0_ ( .D(n529), .CLK(clk), .Q(dp_rf_REGS[24]) );
  DFFPOSX1 dp_rf_REGS_reg_3__0_ ( .D(n528), .CLK(clk), .Q(dp_rf_REGS[16]) );
  DFFPOSX1 dp_rf_REGS_reg_2__0_ ( .D(n527), .CLK(clk), .Q(dp_rf_REGS[8]) );
  DFFPOSX1 dp_rf_REGS_reg_1__0_ ( .D(n526), .CLK(clk), .Q(dp_rf_REGS[0]) );
  DFFPOSX1 dp_wrd_q_reg_0_ ( .D(dp_rd2[0]), .CLK(clk), .Q(writedata[0]) );
  DFFPOSX1 dp_areg_q_reg_0_ ( .D(dp_rd1[0]), .CLK(clk), .Q(dp_a[0]) );
  DFFPOSX1 dp_pcreg_q_reg_1_ ( .D(n475), .CLK(clk), .Q(dp_pc[1]) );
  DFFPOSX1 dp_res_q_reg_1_ ( .D(n534), .CLK(clk), .Q(dp_aluout[1]) );
  DFFPOSX1 dp_rf_REGS_reg_7__1_ ( .D(n525), .CLK(clk), .Q(dp_rf_REGS[49]) );
  DFFPOSX1 dp_rf_REGS_reg_6__1_ ( .D(n524), .CLK(clk), .Q(dp_rf_REGS[41]) );
  DFFPOSX1 dp_rf_REGS_reg_5__1_ ( .D(n523), .CLK(clk), .Q(dp_rf_REGS[33]) );
  DFFPOSX1 dp_rf_REGS_reg_4__1_ ( .D(n522), .CLK(clk), .Q(dp_rf_REGS[25]) );
  DFFPOSX1 dp_rf_REGS_reg_3__1_ ( .D(n521), .CLK(clk), .Q(dp_rf_REGS[17]) );
  DFFPOSX1 dp_rf_REGS_reg_2__1_ ( .D(n520), .CLK(clk), .Q(dp_rf_REGS[9]) );
  DFFPOSX1 dp_rf_REGS_reg_1__1_ ( .D(n519), .CLK(clk), .Q(dp_rf_REGS[1]) );
  DFFPOSX1 dp_wrd_q_reg_1_ ( .D(dp_rd2[1]), .CLK(clk), .Q(writedata[1]) );
  DFFPOSX1 dp_areg_q_reg_1_ ( .D(dp_rd1[1]), .CLK(clk), .Q(dp_a[1]) );
  DFFPOSX1 dp_pcreg_q_reg_2_ ( .D(n474), .CLK(clk), .Q(dp_pc[2]) );
  DFFPOSX1 dp_res_q_reg_2_ ( .D(n535), .CLK(clk), .Q(dp_aluout[2]) );
  DFFPOSX1 dp_rf_REGS_reg_7__2_ ( .D(n518), .CLK(clk), .Q(dp_rf_REGS[50]) );
  DFFPOSX1 dp_rf_REGS_reg_6__2_ ( .D(n517), .CLK(clk), .Q(dp_rf_REGS[42]) );
  DFFPOSX1 dp_rf_REGS_reg_5__2_ ( .D(n516), .CLK(clk), .Q(dp_rf_REGS[34]) );
  DFFPOSX1 dp_rf_REGS_reg_4__2_ ( .D(n515), .CLK(clk), .Q(dp_rf_REGS[26]) );
  DFFPOSX1 dp_rf_REGS_reg_3__2_ ( .D(n514), .CLK(clk), .Q(dp_rf_REGS[18]) );
  DFFPOSX1 dp_rf_REGS_reg_2__2_ ( .D(n513), .CLK(clk), .Q(dp_rf_REGS[10]) );
  DFFPOSX1 dp_rf_REGS_reg_1__2_ ( .D(n512), .CLK(clk), .Q(dp_rf_REGS[2]) );
  DFFPOSX1 dp_wrd_q_reg_2_ ( .D(dp_rd2[2]), .CLK(clk), .Q(writedata[2]) );
  DFFPOSX1 dp_areg_q_reg_2_ ( .D(dp_rd1[2]), .CLK(clk), .Q(dp_a[2]) );
  DFFPOSX1 dp_pcreg_q_reg_3_ ( .D(n473), .CLK(clk), .Q(dp_pc[3]) );
  DFFPOSX1 dp_res_q_reg_3_ ( .D(n536), .CLK(clk), .Q(dp_aluout[3]) );
  DFFPOSX1 dp_rf_REGS_reg_7__3_ ( .D(n511), .CLK(clk), .Q(dp_rf_REGS[51]) );
  DFFPOSX1 dp_rf_REGS_reg_6__3_ ( .D(n510), .CLK(clk), .Q(dp_rf_REGS[43]) );
  DFFPOSX1 dp_rf_REGS_reg_5__3_ ( .D(n509), .CLK(clk), .Q(dp_rf_REGS[35]) );
  DFFPOSX1 dp_rf_REGS_reg_4__3_ ( .D(n508), .CLK(clk), .Q(dp_rf_REGS[27]) );
  DFFPOSX1 dp_rf_REGS_reg_3__3_ ( .D(n507), .CLK(clk), .Q(dp_rf_REGS[19]) );
  DFFPOSX1 dp_rf_REGS_reg_2__3_ ( .D(n506), .CLK(clk), .Q(dp_rf_REGS[11]) );
  DFFPOSX1 dp_rf_REGS_reg_1__3_ ( .D(n505), .CLK(clk), .Q(dp_rf_REGS[3]) );
  DFFPOSX1 dp_wrd_q_reg_3_ ( .D(dp_rd2[3]), .CLK(clk), .Q(writedata[3]) );
  DFFPOSX1 dp_areg_q_reg_3_ ( .D(dp_rd1[3]), .CLK(clk), .Q(dp_a[3]) );
  DFFPOSX1 dp_pcreg_q_reg_4_ ( .D(n472), .CLK(clk), .Q(dp_pc[4]) );
  DFFPOSX1 dp_res_q_reg_4_ ( .D(n537), .CLK(clk), .Q(dp_aluout[4]) );
  DFFPOSX1 dp_rf_REGS_reg_7__4_ ( .D(n504), .CLK(clk), .Q(dp_rf_REGS[52]) );
  DFFPOSX1 dp_rf_REGS_reg_6__4_ ( .D(n503), .CLK(clk), .Q(dp_rf_REGS[44]) );
  DFFPOSX1 dp_rf_REGS_reg_5__4_ ( .D(n502), .CLK(clk), .Q(dp_rf_REGS[36]) );
  DFFPOSX1 dp_rf_REGS_reg_4__4_ ( .D(n501), .CLK(clk), .Q(dp_rf_REGS[28]) );
  DFFPOSX1 dp_rf_REGS_reg_3__4_ ( .D(n500), .CLK(clk), .Q(dp_rf_REGS[20]) );
  DFFPOSX1 dp_rf_REGS_reg_2__4_ ( .D(n499), .CLK(clk), .Q(dp_rf_REGS[12]) );
  DFFPOSX1 dp_rf_REGS_reg_1__4_ ( .D(n498), .CLK(clk), .Q(dp_rf_REGS[4]) );
  DFFPOSX1 dp_wrd_q_reg_4_ ( .D(dp_rd2[4]), .CLK(clk), .Q(writedata[4]) );
  DFFPOSX1 dp_areg_q_reg_4_ ( .D(dp_rd1[4]), .CLK(clk), .Q(dp_a[4]) );
  DFFPOSX1 dp_pcreg_q_reg_5_ ( .D(n471), .CLK(clk), .Q(dp_pc[5]) );
  DFFPOSX1 dp_res_q_reg_5_ ( .D(n538), .CLK(clk), .Q(dp_aluout[5]) );
  DFFPOSX1 dp_rf_REGS_reg_7__5_ ( .D(n497), .CLK(clk), .Q(dp_rf_REGS[53]) );
  DFFPOSX1 dp_rf_REGS_reg_6__5_ ( .D(n496), .CLK(clk), .Q(dp_rf_REGS[45]) );
  DFFPOSX1 dp_rf_REGS_reg_5__5_ ( .D(n495), .CLK(clk), .Q(dp_rf_REGS[37]) );
  DFFPOSX1 dp_rf_REGS_reg_4__5_ ( .D(n494), .CLK(clk), .Q(dp_rf_REGS[29]) );
  DFFPOSX1 dp_rf_REGS_reg_3__5_ ( .D(n493), .CLK(clk), .Q(dp_rf_REGS[21]) );
  DFFPOSX1 dp_rf_REGS_reg_2__5_ ( .D(n492), .CLK(clk), .Q(dp_rf_REGS[13]) );
  DFFPOSX1 dp_rf_REGS_reg_1__5_ ( .D(n491), .CLK(clk), .Q(dp_rf_REGS[5]) );
  DFFPOSX1 dp_wrd_q_reg_5_ ( .D(dp_rd2[5]), .CLK(clk), .Q(writedata[5]) );
  DFFPOSX1 dp_areg_q_reg_5_ ( .D(dp_rd1[5]), .CLK(clk), .Q(dp_a[5]) );
  DFFPOSX1 dp_pcreg_q_reg_6_ ( .D(n470), .CLK(clk), .Q(dp_pc[6]) );
  DFFPOSX1 dp_res_q_reg_6_ ( .D(n539), .CLK(clk), .Q(dp_aluout[6]) );
  DFFPOSX1 dp_rf_REGS_reg_7__6_ ( .D(n490), .CLK(clk), .Q(dp_rf_REGS[54]) );
  DFFPOSX1 dp_rf_REGS_reg_6__6_ ( .D(n489), .CLK(clk), .Q(dp_rf_REGS[46]) );
  DFFPOSX1 dp_rf_REGS_reg_5__6_ ( .D(n488), .CLK(clk), .Q(dp_rf_REGS[38]) );
  DFFPOSX1 dp_rf_REGS_reg_4__6_ ( .D(n487), .CLK(clk), .Q(dp_rf_REGS[30]) );
  DFFPOSX1 dp_rf_REGS_reg_3__6_ ( .D(n486), .CLK(clk), .Q(dp_rf_REGS[22]) );
  DFFPOSX1 dp_rf_REGS_reg_2__6_ ( .D(n485), .CLK(clk), .Q(dp_rf_REGS[14]) );
  DFFPOSX1 dp_rf_REGS_reg_1__6_ ( .D(n484), .CLK(clk), .Q(dp_rf_REGS[6]) );
  DFFPOSX1 dp_wrd_q_reg_6_ ( .D(dp_rd2[6]), .CLK(clk), .Q(writedata[6]) );
  DFFPOSX1 dp_areg_q_reg_6_ ( .D(dp_rd1[6]), .CLK(clk), .Q(dp_a[6]) );
  DFFPOSX1 dp_pcreg_q_reg_7_ ( .D(n469), .CLK(clk), .Q(dp_pc[7]) );
  INVX2 U588 ( .A(dp_n12), .Y(n1017) );
  BUFX2 U589 ( .A(n708), .Y(n731) );
  BUFX2 U590 ( .A(n788), .Y(n801) );
  INVX2 U591 ( .A(dp_n15), .Y(n1014) );
  BUFX2 U592 ( .A(n975), .Y(n982) );
  INVX1 U593 ( .A(n648), .Y(n636) );
  INVX1 U594 ( .A(n727), .Y(n730) );
  INVX1 U595 ( .A(dp_rf_REGS[30]), .Y(n790) );
  INVX1 U596 ( .A(dp_rf_REGS[29]), .Y(n781) );
  INVX1 U597 ( .A(dp_rf_REGS[20]), .Y(n770) );
  INVX1 U598 ( .A(dp_rf_REGS[26]), .Y(n757) );
  INVX1 U599 ( .A(dp_rf_REGS[25]), .Y(n749) );
  INVX1 U600 ( .A(dp_rf_REGS[24]), .Y(n741) );
  INVX1 U601 ( .A(n725), .Y(n733) );
  INVX1 U602 ( .A(n794), .Y(n803) );
  INVX1 U603 ( .A(n958), .Y(n984) );
  INVX1 U604 ( .A(n854), .Y(n852) );
  INVX1 U605 ( .A(n679), .Y(n665) );
  INVX1 U606 ( .A(cont_state[2]), .Y(n564) );
  INVX1 U607 ( .A(n650), .Y(n671) );
  INVX1 U608 ( .A(n642), .Y(n658) );
  INVX1 U609 ( .A(dp_n10), .Y(n1020) );
  INVX1 U610 ( .A(instr[5]), .Y(n1000) );
  INVX1 U611 ( .A(memdata[0]), .Y(n541) );
  INVX1 U612 ( .A(n553), .Y(n554) );
  INVX1 U613 ( .A(reset), .Y(n445) );
  BUFX2 U614 ( .A(n897), .Y(n928) );
  BUFX2 U615 ( .A(n895), .Y(n926) );
  BUFX2 U616 ( .A(n901), .Y(n934) );
  BUFX2 U617 ( .A(n903), .Y(n936) );
  BUFX2 U618 ( .A(n905), .Y(n938) );
  INVX2 U619 ( .A(n865), .Y(n862) );
  INVX2 U620 ( .A(n570), .Y(n581) );
  INVX2 U621 ( .A(n982), .Y(n948) );
  INVX1 U622 ( .A(n1004), .Y(n1001) );
  INVX2 U623 ( .A(n924), .Y(n923) );
  INVX1 U624 ( .A(n1021), .Y(n1019) );
  INVX1 U625 ( .A(n994), .Y(n992) );
  INVX2 U626 ( .A(n796), .Y(n800) );
  INVX2 U627 ( .A(dp_rf_REGS[22]), .Y(n786) );
  INVX2 U628 ( .A(dp_rf_REGS[28]), .Y(n773) );
  INVX2 U629 ( .A(dp_rf_REGS[31]), .Y(n804) );
  INVX2 U630 ( .A(dp_n14), .Y(n1015) );
  INVX2 U631 ( .A(dp_rf_REGS[18]), .Y(n754) );
  INVX2 U632 ( .A(dp_rf_REGS[27]), .Y(n765) );
  INVX2 U633 ( .A(dp_n13), .Y(n1016) );
  INVX2 U634 ( .A(dp_rf_REGS[21]), .Y(n778) );
  INVX2 U635 ( .A(dp_rf_REGS[23]), .Y(n797) );
  INVX2 U636 ( .A(cont_state[0]), .Y(n941) );
  INVX2 U637 ( .A(instr[28]), .Y(n990) );
  INVX2 U638 ( .A(instr[4]), .Y(n999) );
  INVX2 U639 ( .A(dp_rf_REGS[17]), .Y(n746) );
  INVX2 U640 ( .A(instr[0]), .Y(n995) );
  INVX2 U641 ( .A(instr[2]), .Y(n997) );
  INVX2 U642 ( .A(dp_rf_REGS[16]), .Y(n738) );
  INVX2 U643 ( .A(instr[30]), .Y(n993) );
  INVX2 U644 ( .A(instr[27]), .Y(n989) );
  INVX2 U645 ( .A(cont_state[1]), .Y(n680) );
  INVX2 U646 ( .A(dp_rf_REGS[19]), .Y(n762) );
  INVX2 U647 ( .A(n555), .Y(n556) );
  INVX2 U648 ( .A(n541), .Y(n542) );
  INVX2 U649 ( .A(n543), .Y(n544) );
  INVX1 U650 ( .A(memdata[6]), .Y(n551) );
  INVX1 U651 ( .A(memdata[7]), .Y(n553) );
  INVX2 U652 ( .A(memdata[1]), .Y(n543) );
  INVX2 U653 ( .A(memdata[2]), .Y(n555) );
  INVX1 U654 ( .A(memdata[3]), .Y(n545) );
  INVX1 U655 ( .A(memdata[4]), .Y(n547) );
  INVX1 U656 ( .A(memdata[5]), .Y(n549) );
  INVX2 U657 ( .A(n545), .Y(n546) );
  INVX2 U658 ( .A(n547), .Y(n548) );
  INVX2 U659 ( .A(n549), .Y(n550) );
  INVX2 U660 ( .A(n551), .Y(n552) );
  INVX1 U661 ( .A(n604), .Y(n609) );
  INVX1 U662 ( .A(n670), .Y(n678) );
  INVX1 U663 ( .A(n621), .Y(n627) );
  INVX1 U664 ( .A(n586), .Y(n591) );
  INVX1 U665 ( .A(n612), .Y(n618) );
  INVX1 U666 ( .A(n557), .Y(n467) );
  NOR2X1 U667 ( .A(n995), .B(n673), .Y(n650) );
  INVX1 U668 ( .A(cont_state[3]), .Y(n565) );
  NAND2X1 U669 ( .A(n565), .B(n680), .Y(n1012) );
  NAND2X1 U670 ( .A(n564), .B(n941), .Y(n1005) );
  NOR2X1 U671 ( .A(n1012), .B(n1005), .Y(n994) );
  OAI22X1 U672 ( .A(n992), .B(n556), .C(instr[26]), .D(n994), .Y(n557) );
  NAND2X1 U673 ( .A(cont_state[3]), .B(n680), .Y(n940) );
  NAND2X1 U674 ( .A(cont_state[0]), .B(n564), .Y(n1013) );
  NOR2X1 U675 ( .A(n940), .B(n1013), .Y(n567) );
  NAND2X1 U676 ( .A(n990), .B(n989), .Y(n558) );
  NOR2X1 U677 ( .A(instr[26]), .B(n558), .Y(n817) );
  NAND2X1 U678 ( .A(n817), .B(n993), .Y(n825) );
  NOR2X1 U679 ( .A(instr[31]), .B(n825), .Y(n559) );
  NAND2X1 U680 ( .A(instr[29]), .B(n559), .Y(n845) );
  NAND3X1 U681 ( .A(instr[5]), .B(n567), .C(n845), .Y(n560) );
  NOR2X1 U682 ( .A(instr[4]), .B(n560), .Y(n563) );
  NAND3X1 U683 ( .A(instr[1]), .B(n563), .C(n997), .Y(n573) );
  NOR2X1 U684 ( .A(instr[0]), .B(n573), .Y(n561) );
  NAND2X1 U685 ( .A(instr[3]), .B(n561), .Y(n659) );
  NOR2X1 U686 ( .A(instr[3]), .B(instr[1]), .Y(n562) );
  NAND3X1 U687 ( .A(instr[2]), .B(n563), .C(n562), .Y(n673) );
  NAND2X1 U688 ( .A(n659), .B(n673), .Y(n679) );
  NOR2X1 U689 ( .A(n564), .B(n1012), .Y(n568) );
  NAND2X1 U690 ( .A(cont_state[0]), .B(n568), .Y(n836) );
  OAI21X1 U691 ( .A(n1013), .B(n565), .C(n836), .Y(n632) );
  INVX1 U692 ( .A(dp_pc[3]), .Y(n966) );
  NAND2X1 U693 ( .A(dp_a[3]), .B(n632), .Y(n566) );
  OAI21X1 U694 ( .A(n632), .B(n966), .C(n566), .Y(n603) );
  INVX1 U695 ( .A(instr[1]), .Y(n996) );
  NAND2X1 U696 ( .A(n568), .B(n941), .Y(n820) );
  INVX1 U697 ( .A(n567), .Y(n841) );
  INVX1 U698 ( .A(n568), .Y(n569) );
  OAI21X1 U699 ( .A(n845), .B(n841), .C(n569), .Y(n570) );
  OAI21X1 U700 ( .A(cont_state[2]), .B(cont_state[3]), .C(n820), .Y(n582) );
  NOR2X1 U701 ( .A(n581), .B(n582), .Y(n633) );
  NOR2X1 U702 ( .A(cont_state[2]), .B(cont_state[3]), .Y(n947) );
  NOR2X1 U703 ( .A(n947), .B(n570), .Y(n634) );
  AOI22X1 U704 ( .A(instr[3]), .B(n633), .C(n634), .D(writedata[3]), .Y(n571)
         );
  OAI21X1 U705 ( .A(n996), .B(n820), .C(n571), .Y(n589) );
  INVX1 U706 ( .A(n589), .Y(n574) );
  NAND2X1 U707 ( .A(cont_state[3]), .B(cont_state[1]), .Y(n844) );
  NOR2X1 U708 ( .A(n1013), .B(n844), .Y(n980) );
  INVX1 U709 ( .A(n980), .Y(n572) );
  OAI21X1 U710 ( .A(instr[0]), .B(n573), .C(n572), .Y(n648) );
  AOI22X1 U711 ( .A(n574), .B(n636), .C(n648), .D(n589), .Y(n602) );
  INVX1 U712 ( .A(dp_pc[2]), .Y(n962) );
  NAND2X1 U713 ( .A(dp_a[2]), .B(n632), .Y(n575) );
  OAI21X1 U714 ( .A(n632), .B(n962), .C(n575), .Y(n616) );
  AOI22X1 U715 ( .A(instr[2]), .B(n633), .C(n634), .D(writedata[2]), .Y(n576)
         );
  OAI21X1 U716 ( .A(n995), .B(n820), .C(n576), .Y(n615) );
  INVX1 U717 ( .A(n615), .Y(n577) );
  AOI22X1 U718 ( .A(n577), .B(n636), .C(n648), .D(n615), .Y(n611) );
  INVX1 U719 ( .A(dp_pc[1]), .Y(n956) );
  NAND2X1 U720 ( .A(dp_a[1]), .B(n632), .Y(n578) );
  OAI21X1 U721 ( .A(n632), .B(n956), .C(n578), .Y(n663) );
  AOI22X1 U722 ( .A(instr[1]), .B(n633), .C(n634), .D(writedata[1]), .Y(n667)
         );
  INVX1 U723 ( .A(n667), .Y(n579) );
  AOI22X1 U724 ( .A(n667), .B(n636), .C(n648), .D(n579), .Y(n661) );
  INVX1 U725 ( .A(dp_pc[0]), .Y(n954) );
  NAND2X1 U726 ( .A(dp_a[0]), .B(n632), .Y(n580) );
  OAI21X1 U727 ( .A(n632), .B(n954), .C(n580), .Y(n651) );
  INVX1 U728 ( .A(n633), .Y(n584) );
  OAI21X1 U729 ( .A(writedata[0]), .B(n582), .C(n581), .Y(n583) );
  OAI21X1 U730 ( .A(n584), .B(n995), .C(n583), .Y(n652) );
  INVX1 U731 ( .A(n652), .Y(n585) );
  AOI22X1 U732 ( .A(n585), .B(n636), .C(n648), .D(n652), .Y(n649) );
  NAND2X1 U733 ( .A(n603), .B(n589), .Y(n587) );
  OAI21X1 U734 ( .A(n673), .B(n587), .C(n671), .Y(n588) );
  OAI21X1 U735 ( .A(n603), .B(n589), .C(n588), .Y(n590) );
  OAI21X1 U736 ( .A(n679), .B(n591), .C(n590), .Y(n536) );
  INVX1 U737 ( .A(dp_pc[6]), .Y(n979) );
  NAND2X1 U738 ( .A(dp_a[6]), .B(n632), .Y(n592) );
  OAI21X1 U739 ( .A(n632), .B(n979), .C(n592), .Y(n630) );
  AOI22X1 U740 ( .A(n634), .B(writedata[6]), .C(n633), .D(dp_n20), .Y(n593) );
  OAI21X1 U741 ( .A(n999), .B(n820), .C(n593), .Y(n607) );
  INVX1 U742 ( .A(n607), .Y(n594) );
  AOI22X1 U743 ( .A(n594), .B(n636), .C(n648), .D(n607), .Y(n629) );
  INVX1 U744 ( .A(dp_pc[5]), .Y(n974) );
  NAND2X1 U745 ( .A(dp_a[5]), .B(n632), .Y(n595) );
  OAI21X1 U746 ( .A(n632), .B(n974), .C(n595), .Y(n676) );
  INVX1 U747 ( .A(instr[3]), .Y(n998) );
  AOI22X1 U748 ( .A(instr[5]), .B(n633), .C(n634), .D(writedata[5]), .Y(n596)
         );
  OAI21X1 U749 ( .A(n998), .B(n820), .C(n596), .Y(n675) );
  INVX1 U750 ( .A(n675), .Y(n597) );
  AOI22X1 U751 ( .A(n597), .B(n636), .C(n648), .D(n675), .Y(n669) );
  INVX1 U752 ( .A(dp_pc[4]), .Y(n970) );
  NAND2X1 U753 ( .A(dp_a[4]), .B(n632), .Y(n598) );
  OAI21X1 U754 ( .A(n632), .B(n970), .C(n598), .Y(n625) );
  AOI22X1 U755 ( .A(instr[4]), .B(n633), .C(n634), .D(writedata[4]), .Y(n599)
         );
  OAI21X1 U756 ( .A(n997), .B(n820), .C(n599), .Y(n624) );
  INVX1 U757 ( .A(n624), .Y(n600) );
  AOI22X1 U758 ( .A(n600), .B(n636), .C(n648), .D(n624), .Y(n620) );
  FAX1 U759 ( .A(n603), .B(n602), .C(n601), .YC(n619), .YS(n586) );
  NAND2X1 U760 ( .A(n630), .B(n607), .Y(n605) );
  OAI21X1 U761 ( .A(n673), .B(n605), .C(n671), .Y(n606) );
  OAI21X1 U762 ( .A(n630), .B(n607), .C(n606), .Y(n608) );
  OAI21X1 U763 ( .A(n679), .B(n609), .C(n608), .Y(n539) );
  FAX1 U764 ( .A(n616), .B(n611), .C(n610), .YC(n601), .YS(n612) );
  NAND2X1 U765 ( .A(n616), .B(n615), .Y(n613) );
  OAI21X1 U766 ( .A(n673), .B(n613), .C(n671), .Y(n614) );
  OAI21X1 U767 ( .A(n616), .B(n615), .C(n614), .Y(n617) );
  OAI21X1 U768 ( .A(n679), .B(n618), .C(n617), .Y(n535) );
  FAX1 U769 ( .A(n625), .B(n620), .C(n619), .YC(n668), .YS(n621) );
  NAND2X1 U770 ( .A(n625), .B(n624), .Y(n622) );
  OAI21X1 U771 ( .A(n673), .B(n622), .C(n671), .Y(n623) );
  OAI21X1 U772 ( .A(n625), .B(n624), .C(n623), .Y(n626) );
  OAI21X1 U773 ( .A(n679), .B(n627), .C(n626), .Y(n537) );
  FAX1 U774 ( .A(n630), .B(n629), .C(n628), .YC(n641), .YS(n604) );
  INVX1 U775 ( .A(dp_pc[7]), .Y(n986) );
  NAND2X1 U776 ( .A(dp_a[7]), .B(n632), .Y(n631) );
  OAI21X1 U777 ( .A(n632), .B(n986), .C(n631), .Y(n646) );
  AOI22X1 U778 ( .A(writedata[7]), .B(n634), .C(dp_n19), .D(n633), .Y(n635) );
  OAI21X1 U779 ( .A(n1000), .B(n820), .C(n635), .Y(n645) );
  INVX1 U780 ( .A(n645), .Y(n637) );
  AOI22X1 U781 ( .A(n637), .B(n636), .C(n648), .D(n645), .Y(n638) );
  XNOR2X1 U782 ( .A(n646), .B(n638), .Y(n640) );
  NAND2X1 U783 ( .A(n641), .B(n640), .Y(n639) );
  OAI21X1 U784 ( .A(n641), .B(n640), .C(n639), .Y(n642) );
  NAND2X1 U785 ( .A(n646), .B(n645), .Y(n643) );
  OAI21X1 U786 ( .A(n673), .B(n643), .C(n671), .Y(n644) );
  OAI21X1 U787 ( .A(n646), .B(n645), .C(n644), .Y(n647) );
  OAI21X1 U788 ( .A(n658), .B(n679), .C(n647), .Y(n540) );
  FAX1 U789 ( .A(n651), .B(n649), .C(n648), .YC(n660), .YS(n656) );
  NAND2X1 U790 ( .A(n652), .B(n651), .Y(n654) );
  OAI21X1 U791 ( .A(n652), .B(n651), .C(n650), .Y(n653) );
  OAI21X1 U792 ( .A(n673), .B(n654), .C(n653), .Y(n655) );
  AOI21X1 U793 ( .A(n665), .B(n656), .C(n655), .Y(n657) );
  OAI21X1 U794 ( .A(n659), .B(n658), .C(n657), .Y(n533) );
  FAX1 U795 ( .A(n663), .B(n661), .C(n660), .YC(n610), .YS(n664) );
  OAI21X1 U796 ( .A(n667), .B(n673), .C(n671), .Y(n662) );
  AOI22X1 U797 ( .A(n665), .B(n664), .C(n663), .D(n662), .Y(n666) );
  OAI21X1 U798 ( .A(n667), .B(n671), .C(n666), .Y(n534) );
  FAX1 U799 ( .A(n676), .B(n669), .C(n668), .YC(n628), .YS(n670) );
  NAND2X1 U800 ( .A(n676), .B(n675), .Y(n672) );
  OAI21X1 U801 ( .A(n673), .B(n672), .C(n671), .Y(n674) );
  OAI21X1 U802 ( .A(n676), .B(n675), .C(n674), .Y(n677) );
  OAI21X1 U803 ( .A(n679), .B(n678), .C(n677), .Y(n538) );
  NOR2X1 U804 ( .A(n940), .B(n1005), .Y(memwrite) );
  NOR2X1 U806 ( .A(cont_state[3]), .B(n680), .Y(n1006) );
  NAND2X1 U807 ( .A(cont_state[2]), .B(n1006), .Y(n843) );
  INVX1 U808 ( .A(n843), .Y(n681) );
  NAND2X1 U809 ( .A(n681), .B(n941), .Y(n818) );
  OAI21X1 U810 ( .A(cont_state[2]), .B(cont_state[3]), .C(n818), .Y(memread)
         );
  NOR2X1 U811 ( .A(dp_n14), .B(dp_n13), .Y(n729) );
  NAND2X1 U812 ( .A(dp_n14), .B(n1016), .Y(n727) );
  NOR2X1 U813 ( .A(dp_n14), .B(n1016), .Y(n725) );
  NOR2X1 U814 ( .A(n1015), .B(n1016), .Y(n708) );
  AOI22X1 U815 ( .A(dp_rf_REGS[32]), .B(n725), .C(dp_rf_REGS[48]), .D(n731), 
        .Y(n682) );
  OAI21X1 U816 ( .A(n738), .B(n727), .C(n682), .Y(n683) );
  AOI21X1 U817 ( .A(dp_rf_REGS[0]), .B(n729), .C(n683), .Y(n687) );
  AOI22X1 U818 ( .A(dp_rf_REGS[40]), .B(n708), .C(dp_rf_REGS[8]), .D(n730), 
        .Y(n684) );
  OAI21X1 U819 ( .A(n741), .B(n733), .C(n684), .Y(n685) );
  NAND2X1 U820 ( .A(n1014), .B(n685), .Y(n686) );
  OAI21X1 U821 ( .A(n687), .B(n1014), .C(n686), .Y(dp_rd2[0]) );
  AOI22X1 U822 ( .A(dp_rf_REGS[33]), .B(n725), .C(dp_rf_REGS[49]), .D(n731), 
        .Y(n688) );
  OAI21X1 U823 ( .A(n746), .B(n727), .C(n688), .Y(n689) );
  AOI21X1 U824 ( .A(dp_rf_REGS[1]), .B(n729), .C(n689), .Y(n693) );
  AOI22X1 U825 ( .A(dp_rf_REGS[41]), .B(n731), .C(dp_rf_REGS[9]), .D(n730), 
        .Y(n690) );
  OAI21X1 U826 ( .A(n749), .B(n733), .C(n690), .Y(n691) );
  NAND2X1 U827 ( .A(n1014), .B(n691), .Y(n692) );
  OAI21X1 U828 ( .A(n693), .B(n1014), .C(n692), .Y(dp_rd2[1]) );
  AOI22X1 U829 ( .A(dp_rf_REGS[34]), .B(n725), .C(dp_rf_REGS[50]), .D(n731), 
        .Y(n694) );
  OAI21X1 U830 ( .A(n754), .B(n727), .C(n694), .Y(n695) );
  AOI21X1 U831 ( .A(dp_rf_REGS[2]), .B(n729), .C(n695), .Y(n699) );
  AOI22X1 U832 ( .A(dp_rf_REGS[42]), .B(n708), .C(dp_rf_REGS[10]), .D(n730), 
        .Y(n696) );
  OAI21X1 U833 ( .A(n757), .B(n733), .C(n696), .Y(n697) );
  NAND2X1 U834 ( .A(n1014), .B(n697), .Y(n698) );
  OAI21X1 U835 ( .A(n699), .B(n1014), .C(n698), .Y(dp_rd2[2]) );
  AOI22X1 U836 ( .A(dp_rf_REGS[35]), .B(n725), .C(dp_rf_REGS[51]), .D(n731), 
        .Y(n700) );
  OAI21X1 U837 ( .A(n762), .B(n727), .C(n700), .Y(n701) );
  AOI21X1 U838 ( .A(dp_rf_REGS[3]), .B(n729), .C(n701), .Y(n705) );
  AOI22X1 U839 ( .A(dp_rf_REGS[43]), .B(n731), .C(dp_rf_REGS[11]), .D(n730), 
        .Y(n702) );
  OAI21X1 U840 ( .A(n765), .B(n733), .C(n702), .Y(n703) );
  NAND2X1 U841 ( .A(n1014), .B(n703), .Y(n704) );
  OAI21X1 U842 ( .A(n705), .B(n1014), .C(n704), .Y(dp_rd2[3]) );
  AOI22X1 U843 ( .A(dp_rf_REGS[36]), .B(n725), .C(dp_rf_REGS[52]), .D(n731), 
        .Y(n706) );
  OAI21X1 U844 ( .A(n770), .B(n727), .C(n706), .Y(n707) );
  AOI21X1 U845 ( .A(dp_rf_REGS[4]), .B(n729), .C(n707), .Y(n712) );
  AOI22X1 U846 ( .A(dp_rf_REGS[44]), .B(n708), .C(dp_rf_REGS[12]), .D(n730), 
        .Y(n709) );
  OAI21X1 U847 ( .A(n773), .B(n733), .C(n709), .Y(n710) );
  NAND2X1 U848 ( .A(n1014), .B(n710), .Y(n711) );
  OAI21X1 U849 ( .A(n712), .B(n1014), .C(n711), .Y(dp_rd2[4]) );
  AOI22X1 U850 ( .A(dp_rf_REGS[37]), .B(n725), .C(dp_rf_REGS[53]), .D(n731), 
        .Y(n713) );
  OAI21X1 U851 ( .A(n778), .B(n727), .C(n713), .Y(n714) );
  AOI21X1 U852 ( .A(dp_rf_REGS[5]), .B(n729), .C(n714), .Y(n718) );
  AOI22X1 U853 ( .A(dp_rf_REGS[45]), .B(n731), .C(dp_rf_REGS[13]), .D(n730), 
        .Y(n715) );
  OAI21X1 U854 ( .A(n781), .B(n733), .C(n715), .Y(n716) );
  NAND2X1 U855 ( .A(n1014), .B(n716), .Y(n717) );
  OAI21X1 U856 ( .A(n718), .B(n1014), .C(n717), .Y(dp_rd2[5]) );
  AOI22X1 U857 ( .A(dp_rf_REGS[38]), .B(n725), .C(dp_rf_REGS[54]), .D(n731), 
        .Y(n719) );
  OAI21X1 U858 ( .A(n786), .B(n727), .C(n719), .Y(n720) );
  AOI21X1 U859 ( .A(dp_rf_REGS[6]), .B(n729), .C(n720), .Y(n724) );
  AOI22X1 U860 ( .A(dp_rf_REGS[46]), .B(n731), .C(dp_rf_REGS[14]), .D(n730), 
        .Y(n721) );
  OAI21X1 U861 ( .A(n790), .B(n733), .C(n721), .Y(n722) );
  NAND2X1 U862 ( .A(n1014), .B(n722), .Y(n723) );
  OAI21X1 U863 ( .A(n724), .B(n1014), .C(n723), .Y(dp_rd2[6]) );
  AOI22X1 U864 ( .A(dp_rf_REGS[39]), .B(n725), .C(dp_rf_REGS[55]), .D(n731), 
        .Y(n726) );
  OAI21X1 U865 ( .A(n797), .B(n727), .C(n726), .Y(n728) );
  AOI21X1 U866 ( .A(dp_rf_REGS[7]), .B(n729), .C(n728), .Y(n736) );
  AOI22X1 U867 ( .A(dp_rf_REGS[47]), .B(n731), .C(dp_rf_REGS[15]), .D(n730), 
        .Y(n732) );
  OAI21X1 U868 ( .A(n804), .B(n733), .C(n732), .Y(n734) );
  NAND2X1 U869 ( .A(n1014), .B(n734), .Y(n735) );
  OAI21X1 U870 ( .A(n736), .B(n1014), .C(n735), .Y(dp_rd2[7]) );
  NOR2X1 U871 ( .A(dp_n10), .B(dp_n11), .Y(n799) );
  NAND2X1 U872 ( .A(dp_n11), .B(n1020), .Y(n796) );
  NOR2X1 U873 ( .A(dp_n11), .B(n1020), .Y(n794) );
  INVX1 U874 ( .A(dp_n11), .Y(n1018) );
  NOR2X1 U875 ( .A(n1020), .B(n1018), .Y(n788) );
  AOI22X1 U876 ( .A(dp_rf_REGS[32]), .B(n794), .C(dp_rf_REGS[48]), .D(n801), 
        .Y(n737) );
  OAI21X1 U877 ( .A(n738), .B(n796), .C(n737), .Y(n739) );
  AOI21X1 U878 ( .A(dp_rf_REGS[0]), .B(n799), .C(n739), .Y(n744) );
  AOI22X1 U879 ( .A(dp_rf_REGS[40]), .B(n788), .C(dp_rf_REGS[8]), .D(n800), 
        .Y(n740) );
  OAI21X1 U880 ( .A(n741), .B(n803), .C(n740), .Y(n742) );
  NAND2X1 U881 ( .A(n1017), .B(n742), .Y(n743) );
  OAI21X1 U882 ( .A(n744), .B(n1017), .C(n743), .Y(dp_rd1[0]) );
  AOI22X1 U883 ( .A(dp_rf_REGS[33]), .B(n794), .C(dp_rf_REGS[49]), .D(n801), 
        .Y(n745) );
  OAI21X1 U884 ( .A(n746), .B(n796), .C(n745), .Y(n747) );
  AOI21X1 U885 ( .A(dp_rf_REGS[1]), .B(n799), .C(n747), .Y(n752) );
  AOI22X1 U886 ( .A(dp_rf_REGS[41]), .B(n801), .C(dp_rf_REGS[9]), .D(n800), 
        .Y(n748) );
  OAI21X1 U887 ( .A(n749), .B(n803), .C(n748), .Y(n750) );
  NAND2X1 U888 ( .A(n1017), .B(n750), .Y(n751) );
  OAI21X1 U889 ( .A(n752), .B(n1017), .C(n751), .Y(dp_rd1[1]) );
  AOI22X1 U890 ( .A(dp_rf_REGS[34]), .B(n794), .C(dp_rf_REGS[50]), .D(n801), 
        .Y(n753) );
  OAI21X1 U891 ( .A(n754), .B(n796), .C(n753), .Y(n755) );
  AOI21X1 U892 ( .A(dp_rf_REGS[2]), .B(n799), .C(n755), .Y(n760) );
  AOI22X1 U893 ( .A(dp_rf_REGS[42]), .B(n788), .C(dp_rf_REGS[10]), .D(n800), 
        .Y(n756) );
  OAI21X1 U894 ( .A(n757), .B(n803), .C(n756), .Y(n758) );
  NAND2X1 U895 ( .A(n1017), .B(n758), .Y(n759) );
  OAI21X1 U896 ( .A(n760), .B(n1017), .C(n759), .Y(dp_rd1[2]) );
  AOI22X1 U897 ( .A(dp_rf_REGS[35]), .B(n794), .C(dp_rf_REGS[51]), .D(n801), 
        .Y(n761) );
  OAI21X1 U898 ( .A(n762), .B(n796), .C(n761), .Y(n763) );
  AOI21X1 U899 ( .A(dp_rf_REGS[3]), .B(n799), .C(n763), .Y(n768) );
  AOI22X1 U900 ( .A(dp_rf_REGS[43]), .B(n801), .C(dp_rf_REGS[11]), .D(n800), 
        .Y(n764) );
  OAI21X1 U901 ( .A(n765), .B(n803), .C(n764), .Y(n766) );
  NAND2X1 U902 ( .A(n1017), .B(n766), .Y(n767) );
  OAI21X1 U903 ( .A(n768), .B(n1017), .C(n767), .Y(dp_rd1[3]) );
  AOI22X1 U904 ( .A(dp_rf_REGS[36]), .B(n794), .C(dp_rf_REGS[52]), .D(n801), 
        .Y(n769) );
  OAI21X1 U905 ( .A(n770), .B(n796), .C(n769), .Y(n771) );
  AOI21X1 U906 ( .A(dp_rf_REGS[4]), .B(n799), .C(n771), .Y(n776) );
  AOI22X1 U907 ( .A(dp_rf_REGS[44]), .B(n788), .C(dp_rf_REGS[12]), .D(n800), 
        .Y(n772) );
  OAI21X1 U908 ( .A(n773), .B(n803), .C(n772), .Y(n774) );
  NAND2X1 U909 ( .A(n1017), .B(n774), .Y(n775) );
  OAI21X1 U910 ( .A(n776), .B(n1017), .C(n775), .Y(dp_rd1[4]) );
  AOI22X1 U911 ( .A(dp_rf_REGS[37]), .B(n794), .C(dp_rf_REGS[53]), .D(n801), 
        .Y(n777) );
  OAI21X1 U912 ( .A(n778), .B(n796), .C(n777), .Y(n779) );
  AOI21X1 U913 ( .A(dp_rf_REGS[5]), .B(n799), .C(n779), .Y(n784) );
  AOI22X1 U914 ( .A(dp_rf_REGS[45]), .B(n801), .C(dp_rf_REGS[13]), .D(n800), 
        .Y(n780) );
  OAI21X1 U915 ( .A(n781), .B(n803), .C(n780), .Y(n782) );
  NAND2X1 U916 ( .A(n1017), .B(n782), .Y(n783) );
  OAI21X1 U917 ( .A(n784), .B(n1017), .C(n783), .Y(dp_rd1[5]) );
  AOI22X1 U918 ( .A(dp_rf_REGS[38]), .B(n794), .C(dp_rf_REGS[54]), .D(n801), 
        .Y(n785) );
  OAI21X1 U919 ( .A(n786), .B(n796), .C(n785), .Y(n787) );
  AOI21X1 U920 ( .A(dp_rf_REGS[6]), .B(n799), .C(n787), .Y(n793) );
  AOI22X1 U921 ( .A(dp_rf_REGS[46]), .B(n788), .C(dp_rf_REGS[14]), .D(n800), 
        .Y(n789) );
  OAI21X1 U922 ( .A(n790), .B(n803), .C(n789), .Y(n791) );
  NAND2X1 U923 ( .A(n1017), .B(n791), .Y(n792) );
  OAI21X1 U924 ( .A(n793), .B(n1017), .C(n792), .Y(dp_rd1[6]) );
  AOI22X1 U925 ( .A(dp_rf_REGS[39]), .B(n794), .C(dp_rf_REGS[55]), .D(n801), 
        .Y(n795) );
  OAI21X1 U926 ( .A(n797), .B(n796), .C(n795), .Y(n798) );
  AOI21X1 U927 ( .A(dp_rf_REGS[7]), .B(n799), .C(n798), .Y(n807) );
  AOI22X1 U928 ( .A(dp_rf_REGS[47]), .B(n801), .C(dp_rf_REGS[15]), .D(n800), 
        .Y(n802) );
  OAI21X1 U929 ( .A(n804), .B(n803), .C(n802), .Y(n805) );
  NAND2X1 U930 ( .A(n1017), .B(n805), .Y(n806) );
  OAI21X1 U931 ( .A(n807), .B(n1017), .C(n806), .Y(dp_rd1[7]) );
  OAI21X1 U932 ( .A(n1005), .B(n940), .C(n818), .Y(n816) );
  NAND2X1 U933 ( .A(dp_aluout[0]), .B(n816), .Y(n808) );
  OAI21X1 U934 ( .A(n816), .B(n954), .C(n808), .Y(adr[0]) );
  NAND2X1 U935 ( .A(dp_aluout[1]), .B(n816), .Y(n809) );
  OAI21X1 U936 ( .A(n816), .B(n956), .C(n809), .Y(adr[1]) );
  NAND2X1 U937 ( .A(dp_aluout[2]), .B(n816), .Y(n810) );
  OAI21X1 U938 ( .A(n816), .B(n962), .C(n810), .Y(adr[2]) );
  NAND2X1 U939 ( .A(dp_aluout[3]), .B(n816), .Y(n811) );
  OAI21X1 U940 ( .A(n816), .B(n966), .C(n811), .Y(adr[3]) );
  NAND2X1 U941 ( .A(dp_aluout[4]), .B(n816), .Y(n812) );
  OAI21X1 U942 ( .A(n816), .B(n970), .C(n812), .Y(adr[4]) );
  NAND2X1 U943 ( .A(dp_aluout[5]), .B(n816), .Y(n813) );
  OAI21X1 U944 ( .A(n816), .B(n974), .C(n813), .Y(adr[5]) );
  NAND2X1 U945 ( .A(dp_aluout[6]), .B(n816), .Y(n814) );
  OAI21X1 U946 ( .A(n816), .B(n979), .C(n814), .Y(adr[6]) );
  NAND2X1 U947 ( .A(dp_aluout[7]), .B(n816), .Y(n815) );
  OAI21X1 U948 ( .A(n816), .B(n986), .C(n815), .Y(adr[7]) );
  INVX1 U949 ( .A(instr[31]), .Y(n988) );
  NOR2X1 U950 ( .A(instr[29]), .B(n988), .Y(n826) );
  NAND2X1 U951 ( .A(n817), .B(n826), .Y(n819) );
  OAI21X1 U952 ( .A(n819), .B(n820), .C(n818), .Y(n834) );
  NOR2X1 U953 ( .A(instr[31]), .B(n820), .Y(n821) );
  INVX1 U954 ( .A(n821), .Y(n823) );
  INVX1 U955 ( .A(instr[29]), .Y(n991) );
  NAND3X1 U956 ( .A(n821), .B(n991), .C(n993), .Y(n822) );
  NOR2X1 U957 ( .A(instr[26]), .B(n822), .Y(n831) );
  NAND3X1 U958 ( .A(instr[28]), .B(n831), .C(n989), .Y(n828) );
  OAI21X1 U959 ( .A(n823), .B(n825), .C(n828), .Y(n837) );
  NOR2X1 U960 ( .A(n834), .B(n837), .Y(n824) );
  OAI21X1 U961 ( .A(cont_state[3]), .B(n1005), .C(n824), .Y(cont_nextstate[0])
         );
  INVX1 U962 ( .A(n825), .Y(n827) );
  NAND2X1 U963 ( .A(n827), .B(n826), .Y(n838) );
  OAI21X1 U964 ( .A(cont_state[1]), .B(n1013), .C(n828), .Y(n829) );
  AOI21X1 U965 ( .A(n1006), .B(n941), .C(n829), .Y(n830) );
  OAI21X1 U966 ( .A(n836), .B(n838), .C(n830), .Y(cont_nextstate[1]) );
  NAND2X1 U967 ( .A(n831), .B(n990), .Y(n840) );
  INVX1 U968 ( .A(n1013), .Y(n832) );
  NAND2X1 U969 ( .A(n832), .B(n1006), .Y(n1004) );
  OAI21X1 U970 ( .A(n989), .B(n840), .C(n1004), .Y(n833) );
  NOR2X1 U971 ( .A(n834), .B(n833), .Y(n835) );
  OAI21X1 U972 ( .A(n836), .B(n838), .C(n835), .Y(cont_nextstate[2]) );
  INVX1 U973 ( .A(n836), .Y(n839) );
  AOI21X1 U974 ( .A(n839), .B(n838), .C(n837), .Y(n842) );
  NAND3X1 U975 ( .A(n842), .B(n841), .C(n840), .Y(cont_nextstate[3]) );
  NOR2X1 U976 ( .A(n941), .B(n843), .Y(n924) );
  AOI22X1 U977 ( .A(n924), .B(dp_md[0]), .C(dp_aluout[0]), .D(n923), .Y(n869)
         );
  OAI21X1 U978 ( .A(n1005), .B(n844), .C(n923), .Y(n858) );
  INVX1 U979 ( .A(n844), .Y(n846) );
  AND2X2 U980 ( .A(n846), .B(n845), .Y(n850) );
  NAND2X1 U981 ( .A(dp_n16), .B(n850), .Y(n847) );
  OAI21X1 U982 ( .A(n850), .B(n1016), .C(n847), .Y(n859) );
  NAND2X1 U983 ( .A(n858), .B(n859), .Y(n854) );
  NAND2X1 U984 ( .A(dp_n18), .B(n850), .Y(n848) );
  OAI21X1 U985 ( .A(n850), .B(n1014), .C(n848), .Y(n865) );
  NAND2X1 U986 ( .A(dp_n17), .B(n850), .Y(n849) );
  OAI21X1 U987 ( .A(n850), .B(n1015), .C(n849), .Y(n864) );
  NAND3X1 U988 ( .A(n852), .B(n865), .C(n864), .Y(n895) );
  NAND2X1 U989 ( .A(dp_rf_REGS[48]), .B(n926), .Y(n851) );
  OAI21X1 U990 ( .A(n869), .B(n895), .C(n851), .Y(n532) );
  NAND3X1 U991 ( .A(n862), .B(n852), .C(n864), .Y(n897) );
  NAND2X1 U992 ( .A(dp_rf_REGS[40]), .B(n928), .Y(n853) );
  OAI21X1 U993 ( .A(n869), .B(n897), .C(n853), .Y(n531) );
  NOR2X1 U994 ( .A(n864), .B(n854), .Y(n856) );
  NAND2X1 U995 ( .A(n856), .B(n865), .Y(n930) );
  NAND2X1 U996 ( .A(dp_rf_REGS[32]), .B(n930), .Y(n855) );
  OAI21X1 U997 ( .A(n869), .B(n930), .C(n855), .Y(n530) );
  NAND2X1 U998 ( .A(n862), .B(n856), .Y(n932) );
  NAND2X1 U999 ( .A(dp_rf_REGS[24]), .B(n932), .Y(n857) );
  OAI21X1 U1000 ( .A(n869), .B(n932), .C(n857), .Y(n529) );
  INVX1 U1001 ( .A(n858), .Y(n860) );
  NOR2X1 U1002 ( .A(n860), .B(n859), .Y(n866) );
  NAND3X1 U1003 ( .A(n866), .B(n865), .C(n864), .Y(n901) );
  NAND2X1 U1004 ( .A(dp_rf_REGS[16]), .B(n934), .Y(n861) );
  OAI21X1 U1005 ( .A(n869), .B(n901), .C(n861), .Y(n528) );
  NAND3X1 U1006 ( .A(n862), .B(n866), .C(n864), .Y(n903) );
  NAND2X1 U1007 ( .A(dp_rf_REGS[8]), .B(n936), .Y(n863) );
  OAI21X1 U1008 ( .A(n869), .B(n903), .C(n863), .Y(n527) );
  INVX1 U1009 ( .A(n864), .Y(n867) );
  NAND3X1 U1010 ( .A(n867), .B(n866), .C(n865), .Y(n905) );
  NAND2X1 U1011 ( .A(dp_rf_REGS[0]), .B(n938), .Y(n868) );
  OAI21X1 U1012 ( .A(n869), .B(n905), .C(n868), .Y(n526) );
  AOI22X1 U1013 ( .A(n924), .B(dp_md[1]), .C(dp_aluout[1]), .D(n923), .Y(n877)
         );
  NAND2X1 U1014 ( .A(dp_rf_REGS[49]), .B(n926), .Y(n870) );
  OAI21X1 U1015 ( .A(n877), .B(n926), .C(n870), .Y(n525) );
  NAND2X1 U1016 ( .A(dp_rf_REGS[41]), .B(n928), .Y(n871) );
  OAI21X1 U1017 ( .A(n877), .B(n928), .C(n871), .Y(n524) );
  NAND2X1 U1018 ( .A(dp_rf_REGS[33]), .B(n930), .Y(n872) );
  OAI21X1 U1019 ( .A(n877), .B(n930), .C(n872), .Y(n523) );
  NAND2X1 U1020 ( .A(dp_rf_REGS[25]), .B(n932), .Y(n873) );
  OAI21X1 U1021 ( .A(n877), .B(n932), .C(n873), .Y(n522) );
  NAND2X1 U1022 ( .A(dp_rf_REGS[17]), .B(n934), .Y(n874) );
  OAI21X1 U1023 ( .A(n877), .B(n934), .C(n874), .Y(n521) );
  NAND2X1 U1024 ( .A(dp_rf_REGS[9]), .B(n936), .Y(n875) );
  OAI21X1 U1025 ( .A(n877), .B(n936), .C(n875), .Y(n520) );
  NAND2X1 U1026 ( .A(dp_rf_REGS[1]), .B(n938), .Y(n876) );
  OAI21X1 U1027 ( .A(n877), .B(n938), .C(n876), .Y(n519) );
  AOI22X1 U1028 ( .A(n924), .B(dp_md[2]), .C(dp_aluout[2]), .D(n923), .Y(n885)
         );
  NAND2X1 U1029 ( .A(dp_rf_REGS[50]), .B(n926), .Y(n878) );
  OAI21X1 U1030 ( .A(n885), .B(n895), .C(n878), .Y(n518) );
  NAND2X1 U1031 ( .A(dp_rf_REGS[42]), .B(n928), .Y(n879) );
  OAI21X1 U1032 ( .A(n885), .B(n897), .C(n879), .Y(n517) );
  NAND2X1 U1033 ( .A(dp_rf_REGS[34]), .B(n930), .Y(n880) );
  OAI21X1 U1034 ( .A(n885), .B(n930), .C(n880), .Y(n516) );
  NAND2X1 U1035 ( .A(dp_rf_REGS[26]), .B(n932), .Y(n881) );
  OAI21X1 U1036 ( .A(n885), .B(n932), .C(n881), .Y(n515) );
  NAND2X1 U1037 ( .A(dp_rf_REGS[18]), .B(n934), .Y(n882) );
  OAI21X1 U1038 ( .A(n885), .B(n901), .C(n882), .Y(n514) );
  NAND2X1 U1039 ( .A(dp_rf_REGS[10]), .B(n936), .Y(n883) );
  OAI21X1 U1040 ( .A(n885), .B(n903), .C(n883), .Y(n513) );
  NAND2X1 U1041 ( .A(dp_rf_REGS[2]), .B(n938), .Y(n884) );
  OAI21X1 U1042 ( .A(n885), .B(n905), .C(n884), .Y(n512) );
  AOI22X1 U1043 ( .A(n924), .B(dp_md[3]), .C(dp_aluout[3]), .D(n923), .Y(n893)
         );
  NAND2X1 U1044 ( .A(dp_rf_REGS[51]), .B(n926), .Y(n886) );
  OAI21X1 U1045 ( .A(n893), .B(n926), .C(n886), .Y(n511) );
  NAND2X1 U1046 ( .A(dp_rf_REGS[43]), .B(n928), .Y(n887) );
  OAI21X1 U1047 ( .A(n893), .B(n928), .C(n887), .Y(n510) );
  NAND2X1 U1048 ( .A(dp_rf_REGS[35]), .B(n930), .Y(n888) );
  OAI21X1 U1049 ( .A(n893), .B(n930), .C(n888), .Y(n509) );
  NAND2X1 U1050 ( .A(dp_rf_REGS[27]), .B(n932), .Y(n889) );
  OAI21X1 U1051 ( .A(n893), .B(n932), .C(n889), .Y(n508) );
  NAND2X1 U1052 ( .A(dp_rf_REGS[19]), .B(n934), .Y(n890) );
  OAI21X1 U1053 ( .A(n893), .B(n934), .C(n890), .Y(n507) );
  NAND2X1 U1054 ( .A(dp_rf_REGS[11]), .B(n936), .Y(n891) );
  OAI21X1 U1055 ( .A(n893), .B(n936), .C(n891), .Y(n506) );
  NAND2X1 U1056 ( .A(dp_rf_REGS[3]), .B(n938), .Y(n892) );
  OAI21X1 U1057 ( .A(n893), .B(n938), .C(n892), .Y(n505) );
  AOI22X1 U1058 ( .A(n924), .B(dp_md[4]), .C(dp_aluout[4]), .D(n923), .Y(n906)
         );
  NAND2X1 U1059 ( .A(dp_rf_REGS[52]), .B(n926), .Y(n894) );
  OAI21X1 U1060 ( .A(n906), .B(n895), .C(n894), .Y(n504) );
  NAND2X1 U1061 ( .A(dp_rf_REGS[44]), .B(n928), .Y(n896) );
  OAI21X1 U1062 ( .A(n906), .B(n897), .C(n896), .Y(n503) );
  NAND2X1 U1063 ( .A(dp_rf_REGS[36]), .B(n930), .Y(n898) );
  OAI21X1 U1064 ( .A(n906), .B(n930), .C(n898), .Y(n502) );
  NAND2X1 U1065 ( .A(dp_rf_REGS[28]), .B(n932), .Y(n899) );
  OAI21X1 U1066 ( .A(n906), .B(n932), .C(n899), .Y(n501) );
  NAND2X1 U1067 ( .A(dp_rf_REGS[20]), .B(n934), .Y(n900) );
  OAI21X1 U1068 ( .A(n906), .B(n901), .C(n900), .Y(n500) );
  NAND2X1 U1069 ( .A(dp_rf_REGS[12]), .B(n936), .Y(n902) );
  OAI21X1 U1070 ( .A(n906), .B(n903), .C(n902), .Y(n499) );
  NAND2X1 U1071 ( .A(dp_rf_REGS[4]), .B(n938), .Y(n904) );
  OAI21X1 U1072 ( .A(n906), .B(n905), .C(n904), .Y(n498) );
  AOI22X1 U1073 ( .A(n924), .B(dp_md[5]), .C(dp_aluout[5]), .D(n923), .Y(n914)
         );
  NAND2X1 U1074 ( .A(dp_rf_REGS[53]), .B(n926), .Y(n907) );
  OAI21X1 U1075 ( .A(n914), .B(n926), .C(n907), .Y(n497) );
  NAND2X1 U1076 ( .A(dp_rf_REGS[45]), .B(n928), .Y(n908) );
  OAI21X1 U1077 ( .A(n914), .B(n928), .C(n908), .Y(n496) );
  NAND2X1 U1078 ( .A(dp_rf_REGS[37]), .B(n930), .Y(n909) );
  OAI21X1 U1079 ( .A(n914), .B(n930), .C(n909), .Y(n495) );
  NAND2X1 U1080 ( .A(dp_rf_REGS[29]), .B(n932), .Y(n910) );
  OAI21X1 U1081 ( .A(n914), .B(n932), .C(n910), .Y(n494) );
  NAND2X1 U1082 ( .A(dp_rf_REGS[21]), .B(n934), .Y(n911) );
  OAI21X1 U1083 ( .A(n914), .B(n934), .C(n911), .Y(n493) );
  NAND2X1 U1084 ( .A(dp_rf_REGS[13]), .B(n936), .Y(n912) );
  OAI21X1 U1085 ( .A(n914), .B(n936), .C(n912), .Y(n492) );
  NAND2X1 U1086 ( .A(dp_rf_REGS[5]), .B(n938), .Y(n913) );
  OAI21X1 U1087 ( .A(n914), .B(n938), .C(n913), .Y(n491) );
  AOI22X1 U1088 ( .A(n924), .B(dp_md[6]), .C(dp_aluout[6]), .D(n923), .Y(n922)
         );
  NAND2X1 U1089 ( .A(dp_rf_REGS[54]), .B(n926), .Y(n915) );
  OAI21X1 U1090 ( .A(n922), .B(n926), .C(n915), .Y(n490) );
  NAND2X1 U1091 ( .A(dp_rf_REGS[46]), .B(n928), .Y(n916) );
  OAI21X1 U1092 ( .A(n922), .B(n928), .C(n916), .Y(n489) );
  NAND2X1 U1093 ( .A(dp_rf_REGS[38]), .B(n930), .Y(n917) );
  OAI21X1 U1094 ( .A(n922), .B(n930), .C(n917), .Y(n488) );
  NAND2X1 U1095 ( .A(dp_rf_REGS[30]), .B(n932), .Y(n918) );
  OAI21X1 U1096 ( .A(n922), .B(n932), .C(n918), .Y(n487) );
  NAND2X1 U1097 ( .A(dp_rf_REGS[22]), .B(n934), .Y(n919) );
  OAI21X1 U1098 ( .A(n922), .B(n934), .C(n919), .Y(n486) );
  NAND2X1 U1099 ( .A(dp_rf_REGS[14]), .B(n936), .Y(n920) );
  OAI21X1 U1100 ( .A(n922), .B(n936), .C(n920), .Y(n485) );
  NAND2X1 U1101 ( .A(dp_rf_REGS[6]), .B(n938), .Y(n921) );
  OAI21X1 U1102 ( .A(n922), .B(n938), .C(n921), .Y(n484) );
  AOI22X1 U1103 ( .A(n924), .B(dp_md[7]), .C(dp_aluout[7]), .D(n923), .Y(n939)
         );
  NAND2X1 U1104 ( .A(dp_rf_REGS[55]), .B(n926), .Y(n925) );
  OAI21X1 U1105 ( .A(n939), .B(n926), .C(n925), .Y(n483) );
  NAND2X1 U1106 ( .A(dp_rf_REGS[47]), .B(n928), .Y(n927) );
  OAI21X1 U1107 ( .A(n939), .B(n928), .C(n927), .Y(n482) );
  NAND2X1 U1108 ( .A(dp_rf_REGS[39]), .B(n930), .Y(n929) );
  OAI21X1 U1109 ( .A(n939), .B(n930), .C(n929), .Y(n481) );
  NAND2X1 U1110 ( .A(dp_rf_REGS[31]), .B(n932), .Y(n931) );
  OAI21X1 U1111 ( .A(n939), .B(n932), .C(n931), .Y(n480) );
  NAND2X1 U1112 ( .A(dp_rf_REGS[23]), .B(n934), .Y(n933) );
  OAI21X1 U1113 ( .A(n939), .B(n934), .C(n933), .Y(n479) );
  NAND2X1 U1114 ( .A(dp_rf_REGS[15]), .B(n936), .Y(n935) );
  OAI21X1 U1115 ( .A(n939), .B(n936), .C(n935), .Y(n478) );
  NAND2X1 U1116 ( .A(dp_rf_REGS[7]), .B(n938), .Y(n937) );
  OAI21X1 U1117 ( .A(n939), .B(n938), .C(n937), .Y(n477) );
  INVX1 U1118 ( .A(n940), .Y(n942) );
  NAND3X1 U1119 ( .A(cont_state[2]), .B(n942), .C(n941), .Y(n975) );
  AOI22X1 U1120 ( .A(dp_aluout[0]), .B(n980), .C(n975), .D(n533), .Y(n955) );
  NOR2X1 U1121 ( .A(n534), .B(n538), .Y(n943) );
  NAND2X1 U1122 ( .A(n980), .B(n943), .Y(n951) );
  NOR2X1 U1123 ( .A(n540), .B(n533), .Y(n946) );
  NOR2X1 U1124 ( .A(n535), .B(n537), .Y(n945) );
  NOR2X1 U1125 ( .A(n536), .B(n539), .Y(n944) );
  NAND3X1 U1126 ( .A(n946), .B(n945), .C(n944), .Y(n950) );
  NOR2X1 U1127 ( .A(n948), .B(n947), .Y(n949) );
  OAI21X1 U1128 ( .A(n951), .B(n950), .C(n949), .Y(n952) );
  NAND2X1 U1129 ( .A(n445), .B(n952), .Y(n958) );
  INVX1 U1130 ( .A(n952), .Y(n953) );
  NAND2X1 U1131 ( .A(n953), .B(n445), .Y(n987) );
  OAI22X1 U1132 ( .A(n955), .B(n958), .C(n954), .D(n987), .Y(n476) );
  AOI22X1 U1133 ( .A(dp_aluout[1]), .B(n980), .C(n975), .D(n534), .Y(n957) );
  OAI22X1 U1134 ( .A(n957), .B(n958), .C(n956), .D(n987), .Y(n475) );
  AOI22X1 U1135 ( .A(dp_aluout[2]), .B(n980), .C(n982), .D(n535), .Y(n959) );
  OAI21X1 U1136 ( .A(n982), .B(n995), .C(n959), .Y(n960) );
  NAND2X1 U1137 ( .A(n984), .B(n960), .Y(n961) );
  OAI21X1 U1138 ( .A(n987), .B(n962), .C(n961), .Y(n474) );
  AOI22X1 U1139 ( .A(dp_aluout[3]), .B(n980), .C(n982), .D(n536), .Y(n963) );
  OAI21X1 U1140 ( .A(n982), .B(n996), .C(n963), .Y(n964) );
  NAND2X1 U1141 ( .A(n984), .B(n964), .Y(n965) );
  OAI21X1 U1142 ( .A(n987), .B(n966), .C(n965), .Y(n473) );
  AOI22X1 U1143 ( .A(dp_aluout[4]), .B(n980), .C(n982), .D(n537), .Y(n967) );
  OAI21X1 U1144 ( .A(n982), .B(n997), .C(n967), .Y(n968) );
  NAND2X1 U1145 ( .A(n984), .B(n968), .Y(n969) );
  OAI21X1 U1146 ( .A(n987), .B(n970), .C(n969), .Y(n472) );
  AOI22X1 U1147 ( .A(dp_aluout[5]), .B(n980), .C(n982), .D(n538), .Y(n971) );
  OAI21X1 U1148 ( .A(n982), .B(n998), .C(n971), .Y(n972) );
  NAND2X1 U1149 ( .A(n984), .B(n972), .Y(n973) );
  OAI21X1 U1150 ( .A(n987), .B(n974), .C(n973), .Y(n471) );
  AOI22X1 U1151 ( .A(dp_aluout[6]), .B(n980), .C(n975), .D(n539), .Y(n976) );
  OAI21X1 U1152 ( .A(n982), .B(n999), .C(n976), .Y(n977) );
  NAND2X1 U1153 ( .A(n984), .B(n977), .Y(n978) );
  OAI21X1 U1154 ( .A(n987), .B(n979), .C(n978), .Y(n470) );
  AOI22X1 U1155 ( .A(dp_aluout[7]), .B(n980), .C(n982), .D(n540), .Y(n981) );
  OAI21X1 U1156 ( .A(n982), .B(n1000), .C(n981), .Y(n983) );
  NAND2X1 U1157 ( .A(n984), .B(n983), .Y(n985) );
  OAI21X1 U1158 ( .A(n987), .B(n986), .C(n985), .Y(n469) );
  AOI22X1 U1159 ( .A(n994), .B(n553), .C(n988), .D(n992), .Y(n468) );
  AOI22X1 U1160 ( .A(n994), .B(n545), .C(n989), .D(n992), .Y(n466) );
  AOI22X1 U1161 ( .A(n994), .B(n547), .C(n990), .D(n992), .Y(n465) );
  AOI22X1 U1162 ( .A(n994), .B(n549), .C(n991), .D(n992), .Y(n464) );
  AOI22X1 U1163 ( .A(n994), .B(n551), .C(n993), .D(n992), .Y(n463) );
  AOI22X1 U1164 ( .A(n1001), .B(n541), .C(n995), .D(n1004), .Y(n462) );
  AOI22X1 U1165 ( .A(n1001), .B(n543), .C(n996), .D(n1004), .Y(n461) );
  AOI22X1 U1166 ( .A(n1001), .B(n555), .C(n997), .D(n1004), .Y(n460) );
  AOI22X1 U1167 ( .A(n1001), .B(n545), .C(n998), .D(n1004), .Y(n459) );
  AOI22X1 U1168 ( .A(n1001), .B(n547), .C(n999), .D(n1004), .Y(n458) );
  AOI22X1 U1169 ( .A(n1001), .B(n549), .C(n1000), .D(n1004), .Y(n457) );
  NAND2X1 U1170 ( .A(dp_n20), .B(n1004), .Y(n1002) );
  OAI21X1 U1171 ( .A(n551), .B(n1004), .C(n1002), .Y(n456) );
  NAND2X1 U1172 ( .A(dp_n19), .B(n1004), .Y(n1003) );
  OAI21X1 U1173 ( .A(n553), .B(n1004), .C(n1003), .Y(n455) );
  INVX1 U1174 ( .A(n1005), .Y(n1007) );
  NAND2X1 U1175 ( .A(n1007), .B(n1006), .Y(n1011) );
  NAND2X1 U1176 ( .A(dp_n18), .B(n1011), .Y(n1008) );
  OAI21X1 U1177 ( .A(n1011), .B(n545), .C(n1008), .Y(n454) );
  NAND2X1 U1178 ( .A(dp_n17), .B(n1011), .Y(n1009) );
  OAI21X1 U1179 ( .A(n1011), .B(n547), .C(n1009), .Y(n453) );
  NAND2X1 U1180 ( .A(dp_n16), .B(n1011), .Y(n1010) );
  OAI21X1 U1181 ( .A(n1011), .B(n549), .C(n1010), .Y(n452) );
  NOR2X1 U1182 ( .A(n1013), .B(n1012), .Y(n1021) );
  AOI22X1 U1183 ( .A(n1021), .B(n541), .C(n1014), .D(n1019), .Y(n451) );
  AOI22X1 U1184 ( .A(n1021), .B(n543), .C(n1015), .D(n1019), .Y(n450) );
  AOI22X1 U1185 ( .A(n1021), .B(n555), .C(n1016), .D(n1019), .Y(n449) );
  AOI22X1 U1186 ( .A(n1021), .B(n549), .C(n1017), .D(n1019), .Y(n448) );
  AOI22X1 U1187 ( .A(n1021), .B(n551), .C(n1018), .D(n1019), .Y(n447) );
  AOI22X1 U1188 ( .A(n1021), .B(n553), .C(n1020), .D(n1019), .Y(n446) );
endmodule

