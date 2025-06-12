class ram_test extends uvm_test;
`uvm_component_utils(ram_test)
ram_env env;
ram_sequence seq;

// constructor
function new(string name, uvm_component parent);
super.new(name, parent);
endfunction
//build_phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = ram_env::type_id::create("env", this);
seq = ram_sequence::type_id::create("seq");

endfunction

// task run phase
virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
if(seq ==null)begin
`uvm_error(get_type_name(), "Failed");
end else 
begin
seq.start(env.agnt.sequencer);
end
phase.drop_objection(this);
endtask
endclass
