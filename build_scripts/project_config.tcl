# Project configuration

set project_name "tdc"
set project_dir  "../tdc"

# Board repository path (relative to this script)
set board_repo [file normalize "../board_files"]
set_param board.repoPaths [list $board_repo]


# Use FPGA part directly
set fpga_part  "xc7z010clg400-1"


# Edit board choices
set board_redpitaya        "redpitaya.com:redpitaya:part0:1.1"
set board_zybo_z7          "digilentinc.com:zybo:part0:1.0"

#set board part
##set board_part $board_redpitaya  #use board part here.
set board_part $board_zybo_z7  


set top_module   "tdc_top"

set target_language    "VHDL"
set simulator_language "VHDL"