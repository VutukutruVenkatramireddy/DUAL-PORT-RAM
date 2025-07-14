class wr_rd_delay extends ram_test;
`uvm_component_utils(wr_rd_delay)
ram_wr_rd_delay_seq seq;
//constructor
function new(string name,uvm_component parent = null);
super.new(name,parent);
endfunction

//build_phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
seq=ram_wr_rd_delay_seq::type_id::create("seq");
endfunction
task run_phase (uvm_phase phase);
 phase.raise_objection(this);
    seq.start(env.agnt.sequencer);
    phase.drop_objection(this);
  endtask
endclass
