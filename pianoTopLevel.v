module pianoTopModule(clk, sw, btn, n1, n2, n3, n4, n5, n6, n7, n8);
input clk;
input[7:0] sw;
input[3:0] btn;
output wire n1, n2, n3, n4, n5, n6, n7, n8;
piano p(clk, sw, btn, n1, n2, n3, n4, n5, n6, n7, n8);
endmodule