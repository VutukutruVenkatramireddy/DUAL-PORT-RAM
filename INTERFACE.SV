
interface ram_intf(input logic clk);
logic read;
logic write;
logic [7:0] wr_address;
logic [7:0] rd_address;
logic [15:0] data_in;
logic  [15:0] data_out;
clocking drv_cb @(posedge clk);
default input #1 output #1;
output  write;
output read;
output wr_address;
output rd_address;
output data_in;
endclocking

clocking mon_cb @(posedge clk);
default input #0 output #1;

input  write;
input read;
input wr_address;
input rd_address;
input data_in;
output data_out;
endclocking
endinterface
