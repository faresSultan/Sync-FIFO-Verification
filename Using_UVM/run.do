vlib work 
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/fifo_if/*
coverage save FIFO_tb.ucdb -onexit 
run -all