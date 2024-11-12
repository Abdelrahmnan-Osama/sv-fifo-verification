////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
`define SIM

module FIFO (
    fifo_if.DUT fif
);

  reg [fif.FIFO_WIDTH-1:0] mem[fif.FIFO_DEPTH-1:0];
  reg [fif.max_fifo_addr-1:0] wr_ptr, rd_ptr;
  reg [fif.max_fifo_addr:0] count;

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      wr_ptr <= 0;
      fif.wr_ack <= 1'b0;
      fif.overflow <= 0;
    end else if (fif.wr_en && count < fif.FIFO_DEPTH) begin
      mem[wr_ptr] <= fif.data_in;
      fif.wr_ack <= 1;
      wr_ptr <= wr_ptr + 1;
    end else begin
      fif.wr_ack <= 0;
      if (fif.full & fif.wr_en) fif.overflow <= 1;
      else fif.overflow <= 0;
    end
  end

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      rd_ptr <= 0;
    end else if (fif.rd_en && count != 0) begin
      fif.data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      fif.underflow <= 0;
    end else if (fif.empty && fif.rd_en) begin
      fif.underflow <= 1;
    end else begin
      fif.underflow <= 0;
    end
  end

  always @(posedge fif.clk or negedge fif.rst_n) begin
    if (!fif.rst_n) begin
      count <= 0;
    end else begin
      if (fif.wr_en && fif.rd_en && fif.empty) count <= count + 1;
      else if (fif.wr_en && fif.rd_en && fif.full) count <= count - 1;
      else if (fif.wr_en && !fif.rd_en && !fif.full) count <= count + 1;
      else if (fif.rd_en && !fif.wr_en && !fif.empty) count <= count - 1;
    end
  end

  assign fif.full = (count == fif.FIFO_DEPTH) ? 1 : 0;
  assign fif.empty = (count == 0) ? 1 : 0;
  assign fif.almostfull = (count == fif.FIFO_DEPTH - 1) ? 1 : 0;
  assign fif.almostempty = (count == 1) ? 1 : 0;

`ifdef SIM
  property p_write_pointer_inc;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && !fif.rd_en && !fif.full || fif.wr_en && fif.rd_en && fif.empty |=> wr_ptr == $past(
        wr_ptr
    ) + 1'b1;
  endproperty

  property p_read_pointer_inc;
    @(posedge fif.clk) disable iff (!fif.rst_n) !fif.wr_en && fif.rd_en && !fif.empty || fif.wr_en && fif.rd_en && fif.full |=> rd_ptr == $past(
        rd_ptr
    ) + 1'b1;
  endproperty

  property p_write_pointer_const;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && fif.rd_en && fif.full |=> wr_ptr == $past(
        wr_ptr
    );
  endproperty

  property p_read_pointer_const;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && fif.rd_en && fif.empty |=> rd_ptr == $past(
        rd_ptr
    );
  endproperty

  property p_counter_inc;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && !fif.rd_en && !fif.full || fif.wr_en && fif.rd_en && fif.empty  |=> count == $past(
        count
    ) + 1'b1;
  endproperty

  property p_counter_dec;
    @(posedge fif.clk) disable iff (!fif.rst_n) !fif.wr_en && fif.rd_en && !fif.empty || fif.wr_en && fif.rd_en && fif.full |=> count == $past(
        count
    ) - 1'b1;
  endproperty

  property p_counter_const;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && fif.rd_en && !fif.empty && !fif.full |=> count == $past(
        count
    );
  endproperty

  property p_wr_ack;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.wr_en && !fif.full |=> fif.wr_ack;
  endproperty

  property p_overflow;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.full && fif.wr_en |=> fif.overflow;
  endproperty

  property p_underflow;
    @(posedge fif.clk) disable iff (!fif.rst_n) fif.empty && fif.rd_en |=> fif.underflow;
  endproperty

  // FIFO_10
  wr_ptr_inc_assertion :
  assert property (p_write_pointer_inc);
  cover property (p_write_pointer_inc);

  // FIFO_11
  rd_ptr_inc_assertion :
  assert property (p_read_pointer_inc);
  cover property (p_read_pointer_inc);

  // FIFO_15
  wr_ptr_const_assertion :
  assert property (p_write_pointer_const);
  cover property (p_write_pointer_const);

  // FIFO_16
  rd_ptr_const_assertion :
  assert property (p_read_pointer_const);
  cover property (p_read_pointer_const);

  // FIFO_13
  counter_dec_assertion :
  assert property (p_counter_dec);
  cover property (p_counter_dec);

  // FIFO_12  
  counter_inc_assertion :
  assert property (p_counter_inc);
  cover property (p_counter_inc);

  // FIFO_2
  wr_ack_assertion :
  assert property (p_wr_ack);
  cover property (p_wr_ack);

  // FIFO_3
  overflow_assertion :
  assert property (p_overflow);
  cover property (p_overflow);

  // FIFO_6
  underflow_assertion :
  assert property (p_underflow);
  cover property (p_underflow);

  // FIFO_14
  counter_const_assertion :
  assert property (p_counter_const);
  cover property (p_counter_const);


  always_comb begin : immediate_assertions
    // FIFO_9
    if (count == fif.FIFO_DEPTH) begin
      full_assertion : assert final (fif.full);
    end
    // FIFO_8
    if (count == 0) begin
      empty_assertion : assert final (fif.empty);
    end
    // FIFO_4
    if (count == fif.FIFO_DEPTH - 1) begin
      almostfull_assertion : assert final (fif.almostfull);
    end
    // FIFO_7
    if (count == 1) begin
      almostempty_assertion : assert final (fif.almostempty);
    end
    // FIFO_1
    if (!fif.rst_n) begin
      reset_assertion :
      assert final (count == 0 && wr_ptr == 0 && rd_ptr == 0 && !fif.overflow && !fif.underflow && 
                    fif.empty && !fif.full && !fif.almostempty && !fif.almostfull && !fif.wr_ack);
    end
  end
`endif

endmodule
