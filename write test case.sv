class wr_op extends ram_test;
  `uvm_component_utils(wr_op)
 
  ram_write_seq seq;
 
  function new(string name = "wr_op", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = ram_write_seq::type_id::create("seq");
  endfunction
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agnt.sequencer);
    phase.drop_objection(this);
  endtask
endclass
