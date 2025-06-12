class ram_env extends uvm_env;
`uvm_component_utils(ram_env)
ram_agent agnt;
ram_scb scb;
ram_coverage cov;
//constructor
function new(string name,uvm_component parent);
super.new(name,parent);
endfunction

//build phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
agnt = ram_agent::type_id::create("agnt",this);
scb= ram_scb::type_id::create("scb",this);
cov = ram_coverage::type_id::create("cov", this);

endfunction
//connect_phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
agnt.mon.item_collected_port.connect(scb.item_collected_export);
agnt.mon.item_collected_port.connect(cov.analysis_export);

endfunction
endclass
