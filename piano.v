module piano(clk, speaker);
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
wire speaker;
piano p(clk, speaker);

initial begin
  clk = 0;
end
always begin
  #2 clk = !clk;
end
endmodule

/*
440 //A4
466
493
523
554
587
622
659
698
739
783
803

880 //A5


*/