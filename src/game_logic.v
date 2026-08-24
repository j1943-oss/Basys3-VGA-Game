`timescale 1ns / 1ps

// Game Logic
// handles player movement, player state, and chicken movement
// movement updates are slowed using a counter, so movements are not too fast

module game_logic(
    input clk,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input btnC,

    output reg [9:0] sprite_x = 319,
    output reg [9:0] sprite_y = 239,

    output reg [9:0] chicken_x = 119,
    output reg [9:0] chicken_y = 139,

    output reg [2:0] sprite_state = 1
);

    // all sprites used were 32x32
    localparam SPRITE_H = 32;
    localparam SPRITE_W = 32;

    // 640x480 VGA display
    localparam SCREEN_H = 480;
    localparam SCREEN_W = 640;


    // counter used to slow down movement
    reg [25:0] slow_timer = 0;


    // chicken movement directions:
    // horizontal: 0 = left, 1 = right
    // vertical:   0 = up,   1 = down
    reg direction_horizontal = 0;
    reg direction_vertical = 0;


    // updates state, position, and direction 
    always @(posedge clk) begin

        if (slow_timer == 3_000_000) begin
        
            slow_timer <= 0;

            // default player state: idle
            sprite_state <= 1;

            // player horizontal movement
            if (btnL && sprite_x > 0) begin
                sprite_x <= sprite_x - 1;
                sprite_state <= 2;
            end

            else if (btnR && sprite_x < SCREEN_W - SPRITE_W) begin
                sprite_x <= sprite_x + 1;
                sprite_state <= 2;
            end

            // player vertical movement
            if (btnU && sprite_y > 0) begin
                sprite_y <= sprite_y - 1;
                sprite_state <= 2;
            end

            else if (btnD && sprite_y < SCREEN_H - SPRITE_H) begin
                sprite_y <= sprite_y + 1;
                sprite_state <= 2;
            end

            // center button triggers the attack state
            if (btnC)
                sprite_state <= 3;

            // reverse chicken direction when it reaches a horizontal boundary
            if (chicken_x == 1 && !direction_horizontal)
                direction_horizontal <= 1;

            else if (chicken_x == SCREEN_W - SPRITE_W -1 && direction_horizontal)
                direction_horizontal <= 0;

            // reverse chicken direction when it reaches a vertical boundary
            if (chicken_y == 1 && !direction_vertical)
                direction_vertical <= 1;

            else if (chicken_y == SCREEN_H - SPRITE_H - 1 && direction_vertical)
                direction_vertical <= 0;

            // move the chicken horizontally and vertically
            if (direction_horizontal)
                chicken_x <= chicken_x + 1;
            else
                chicken_x <= chicken_x - 1;

            if (direction_vertical)
                chicken_y <= chicken_y + 1;
            else
                chicken_y <= chicken_y - 1;

        end

        else
            slow_timer <= slow_timer + 1;

    end

endmodule