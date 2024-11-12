package Cvg_Pkg;
  import Trans_Pkg::*;

  class FIFO_coverage;
    FIFO_transaction F_cvg_txn;

    covergroup CovCode;
      // FIFO_9
      rd_wr_full: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.full;
      // FIFO_4
      rd_wr_almostfull: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.almostfull;
      // FIFO_8
      rd_wr_empty: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.empty;
      // FIFO_7
      rd_wr_almostempty: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.almostempty;
      // FIFO_3
      rd_wr_overflow: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.overflow;
      // FIFO_6
      rd_wr_underflow: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.underflow;
      // FIFO_2
      rd_wr_wr_ack: cross F_cvg_txn.rd_en, F_cvg_txn.wr_en, F_cvg_txn.wr_ack;
    endgroup

    function new();
      CovCode   = new();
      F_cvg_txn = new();
    endfunction  //new()

    function void sample_data(input FIFO_transaction F_txn);
      F_cvg_txn = F_txn;
      CovCode.sample();
    endfunction

  endclass  //FIFO_coverage

endpackage





