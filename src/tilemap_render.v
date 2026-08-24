`timescale 1ns / 1ps

// Tilemap Renderer
// determines which tile the current pixel is on, then outputs that tile's color

module tilemap_render(
    input [9:0] h_count,
    input [9:0] v_count,

    input [11:0] ground_color,
    input [11:0] wall_color,

    output reg [11:0] tile_color,

    output [9:0] tile_address
);


    // 20 columns x 15 rows = 300 tiles
    // each entry stores the type of tile at that position
    reg [2:0] map_index [0:299];


    // load the tile map
    initial begin
        $readmemh("map.mem", map_index);
    end


    // determine which tile contains the current pixel
    wire [4:0] tile_x;
    wire [3:0] tile_y;
    wire [8:0] tile_num;
    wire [2:0] tile_type;

    // divide screen coordinates by 32 to get the tile coordinates aka shift right 5 bits
    assign tile_x = h_count[9:5];
    assign tile_y = v_count[9:5];

    // converts 2D tile coordinates into a 0-299 memory index
    assign tile_num = tile_x + (tile_y * 20);

    // fetch the tile type from the tilemap
    assign tile_type = map_index[tile_num];


    // position of the current pixel within its 32x32 tile
    wire [4:0] local_x;
    wire [4:0] local_y;

    // lower 4 bits correspond to local x/y 
    assign local_x = h_count[4:0];
    assign local_y = v_count[4:0];


    // convert the local x/y position into a pixel address (0-1023)
    assign tile_address = (local_y * 32) + local_x;


    // select the color based on the tile type
    always @(*) begin

        case (tile_type)

            // 0 = wall
            3'd0: begin
                tile_color = wall_color;
            end

            // 1 = ground
            3'd1: begin
                tile_color = ground_color;
            end

            // defaults to the color black
            default: begin
                tile_color = 12'h000;
            end

        endcase

    end

endmodule