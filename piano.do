vlog -reportprogress 300 -work work piano.v
vsim -voptargs="+acc" testpiano
add wave -position insertpoint \
sim:/testpiano/clk \
sim:/testpiano/note1 \
sim:/testpiano/note2 \
sim:/testpiano/note3 \
sim:/testpiano/note4 \
sim:/testpiano/note5 \
sim:/testpiano/note6 \
sim:/testpiano/note7 \
sim:/testpiano/note8
run 400000
wave zoom full
