`timescale 1ns / 1ps

import CounterPkg::*; 

module heartbeat_with_classes(
    input logic clk, 
    output logic o_heartbeat
);
    
typedef int unsigned  u32;
localparam u32 Modulo = 12_000_000;
localparam u32 Duty = 600_000;

UpCount #(.T(u32),.Modulo(Modulo)) counterX;
DnCount #(.T(u32),.Modulo(Duty)) counterY;

always_ff@(posedge clk) begin 
    counterX.increment();
    if (counterX.flag) begin
        counterX.clear();
        counterY.load(Duty);
    end 
    if (counterY.value) counterY.decrement();
end 

assign o_heartbeat = counterY.flag;

endmodule
