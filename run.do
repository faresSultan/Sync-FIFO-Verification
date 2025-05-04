vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc top -cover
run 0
add wave -position insertpoint sim:/top/fifo_if/*
add wave -position insertpoint  \
sim:/top/monitor/txn
add wave -position insertpoint  \
sim:/top/DUT/mem \
sim:/top/DUT/wr_ptr \
sim:/top/DUT/rd_ptr \
sim:/top/DUT/count
coverage save FIFO_tb.ucdb -onexit 
run -all


