interface fifo_if(clk);
  parameter FIFO_WIDTH = 16;
  parameter FIFO_DEPTH = 8;
  parameter max_fifo_addr = $clog2(FIFO_DEPTH);

  input bit clk;
  logic [FIFO_WIDTH-1:0] data_in;
  logic rst_n, wr_en, rd_en;
  logic [FIFO_WIDTH-1:0] data_out;
  logic wr_ack, overflow;
  logic full, empty, almostfull, almostempty, underflow;

  modport DUT (
  input clk, data_in, wr_en, rd_en, rst_n,
  output data_out, full, almostfull, empty, almostempty, overflow, underflow, wr_ack
  );

  modport TEST (
  input clk, data_out, full, almostfull, empty, almostempty, overflow, underflow, wr_ack,
  output data_in, wr_en, rd_en, rst_n
  );

  modport MONITOR (
  input clk, data_in, wr_en, rd_en, rst_n, data_out, full, almostfull, empty, almostempty, overflow,
  underflow, wr_ack
  );
endinterface
