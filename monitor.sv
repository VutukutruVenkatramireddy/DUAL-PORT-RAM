/code required original old code 
class ram_monitor extends uvm_monitor;
`uvm_component_utils(ram_monitor)
ram_seq_item tx;
virtual ram_intf vif;
uvm_analysis_port #(ram_seq_item) item_collected_port;
//constructor
function new(string name,uvm_component parent);
super.new(name,parent);
tx=new();
  item_collected_port = new("item_collected_port",this);
endfunction

//buildphase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(virtual ram_intf)::get(this,"","vif",vif)) begin
`uvm_fatal("NO VIF",{"virtual interface not set",get_full_name(),"vif"}) end
endfunction

//task run phase
virtual task run_phase(uvm_phase phase);
forever begin
@(vif.mon_cb);
tx.write = vif.mon_cb.write;
tx.read = vif.mon_cb.read;
tx.wr_address = vif.mon_cb.wr_address;
tx.rd_address =vif.mon_cb.rd_address;
tx.data_in = vif.mon_cb.data_in;
tx.data_out = vif.data_out;
`uvm_info("Monitor", $sformatf("time=%0t,wr_address=%0d,rd_address=%0d,check the value data_out=%0d",$time,tx.wr_address,tx.rd_address,tx.data_out),UVM_MEDIUM)
item_collected_port.write(tx);
end
endtask
endclass
