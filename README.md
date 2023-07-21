# RedPitaya
Collection of references for my Red Pitaya research project funded by the University of Kentucky.

# Purpose
This GitHub repository is a publicly available set of documents created during my undergraduate research at the University of Kentucky. My research is centered around the application of the Red Pitaya ecosystem of open-source FPGAs and their application to independent research, academics, and the professional space. Throughout my documentation I rely on [Red Pitaya's GitHub](https://github.com/RedPitaya/RedPitaya.git) and Vestaia's work with a similar project at https://github.com/Vestaia/DSP.

# How to build Pavel Demin's Cores
Pavel has extenive notes on working with the Red Pitaya, most of which can be found [here](https://github.com/pavel-demin/red-pitaya-notes/tree/master). The scripts used in the following steps are a modification of those made by Pavel.
1. Open preferred Linux distribution (I am using Ubuntu 22.04.2 LTS as of update).
2. Run `source /opt/Xilinx/Vivado/2023.1/settings64.sh`.
3. Access "RedPitaya-DSP" folder by `cd RedPitaya-DSP` (assuming repo cloned into "~" directory).
4. Run `vivado -mode batch -source build-cores.tcl`.

Cores will be located in "RedPitaya-DSP/tmp/pavel-cores" and can be sourced for other projects.

# GitHub Sources
* [RedPitaya](https://github.com/RedPitaya/RedPitaya)
* [RedPitaya-FPGA](https://github.com/RedPitaya/RedPitaya-FPGA/tree/master)
* [Vestaia's DSP](https://github.com/Vestaia/DSP/tree/main)
* [Pavel Demin's red-pitaya-notes](https://github.com/pavel-demin/red-pitaya-notes/tree/master)
