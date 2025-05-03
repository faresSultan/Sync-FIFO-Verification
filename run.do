vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc top -cover
run 0
add wave -position insertpoint sim:/top/fifo_if/*
add wave -position insertpoint  \
sim:/top/monitor/txn
coverage save FIFO_tb.ucdb -onexit 
run -all


