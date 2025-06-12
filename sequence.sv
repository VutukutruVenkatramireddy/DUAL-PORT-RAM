class ram_sequence extends uvm_sequence #(ram_seq_item);
`uvm_object_utils (ram_sequence)
//constructor
function new(string name="ram_sequence");
super.new(name);
endfunction

virtual task body();
ram_seq_item req;
repeat(500) begin

`uvm_do(req);
end
endtask
endclass
