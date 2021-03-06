APOLLO Service Module firmware

Github branching policy:
We are going to try to follow: https://nvie.com/posts/a-successful-git-branching-model/
The default branch is develop and you should branch off of that.


To Build FPGA FW:
  >make init
  >make prebuild
  >make
  Ouput:
    bit/top.bit
    kernel/hw/*.dtsi_chunk,*.dtsi_post_chunk,hwdef

To Build zynq fsbl+kernel+fs
  First, build FPGA FW
  >./scripts/GetReleases.py
  >cd kernel
  >make

  Output:
    kernel/zynq_os/images/linux/BOOT.bin
    kernel/zynq_os/images/linux/image.ub

To Build the centos image
   First, build FPGA FW and run the GetReleases script if you haven't already
   >./scripts/BuildAddressTable.py -l os/slaves.yaml -r os/Kintex_slaves.yaml -r os/Virtex_slaves.yaml
   > cd os
   > sudo make clean; sudo make

   Output: (follow os/README for copying instructions)
     os/image
   
Organization:
  Build scripts are in ./scripts and are called by the Makefile
  
  Zynq block diagram generation tcl scripts are in ./src/ZynqOS
    create.tcl is automatically called by build scripts.
  This relies on the tcl scripts in the submodule in bd.

  HDL & constraint files are in ./src with top.vhd as the top module.
  slaves.yaml in ./src lists the slaves to be built and the tcl needed to build them
  Output HDL _map.vhd and _PKG.vhd, and AddSlaves.tcl are autogenerated, but commited to git so UHAL isn't required to do simple builds 

  Linux Kernel & FSBL:
    ./kernel/hw contains device-tree elements and the xilinx hwdef files needed to build the PS system
    ./kernel/zynq_os_mods contains recipes for mods/patches for/of the petalinux system.

  CentOS:
    ./os/address_table contains the build address table and module files
    ./os/mods contains the modifications to the centos system

Dependencies:
	UHAL is required for HDL builds from address tables
	generation of xml regmaps requires the Jinja2 library for python
