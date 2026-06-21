# General Vivado project generator

#current directory.
set script_dir [file dirname [file normalize [info script]]]
cd $script_dir

source ./project_config.tcl

#set either FPGA part or board files in board_files directory.
if {$board_part eq ""} {
    create_project $project_name $project_dir -part $fpga_part -force
} else {
    create_project $project_name $project_dir -force
    set_property board_part $board_part [current_project]
}


set_property target_language $target_language [current_project]
set_property simulator_language $simulator_language [current_project]

proc add_files_from_list {filelist fileset_name file_type} {
    if {![file exists $filelist]} {
        puts "WARNING: Missing file list: $filelist"
        return
    }

    set fp [open $filelist r]

    while {[gets $fp line] >= 0} {
        set line [string trim $line]

        if {$line eq ""} {
            continue
        }

        if {[string match "#*" $line]} {
            continue
        }

        set path [file normalize $line]

        if {[file exists $path]} {
            puts "Adding $file_type: $path"
            add_files -fileset $fileset_name $path
        } else {
            puts "WARNING: Missing $file_type file: $path"
        }
    }

    close $fp
}

# -------------------------
# Add design sources
# -------------------------
add_files_from_list "./sources.f" "sources_1" "design source"

set_property top $top_module [current_fileset]

# -------------------------
# Add simulation sources
# -------------------------
add_files_from_list "./sim_sources.f" "sim_1" "simulation source"

# -------------------------
# Add constraints
# -------------------------
add_files_from_list "./constraints.f" "constrs_1" "constraint"

# -------------------------
# Update compile order
# -------------------------
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts ""
puts "Vivado project generated successfully."
puts "Project: $project_name"
puts "Directory: $project_dir"
puts "Part:    $fpga_part"
puts "Board:   $board_part"
puts "Top:     $top_module"

# -------------------------
# Export project info for batch scripts
# -------------------------
set project_info_file [file normalize "./project_info.bat"]

set fp [open $project_info_file w]
puts $fp "set PROJECT_NAME=$project_name"
puts $fp "set PROJECT_DIR=$project_dir"
puts $fp "set XPR_PATH=$project_dir/$project_name.xpr"
close $fp

puts "Generated batch project info: $project_info_file"