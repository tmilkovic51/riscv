# create project and set ultra96 as target board
create_project riscv E:/Vivado_projects/riscv -part xczu3eg-sbva484-1-e -force
set_property board_part em.avnet.com:ultra96v2:part0:1.0 [current_project]

# change working directory to current project directory
set project_directory [get_property DIRECTORY [current_project]] 
cd $project_directory

# add constraints for ultra96 board
add_files -fileset constrs_1 -norecurse constraints/ultra96_constraints.xdc

# add source files
add_files -fileset sources_1 -norecurse packages/riscv_opcodes_pkg.vhd
add_files -fileset sources_1 -norecurse packages/riscv_types_pkg.vhd
add_files -fileset sources_1 -norecurse packages/riscv_control_pkg.vhd
add_files -fileset sources_1 -norecurse packages/riscv_components_pkg.vhd
add_files -fileset sources_1 -norecurse rtl/1_IF_stage/IF_stage.vhd
add_files -fileset sources_1 -norecurse rtl/2_OF_stage/regset.vhd
add_files -fileset sources_1 -norecurse rtl/2_OF_stage/immediate_extraction.vhd
add_files -fileset sources_1 -norecurse rtl/2_OF_stage/OF_stage.vhd
add_files -fileset sources_1 -norecurse rtl/3_EX_stage/EX_stage.vhd

#update_compile_order -fileset sources_1