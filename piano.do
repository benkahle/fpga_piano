vlog -reportprogress 300 -work work piano.v
vsim -voptargs="+acc" testpiano
add wave -position insertpoint \
sim:/testpiano/clk \
sim:/testpiano/speaker
run 400000
wave zoom full
