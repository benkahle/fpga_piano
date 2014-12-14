vlog -reportprogress 300 -work work piano.v
vsim -voptargs="+acc" testpiano
add wave -position insertpoint \
sim:/testpiano/p/fullNote \
sim:/testpiano/n1 \
sim:/testpiano/n2 \
sim:/testpiano/n3 \
sim:/testpiano/n4 \
sim:/testpiano/n5 \
sim:/testpiano/n6 \
sim:/testpiano/n7 \
sim:/testpiano/n8 
run 4000000000
wave zoom full
