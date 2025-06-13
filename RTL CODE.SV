module dual_mem (clk,data_in,rd_address,wr_address,read,write,data_out);

 input clk;
 input read,write;
 input [7:0]rd_address,wr_address;
 input [15:0]data_in;
 
 output reg [15:0]data_out;

 reg [15:0]mem[0:255];

 always@(posedge clk)begin
   if(write && read)begin
     data_out <= 16'b0;
   end
   else if(write && !read)begin
     mem[wr_address] <= data_in;
   end
   else if(read && !write)begin
     data_out <=  mem[rd_address];
   end
   else
     data_out <= data_out;
 end  
 
 endmodule

 
