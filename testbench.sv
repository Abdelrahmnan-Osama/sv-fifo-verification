import shared_pkg::*;
import Trans_Pkg::*;

module fifo_tb (
    fifo_if.TEST fif
);

  FIFO_transaction fifo_txn;

  initial begin
    fifo_txn = new;
    rst_randomization_assertion : assert (fifo_txn.randomize());

    @(negedge fif.clk);
    // FIFO_1.1
    fif.rst_n   = 0;
    fif.data_in = fifo_txn.data_in;
    fif.wr_en   = fifo_txn.wr_en;
    fif.rd_en   = fifo_txn.rd_en;
    @(negedge fif.clk);

    // FIFO_1.2 -> FIFO_13
    repeat (1000) begin
      stimulus_randomization_assertion : assert (fifo_txn.randomize());
      fif.rst_n   = fifo_txn.rst_n;
      fif.data_in = fifo_txn.data_in;
      fif.wr_en   = fifo_txn.wr_en;
      fif.rd_en   = fifo_txn.rd_en;
      @(negedge fif.clk);

    end

    test_finished = 1;
  end
endmodule
