`timescale 1ns / 1ps

module heartbeat_with_classes(
    input  bit clk, 
    input  bit reset, 
    output bit o_heartbeat
);
    
localparam types::u32 Modulo = 12_000_000;
localparam types::u32 Duty   =  2_400_000;

localparam type uT = bit[$clog2(Modulo)-1:0];
localparam type dT = bit[$clog2(Duty)-1:0];

CounterPkg::UpCount #(.T(uT),.Modulo(Modulo)) frame_counter;
CounterPkg::DnCount #(.T(dT),.Modulo(Duty)) duty_counter;

always_ff@(posedge clk) begin 
  if (reset) begin 
    frame_counter.clear();
    duty_counter.clear();
  end
  else begin 
    frame_counter.increment();
    if (frame_counter.flag) begin
        frame_counter.clear();
        duty_counter.load(Duty);
    end 
    if (duty_counter.value) duty_counter.decrement();
  end 
end 

assign o_heartbeat = (duty_counter.value);

endmodule
