//write read with delay
class ram_wr_rd_delay_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_wr_rd_delay_seq)
bit [4:0] delay_n;  
bit [7:0] temp_addr;
 
function new(string name = "ram_wr_rd_delay_seq");
super.new(name);
endfunction
 
virtual task body();
repeat (10) begin
`uvm_do_with(req,{write == 1;read == 0;})
temp_addr = req.wr_address;
`uvm_do_with(req, {write == 0;read == 1;rd_address == temp_addr;})
delay_n = $urandom_range(0,30);
`uvm_info("WR_RD_DELAY_SEQ", $sformatf("Delaying for %0d ns", delay_n), UVM_MEDIUM)
#delay_n;
`uvm_do_with(req, {write == 1;read == 0;})
temp_addr = req.wr_address;
`uvm_do_with(req, {write == 0;read == 1;rd_address == temp_addr;})
`uvm_do_with(req, {write == 0;read == 0;})
end
endtask
endclass
