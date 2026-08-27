module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input  wire                  clk,
    input  wire                  reset,

    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] wr_data,

    output reg  [DATA_WIDTH-1:0] rd_data,
    output wire                  full,
    output wire                  empty
);

    // FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Pointers
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;

    // Number of stored elements
    reg [4:0] count;

    // Empty and full conditions
    assign empty = (count == 0);
    assign full  = (count == FIFO_DEPTH);

    always @(posedge clk) begin

        if (reset) begin
            wr_ptr  <= 4'b0000;
            rd_ptr  <= 4'b0000;
            count   <= 5'b00000;
            rd_data <= {DATA_WIDTH{1'b0}};
        end

        else begin

            // Write operation
            if (wr_en && !full) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end

            // Read operation
            if (rd_en && !empty) begin
                rd_data <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end

            // Update FIFO count
            case ({wr_en && !full, rd_en && !empty})

                2'b10: count <= count + 1'b1; // Write only
                2'b01: count <= count - 1'b1; // Read only
                2'b11: count <= count;        // Read and write
                default: count <= count;      // No operation

            endcase
        end
    end

endmodule
