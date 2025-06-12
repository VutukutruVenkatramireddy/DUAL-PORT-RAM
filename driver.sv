class ram_driver extends uvm_driver #(ram_seq_item);
`uvm_component_utils(ram_driver)
virtual ram_intf vif;

//constructor
function new(string name,uvm_component parent);
super.new(name, parent);
endfunction
//build phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual ram_intf)::get(this,"","vif",vif))
`uvm_fatal("No_VIF",{"virtual iterface must be set for " ,get_full_name(),"vif"})
endfunction:build_phase
//run phase
virtual task run_phase(uvm_phase phase);
forever begin
ram_seq_item req;
seq_item_port.get_next_item(req);
drive(req);
seq_item_port.item_done();
end
endtask
virtual task drive(ram_seq_item req);

@(vif.drv_cb); 
vif.drv_cb.write <= req.write;
vif.drv_cb.read <= req.read;
vif.drv_cb.wr_address <= req.wr_address;
vif.drv_cb.rd_address <= req.rd_address;
vif.drv_cb.data_in <= req.data_in;
`uvm_info("Driver",$sformatf("time=%0t,write=%0d,read=%0d,wr_address=%0d,rd_address=%0d,data_in=%0d",$time,vif.write,vif.read,vif.wr_address,vif.rd_address,vif.data_in),UVM_MEDIUM)


endtask
endclass
