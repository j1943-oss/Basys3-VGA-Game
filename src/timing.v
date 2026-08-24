`timescale 1ns / 1ps


// VGA Timing
// generates hsync, vysnc, h/v counters, and defines active
// display region for a 640x480 VGA display


module timing(
    input pixel_clk,

    output hsync,
    output vsync,
    output video_on,

    output reg [9:0] h_count = 0,
    output reg [9:0] v_count = 0
);

    // h_count iterates through 800 pixels
    // v_count iterates once each h_count is done, and runs through
    // 525 lines per frame
    always @(posedge pixel_clk) begin

        if (h_count == 799) begin
        
            h_count <= 0;

            if (v_count == 524)
                v_count <= 0;

            else
                v_count <= v_count + 1;
                
        end

        else
            h_count <= h_count + 1;

    end


    // creates active-low horizontal sync
    assign hsync = ~((h_count >= 656) && (h_count < 752));

    // creates active-low vertical sync
    assign vsync = ~((v_count >= 490) && (v_count < 492));


    // active display region
    assign video_on = (h_count < 640) && (v_count < 480);

endmodule