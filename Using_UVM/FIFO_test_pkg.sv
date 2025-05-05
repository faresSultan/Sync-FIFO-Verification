package FIFO_test_pkg;

    import uvm_pkg::*;
    import fifo_env_pkg::*;
    import config_obj_pkg::*;
    import FIFO_sequence_pkg::*;
    `include "uvm_macros.svh"

    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)

        fifo_env env;
        fifo_config fifo_config_obj_test;

        //define sequences handles here

        function new(string name = "fifo_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            fifo_config_obj_test = fifo_config::type_id::create("fifo_config_obj_test");

            if(!uvm_config_db#(virtual FIFO_IF)::get(this,"","FIFO_IF",fifo_config_obj_test.fifo_config_if))
                `uvm_fatal("build_phase","Test - unable to get the virtual interface")
            uvm_config_db#(fifo_config)::set(this,*,"CFG",fifo_config_obj_test);

            env = fifo_env::type_id::create("env",this);

            // create sequences here

        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                // run sequences using .start method               
            phase.drop_objection(this);               
        endtask 

    endclass
endpackage