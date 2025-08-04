vlib work
vlog *.v
vsim -voptargs=+acc work.spi_DUT
add wave *
run -all
#quit -sim