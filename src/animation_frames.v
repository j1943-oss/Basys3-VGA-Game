`timescale 1ns / 1ps

// Animation Frames
// takes in sprite, sprite state, and the colors of various states
// based on state determines which sprite animation to show


module animation_frames(
    input clk,

    input [11:0] chef_color,
    input [11:0] attack_color,
    input [11:0] walk_color,
    input [11:0] idle_color,

    input [2:0] sprite_state,

    output reg [11:0] sprite_color
);

    // counter used to control animation speed
    reg [25:0] slow_timer = 0;

    // alternates value, allowing for toggling between frames
    reg toggle = 0;


    // toggle the animation frame every 0.4 seconds 
    always @(posedge clk) begin
    
        if (slow_timer == 40_000_000) begin
            slow_timer <= 0;
            toggle <= ~toggle;
        end

        else begin
            slow_timer <= slow_timer + 1;
        end
        
    end

    // chooses which sprite to output based on sprite state
    always @(*) begin

        case (sprite_state)

            // idle animation alternates between two frames
            3'd1: begin

                if (toggle)
                    sprite_color = chef_color;
                else
                    sprite_color = idle_color;

            end

            // walking frame
            3'd2: begin
                sprite_color = walk_color;
            end

            // attack frame
            3'd3: begin
                sprite_color = attack_color;
            end

            // default to the idle frame.
            default: begin
                sprite_color = idle_color;
            end

        endcase

    end

endmodule