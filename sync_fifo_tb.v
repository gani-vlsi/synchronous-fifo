`timescale 1ns/1ps

module sync_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    // Testbench signals
    reg clk;
    reg reset;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] wr_data;

    wire [DATA_WIDTH-1:0] rd_data;
    wire full;
    wire empty;

    // ------------------------------------------------
    // DUT: Device Under Test
    // ------------------------------------------------

    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // ------------------------------------------------
    // Clock Generation
    // 10 ns clock period
    // ------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------
    // VCD Waveform Generation
    // ------------------------------------------------

    initial begin
        $dumpfile("sync_fifo.vcd");
        $dumpvars(0, sync_fifo_tb);
    end

    // ------------------------------------------------
    // Main Test
    // ------------------------------------------------

    initial begin

        // Initialize signals
        clk     = 0;
        reset   = 1;
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;

        // ============================================
        // TEST 1: RESET
        // ============================================

        #12;
        reset = 0;

        $display("--------------------------------------");
        $display("RESET COMPLETED");
        $display("--------------------------------------");

        // ============================================
        // TEST 2: WRITE FOUR VALUES
        // ============================================

        @(negedge clk);

        wr_en   = 1;
        rd_en   = 0;
        wr_data = 8'hA1;

        @(negedge clk);
        wr_data = 8'hB2;

        @(negedge clk);
        wr_data = 8'hC3;

        @(negedge clk);
        wr_data = 8'hD4;

        @(negedge clk);
        wr_en = 0;

        $display("TEST 2: FOUR VALUES WRITTEN");
        $display("A1 -> B2 -> C3 -> D4");

        // ============================================
        // TEST 3: READ TWO VALUES
        // ============================================

        @(negedge clk);

        rd_en = 1;

        @(negedge clk);
        rd_en = 0;

        @(negedge clk);
        rd_en = 1;

        @(negedge clk);
        rd_en = 0;

        $display("TEST 3: TWO VALUES READ");
        $display("Expected order: A1 -> B2");

        // ============================================
        // TEST 4: SIMULTANEOUS READ AND WRITE
        // ============================================

        @(negedge clk);

        wr_en   = 1;
        rd_en   = 1;
        wr_data = 8'hE5;

        @(negedge clk);

        wr_en = 0;
        rd_en = 0;

        $display("TEST 4: SIMULTANEOUS READ/WRITE COMPLETED");

        // ============================================
        // TEST 5: FILL FIFO COMPLETELY
        // ============================================

        @(negedge clk);

        wr_en = 1;
        rd_en = 0;

        wr_data = 8'h01;

        @(negedge clk);
        wr_data = 8'h02;

        @(negedge clk);
        wr_data = 8'h03;

        @(negedge clk);
        wr_data = 8'h04;

        @(negedge clk);
        wr_data = 8'h05;

        @(negedge clk);
        wr_data = 8'h06;

        @(negedge clk);
        wr_data = 8'h07;

        @(negedge clk);
        wr_data = 8'h08;

        @(negedge clk);
        wr_data = 8'h09;

        @(negedge clk);
        wr_data = 8'h0A;

        @(negedge clk);
        wr_data = 8'h0B;

        @(negedge clk);
        wr_data = 8'h0C;

        @(negedge clk);
        wr_data = 8'h0D;

        @(negedge clk);
        wr_data = 8'h0E;

        @(negedge clk);
        wr_data = 8'h0F;

        @(negedge clk);
        wr_data = 8'h10;

        @(negedge clk);

        wr_en = 0;

        // ============================================
        // CHECK FULL CONDITION
        // ============================================

        if (full == 1'b1)
            $display("TEST 5: FIFO FULL CONDITION -> PASS");
        else
            $display("TEST 5: FIFO FULL CONDITION -> FAIL");

// ============================================
// TEST 6: TRY TO WRITE WHEN FIFO IS FULL
// ============================================

@(negedge clk);

wr_en   = 1;
rd_en   = 0;
wr_data = 8'hFF;

@(posedge clk);
#1;

// FIFO should still be full
// because writing must be blocked when full

if (full == 1'b1)
    $display("TEST 6: WRITE WHILE FULL -> PASS");
else
    $display("TEST 6: WRITE WHILE FULL -> FAIL");

wr_en = 0;


        // ============================================
        // TEST 7: READ ALL DATA
        // ============================================

        @(negedge clk);

        rd_en = 1;

        repeat (16) begin
            @(negedge clk);
        end

        rd_en = 0;

        // ============================================
        // CHECK EMPTY CONDITION
        // ============================================

        @(negedge clk);

        if (empty == 1'b1)
            $display("TEST 7: FIFO EMPTY CONDITION -> PASS");
        else
            $display("TEST 7: FIFO EMPTY CONDITION -> FAIL");

        // ============================================
        // END SIMULATION
        // ============================================

        #20;

        $display("--------------------------------------");
        $display("FIFO SIMULATION COMPLETED");
        $display("--------------------------------------");

        $finish;

    end

    // ------------------------------------------------
    // Terminal Monitor
    // ------------------------------------------------

    initial begin

        $monitor(
            "Time=%0t | Reset=%b | WR=%b | RD=%b | Data_In=%h | Data_Out=%h | Full=%b | Empty=%b",
            $time,
            reset,
            wr_en,
            rd_en,
            wr_data,
            rd_data,
            full,
            empty
        );

    end

endmodule
