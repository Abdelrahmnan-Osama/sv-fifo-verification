import Cvg_Pkg::*;
import Trans_Pkg::*;
import Scr_Brd_Pkg::*;
import shared_pkg::*;

module monitor (
    fifo_if.MONITOR fif
);
  FIFO_transaction fifo_txn;
  FIFO_scoreboard fifo_scr;
  FIFO_coverage fifo_cvr;

  // sample interface values
  initial begin
    fifo_txn = new;
    fifo_scr = new;
    fifo_cvr = new;

    forever begin
      @(negedge fif.clk);
      fifo_txn.data_in <= fif.data_in;
      fifo_txn.rst_n   <= fif.rst_n;
      fifo_txn.wr_en   <= fif.wr_en;
      fifo_txn.rd_en   <= fif.rd_en;
      fifo_txn.wr_ack = fif.wr_ack;
      fifo_txn.overflow = fif.overflow;
      fifo_txn.underflow = fif.underflow;
      fifo_txn.full = fif.full;
      fifo_txn.empty = fif.empty;
      fifo_txn.almostfull = fif.almostfull;
      fifo_txn.almostempty = fif.almostempty;
      fifo_txn.data_out = fif.data_out;
      // check the design against golden model and calculated coverage
      fork
        begin
          fifo_cvr.sample_data(fifo_txn);
        end

        begin
          fifo_scr.check_data(fifo_txn);
        end
      join

      // stop simulation when finished
      if (test_finished) begin
        $display("error_count = %0d, correct_count = %0d", error_count, correct_count);
        $stop;
      end

    end

  end

endmodule
