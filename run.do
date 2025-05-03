vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc top -cover
add wave -position insertpoint sim:/top/fifo_if/*
coverage save FIFO_tb.ucdb -onexit 
run -all


