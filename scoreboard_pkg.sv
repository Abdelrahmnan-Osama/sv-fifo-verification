package Scr_Brd_Pkg;
  import Trans_Pkg::*;
  import shared_pkg::*;

  class FIFO_scoreboard;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    parameter max_fifo_addr = $clog2(FIFO_DEPTH);

    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
    logic [FIFO_WIDTH-1:0] FIFO[$];

    function void check_data(input FIFO_transaction fifo_txn);
      reference_model(fifo_txn);
      if (fifo_txn.data_out !== data_out_ref) begin
        error_count++;
        $display(
            "%0t: Error: rst_n = %b, data_in = %h, wr_en = %b, rd_en = %b, data_out = %h, data_out_ref = %h",
            $time, fifo_txn.rst_n, fifo_txn.data_in, fifo_txn.wr_en, fifo_txn.rd_en,
            fifo_txn.data_out, data_out_ref);
      end else begin
        correct_count++;
      end
    endfunction

    function void reference_model(input FIFO_transaction fifo_txn);
      if (!fifo_txn.rst_n) begin
        FIFO.delete();
      end else begin
        if (fifo_txn.rd_en && fifo_txn.wr_en && FIFO.size() == 0) begin
          FIFO.push_back(fifo_txn.data_in);
        end else if (fifo_txn.rd_en && fifo_txn.wr_en && FIFO.size() == FIFO_DEPTH) begin
          data_out_ref = FIFO.pop_front();
        end else if (fifo_txn.rd_en && fifo_txn.wr_en && FIFO.size() < FIFO_DEPTH && FIFO.size() != 0) begin
          FIFO.push_back(fifo_txn.data_in);
          data_out_ref = FIFO.pop_front();
        end else if (fifo_txn.wr_en && !fifo_txn.rd_en && FIFO.size() < FIFO_DEPTH) begin
          FIFO.push_back(fifo_txn.data_in);
        end else if (fifo_txn.rd_en && !fifo_txn.wr_en && FIFO.size() != 0) begin
          data_out_ref = FIFO.pop_front();
        end

      end
    endfunction
  endclass  //FIFO_scoreboard
endpackage
