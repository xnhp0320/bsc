package Counter;

(* synthesize *)
module mkCounter();
   Reg#(UInt#(8)) count <- mkReg(0);

   rule tick;
      $display("cycle=%0d count=%0d", count, count);
      if (count == 9) begin
         $finish(0);
      end
      count <= count + 1;
   endrule
endmodule

endpackage
