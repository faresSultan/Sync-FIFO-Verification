vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc top -cover
add wave -position insertpoint sim:/top/tb/counterIF/*
coverage save counter_tb.ucdb -onexit 
run -all


