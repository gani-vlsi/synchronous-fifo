# Synchronous FIFO (16×8) – Verilog HDL

## Project Overview

This project implements a **16-depth × 8-bit Synchronous FIFO (First-In, First-Out)** using **Verilog HDL**.

A FIFO is a sequential data storage structure in which the **first data written is the first data read**. This project demonstrates fundamental RTL design concepts including memory, read/write pointers, occupancy tracking, and full/empty status detection.

The design was simulated using **Icarus Verilog** and the generated waveforms were analyzed using **GTKWave**.

## Features

- 8-bit data width
- 16-entry FIFO depth
- Synchronous operation using a clock
- Independent read and write enable controls
- Read and write pointers
- Occupancy counter
- FIFO `full` flag
- FIFO `empty` flag
- Reset functionality
- Protection against writing when FIFO is full
- Protection against reading when FIFO is empty
- Verilog testbench for functional verification
- VCD waveform generation for simulation analysis

## Block-Level Architecture

```text
                 +----------------------+
                 |   Synchronous FIFO   |
                 |                      |
   wr_data[7:0] ->|                      |-> rd_data[7:0]
   wr_en -------->|   Write / Read      |
   rd_en -------->|   Control Logic     |
   clk ---------->|                      |
   reset -------->|   FIFO Memory       |
                 |                      |
                 |   Write Pointer      |
                 |   Read Pointer       |
                 |   Occupancy Counter  |
                 |                      |
                 |   Full / Empty       |
                 +----------------------+
                     |            |
                   full         empty
Design Parameters
Parameter	Value	Description
DATA_WIDTH	8	Width of each stored data word
FIFO_DEPTH	16	Number of data entries

Therefore, the total storage capacity is:

16 × 8 = 128 bits

Main Signals
Signal	Direction	Description
clk	Input	System clock
reset	Input	Synchronous reset
wr_en	Input	Write enable
rd_en	Input	Read enable
wr_data[7:0]	Input	Data written into FIFO
rd_data[7:0]	Output	Data read from FIFO
full	Output	Indicates FIFO is full
empty	Output	Indicates FIFO is empty
Internal Architecture
1. FIFO Memory

The FIFO uses an array of 16 entries, with each entry capable of storing 8 bits.

reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
2. Write Pointer

The write pointer identifies the memory location where the next input data will be stored.

3. Read Pointer

The read pointer identifies the memory location from which the next output data will be read.

4. Occupancy Counter

The counter keeps track of the number of valid data elements currently stored in the FIFO.

Count = 0      → FIFO Empty
Count = 16     → FIFO Full
5. Full and Empty Detection

The FIFO status is generated from the occupancy counter.

assign empty = (count == 0);
assign full  = (count == FIFO_DEPTH);
Verification

The testbench verifies the following conditions:

Reset operation
Sequential write operations
Sequential read operations
Simultaneous read/write operation
FIFO full condition
Write attempt while FIFO is full
FIFO empty condition
Read operation after FIFO becomes empty

The simulation output confirms:

TEST 5: FIFO FULL CONDITION  -> PASS
TEST 6: WRITE ATTEMPT WHILE FULL COMPLETED
TEST 7: FIFO EMPTY CONDITION  -> PASS

FIFO SIMULATION COMPLETED
Simulation Tools
Icarus Verilog – RTL compilation and simulation
GTKWave – VCD waveform analysis
Linux / Ubuntu WSL – Development environment
Files
synchronous-fifo/
│
├── sync_fifo.v       # FIFO RTL design
├── sync_fifo_tb.v    # Verilog testbench
├── sync_fifo.vcd     # Simulation waveform
└── README.md         # Project documentation
Learning Outcomes

Through this project, I practiced:

RTL design using Verilog HDL
Sequential logic design
Memory modeling
Read/write pointer implementation
Counter-based FIFO status tracking
Full and empty condition handling
Testbench development
Functional verification
VCD waveform generation
Simulation and waveform analysis


Author

Uppala LakshmiGanesh

B.Tech – Electronics and Communication Engineering

GitHub: https://github.com/gani-vlsi

Areas of Interest: Digital Design, Verilog HDL, RTL Design, VLSI, FPGA.
