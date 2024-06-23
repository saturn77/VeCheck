# VeCheck
*Checking* **SystemVerilog IEEE-2023 and IEEE-2017 synthesis capabilities** and providing example designs.  

# Introduction
The features of SystemVerilog for synthesis are the focus, where 
example projects are built to evaluate various features of the language. The documentation guides from vendors are often vague, so specific 
examples are needed to validate the advertised language aspects. 

## Standards and Scope

SystemVerilog is an IEEE standard; the two most recent standards being IEEE 1800-2017 and IEEE 1800-2023.  Many of the features
in the latest revisions have not yet been adopted, and this repository's purpose and scope is to evaluate specific features for synthesis.

An additional scope and purpose of this repository is to
provide a library of synthesizable modules that have been
vetted and incorporate advanced features of the language.

# Testing Features

The various features are evaluated for the 2017 and 2023 standards. 

Feature | Description | Passing
---------|----------|---------
 fixed point format | use of bit[I:-Q] or logic[I:-Q] | passing
 classes | use of classes, wrapped in a package | passing
 types | passing parameters as types | passing
tbd | new features of 1800-2023 | 

## Classes and Types

A particular interest is clases, allowing for more Object Oriented Programming (OOP)
approach for **synthesis** with SystemVerilog. The AMD user guide UG901 advertises support classes, and this repository is a test platform for those features.

One advantage of classes is encapsulating code that handles
bit widths as shown by the $clog2 function in the resolution
of the data types uT and dT. 

### Example Class

Consider the implementation of a heartbeat counter below
comprised of an up counter for the frame, and a down counter
for the duty cycle. The handling of data types with 
the localparams uT and dT are local to the class and allow
for great flexibility when instantiating the class, and the 
designer does not have to repeat this type of code in the higher
level module instantiation. Note that there are **functional** 
programming aspect to handling the counters. 

```Verilog
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
```
### Wrapping Classes in a Package

The code below shows how the UpCount class was wrapped in package
called CounterPkg. This allows for the code above to work. 

The upstream module can import with import CounterPkg::*, or one
can use local bindings such as CounterPkg::UpCount() as in the code above. 

```Verilog
package CounterPkg; 

class UpCount #(parameter type T, parameter T Modulo = 0); 

static T value;
static bit flag; 
static T modulo = 0;

function new();
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

endpackage 
```


# Validation

For this repsitory, validating the example design is done by 
targeting the Digilent CMODS7 board, as it is a low cost small
form factor board that is generally available. 

Steps to duplicate the design results : 

```bash
git clone https://git@github.com/saturn77/VeCheck.git
```

The open Vivado and create a new project, adding the source
files and constraint files in the repos. Upon RTL elaboration,
the block diagram below should be displayed. 

![Top Level](./assets/top_level_design.png)











