vlog -reportprogress 300 -work work piano.v
vsim -voptargs="+acc" testpiano
add wave -position insertpoint \
sim:/testpiano/clk \
sim:/testpiano/A4 \
sim:/testpiano/B \
sim:/testpiano/C \
sim:/testpiano/D \
sim:/testpiano/E \
sim:/testpiano/F \
sim:/testpiano/G \
sim:/testpiano/A5
run 400000
wave zoom full
