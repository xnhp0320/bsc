package Hello;

(* synthesize *)
module mkHello(Empty);

    rule sayHello;
        $display("Hello World!");
        $finish(0);
    endrule

endmodule

endpackage
