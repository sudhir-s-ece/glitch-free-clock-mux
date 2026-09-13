module glitchless_mux (
    input  wire clk0,    
    input  wire clk1,   
    input  wire rst_n,   
    input  wire sel,    
    output wire clk_out  
);

    reg q0;
    reg q1;

    
    always @(negedge clk0 or negedge rst_n) begin
        if (!rst_n)
            q0 <= 1'b0;
        else
            q0 <= (~sel) & (~q1);
    end

   
    always @(negedge clk1 or negedge rst_n) begin
        if (!rst_n)
            q1 <= 1'b0;
        else
            q1 <= sel & (~q0);
    end

   
    assign clk_out = (clk0 & q0) | (clk1 & q1);

endmodule