package CounterPkg; 

class UpCount #(parameter type T, parameter T Modulo = 0); 

static T value;
static bit flag; 
static T modulo = 0;

function new(T Modulo);
this.value = 0;
this.modulo = Modulo;
endfunction

function void clear();
    this.value = 0;
endfunction 

function void load(T load_value);
    this.value = load_value;
endfunction 

function void increment();
   this.value++;
   this.flag = (this.value == this.modulo);
endfunction

endclass

class DnCount #(parameter type T, parameter T Modulo = 0); 

static T value;
static bit flag; 

function new();
this.value = Modulo;
endfunction

function void clear ();
    this.value = 0;
endfunction 

function void load (T load_value);
    this.value = load_value;
endfunction 

function void decrement ();
   this.value = this.value - 1;
   this.flag = (this.value);
endfunction

endclass

endpackage 






