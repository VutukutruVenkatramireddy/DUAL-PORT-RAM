module testbench;
bit clk=0;
ram_intf i_intf(clk);

//instantiation
dual_mem dut(
.clk(i_intf.clk),
.write(i_intf.write),
.read(i_intf.read),
.data_in(i_intf.data_in),
.wr_address(i_intf.wr_address),
.rd_address(i_intf.rd_address),
.data_out(i_intf.data_out)
);

always #5 clk=~clk;

initial begin
uvm_config_db#(virtual ram_intf)::set(uvm_root::get(), "*", "vif", i_intf);

run_test();
end

initial begin
$shm_open("waves.shm");
$shm_probe("ACMTF");
end
endmodule

