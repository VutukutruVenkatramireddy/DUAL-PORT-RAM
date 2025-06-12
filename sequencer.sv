class ram_sequencer extends uvm_sequencer #(ram_seq_item);
`uvm_component_utils (ram_sequencer)
//constructor
function new(string name,uvm_component parent);
super.new(name,parent);
endfunction
endclass
