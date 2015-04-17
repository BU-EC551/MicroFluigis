#Partial Reconfiguration

A script is provided to automate the generation of blanking and partial bitstreams for partial reconfiguration using Xilinx Vivado.

The user of this script is responsible for generating Verilog modules for:
- A Verilog top level module
- Verilog for each Reconfigurable Module (RM)
- An `.xdc` file

The user must also have an idea of how large the above modules are (i.e., what is the FPGA footprint) in order to create appropriately-sized Reconfigurable Partitions (RP). These sizes are reflected in the `.xdc` file.

##`design_complete.tcl`
This script was designed in accordance with Xilinx User's Guide 947: Partial Reconfiguration for Vivado

####Requirements:
- Vivado 2014.1+
- Xilinx Partial Reconfiguration license
- 7-Series FPGA
  - The script ships with the variant of the Xilinx Artix-7 family on the Digilent Basys3 as the default, but it can be easily modified

####File System Hierarchy
The script requires the following directory structure:

*\Bitstreams*
- Create this folder and leave it empty. This is where you will find your bitstreams once the script has run

*\Implement*
- This folder will store checkpoints created in the process of executing the script

*\Sources*
- This folder will contain your design files in the following subfolders:

*\Sources\hdl*
- Create a separate folder (\Sources\hdl\rm1, \Sources\hdl\rm2, \Sources\hdl\top, etc.) for each reconfigurable module as well as a separate folder for your top level module.

*\Sources\xdc*
- Place your `.xdc` file here

*\Synth*
- This folder will contain all post-synthesis checkpoints

*\Tcl*
- This folder should contain all subscripts invoked by `design_complete.tcl`. **DO NOT MODIFY THESE SCRIPTS UNLESS YOU REALLY KNOW WHAT YOU'RE DOING!!** These scripts include:
  -design_utils.tcl
  -eco_utils.tcl
  -hd_floorplan_utils.tcl
  -impl.tcl
  -impl_utils.tcl
  -log.tcl
  -ooc_impl.tcl
  -pr_impl.tcl
  -run.tcl
  -step.tcl
  -synth.tcl
  -synth_utils.tcl

####Invoking the Script
To run the script simply `cd` into the project directory where the `design_complete.tcl` script is located. Run the following commands

```
$ vivado -mode tcl
% source design_complete.tcl
```

The above two commands will go complete the entire process from RP definition, synthesis, out of order synthesis of RMs, P&R to bitstream generation.

# LCD Displaying Color Data
The `\build.srcs` folder contains all source code implementing a data parser for the RGB color sensor and displaying the parsed data on an LCD (Digilent PModCLS).
