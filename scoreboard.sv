class ram_scb extends uvm_scoreboard;
`uvm_component_utils(ram_scb)
uvm_analysis_imp #(ram_seq_item, ram_scb)item_collected_export;
ram_seq_item  qu[$];
ram_seq_item actual_tx;
bit [15:0] expected_mem [0:255];
bit [15:0] expected_data;
//constructor
function new (string name,uvm_component parent);
super.new(name,parent);
item_collected_export=new("item_collected_export",this);

endfunction

/*//build_phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
item_collected_export=new("item_collected_export",this);
endfunction*/


virtual function void write (ram_seq_item tx);
qu.push_back (tx);
//$display("scoreboard: item collected");
endfunction
//run_phase
task run_phase(uvm_phase phase);
forever begin
wait(qu.size()>0);
actual_tx =qu.pop_front(); 

//compare
 
// Case 1: Write only
if (actual_tx.write && !actual_tx.read) begin
expected_mem [actual_tx.wr_address] = actual_tx.data_in; 
`uvm_info("SCOREBOARD_write_PASS", $sformatf("WRITE: wr_address=%0d data_in=%0h \n",actual_tx.wr_address, actual_tx.data_in), UVM_MEDIUM)
end

// Case 2: Read only
else if (actual_tx.read && !actual_tx.write) begin
expected_data = expected_mem[actual_tx.rd_address];
if(actual_tx.data_out === expected_data) begin
//`uvm_info("RD_PASS", $sformatf("READ PASS: ... \n"), UVM_LOW)
`uvm_info("SCOREBOARD READ_pass", $sformatf("READ pass: rd_address=%0d Expected=%0h Got=%0h \n",actual_tx.rd_address, expected_data, actual_tx.data_out),UVM_LOW)
end else begin
`uvm_error("SCOREBOARD READ_FAIL", $sformatf("READ FAIL: rd_address=%0d Expected=%0h Got=%0h \n",actual_tx.rd_address, expected_data, actual_tx.data_out))
end 
expected_data = actual_tx.data_out;
end

// Case 3: Simultaneous Write and Read
else if (actual_tx.write && actual_tx.read) begin
if (actual_tx.data_out === 16'b0)begin
`uvm_info("WR_RD_PASS BOTH_HIGH", "WRITE+READ PASS: data_out is 0 \n", UVM_LOW)
 end else begin
`uvm_error("WR_RD_FAIL BOTH", $sformatf("WRITE+READ FAIL: data_out=%0h (expected 0) \n", actual_tx.data_out))
 end
expected_data=actual_tx.data_out;
end

//case 4:both low write and read
else if (!actual_tx.write && !actual_tx.read) begin
if (actual_tx.data_out == expected_data) begin
`uvm_info("WR_RD_zero", "IDLE PASS: data_out is previous_data %0d \n", UVM_LOW)
end else begin
`uvm_error("WR_RD_not_zero  BOTH", $sformatf("IDLE FAIL: (-expected previous_data %0d) \n", actual_tx.data_out))
 end
end

 // Store previous data_out
//previous_data = actual_tx.data_out;
end
endtask
endclass
