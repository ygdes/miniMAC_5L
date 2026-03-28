/*
    pipelines.v
    created sam. 28 mars 2026 04:07:10 CET by whygee@f-cpu.org

    This file is a collection of "pipelines" of various characteristics,
    easily swappable so it's integrated in project.v
*/

/* Short circuit config : */
module pipe_empty(
  input wire clk,
  input wire rst,
  input wire Encode,
  input wire Decode,
  input wire Din_OK,
  input wire [17:0] FirstWord,
  output wire Dout_OK,
  output wire [17:0] LastWord 
);
  wire _unused = &{ Encode, Decode, clk, rst, 1'b0};
  
  assign LastWord = FirstWord;
  assign Dout_OK = Din_OK;
endmodule

module pipe_encode_Hammer(
  input wire clk,
  input wire rst,
  input wire Encode,
  input wire Decode,
  input wire Din_OK,
  input wire [17:0] FirstWord,
  output wire Dout_OK,
  output wire [17:0] LastWord 
);
  wire _unused = &{ Decode, 1'b0};

  wire [17:0] HammerEnc_result;
  Encode_Hamming_early Henc(
      .clk(clk), .rst(rst), .HammEn(Din_OK),
      .HammIn(FirstWord), .HammOut(HammerEnc_result) );

  // Mux
  mux2_x18 selEnc( .sel(Encode), .if0(FirstWord), .if1(HammerEnc_result), .res(LastWord) );

  assign Dout_OK = Din_OK;
endmodule

module pipe_encode_decode_Hammer(
  input wire clk,
  input wire rst,
  input wire Encode,
  input wire Decode,
  input wire Din_OK,
  input wire [17:0] FirstWord,
  output wire Dout_OK,
  output wire [17:0] LastWord 
);
  wire _unused = &{ Decode, 1'b0};

  wire [17:0] HammerEnc_result, tmpSel;
  Encode_Hamming_early Henc(
      .clk(clk), .rst(rst), .HammEn(Din_OK),
      .HammIn(FirstWord), .HammOut(HammerEnc_result) );
  mux2_x18 selEnc( .sel(Encode), .if0(FirstWord), .if1(HammerEnc_result), .res(tmpSel) );

  wire [17:0] HammerDec_result;
  Decode_Hamming_early Hdec(
      .clk(clk), .rst(rst), .HammEn(Din_OK),
      .HammIn(FirstWord), .HammOut(HammerDec_result) );
  mux2_x18 selDec( .sel(Decode), .if0(tmpSel), .if1(HammerDec_result), .res(LastWord) );

  assign Dout_OK = Din_OK;
endmodule

module pipe_encode_decode_loopback_Hammer(
  input wire clk,
  input wire rst,
  input wire Encode,
  input wire Decode,
  input wire Din_OK,
  input wire [17:0] FirstWord,
  output wire Dout_OK,
  output wire [17:0] LastWord 
);
  wire [17:0] HammerEnc_result, tmpSel;
  Encode_Hamming_early Henc(
      .clk(clk), .rst(rst), .HammEn(Din_OK),
      .HammIn(FirstWord), .HammOut(HammerEnc_result) );
  mux2_x18 selEnc( .sel(Encode), .if0(FirstWord), .if1(HammerEnc_result), .res(tmpSel) );

  wire [17:0] HammerDec_result, HammerDec_operand;
  wire DecOpSel;
 (* keep *) sg13cmos5l_and2_1 AndSel(.A(Encode), .B(Decode), .Y(DecOpSel));
  mux2_x18 selOpDec( .sel(DecOpSel), .if0(FirstWord), .if1(HammerEnc_result), .res(HammerDec_operand) );
  Decode_Hamming_early Hdec(
      .clk(clk), .rst(rst), .HammEn(Din_OK),
      .HammIn(HammerDec_operand), .HammOut(HammerDec_result) );

  mux2_x18 selDec( .sel(Decode), .if0(tmpSel), .if1(HammerDec_result), .res(LastWord) );

  assign Dout_OK = Din_OK;
endmodule
