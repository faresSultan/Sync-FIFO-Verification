package config_obj_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class fifo_config extends uvm_object;
        `uvm_object_utils(fifo_config)

        virtual FIFO_IF fifo_config_if;

        function new(string name = "fifo_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage