`timescale 1ns / 1ps


// Render
// implements rendering system that includes the sprites and the background
// rendering priority: player sprite > chicken > background 

module render(
    input video_on,
    input chicken_on,
    input sprite_on,

    input [11:0] sprite_color,
    input [11:0] chicken_color,
    input [11:0] tile_color,

    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

    // reserve absolute black in a sprite to mean transparent
    // so if sprite pixel == clear, render background
    localparam CLEAR = 12'h000;

    always @(*) begin

        // screen is black outside display region
        if (!video_on) begin
        
            red = 4'h0;
            green = 4'h0;
            blue = 4'h0;
            
        end

        // player sprite has the highest rendering priority
        else if (sprite_on && sprite_color != CLEAR) begin

            red = sprite_color[11:8];
            green = sprite_color[7:4];
            blue = sprite_color[3:0];

        end

        // chicken is rendered behind the player
        else if (chicken_on && chicken_color != CLEAR) begin

            red = chicken_color[11:8];
            green = chicken_color[7:4];
            blue = chicken_color[3:0];

        end

        // display the background when no sprite is present
        else begin

            red = tile_color[11:8];
            green = tile_color[7:4];
            blue = tile_color[3:0];

        end

    end

endmodule