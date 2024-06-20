/* verilator lint_off DECLFILENAME */
package FixedPointPkg;
/* verilator lint_on DECLFILENAME */


typedef logic signed [31:0] default_t;

class FixPt#(parameter type data_t = type(default_t));

static int i_bits; 
static int q_bits; 
function new ( data_t some_fixed_point_value );
    this.i_bits = $left(some_fixed_point_value);
    this.q_bits = $size(some_fixed_point_value) - $right(some_fixed_point_value) - 1;
endfunction

endclass



endpackage
