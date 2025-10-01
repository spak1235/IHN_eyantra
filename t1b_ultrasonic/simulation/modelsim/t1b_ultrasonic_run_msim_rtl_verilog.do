transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/sohan/Documents/Grindelwald/IHN_eyantra/t1b_ultrasonic/code {/home/sohan/Documents/Grindelwald/IHN_eyantra/t1b_ultrasonic/code/t1b_ultrasonic.v}

vlog -vlog01compat -work work +incdir+/home/sohan/Documents/Grindelwald/IHN_eyantra/t1b_ultrasonic/.test {/home/sohan/Documents/Grindelwald/IHN_eyantra/t1b_ultrasonic/.test/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 48065350 ns
