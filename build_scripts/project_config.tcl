# Project configuration

set project_name "tdc"
set project_dir  "../tdc"

# Use FPGA part directly
set fpga_part  "xc7z020clg400-1"

# Optional board part. Leave empty if not using board files.
set board_part "" 
#set board_part "redpitaya.com:redpitaya:part0:1.0"



set top_module   "tdc_top"

set target_language    "VHDL"
set simulator_language "VHDL"