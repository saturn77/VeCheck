//-------------------------------------------------
// Project : "VivadoCapable__??__"
// File      :  top_level.sv
//-------------------------------------------------
// History
// 0.0.1 -- initial release -- Apr 2024
// 0.0.2 -- updated -- Jun 2024
//--------------------------------------------------
// Description
// This is an ongoing project to evaluate
// features of the IEEE 1800-2023 language
// standard against Vivado's capabilities. 
//
// Currently featured items: 
// 1. IQ fixed point formatting i.e. logic[I : -Q]
// 2. classes 
// Board Targets : 
// Currently tested validated boards: 
// 1. CMOD S7 board, Spartan 7, Digilent
//---------------------------------------------------
// ************ LICENSE ***************
// General Public License 3 
// This code is licensed under GPL 3 
// license, and is not for re-distribution.
//---------------------------------------------------


`timescale 1ns / 1ns
import FixedPointPkg::*; 

typedef logic signed [7:-24] data_t; 

module top_level(
    input   wire clk,
    output wire led0_r,
    output wire led0_b,
    output wire led0_g,
    output data_t adder_out 
    );

logic x_led0_r;
logic x_led0_b;
logic x_led0_g;


var data_t adder_a = 0;
var data_t adder_b; 
var data_t adder_result;

wire data_t wire_a, wire_b; 

assign wire_a = adder_a; 
assign wire_b = adder_a + 1; 

initial begin 
FixPt#(.data_t(data_t)) data_obj; 
$display("The I_Q format for data_t are %d, and %d", data_obj.i_bits, data_obj.q_bits); 

end 

data_t local_count; 


// Make a dummy counter to supply the adder 
always_ff@(posedge clk) begin 
adder_a <= adder_a + 1;
end 

// Make an adder with data_t differrentiated ! 
adder #(.data_t(logic signed[7:-24]))
uAdder (
.clk(clk),
.adder_a(wire_a),
.adder_b(wire_b),
.adder_out(adder_out)
); 

// Heartbeat with SystemVerilog classes 
 heartbeat_with_classes uHeartBeat (
      .clk(clk),
      .o_heartbeat(x_led0_r)
  );



// Heartbeat with standard SystemVerilog 
 heartbeat #(
      .CLK_HZ(12_000_000),
      .HB_HZ(1)
  ) uHeartBeat2 (
      .clock(clk),
      .reset(1'b0),
      .o_heartbeat(x_led0_b)
  );

//Hear
always_ff@(posedge clk) begin 
if (uHeartBeat2.y_count > 10) begin 
x_led0_g <= 1;
end else begin  
x_led0_g <= 0;
end 
end  

assign led0_g = x_led0_g; 

assign led0_r  = !x_led0_r;
assign led0_b = !x_led0_b;
endmodule

// Test adder for manipulating the data_t and so forth 

module adder #(parameter type data_t = type(logic signed[7:-24]))
(input logic clk,
input data_t adder_a, 
input data_t adder_b,
output data_t adder_out);

data_t adder_xy; 
wire signed[31:0] adder_x, adder_y;
assign adder_x = adder_a;
assign adder_y = adder_b;


always_ff@(posedge clk) begin
    adder_xy <= adder_x + adder_y;
end

assign adder_out = adder_xy;

endmodule
