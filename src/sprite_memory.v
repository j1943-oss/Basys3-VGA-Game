`timescale 1ns / 1ps

// Sprite Memory
// initially loads a sprite file given by parameter into memory
// then, given an address, returns the color of the pixel at said address

module sprite_memory #(
    parameter MEM_FILE = "chef.mem"
)(
    input [9:0] address,
    output reg [11:0] pixel_color
);

    // 1024 entry memory storing 12 bit RGB pixel colors
    reg [11:0] memory [0:1023];

    // load the sprite file
    initial
        $readmemh(MEM_FILE, memory);

    // output the pixel color stored at the address given
    always @(*)
        pixel_color = memory[address];

endmodule