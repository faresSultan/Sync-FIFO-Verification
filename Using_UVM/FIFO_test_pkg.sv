package FIFO_test_pkg;

    import uvm_pkg::*;
    import fifo_env_pkg::*;
    import config_obj_pkg::*;
    import fifo_sequence_pkg::*;
    `include "uvm_macros.svh"
    class fifo_test extends uvm_test;
        `uvm_component_utils(fifo_test)

        fifo_env env;
        fifo_config fifo_config_obj_test;

        fifo_reset_sequence seq_1;
        Read_30_Write_70_sequence seq_2;
        Write_only_sequence seq_3;
        Read_only_sequence seq_4;
        Read_50_Write_50_sequence seq_5;

        function new(string name = "fifo_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            fifo_config_obj_test = fifo_config::type_id::create("fifo_config_obj_test");

            if(!uvm_config_db#(virtual FIFO_IF)::get(this,"","FIFO_IF",fifo_config_obj_test.fifo_config_if))
                `uvm_fatal("build_phase","Test - unable to get the virtual interface")
            uvm_config_db#(fifo_config)::set(this,"*","CFG",fifo_config_obj_test);

            env = fifo_env::type_id::create("env",this);

            seq_1 = fifo_reset_sequence::type_id::create("seq_1",this);
            seq_2 = Read_30_Write_70_sequence::type_id::create("seq_2",this);
            seq_3 = Write_only_sequence::type_id::create("seq_3",this);
            seq_4 = Read_only_sequence::type_id::create("seq_4",this);
            seq_5 = Read_50_Write_50_sequence::type_id::create("seq_5",this);

        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                
                `uvm_info("run_phase","Reset sequence started",UVM_MEDIUM)
                seq_1.start(env.agt.sqr);

                `uvm_info("run_phase","High Write Low read sequence started",UVM_MEDIUM)
                seq_2.start(env.agt.sqr);

                `uvm_info("run_phase","Write-only sequence started",UVM_MEDIUM)
                seq_3.start(env.agt.sqr);

                `uvm_info("run_phase","Read-only sequence started",UVM_MEDIUM)
                seq_4.start(env.agt.sqr);

                `uvm_info("run_phase","Balanced Write/Read sequence started",UVM_MEDIUM)
                seq_5.start(env.agt.sqr);

            phase.drop_objection(this);               
        endtask 

    endclass
endpackage