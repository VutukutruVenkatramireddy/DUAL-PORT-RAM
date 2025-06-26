class multi_wr_rd extends ram_test;
`uvm_component_utils(multi_wr_rd) 
multiple_wr_rd_seq seq;
function new(string name = "multi_wr_rd ",uvm_component parent = null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
seq=multiple_wr_rd_seq::type_id::create("seq");
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agnt.sequencer);
    phase.drop_objection(this);
  endtask
endclass
