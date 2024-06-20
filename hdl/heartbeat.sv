`timescale 1ns / 1ps

module heartbeat #(
    parameter int CLK_HZ = 12_000_000,
    parameter int HB_HZ = 1
)(
    input  logic clock,
    input  logic reset,
    output logic o_heartbeat
    );

    localparam int HB_COUNTS = 12_000_000;
    localparam int DUTY_CNTS = 600_000;

    typedef int unsigned uint_32; 
    uint_32  x_count;
    logic    x_flag; 
    uint_32  y_count;
    logic    y_flag;

    always_comb begin 
        o_heartbeat = (y_count > 0) ? 1'b1 : 1'b0;
    end 

    // Xcounter for period counter 
    always_ff@(posedge clock) begin : Xcounter 
        if (reset) begin 
            x_count <= 0; 
            x_flag <= 1'b0; 
        end else begin 
                if (x_count < HB_COUNTS) begin 
                    x_count <= x_count + 1;
                    x_flag <= 1'b0;
                end else begin 
                    x_count <= 0;
                    x_flag <= 1'b1;
                end
        end
    end : Xcounter

    // Ycounter for duty cycle
    always_ff@(posedge clock) begin : Ycounter 
        if (reset || x_flag) begin 
            y_count <= DUTY_CNTS;
        end else begin 
            if (y_count >0  ) begin 
                y_count <= y_count - 1;
            end
        end
    end : Ycounter
    
    
endmodule
