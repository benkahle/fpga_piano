vlog -reportprogress 300 -work work piano.v
vsim -voptargs="+acc" testpiano
add wave -position insertpoint \
sim:/testpiano/p/fullNote \
sim:/testpiano/p/octaveCounter \
sim:/testpiano/p/octavePosition \
sim:/testpiano/n1
run 5000000
wave zoom full
