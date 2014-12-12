module note(clk, speaker);
input clk;
output reg speaker;
parameter clkdivider = 25000000/440/2;

reg [15:0] counter;
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

module piano(clk, sw, btn, n1, n2, n3, n4, n5, n6, n7, n8);
input clk;
input[7:0] sw;
input[3:0] btn;
output reg n1, n2, n3, n4, n5, n6, n7, n8;
reg[7:0] octaveNotes[7:0] = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8};
reg[3:0] octaveCounter;
reg octavePosition;
wire note1, note2, note3, note4, note5, note6, note7, note8, fullNote, halfNote, quarterNote;
note #(25000000/262/2) c4(clk, note1);
note #(25000000/294/2) d(clk, note2);
note #(25000000/330/2) e(clk, note3);
note #(25000000/349/2) f(clk, note4);
note #(25000000/392/2) g(clk, note5);
note #(25000000/440/2) a(clk, note6);
note #(25000000/494/2) b(clk, note7);
note #(25000000/523/2) c5(clk, note8);
note #(25000000/12500000/2) fN(clk,fullNote);
note #(25000000/12500000/2) hN(clk,fullNote);
note #(25000000/6250000/2) qN(clk,fullNote);
always @(posedge clk) begin
  if(!btn) begin
    n1 = note1 & sw[7];
    n2 = note2 & sw[6];
    n3 = note3 & sw[5];
    n4 = note4 & sw[4];
    n5 = note5 & sw[3];
    n6 = note6 & sw[2];
    n7 = note7 & sw[1];
    n8 = note8 & sw[0];
  end
  else begin
    if (btn[0]) begin // Play octave
      if(fullNote && !octavePosition) begin //Increment octave counter on fullNote timing
        octaveCounter = octaveCounter + 1;
        octavePosition = 1;
      end
      if(!fullNote && octavePosition) begin
        octavePosition = 0;
      end
      n1 = note1 & sw[7];
      n2 = note2 & sw[6];
      n3 = note3 & sw[5];
      n4 = note4 & sw[4];
      n5 = note5 & sw[3];
      n6 = note6 & sw[2];
      n7 = note7 & sw[1];
      n8 = note8 & sw[0];
    end
    // if (btn[1]) begin
      
    // end
    // if (btn[2]) begin
      
    // end
    // if (btn[3]) begin
      
    // end
  end
end
endmodule

module testpiano;
reg clk;
wire note1, note2, note3, note4, note5, note6, note7, note8;
note #(25000000/262/2) c4(clk, note1);
note #(25000000/294/2) d(clk, note2);
note #(25000000/330/2) e(clk, note3);
note #(25000000/349/2) f(clk, note4);
note #(25000000/392/2) g(clk, note5);
note #(25000000/440/2) a(clk, note6);
note #(25000000/494/2) b(clk, note7);
note #(25000000/523/2) c5(clk, note8);

initial begin
  clk = 0;
end
always begin
  #2 clk = !clk;
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