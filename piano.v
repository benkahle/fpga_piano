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

module testpiano;
reg clk;
wire A4, B, C, D, E, F, G, A5;
note #(25000000/440/2) a4(clk, A4);
note #(25000000/494/2) b(clk, B);
note #(25000000/523/2) c(clk, C);
note #(25000000/587/2) d(clk, D);
note #(25000000/659/2) e(clk, E);
note #(25000000/698/2) f(clk, F);
note #(25000000/784/2) g(clk, G);
note #(25000000/880/2) a5(clk, A5);

initial begin
  clk = 0;
end
always begin
  #2 clk = !clk;
end
endmodule

/*
440 A4
494 B
523 C
587 D
659 E
698 F
784 G
880 //A5


*/