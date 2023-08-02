# RedPitaya-DSP
Collection of references for my Red Pitaya research project at the University of Kentucky.

# Purpose
This collection is a publicly available repository created during my undergraduate research at the University of Kentucky. My research is centered around the application of the Red Pitaya ecosystem of open-source FPGAs to digital signal processing in an academic space.

# Cloning the Repository
Steps for cloning the repository.
1. Open preferred Linux distribution (I am using Ubuntu 22.04.2 LTS as of update).
2. Install Git using `sudo apt install git`.
3. Within home (~) directory, run `git clone https://github.com/sslerose/RedPitaya-DSP.git`.
4. Rename foder to "RedPitaya-DSP" if it has a different name (allows proper function of included scripts).

# How to Build Pavel Demin's Cores
Pavel has extenive notes on working with the Red Pitaya, most of which can be found [here](https://github.com/pavel-demin/red-pitaya-notes/tree/master). The scripts used in the following steps are a modification of those made by Pavel.
1. Open preferred Linux distribution (I am using Ubuntu 22.04.2 LTS as of update).
2. Run `source /opt/Xilinx/Vivado/2023.1/settings64.sh`.
3. Open "RedPitaya-DSP" folder by `cd RedPitaya-DSP` (assuming repo cloned into home directory).
4. Run `vivado -mode batch -source build-cores.tcl`.

Cores will be located in "RedPitaya-DSP/tmp/pavel-cores" and can be sourced for other projects.

# How to Create Projects in "prj" Folder
To choose the project you want to create, open the "make_project.tcl" file in the "RedPitaya-DSP/prj" folder and uncomment the respective `set project_name "project_name"` command, leaving all others commented.
1. Open preferred Linux distribution (I am using Ubuntu 22.04.2 LTS as of update).
2. Run `source /opt/Xilinx/Vivado/2023.1/settings64.sh`.
3. Open "prj" folder by `cd RedPitaya-DSP/prj` (assuming repo cloned into "~" directory).
4. Launch Vivado by `vivado`.
5. In the TCL console at the bottom, run `source make_project.tcl`.

Vivado will generate the necessary cores for the respective project and then assemble custom Verilog modules, Xilinx IP cores, constraints, and connections to build the block design. The project will be located in "RedPitaya-DSP/tmp".

# GitHub Sources
* [RedPitaya](https://github.com/RedPitaya/RedPitaya)
* [RedPitaya-FPGA](https://github.com/RedPitaya/RedPitaya-FPGA/tree/master)
* [Vestaia's DSP](https://github.com/Vestaia/DSP/tree/main)
* [Pavel Demin's red-pitaya-notes](https://github.com/pavel-demin/red-pitaya-notes/tree/master)
