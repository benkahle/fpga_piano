// returns a signal oscillating at the frequency of the middle parameter of "clkdivider"
module note(clk, speaker);
input clk;
output reg speaker;
parameter clkdivider = 25000000/440/2;

reg [23:0] counter;
initial begin 
  counter = 0;
  speaker = 0;
end
always @(posedge clk) begin
  if (counter == clkdivider) begin
    speaker <= !speaker;
    counter <= 0;
  end
  else begin
    counter <= counter+1;
  end
end
endmodule

// Outputs 8 tones that should be summed and played from a single speaker
// Piano Mode: (no button is pressed)
// *Each switch turns on a tone in an octave
// *Multiple switches play chords
// *Changing clock jumper will change octave
// Song Mode: (button 0-3)
// *0: octave sweep
// *1: Random piano banging
// *2: Happy Birthday!
// *3: (FPGA)Piano Man
module piano(clk, sw, btn, n1, n2, n3, n4, n5, n6, n7, n8);
input clk;
input[7:0] sw;
input[3:0] btn;
output reg n1, n2, n3, n4, n5, n6, n7, n8;
//Initialize data and counters for Song Mode
reg[3:0] currentNote;
reg[3:0] octaveNotes[7:0];
reg[3:0] octaveCounter;
reg[3:0] twinkleNotes[42:0];
reg[7:0] twinkleCounter;
reg[3:0] happyNotes[111:0];
reg[7:0] happyCounter;
reg[3:0] pianoManNotes[182:0];
reg[7:0] pianoManCounter;
reg octavePosition;

initial begin
  currentNote = 0;
  pianoManCounter = 0;
  octavePosition = 0;
  octaveCounter = 0;
  twinkleCounter = 0;
  happyCounter = 0;

  //Octave Notes
  octaveNotes[0] = 4'd1;
  octaveNotes[1] = 4'd2;
  octaveNotes[2] = 4'd3;
  octaveNotes[3] = 4'd4;
  octaveNotes[4] = 4'd5;
  octaveNotes[5] = 4'd6;
  octaveNotes[6] = 4'd7;
  octaveNotes[7] = 4'd8;

  //"Random Noise"
  twinkleNotes[0] = 4'd1;
  twinkleNotes[1] = 4'd1;
  twinkleNotes[2] = 4'd4;
  twinkleNotes[3] = 4'd4;
  twinkleNotes[4] = 4'd5;
  twinkleNotes[5] = 4'd5;
  twinkleNotes[6] = 4'd4; //Held
  twinkleNotes[7] = 4'd4;
  twinkleNotes[8] = 4'd4;
  twinkleNotes[9] = 4'd3;
  twinkleNotes[10] = 4'd3;
  twinkleNotes[11] = 4'd2;
  twinkleNotes[12] = 4'd2;
  twinkleNotes[13] = 4'd1; //Held
  twinkleNotes[14] = 4'd5;
  twinkleNotes[15] = 4'd5;
  twinkleNotes[16] = 4'd4;
  twinkleNotes[17] = 4'd4;
  twinkleNotes[18] = 4'd3;
  twinkleNotes[19] = 4'd3;
  twinkleNotes[20] = 4'd2; //Held
  twinkleNotes[21] = 4'd1;
  twinkleNotes[22] = 4'd5;
  twinkleNotes[23] = 4'd5;
  twinkleNotes[24] = 4'd4;
  twinkleNotes[25] = 4'd4;
  twinkleNotes[26] = 4'd3;
  twinkleNotes[27] = 4'd3;
  twinkleNotes[28] = 4'd2; //Held
  twinkleNotes[29] = 4'd1;
  twinkleNotes[30] = 4'd1;
  twinkleNotes[31] = 4'd4;
  twinkleNotes[32] = 4'd4;
  twinkleNotes[33] = 4'd5;
  twinkleNotes[34] = 4'd5;
  twinkleNotes[35] = 4'd4; //Held
  twinkleNotes[36] = 4'd4;
  twinkleNotes[37] = 4'd4;
  twinkleNotes[38] = 4'd3;
  twinkleNotes[39] = 4'd3;
  twinkleNotes[40] = 4'd2;
  twinkleNotes[41] = 4'd2;
  twinkleNotes[42] = 4'd1; //Held

  //Happy Birthday
  happyNotes[0] = 4'd1;
  happyNotes[1] = 4'd1;
  happyNotes[2] = 4'd1;
  happyNotes[3] = 4'd0;
  happyNotes[4] = 4'd1;
  happyNotes[5] = 4'd1;
  happyNotes[6] = 4'd1;
  happyNotes[7] = 4'd1;
  happyNotes[8] = 4'd2;
  happyNotes[9] = 4'd2;
  happyNotes[10] = 4'd2;
  happyNotes[11] = 4'd2;
  happyNotes[12] = 4'd1;
  happyNotes[13] = 4'd1;
  happyNotes[14] = 4'd1;
  happyNotes[15] = 4'd1;
  happyNotes[16] = 4'd4;
  happyNotes[17] = 4'd4;
  happyNotes[18] = 4'd4;
  happyNotes[19] = 4'd4;
  happyNotes[20] = 4'd3;
  happyNotes[21] = 4'd3;
  happyNotes[22] = 4'd3;
  happyNotes[23] = 4'd3;
  happyNotes[24] = 4'd3;
  happyNotes[25] = 4'd3;
  happyNotes[26] = 4'd3;
  happyNotes[27] = 4'd3;
  happyNotes[28] = 4'd1;
  happyNotes[29] = 4'd1;
  happyNotes[30] = 4'd1;
  happyNotes[31] = 4'd0;
  happyNotes[32] = 4'd1;
  happyNotes[33] = 4'd1;
  happyNotes[34] = 4'd1;
  happyNotes[35] = 4'd1;
  happyNotes[36] = 4'd2;
  happyNotes[37] = 4'd2;
  happyNotes[38] = 4'd2;
  happyNotes[39] = 4'd2;
  happyNotes[40] = 4'd1;
  happyNotes[41] = 4'd1;
  happyNotes[42] = 4'd1;
  happyNotes[43] = 4'd1;
  happyNotes[44] = 4'd5;
  happyNotes[45] = 4'd5;
  happyNotes[46] = 4'd5;
  happyNotes[47] = 4'd5;
  happyNotes[48] = 4'd4;
  happyNotes[49] = 4'd4;
  happyNotes[50] = 4'd4;
  happyNotes[51] = 4'd4;
  happyNotes[52] = 4'd4;
  happyNotes[53] = 4'd4;
  happyNotes[54] = 4'd4;
  happyNotes[55] = 4'd4;
  happyNotes[56] = 4'd1;
  happyNotes[57] = 4'd1;
  happyNotes[58] = 4'd1;
  happyNotes[59] = 4'd0;
  happyNotes[60] = 4'd1;
  happyNotes[61] = 4'd1;
  happyNotes[62] = 4'd1;
  happyNotes[63] = 4'd1;
  happyNotes[64] = 4'd8;
  happyNotes[65] = 4'd8;
  happyNotes[66] = 4'd8;
  happyNotes[67] = 4'd8;
  happyNotes[68] = 4'd6;
  happyNotes[69] = 4'd6;
  happyNotes[70] = 4'd6;
  happyNotes[71] = 4'd6;
  happyNotes[72] = 4'd4;
  happyNotes[73] = 4'd4;
  happyNotes[74] = 4'd4;
  happyNotes[75] = 4'd4;
  happyNotes[76] = 4'd3;
  happyNotes[77] = 4'd3;
  happyNotes[78] = 4'd3;
  happyNotes[79] = 4'd3;
  happyNotes[80] = 4'd2;
  happyNotes[81] = 4'd2;
  happyNotes[82] = 4'd2;
  happyNotes[83] = 4'd2;
  happyNotes[84] = 4'd9;
  happyNotes[85] = 4'd9;
  happyNotes[86] = 4'd9;
  happyNotes[87] = 4'd0;
  happyNotes[88] = 4'd9;
  happyNotes[89] = 4'd9;
  happyNotes[90] = 4'd9;
  happyNotes[91] = 4'd9;
  happyNotes[92] = 4'd6;
  happyNotes[93] = 4'd6;
  happyNotes[94] = 4'd6;
  happyNotes[95] = 4'd6;
  happyNotes[96] = 4'd4;
  happyNotes[97] = 4'd4;
  happyNotes[98] = 4'd4;
  happyNotes[99] = 4'd4;
  happyNotes[100] = 4'd5;
  happyNotes[101] = 4'd5;
  happyNotes[102] = 4'd5;
  happyNotes[103] = 4'd5;
  happyNotes[104] = 4'd4;
  happyNotes[105] = 4'd4;
  happyNotes[106] = 4'd4;
  happyNotes[107] = 4'd4;
  happyNotes[108] = 4'd4;
  happyNotes[109] = 4'd4;
  happyNotes[110] = 4'd4;
  happyNotes[111] = 4'd4;

  //Piano Man
  pianoManNotes[0] = 4'd4;
  pianoManNotes[1] = 4'd4;
  pianoManNotes[2] = 4'd4;
  pianoManNotes[3] = 4'd4;
  pianoManNotes[4] = 4'd5;
  pianoManNotes[5] = 4'd5;
  pianoManNotes[6] = 4'd5;
  pianoManNotes[7] = 4'd5;
  pianoManNotes[8] = 4'd5;
  pianoManNotes[9] = 4'd5;
  pianoManNotes[10] = 4'd5;
  pianoManNotes[11] = 4'd0;
  pianoManNotes[12] = 4'd5;
  pianoManNotes[13] = 4'd5;
  pianoManNotes[14] = 4'd5;
  pianoManNotes[15] = 4'd0;
  pianoManNotes[16] = 4'd5;
  pianoManNotes[17] = 4'd5;
  pianoManNotes[18] = 4'd5;
  pianoManNotes[19] = 4'd5;
  pianoManNotes[20] = 4'd4;
  pianoManNotes[21] = 4'd4;
  pianoManNotes[22] = 4'd4;
  pianoManNotes[23] = 4'd4;
  pianoManNotes[24] = 4'd3;
  pianoManNotes[25] = 4'd3;
  pianoManNotes[26] = 4'd3;
  pianoManNotes[27] = 4'd3;
  pianoManNotes[28] = 4'd4;
  pianoManNotes[29] = 4'd4;
  pianoManNotes[30] = 4'd4;
  pianoManNotes[31] = 4'd4;
  pianoManNotes[32] = 4'd3;
  pianoManNotes[33] = 4'd3;
  pianoManNotes[34] = 4'd3;
  pianoManNotes[35] = 4'd3;
  pianoManNotes[36] = 4'd1;
  pianoManNotes[37] = 4'd1;
  pianoManNotes[38] = 4'd1;
  pianoManNotes[39] = 4'd1;
  pianoManNotes[40] = 4'd1;
  pianoManNotes[41] = 4'd1;
  pianoManNotes[42] = 4'd1;
  pianoManNotes[43] = 4'd1;
  pianoManNotes[44] = 4'd0;
  pianoManNotes[45] = 4'd0;
  pianoManNotes[46] = 4'd0;
  pianoManNotes[47] = 4'd0;
  pianoManNotes[48] = 4'd0;
  pianoManNotes[49] = 4'd0;
  pianoManNotes[50] = 4'd0;
  pianoManNotes[51] = 4'd0;
  pianoManNotes[52] = 4'd1;
  pianoManNotes[53] = 4'd1;
  pianoManNotes[54] = 4'd1;
  pianoManNotes[55] = 4'd0;
  pianoManNotes[56] = 4'd1;
  pianoManNotes[57] = 4'd1;
  pianoManNotes[58] = 4'd1;
  pianoManNotes[59] = 4'd0;
  pianoManNotes[60] = 4'd1;
  pianoManNotes[61] = 4'd1;
  pianoManNotes[62] = 4'd1;
  pianoManNotes[63] = 4'd0;
  pianoManNotes[64] = 4'd1;
  pianoManNotes[65] = 4'd1;
  pianoManNotes[66] = 4'd1;
  pianoManNotes[67] = 4'd0;
  pianoManNotes[68] = 4'd1;
  pianoManNotes[69] = 4'd1;
  pianoManNotes[70] = 4'd1;
  pianoManNotes[71] = 4'd1;
  pianoManNotes[72] = 4'd2;
  pianoManNotes[73] = 4'd2;
  pianoManNotes[74] = 4'd2;
  pianoManNotes[75] = 4'd0;
  pianoManNotes[76] = 4'd2;
  pianoManNotes[77] = 4'd2;
  pianoManNotes[78] = 4'd2;
  pianoManNotes[79] = 4'd0;
  pianoManNotes[80] = 4'd2;
  pianoManNotes[81] = 4'd2;
  pianoManNotes[82] = 4'd2;
  pianoManNotes[83] = 4'd2;
  pianoManNotes[84] = 4'd2;
  pianoManNotes[85] = 4'd2;
  pianoManNotes[86] = 4'd2;
  pianoManNotes[87] = 4'd2;
  pianoManNotes[88] = 4'd0;
  pianoManNotes[89] = 4'd0;
  pianoManNotes[90] = 4'd0;
  pianoManNotes[91] = 4'd0;
  pianoManNotes[92] = 4'd0;
  pianoManNotes[93] = 4'd0;
  pianoManNotes[94] = 4'd0;
  pianoManNotes[95] = 4'd0;
  pianoManNotes[96] = 4'd5;
  pianoManNotes[97] = 4'd5;
  pianoManNotes[98] = 4'd5;
  pianoManNotes[99] = 4'd0;
  pianoManNotes[100] = 4'd5;
  pianoManNotes[101] = 4'd5;
  pianoManNotes[102] = 4'd5;
  pianoManNotes[103] = 4'd0;
  pianoManNotes[104] = 4'd5;
  pianoManNotes[105] = 4'd5;
  pianoManNotes[106] = 4'd5;
  pianoManNotes[107] = 4'd0;
  pianoManNotes[108] = 4'd5;
  pianoManNotes[109] = 4'd5;
  pianoManNotes[110] = 4'd5;
  pianoManNotes[111] = 4'd5;
  pianoManNotes[112] = 4'd5;
  pianoManNotes[113] = 4'd5;
  pianoManNotes[114] = 4'd5;
  pianoManNotes[115] = 4'd5;
  pianoManNotes[116] = 4'd4;
  pianoManNotes[117] = 4'd4;
  pianoManNotes[118] = 4'd4;
  pianoManNotes[119] = 4'd4;
  pianoManNotes[120] = 4'd3;
  pianoManNotes[121] = 4'd3;
  pianoManNotes[122] = 4'd3;
  pianoManNotes[123] = 4'd3;
  pianoManNotes[124] = 4'd4;
  pianoManNotes[125] = 4'd4;
  pianoManNotes[126] = 4'd4;
  pianoManNotes[127] = 4'd4;
  pianoManNotes[128] = 4'd3;
  pianoManNotes[129] = 4'd3;
  pianoManNotes[130] = 4'd3;
  pianoManNotes[131] = 4'd3;
  pianoManNotes[132] = 4'd1;
  pianoManNotes[133] = 4'd1;
  pianoManNotes[134] = 4'd1;
  pianoManNotes[135] = 4'd1;
  pianoManNotes[136] = 4'd0;
  pianoManNotes[137] = 4'd0;
  pianoManNotes[138] = 4'd0;
  pianoManNotes[139] = 4'd0;
  pianoManNotes[140] = 4'd0;
  pianoManNotes[141] = 4'd0;
  pianoManNotes[142] = 4'd0;
  pianoManNotes[143] = 4'd0;
  pianoManNotes[144] = 4'd10;
  pianoManNotes[145] = 4'd10;
  pianoManNotes[146] = 4'd10;
  pianoManNotes[147] = 4'd0;
  pianoManNotes[148] = 4'd10;
  pianoManNotes[149] = 4'd10;
  pianoManNotes[150] = 4'd10;
  pianoManNotes[151] = 4'd0;
  pianoManNotes[152] = 4'd10;
  pianoManNotes[153] = 4'd10;
  pianoManNotes[154] = 4'd10;
  pianoManNotes[155] = 4'd10;
  pianoManNotes[156] = 4'd4;
  pianoManNotes[157] = 4'd4;
  pianoManNotes[158] = 4'd4;
  pianoManNotes[159] = 4'd0;
  pianoManNotes[160] = 4'd4;
  pianoManNotes[161] = 4'd4;
  pianoManNotes[162] = 4'd4;
  pianoManNotes[163] = 4'd0;
  pianoManNotes[164] = 4'd4;
  pianoManNotes[165] = 4'd4;
  pianoManNotes[166] = 4'd4;
  pianoManNotes[167] = 4'd4;
  pianoManNotes[168] = 4'd3;
  pianoManNotes[169] = 4'd3;
  pianoManNotes[170] = 4'd3;
  pianoManNotes[171] = 4'd3;
  pianoManNotes[172] = 4'd1;
  pianoManNotes[173] = 4'd1;
  pianoManNotes[174] = 4'd1;
  pianoManNotes[175] = 4'd1;
  pianoManNotes[176] = 4'd1;
  pianoManNotes[177] = 4'd1;
  pianoManNotes[178] = 4'd1;
  pianoManNotes[179] = 4'd1;
  pianoManNotes[180] = 4'd1;
  pianoManNotes[181] = 4'd1;
  pianoManNotes[182] = 4'd1;
end

//Note Wires
wire note1, note2, note3, note4, note5, note6, note7, note8, note9, note10, sN, tN, fullNote, halfNote, quarterNote;
//Notes
note #(25000000/220/2) a3(clk, note10);
note #(25000000/262/2) c4(clk, note1);
note #(25000000/294/2) d(clk, note2);
note #(25000000/330/2) e(clk, note3);
note #(25000000/349/2) f(clk, note4);
note #(25000000/392/2) g(clk, note5);
note #(25000000/440/2) a(clk, note6);
note #(25000000/466/2) bFlat(clk, note9);
note #(25000000/494/2) b(clk, note7);
note #(25000000/523/2) c5(clk, note8);
note #(25000000/1/2) fN(clk, fullNote);
note #(25000000/2/2) hN(clk, halfNote);
note #(25000000/4/2) qN(clk, quarterNote);
note #(25000000/16/2) sixteenthN(clk, sN);
note #(25000000/14/2) twelfthN(clk, tN);

always @(posedge clk) begin
  if(!btn) begin //Piano Mode
    n1 <= note1 & sw[7];
    n2 <= note2 & sw[6];
    n3 <= note3 & sw[5];
    n4 <= note4 & sw[4];
    n5 <= note5 & sw[3];
    n6 <= note6 & sw[2];
    n7 <= note7 & sw[1];
    n8 <= note8 & sw[0];
  end
  else begin //Song Mode
    if (btn[0]) begin // Play octave
      if(sN & !octavePosition) begin // Increment octave counter on sN timing
        if(octaveCounter == 4'd7) begin
          octaveCounter = 0; // Reset counter if at end
        end
        else begin
          octaveCounter = octaveCounter + 1; // Increment counter otherwise
        end
        octavePosition = 1;
      end
      if(!sN & octavePosition) begin
        octavePosition = 0; // toggle position after sN timer goes back down.
      end
      currentNote = octaveNotes[octaveCounter];
    end
    if (btn[1]) begin // Play Random Noise
      if(sN & !octavePosition) begin //Increment octave counter on sN timing
        if(twinkleCounter == 8'd42) begin
          twinkleCounter = 0;
        end
        else begin
          twinkleCounter = twinkleCounter + 1;
        end
        octavePosition = 1;
      end
      if(!sN & octavePosition) begin
        octavePosition = 0;
      end
      currentNote = twinkleNotes[twinkleCounter];
    end
    if (btn[2]) begin // Play Happy Birthday
      if(sN & !octavePosition) begin //Increment octave counter on sN timing
        if(happyCounter == 8'd111) begin
          happyCounter = 0;
        end
        else begin
          happyCounter = happyCounter + 1;
        end
        octavePosition = 1;
      end
      if(!sN & octavePosition) begin
        octavePosition = 0;
      end
      currentNote = happyNotes[happyCounter];
    end
    if (btn[3]) begin
      if(tN & !octavePosition) begin //Increment octave counter on tN timing
        if(pianoManCounter == 8'd182) begin
          pianoManCounter = 0;
        end
        else begin
          pianoManCounter = pianoManCounter + 1;
        end
        octavePosition = 1;
      end
      if(!tN & octavePosition) begin
        octavePosition = 0;
      end
      currentNote = pianoManNotes[pianoManCounter];
    end
    case(currentNote) // Send specific notes through output note 1
      4'd0: begin
        n1 <= 0;
      end
      4'd1: begin
        n1 <= note1;
      end
      4'd2: begin
        n1 <= note2;
      end
      4'd3: begin
        n1 <= note3;
      end
      4'd4: begin
        n1 <= note4;
      end
      4'd5: begin
        n1 <= note5;
      end
      4'd6: begin
        n1 <= note6;
      end
      4'd7: begin
        n1 <= note7;
      end
      4'd8: begin
        n1 <= note8;
      end
      4'd9: begin
        n1 <= note9;
      end
      4'd10: begin
        n1 <= note10;
      end
    endcase
  end
end
endmodule

module testpiano; // A test module to view waveforms (frequencies should be at least 100 or so to be able to be seen.)
reg clk;
reg[7:0] sw;
reg[3:0] btn;
wire n1, n2, n3, n4, n5, n6, n7, n8;
piano p(clk, sw, btn, n1, n2, n3, n4, n5, n6, n7, n8);

initial begin
  btn[0] = 1;
  clk = 0;
end
always begin
  #00001 clk = !clk;
end
endmodule

/*
262 C4
294 D
330 E
349 F
392 G
440 A
494 B
523 //A4
*/