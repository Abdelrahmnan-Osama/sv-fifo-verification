module top ();
  bit clk;

  initial begin
    clk = 0;
    forever begin
      #20 clk = ~clk;
    end
  end

  fifo_if fif (clk);
  FIFO DUT (fif);
  fifo_tb TB (fif);
  monitor MONITOR (fif);
endmodule
