
`timescale 1 us / 1 ns  // Changed to microsecond scale

// 2. Preprocessor Directives
`define DELAY 0.5  // 1 MHz clock (1 µs period, 0.5 µs HIGH and 0.5 µs LOW)

// 3. Include Statements
// `include "counter_define.h"

module tb_traffic;

// 4. Parameter definitions
parameter ENDTIME = 4000000;  // Increased to match the new timescale

// 5. DUT Input regs
reg clk;
reg rst_n;
reg sensor;
wire [2:0] light_farm;

// 6. DUT Output wires
wire [2:0] light_highway;

// 7. DUT Instantiation
traffic_light tb(light_highway, light_farm, sensor, clk, rst_n);

// 8. Initial Conditions
initial begin
    clk = 1'b0;
    rst_n = 1'b0;
    sensor = 1'b0;
end

// 9. Generating Test Vectors
initial begin
    main;
end

task main;
fork
    clock_gen;
    reset_gen;
    operation_flow;
    debug_output;
    endsimulation;
join
endtask

// Clock generation: 1 MHz (1 µs period)
task clock_gen;
begin
    forever #`DELAY clk = ~clk;
end
endtask

// Reset sequence with microsecond delay
task reset_gen;
begin
    rst_n = 0;
    #20 rst_n = 1;  // Reset remains low for 20 µs
end
endtask

// Sensor operation with microsecond delays
task operation_flow;
begin
    sensor = 0;
    #600 sensor = 1;
    #1200 sensor = 0;
    #1200 sensor = 1;
end
endtask

// Debugging output
task debug_output;
begin
    $display("------------------------------------------------");
    $display("------------ SIMULATION RESULT -----------------");
    $display("------------------------------------------------");
    $monitor("TIME = %d us, reset = %b, sensor = %b, light of highway = %b, light of farm road = %b", 
             $time, rst_n, sensor, light_highway, light_farm);
end
endtask

// Ending simulation at ENDTIME
task endsimulation;
begin
    #ENDTIME
    $display("------------ SIMULATION END ------------");
    $finish;
end
endtask

endmodule




