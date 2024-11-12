vlib work
vlog -f src.list +cover -covercells
vsim -voptargs=+acc work.top -cover

add wave -position insertpoint  \
sim:/top/fif/clk \
sim:/top/fif/rst_n \
sim:/top/fif/wr_en \
sim:/top/fif/rd_en \
sim:/top/fif/data_in \
sim:/top/fif/data_out \
sim:/top/fif/wr_ack \
sim:/top/fif/empty \
sim:/top/fif/full \
sim:/top/fif/almostempty \
sim:/top/fif/almostfull \
sim:/top/fif/overflow \
sim:/top/fif/underflow \

add wave -position insertpoint  \
sim:/top/DUT/wr_ptr \
sim:/top/DUT/rd_ptr \
sim:/top/DUT/count \
sim:/top/DUT/mem 

add wave /top/DUT/wr_ptr_inc_assertion \
/top/DUT/rd_ptr_inc_assertion \
/top/DUT/wr_ptr_const_assertion \
/top/DUT/rd_ptr_const_assertion \
/top/DUT/counter_dec_assertion \
/top/DUT/counter_inc_assertion \
/top/DUT/counter_const_assertion \
/top/DUT/wr_ack_assertion \
/top/DUT/overflow_assertion \
/top/DUT/immediate_assertions/full_assertion \
/top/DUT/immediate_assertions/empty_assertion \
/top/DUT/immediate_assertions/underflow_assertion \
/top/DUT/immediate_assertions/almostfull_assertion \
/top/DUT/immediate_assertions/almostempty_assertion \
/top/DUT/immediate_assertions/reset_assertion

coverage exclude -src FIFO.sv -line 30 -code c

coverage save fifo.ucdb -onexit
run -all
vcover report fifo.ucdb -details -annotate -all -output coverage_rpt.txt