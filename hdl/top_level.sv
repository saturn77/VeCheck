//-------------------------------------------------
// Project   :  VeCheck for SystemVerilog 1800-2023
// File      :  top_level.sv
//-------------------------------------------------
// History   :
// 0.0.1 -- initial release      -- 01 Apr 2024
// 0.0.2 -- updated              -- 20 Jun 2024
// 0.0.3 -- testing with cmod s7 -- 22 Jun 2024
//--------------------------------------------------
// Description 
// This is an ongoing project to evaluate
// features of the IEEE 1800-2023 language
// standard against Vivado's capabilities. 
//---------------------------------------------------
// LICENSE   : GNU Lesser General Public License 3 
//---------------------------------------------------
`timescale 1ns / 1ns

module top_level(
    input  wire      clk,
    input  wire[1:0] btn, 
    output reg       led0_r,
    output reg       led0_b,
    output reg       led0_g
);

bit x_led0_r;
bit x_led0_b;
bit x_led0_g;

bit[2:0] regX, regY; 
bit resetX, resetY; 

bit heartbeat; 

always_ff@(posedge clk) begin
  regX <= {regX[1:0], btn[0]};
  regY <= {regY[1:0], btn[1]};
end 

always_comb begin 
  resetX = regX[2];
  resetY = regY[2];
end 

always_comb begin 
  case({resetX,resetY})
  2'b00 : begin
    led0_r = 1'b1;
    led0_b = 1'b1;
    led0_g = !heartbeat;
  end
  2'b01 : begin
    led0_r = 1'b0;
    led0_b = 1'b1;
    led0_g = 1'b1;
  end
  2'b10 : begin
    led0_r = 1'b1;
    led0_b = 1'b0;
    led0_g = 1'b1;
  end
  2'b11 : begin
    led0_r = 1'b1;
    led0_b = 1'b1;
    led0_g = 1'b0;
  end
  endcase
end

heartbeat_with_classes uHeartBeat (
    .clk(clk),
    .reset(resetY),
    .o_heartbeat(heartbeat)
);

endmodule



