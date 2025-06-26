//multiple writes and multiple reads
class multiple_wr_rd_seq extends uvm_sequence #(ram_seq_item);
`uvm_object_utils(multiple_wr_rd_seq)
bit [7:0] addr_qu[$];
bit [15:0] data_qu[$];
function new(string name = "multiple_wr_rd_seq");
super.new(name);
endfunction
task body();
ram_seq_item req;
int a=15;

for(int i=0;i<a;i++)begin 
`uvm_do_with (req, {write==1;read==0;})
addr_qu.push_back(req.wr_address);
data_qu.push_back(req.data_in);
end

for(int i=0;i<a;i++)begin 
`uvm_do_with (req, {write==0;read==1;rd_address==addr_qu[i];})
end
endtask
endclass
