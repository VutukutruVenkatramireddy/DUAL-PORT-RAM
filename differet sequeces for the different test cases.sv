/only write operation
class ram_write_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_seq)
ram_seq_item req;
function new(string name = "ram_write_seq");
super.new(name);
endfunction

task body();
repeat (10) begin
`uvm_do_with(req, {write==1 ; read==0;})
`uvm_info(get_full_name(),"write high pass \n",UVM_MEDIUM) 
 end
 endtask
endclass


//only read operation
class ram_read_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_read_seq)
ram_seq_item req;
function new(string name = "ram_read_seq");
super.new(name);
endfunction
task body();
repeat (10) begin
`uvm_do_with(req, {write==0 ; read==1;})
`uvm_info(get_full_name(),"read high  pass",UVM_MEDIUM) 
end
endtask
endclass

//both read write are high 
class ram_write_read_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_read_seq)
ram_seq_item req;
function new(string name = "ram_write_read_seq");
super.new(name);
endfunction

task body();
repeat (10)begin
`uvm_do_with(req, {write==1 ; read==1;})
`uvm_info(get_full_name(),"both high pass",UVM_MEDIUM) 
  end
endtask
endclass

//both low write and read
class ram_write_read_low_seq extends uvm_sequence #(ram_seq_item);
  `uvm_object_utils(ram_write_read_low_seq)
ram_seq_item req;
  function new(string name = "ram_write_read_low_seq");
    super.new(name);
  endfunction

task body();
repeat (10)begin
 `uvm_do_with(req, {write==0 ; read==0;})
 `uvm_info(get_full_name(),"both LOW pass",UVM_MEDIUM)   
   end
endtask
endclass


//write after read from different address operation test case

class ram_write_after_read_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_after_read_seq)

function new(string name = "ram_write_after_read_seq");
super.new(name);
endfunction

task body();
ram_seq_item req;
int addr;


repeat(10)begin
//for (int i = 0; i < 10; i++) begin
// Use fixed address and data
//addr = i; // Sequential addresses 0 to 9
//wr_data = 16'h1000 ; // Incrementing data

// Step 1: WRITE
`uvm_do_with(req, {read == 0;write ==1;})
addr=req.wr_address;
// Step 2: READ
`uvm_do_with(req, {read == 1;write == 0;rd_address ==addr;})
end
endtask
endclass




//write and read operation from same address
class ram_write_read_from_same_address_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_read_from_same_address_seq)
//constructor
function new(string name="ram_write_read_from__same_address_seq");
super.new(name);
endfunction
task body();
ram_seq_item req;

repeat(20) begin
`uvm_do_with(req,{
write== 1;
read== 0;
wr_address== 20;
data_in== 16'd1111;})
`uvm_do_with(req,{
write== 0;
read== 1;
rd_address==20;
})

`uvm_info(get_full_name(),$sformatf("write_read_same_address:,wr_address=%0d,rd_address=%0d,data_in=%0d,data_out=%0d",req.wr_address,req.rd_address,req.data_in,req.data_out),UVM_MEDIUM)
end
endtask
endclass


//read only operation for particular address
class ram_read_particular_address_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_read_particular_address_seq)

function new(string name = "ram_read_particular_address_seq");
super.new(name);
endfunction
task body();
ram_seq_item req;
repeat (10) begin
`uvm_do_with(req, {write == 0 ; read == 1; rd_address ==9;})
`uvm_info(get_full_name(),"read high  pass particular address",UVM_MEDIUM) 
end
endtask
endclass


//write and read and idle testcase
class ram_write_read_idle_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(ram_write_read_idle_seq )
ram_seq_item req;
function new(string name = "ram_write_read_idle_seq ");
super.new(name);
endfunction
task body();
ram_seq_item req;
repeat (10) begin
`uvm_do_with(req, {write==1 ; read==0; wr_address==5; })
`uvm_do_with(req, {write==0 ; read==1; rd_address==5; wr_address==0; data_in==0;})
`uvm_do_with(req, {write==0 ; read==0; rd_address==0; wr_address==0; data_in==0;})
//`uvm_do_with(req, {write==1 ; read==1; rd_address==0; wr_address==0; data_in==0;})
 
end
endtask
endclass



