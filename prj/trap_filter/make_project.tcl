# ==================================================================================================
# Primary tcl file for creating Trap_Filter project.
#
# This script should be run using the make_project.tcl file in the RedPitaya-DSP/prj folder.
#
# This script is a modification of Red Pitaya's make_project.tcl script and the generic Vivado block
# design tcl script (i.e., File -> Export -> Export Block Design)
#
# ==================================================================================================

# Create cores
source make_cores.tcl

# Create basic Red Pitaya Block Design
source basic_red_pitaya_bd.tcl

# add source files
add_files -norecurse e_exp_decay.v
add_files -norecurse peak_detector.v
add_files -norecurse pulse_gen.v
add_files -norecurse ring_buffer.v
add_files -norecurse trap_filter.v

# ====================================================================================
# IP cores

# Create instance: reset_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 reset_slicer
set_property -dict [list CONFIG.DIN_WIDTH {30}] [get_bd_cells reset_slicer]
endgroup


# Create instance: xlconstant_0, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 led_const
set_property -dict [list CONFIG.CONST_WIDTH {8}] [get_bd_cells led_const]
endgroup


# Create instance: xlconstant_1, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ext_rst_const


# Create instance: trigger_slicer, and set properties
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 trigger_slicer


# Create instance: sig_amp_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sig_amp_slicer
set_property -dict [list CONFIG.DIN_FROM {31} CONFIG.DIN_TO {18}] [get_bd_cells sig_amp_slicer]
endgroup


# Create instance: decay_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 decay_slicer
set_property -dict [list CONFIG.DIN_FROM {29} CONFIG.DIN_TO {16} CONFIG.DIN_WIDTH {30}] [get_bd_cells decay_slicer]
endgroup


# Create instance: Kdelay_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Kdelay_slicer
set_property -dict [list CONFIG.DIN_FROM {29} CONFIG.DIN_TO {16} CONFIG.DIN_WIDTH {30}] [get_bd_cells Kdelay_slicer]
endgroup


# Create instance: Ldelay_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Ldelay_slicer
set_property -dict [list CONFIG.DIN_FROM {15} CONFIG.DIN_TO {2} CONFIG.DIN_WIDTH {30}] [get_bd_cells Ldelay_slicer]
endgroup


# Create instance: mult_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 mult_slicer
set_property -dict [list CONFIG.DIN_FROM {17} CONFIG.DIN_TO {2}] [get_bd_cells mult_slicer]
endgroup


# Create instance: threshold_slicer, and set properties
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 threshold_slicer
set_property -dict [list CONFIG.DIN_FROM {15} CONFIG.DIN_WIDTH {30}] [get_bd_cells threshold_slicer]
endgroup


# ====================================================================================
# RTL modules

# e_exp_decay
create_bd_cell -type module -reference e_exp_decay e_exp_decay_0

# peak_detector
create_bd_cell -type module -reference peak_detector peak_detector_0

# pulse_gen
create_bd_cell -type module -reference pulse_gen pulse_gen_0

# trap_filter
create_bd_cell -type module -reference trap_filter trap_filter_0


# ====================================================================================
# Connections 


# Create interface connections
connect_bd_intf_net [get_bd_intf_pins peak_detector_0/s_axis] [get_bd_intf_pins trap_filter_0/m_axis]
connect_bd_intf_net [get_bd_intf_pins axis_red_pitaya_adc_0/M_AXIS] [get_bd_intf_pins axis_red_pitaya_dac_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins e_exp_decay_0/m_axis] [get_bd_intf_pins trap_filter_0/s_axis]


# Create port connections
connect_bd_net [get_bd_pins Kdelay_slicer/Dout] [get_bd_pins trap_filter_0/Kdelay] [get_bd_pins peak_detector_0/Kdelay]
connect_bd_net [get_bd_pins Ldelay_slicer/Dout] [get_bd_pins trap_filter_0/Ldelay] [get_bd_pins peak_detector_0/Ldelay]
connect_bd_net [get_bd_pins trap_gpio/gpio2_io_o] [get_bd_pins sig_amp_slicer/Din] [get_bd_pins trigger_slicer/Din] [get_bd_pins mult_slicer/Din]
connect_bd_net [get_bd_pins trap_gpio/gpio_io_o] [get_bd_pins reset_slicer/Din] [get_bd_pins Ldelay_slicer/Din] [get_bd_pins Kdelay_slicer/Din]
connect_bd_net [get_bd_pins peak_gpio/gpio_io_o] [get_bd_pins decay_slicer/Din] [get_bd_pins threshold_slicer/Din]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins pulse_gen_0/clk] [get_bd_pins e_exp_decay_0/clk] [get_bd_pins trap_filter_0/clk] [get_bd_pins peak_detector_0/clk]
connect_bd_net [get_bd_pins mult_slicer/Dout] [get_bd_pins trap_filter_0/mult_factor]
connect_bd_net [get_bd_pins peak_detector_0/peak] [get_bd_pins peak_gpio/gpio2_io_i]
connect_bd_net [get_bd_pins pulse_gen_0/pulse] [get_bd_pins e_exp_decay_0/trigger]
connect_bd_net [get_bd_pins reset_slicer/Dout] [get_bd_pins e_exp_decay_0/aresetn] [get_bd_pins trap_filter_0/aresetn] [get_bd_pins peak_detector_0/aresetn]
connect_bd_net [get_bd_pins led_const/dout] [get_bd_ports led_o]
connect_bd_net [get_bd_pins ext_rst_const/dout] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins sig_amp_slicer/Dout] [get_bd_pins e_exp_decay_0/sig_amp]
connect_bd_net [get_bd_pins decay_slicer/Dout] [get_bd_pins e_exp_decay_0/decay_factor]
connect_bd_net [get_bd_pins threshold_slicer/Dout] [get_bd_pins peak_detector_0/threshold]
connect_bd_net [get_bd_pins trigger_slicer/Dout] [get_bd_pins pulse_gen_0/trigger]

# ====================================================================================
# Hierarchies

group_bd_cells Trap_filter [get_bd_cells trap_filter_0] [get_bd_cells Kdelay_slicer] [get_bd_cells Ldelay_slicer] [get_bd_cells mult_slicer]

group_bd_cells Exp_Signal [get_bd_cells e_exp_decay_0] [get_bd_cells pulse_gen_0] [get_bd_cells decay_slicer] [get_bd_cells sig_amp_slicer] [get_bd_cells trigger_slicer]

group_bd_cells Peak_Detector [get_bd_cells peak_detector_0] [get_bd_cells threshold_slicer]

group_bd_cells PS7 [get_bd_cells processing_system7_0] [get_bd_cells proc_sys_reset_0] [get_bd_cells ext_rst_const] [get_bd_cells axi_interconnect_0]


# ====================================================================================
# Addresses
