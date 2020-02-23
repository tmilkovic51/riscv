# create project and set ultra96 as target board
create_project riscv E:/Vivado_projects/riscv -part xczu3eg-sbva484-1-e -force
set_property board_part em.avnet.com:ultra96v2:part0:1.0 [current_project]

# change working directory to current project directory
set project_directory [get_property DIRECTORY [current_project]] 
cd $project_directory

# add constraints for ultra96 board
add_files -fileset constrs_1 -norecurse constraints/ultra96_constraints.xdc

# add source files
add_files -fileset sources_1 -norecurse packages/riscv_opcodes.vhd
add_files -fileset sources_1 -norecurse packages/riscv_types.vhd


#update_compile_order -fileset sources_1