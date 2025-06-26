UVM_HOME = /cad/cadence/INCISIV152/tools/methodology/UVM/CDNS-1.1d/sv
 
# List of test names for regression
TESTS = ram_test \
  wr_op \
  rd_op \
  wr_rd_op \
  wr_rd_low_op \
  wr_after_rd_op \
  wr_rd_same_address_op \
  rd_only_particular_address_op \
  wr_rd_idle_op \
  multi_wr_rd
 
# Common IRUN options
SIM = irun
COMMON_OPTS = -access +rwc -clean -uvmhome $(UVM_HOME) -f ram_uvm.f -coverage all -covoverwrite
SEED ?= random
 
# Regression target
run_all:
	@for test in $(TESTS); do \ echo "Running $$test..."; \
		$(SIM) $(COMMON_OPTS) +UVM_TESTNAME=$$test -svseed $(SEED); \
	done


run:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=ram_test -f ram_uvm.f \
	-coverage all -covoverwrite  \
        -covworkdir coverage/ram_test 
run1:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=wr_op -f ram_uvm.f \
	-coverage all -covoverwrite   \
        -covworkdir coverage/wr_op 
run2:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=rd_op -f ram_uvm.f \
	-coverage all -covoverwrite   \
        -covworkdir coverage/rd_op 

run3:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=wr_rd_op -f ram_uvm.f \
	-coverage all -covoverwrite   \
        -covworkdir coverage/wr_rd_op 
run4:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=wr_rd_low_op -f ram_uvm.f \
	 -coverage all -covoverwrite   \
	-covworkdir coverage/wr_rd_low_op 
run5:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=wr_after_rd_op -f ram_uvm.f \
	 -coverage all -covoverwrite   \
	-covworkdir coverage/wr_after_rd_op 
run6:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=wr_rd_same_address_op -f ram_uvm.f \
	 -coverage all -covoverwrite   \
        -covworkdir coverage/wr_rd_same_address_op  
run7:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=rd_only_particular_address_op -f ram_uvm.f \
	 -coverage all -covoverwrite   \
        -covworkdir coverage/rd_only_particular_address_op 
run8:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=wr_rd_idle_op -f ram_uvm.f \
	 -coverage all -covoverwrite   \
        -covworkdir coverage/wr_rd_idle_op 
run9:
	irun -access +rwc -clean -uvmhome $(UVM_HOME) +UVM_TESTNAME=multi_wr_rd -f ram_uvm.f \
	 -coverage all -covoverwrite   \
        -covworkdir coverage/multi_wr_rd 
 
cov:
	imc -execcmd "merge -out all cov_work/scope/*; exit"
clean:
	rm -rf irun.* INCA* *.log *.key *.vcd *.fsdb *.ucd *.history *.simvision cov_work merged_cov
cov1:
	imc -batch "merge  coverage/*/scope/test -out all; exit"
