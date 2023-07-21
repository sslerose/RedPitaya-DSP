
set core_name [lindex $argv 0]

set part_name [lindex $argv 1]

file delete -force tmp/pavel-cores/$core_name tmp/pavel-cores/$core_name.cache tmp/pavel-cores/$core_name.hw tmp/pavel-cores/$core_name.xpr tmp/pavel-cores/$core_name.ip_user_files tmp/pavel-cores/$core_name.sim

create_project -part $part_name $core_name tmp/pavel-cores

add_files -norecurse cores/$core_name.v

ipx::package_project -import_files -root_dir tmp/pavel-cores/$core_name

set core [ipx::current_core]

set_property VERSION {1.0} $core
set_property NAME $core_name $core
set_property LIBRARY {user} $core
set_property VENDOR {pavel-demin} $core
set_property VENDOR_DISPLAY_NAME {Pavel Demin} $core
set_property COMPANY_URL {https://github.com/pavel-demin/red-pitaya-notes} $core
set_property SUPPORTED_FAMILIES {zynq Production} $core

ipx::create_xgui_files $core
ipx::update_checksums $core
ipx::save_core $core

close_project
