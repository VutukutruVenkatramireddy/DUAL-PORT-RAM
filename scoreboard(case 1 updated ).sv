class ram_scb extends uvm_scoreboard;
`uvm_component_utils(ram_scb)
uvm_analysis_imp #(ram_seq_item, ram_scb) item_collected_export;
ram_seq_item  qu[$];
ram_seq_item actual_tx;
bit [15:0] expected_mem [255:0];
bit [15:0] expected_data;

// Constructor
function new (string name, uvm_component parent);
super.new(name, parent);
item_collected_export = new("item_collected_export", this);
endfunction

// Write method (called via analysis port)
virtual function void write(ram_seq_item tx);
qu.push_back(tx);
endfunction

// Run phase
task run_phase(uvm_phase phase);
forever begin
wait(qu.size() > 0);
actual_tx = qu.pop_front();

// Case 1: Write only
if (actual_tx.write && !actual_tx.read) begin
if ((actual_tx.data_in === 1'bx) || (actual_tx.data_in === 16'h0000)) begin
`uvm_error("SCOREBOARD_WRITE_ERROR",$sformatf("WRITE FAIL: wr_address=%0d, data_in=%0h\n",actual_tx.wr_address, actual_tx.data_in))
end
else begin
expected_mem[actual_tx.wr_address] = actual_tx.data_in;
`uvm_info("SCOREBOARD_WRITE_PASS",$sformatf("WRITE PASS: wr_address=%0d data_in=%0h\n",actual_tx.wr_address, actual_tx.data_in),UVM_MEDIUM)
end
end

// Case 2: Read only
else if (actual_tx.read && !actual_tx.write) begin
expected_data = expected_mem[actual_tx.rd_address];
if(actual_tx.data_out === expected_data) begin
`uvm_info("SCOREBOARD_READ_PASS",$sformatf("READ PASS: rd_address=%0d Expected=%0h Got=%0h\n",actual_tx.rd_address, expected_data, actual_tx.data_out),UVM_LOW)
end
else begin
`uvm_error("SCOREBOARD_READ_FAIL",$sformatf("READ FAIL: rd_address=%0d Expected=%0h Got=%0h\n",actual_tx.rd_address, expected_data, actual_tx.data_out))
end
expected_data = actual_tx.data_out;
end

// Case 3: Simultaneous Write and Read
else if (actual_tx.write && actual_tx.read) begin
if (actual_tx.data_out === 16'b0) begin
`uvm_info("WR_RD_PASS_BOTH_HIGH","WRITE+READ PASS: data_out is 0\n",UVM_LOW)
end
else begin
`uvm_error("WR_RD_FAIL_BOTH",$sformatf("WRITE+READ FAIL: data_out=%0h (expected 0)",actual_tx.data_out))
end
expected_data = actual_tx.data_out;
end

// Case 4: Both write and read low (Idle)
else if (!actual_tx.write && !actual_tx.read) begin
if (actual_tx.data_out == expected_data) begin
`uvm_info("WR_RD_ZERO",$sformatf("IDLE PASS: data_out is previous_data %0h\n",expected_data),UVM_LOW)
end
else begin
`uvm_error("WR_RD_NOT_ZERO_BOTH",$sformatf("IDLE FAIL: Expected previous_data %0h Got %0h\n",expected_data, actual_tx.data_out))
end
end
end
endtask
endclass

