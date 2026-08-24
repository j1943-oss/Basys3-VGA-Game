`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06/07/2026 08:20:40 PM
// Design Name:
// Module Name: top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk, // 100MHz clock
    input btnU, //  up button
    input btnL, // left button
    input btnR, // right button
    input btnD, // down button
    input btnC,

    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,

    output hsync,
    output vsync
);

    // internal signals
    wire pixel_clk;

    wire [9:0] h_count;
    wire [9:0] v_count;

    wire video_on;

    wire [9:0] sprite_x;
    wire [9:0] sprite_y;
    wire [9:0] sprite_address;
    wire sprite_on;

    wire [9:0] tile_address;
    
    wire [9:0] chicken_x;
    wire [9:0] chicken_y;
    wire [9:0] chicken_address;
    wire chicken_on;

    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;



    wire [11:0] sprite_color;
    wire [11:0] chicken_color;
    wire [11:0] tile_color;
    wire [11:0] ground_color;
    wire [11:0] wall_color;

    wire [11:0] idle_color;
    wire [11:0] attack_color;
    wire [11:0] walk_color;

    wire [2:0] sprite_state;
    wire [11:0] chef_color;



    clock_divider vga_clock(
        .clk(clk),
        .pixel_clk(pixel_clk)
    );


    timing pixel_time(
        .pixel_clk(pixel_clk),
        .h_count(h_count),
        .v_count(v_count),
        .video_on(video_on),
        .hsync(hsync),
        .vsync(vsync)
    );


    game_logic game(
        .sprite_x(sprite_x),
        .sprite_y(sprite_y),
        .chicken_x(chicken_x),
        .chicken_y(chicken_y),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .btnD(btnD),
        .btnC(btnC),
        .clk(clk),
        .sprite_state(sprite_state)
    );


    render renderer(
        .video_on(video_on),
        .chicken_on(chicken_on),
        .sprite_on(sprite_on),
        .red(red),
        .green(green),
        .blue(blue),
        .chicken_color(chicken_color),
        .sprite_color(sprite_color),
        .tile_color(tile_color)
    );


    sprite_memory #(
        .MEM_FILE("chicken.mem")
    ) chicken_sprite (
        .pixel_color(chicken_color),
        .address(chicken_address)
    );


    sprite_memory #(
        .MEM_FILE("chef.mem")
    ) chef_sprite (
        .pixel_color(chef_color),
        .address(sprite_address)
    );


    sprite_memory #(
        .MEM_FILE("ground.mem")
    ) ground_sprite (
        .pixel_color(ground_color),
        .address(tile_address)
    );


    sprite_memory #(
        .MEM_FILE("wall.mem")
    ) wall_sprite (
        .pixel_color(wall_color),
        .address(tile_address)
    );


    sprite_memory #(
        .MEM_FILE("idle.mem")
    ) idle_sprite (
        .pixel_color(idle_color),
        .address(sprite_address)
    );


    sprite_memory #(
        .MEM_FILE("attack.mem")
    ) attack_sprite (
        .pixel_color(attack_color),
        .address(sprite_address)
    );


    sprite_memory #(
        .MEM_FILE("walk.mem")
    ) walk_sprite (
        .pixel_color(walk_color),
        .address(sprite_address)
    );


    sprite_renderer spr_render(
        .h_count(h_count),
        .v_count(v_count),
        .sprite_x(sprite_x),
        .sprite_y(sprite_y),
        .sprite_on(sprite_on),
        .address(sprite_address)
    );


    sprite_renderer chicken_render(
        .h_count(h_count),
        .v_count(v_count),
        .sprite_x(chicken_x),
        .sprite_y(chicken_y),
        .sprite_on(chicken_on),
        .address(chicken_address)
    );


    tilemap_render tile_map(
        .h_count(h_count),
        .v_count(v_count),
        .tile_color(tile_color),
        .ground_color(ground_color),
        .wall_color(wall_color),
        .tile_address(tile_address)
    );


    animation_frames chef_animated(
        .clk(clk),
        .chef_color(chef_color),
        .attack_color(attack_color),
        .walk_color(walk_color),
        .idle_color(idle_color),
        .sprite_state(sprite_state),
        .sprite_color(sprite_color)
    );


    assign vgaRed = red;
    assign vgaGreen = green;
    assign vgaBlue = blue;

endmodule