class ram_seq_item extends uvm_sequence_item;
rand bit write;
rand bit read;
rand bit [7:0] wr_address;
rand bit [7:0] rd_address;
rand bit [15:0] data_in;
bit [15:0] data_out;
`uvm_object_utils_begin(ram_seq_item)
`uvm_field_int(write,UVM_ALL_ON)
`uvm_field_int(read,UVM_ALL_ON)
`uvm_field_int(wr_address,UVM_ALL_ON)
`uvm_field_int(rd_address,UVM_ALL_ON)
`uvm_field_int(data_in,UVM_ALL_ON)
`uvm_field_int(data_out,UVM_ALL_ON)
`uvm_object_utils_end
function new(string name="ram_seq_item");
super.new(name);
endfunction
endclass
