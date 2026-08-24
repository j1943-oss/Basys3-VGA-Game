`timescale 1ns / 1ps


// Clock Divider
// divides the 100 MHz Basys clock to generate a 25 MHz clock for VGA


module clock_divider(
    input clk,       // 100 MHz clock
    output pixel_clk // 25 MHz VGA clock
);

    // 2-bit counter used to divide the clock by 4
    reg [1:0] clk_div = 0;

    // increment counter on each positive edge of the input clock
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    
    // assigning pixel clock to toggle between 1 and 0 at 1/4 the rate of clk
    assign pixel_clk = clk_div[1];

endmodule
