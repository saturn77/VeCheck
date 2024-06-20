package CounterPkg; 

class UpCount #(parameter type T, parameter T Modulo = 0); 

static T value;
static bit flag; 

function new();
this.value = 0;
endfunction

function clear ();
    this.value = 0;
endfunction 

function load (T load_value);
    this.value = load_value;
endfunction 

function increment ();
   this.value = this.value + 1;
   this.flag = (this.value == Modulo) ? 1'b1 : 1'b0;
endfunction

endclass

class DnCount #(parameter type T, parameter T Modulo = 0); 

static T value;
static bit flag; 

function new();
this.value = Modulo;
endfunction

function clear ();
    this.value = 0;
endfunction 

function load (T load_value);
    this.value = load_value;
endfunction 

function decrement ();
   this.value = this.value - 1;
   this.flag = (this.value) ? 1'b1 : 1'b0;
endfunction

endclass

endpackage 






