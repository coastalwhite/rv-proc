`include "./src/register_bank.v"
`include "./src/exec_unit.v"
`include "./src/top.v"

module tb();
    reg CLK;
    reg BTN_N;

    wire TX;
    reg RX;

    top processor(
        .CLK(CLK),
        .BTN_N(BTN_N),

        .TX(TX),
        .RX(RX)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,tb);
    end

    initial begin
        CLK <= 0;
        BTN_N <= 0;
        RX <= 0;

        #2

        BTN_N <= 1;

        #40 $finish;
    end

    always #1 CLK <= !CLK;
endmodule