`timescale 1ns / 1ps

// Sprite Renderer
// determines whether the current screen pixel is inside the 32x32 sprite
// then calculates the corresponding pixel address

module sprite_renderer (
    input [9:0] h_count,
    input [9:0] v_count,
    input [9:0] sprite_x,
    input [9:0] sprite_y,

    output [9:0] address,
    output sprite_on
);

    localparam SPRITE_H = 32;
    localparam SPRITE_W = 32;


    // pixel coordinates relative to the top left corner of the sprite
    wire [4:0] sprite_px;
    wire [4:0] sprite_py;

    assign sprite_px = h_count - sprite_x;
    assign sprite_py = v_count - sprite_y;


    // convert the sprite's x/y position into a 0-1023 memory address
    assign address = (sprite_py * SPRITE_W) + sprite_px;


    // determines if current pixel is inside sprite
    assign sprite_on =
        (h_count >= sprite_x) &&
        (h_count < sprite_x + SPRITE_W) &&
        (v_count >= sprite_y) &&
        (v_count < sprite_y + SPRITE_H);

endmodule