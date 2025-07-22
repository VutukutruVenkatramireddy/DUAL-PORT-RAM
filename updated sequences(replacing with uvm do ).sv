class ram_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils (ram_sequence)
//constructor
function new(string name="ram_sequence");
super.new(name);
endfunction

virtual task body();
ram_seq_item req;
repeat(20) begin

`uvm_do(req);
end
endtask
endclass



//both read write are high 
/*class ram_write_read_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_read_seq)
ram_seq_item req;
function new(string name = "ram_write_read_seq");
super.new(name);
endfunction

task body();
repeat (10)begin
`uvm_do_with(req, {write==1 ; read==1;})
end
endtask
endclass*/

//replace uvm do
//both read write are high 
class ram_write_read_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_read_seq)
ram_seq_item req;
function new(string name = "ram_write_read_seq");
super.new(name);
req=ram_seq_item::type_id::create("req");
endfunction

task body();
repeat (10)begin
wait_for_grant();
assert (req.randomize() with{write ==1; read ==1;});
//req.randomize();
send_request(req);
wait_for_item_done();
end
endtask
endclass




//MULTIPLE WRITE AND READ
class multiple_wr_rd_seq  extends uvm_sequence#(ram_seq_item);
`uvm_object_utils(multiple_wr_rd_seq)
 
  ram_seq_item req;
  bit   [7:0] start_addr = 8'd100;
  bit   [7:0] addr_q[$];
  int         N1, N2;
 
function new(string name = "multiple_wr_rd_seq");
super.new(name);
req=ram_seq_item::type_id::create("req");
endfunction
 
task body();
N1 = $urandom_range(0,30);
N2 = $urandom_range(0,N1);
`uvm_info("WR_SEQ", $sformatf("Randomized N1 = %0d", N1), UVM_LOW)
`uvm_info("RD_SEQ", $sformatf("Randomized N2 = %0d", N2), UVM_LOW)
 
for (int i = 0; i < N1; i++) begin
start_item(req);
assert (req.randomize()with { write == 1; read == 0; wr_address == start_addr + i; })
finish_item(req);
addr_q.push_back(req.wr_address);
end 
for (int i = 0; i < N2; i++) begin
start_item(req);
assert (req.randomize() with{ write == 0; read == 1; rd_address == addr_q[i]; })
finish_item(req);
end
endtask
endclass




//write read with delay
/*class ram_wr_rd_delay_seq extends uvm_sequence #(ram_seq_item);
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
endclass*/


//started modification replace with uvm do 
//write read with delay
class ram_wr_rd_delay_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_wr_rd_delay_seq)
bit [4:0] delay_n;  
bit [7:0] temp_addr;
 
function new(string name = "ram_wr_rd_delay_seq");
super.new(name);
req=ram_seq_item::type_id::create("req");
endfunction
 
virtual task body();
//repeat (10) begin
wait_for_grant();
assert(req.randomize() with{write == 1; read ==0;});
temp_addr = req.wr_address;
send_request(req);
wait_for_item_done();
wait_for_grant();
assert(req.randomize()with{write ==0;read == 1;rd_address ==temp_addr;})
send_request(req);
wait_for_item_done();
delay_n = $urandom_range(0,30);
`uvm_info("WR_RD_DELAY_SEQ", $sformatf("Delaying for %0d ns", delay_n), UVM_MEDIUM)
#delay_n;
wait_for_grant();
assert(req.randomize()with{write==1;read==0;})
send_request(req);
wait_for_item_done();
temp_addr = req.wr_address;
wait_for_grant();
assert(req.randomize()with{write == 0;read == 1;rd_address ==temp_addr;})
send_request(req);
wait_for_item_done();
wait_for_grant();
assert(req.randomize()with{write == 0;read == 0;})
send_request(req);
wait_for_item_done();
endtask
endclass


