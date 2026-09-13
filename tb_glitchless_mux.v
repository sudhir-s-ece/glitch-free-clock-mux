`timescale 1ns/1ps

module tb_glitchless_mux;

    reg clk0;
    reg clk1;
    reg rst_n;
    reg sel;
    wire clk_out;

    // Instantiate the Device Under Test (DUT)
    glitchless_mux uut (
        .clk0(clk0),
        .clk1(clk1),
        .rst_n(rst_n),
        .sel(sel),
        .clk_out(clk_out)
    );

    // Generate Clock 0: 100 MHz (Period = 10ns)
    initial clk0 = 0;
    always #5 clk0 = ~clk0;

    // Generate Clock 1: ~62.5 MHz (Period = 16ns)
    initial clk1 = 0;
    always #8 clk1 = ~clk1;

    initial begin
        // Enable waveform dumping for EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_glitchless_mux);

        // Initialize signals
        rst_n = 0;
        sel   = 0;
        #20;
        rst_n = 1; // Release reset

        // Test 1: Switch from clk0 to clk1 mid-pulse (at 33ns)
        #13;
        sel = 1;

        // Let clk1 run stably
        #60;

        // Test 2: Switch back from clk1 to clk0 mid-pulse (at 93ns)
        sel = 0;

        // Let clk0 run stably
        #50;

        $finish;
    end

endmodule
