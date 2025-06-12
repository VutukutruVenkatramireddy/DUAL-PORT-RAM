class ram_agent extends uvm_agent;
`uvm_component_utils(ram_agent)
ram_sequencer sequencer;
ram_driver drv;
ram_monitor mon;
//constructor
function new(string name,uvm_component parent);
super.new(name,parent);
endfunction

//buildphase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon=ram_monitor::type_id::create("mon",this);
if(get_is_active() == UVM_ACTIVE) begin
sequencer=ram_sequencer::type_id::create("sequencer",this);
drv=ram_driver::type_id::create("drv",this);
end
endfunction
//connect phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(get_is_active() == UVM_ACTIVE) begin
drv.seq_item_port.connect(sequencer.seq_item_export);
end
endfunction
endclass
