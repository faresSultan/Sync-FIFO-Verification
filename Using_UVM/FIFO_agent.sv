package fifo_agent_pkg;

    import uvm_pkg::*;
    import fifo_driver_pkg::*;
    import fifo_sequencer_pkg::*;
    import fifo_monitor_pkg::*;
    import fifo_seq_item_pkg::*;

    import config_obj_pkg::*;
    `include "uvm_macros.svh"

    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent)
        fifo_driver driver;
        fifo_sequencer sqr;
        fifo_monitor mon;
        fifo_config fifo_config_obj;
        uvm_analysis_port #(fifo_seq_item) agt_a_port;

        function new(string name = "fifo_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(fifo_config)::get(this,"","CFG",fifo_config_obj))
                `uvm_fatal("build_phase","Agent - unable to get the virtual interface")     
            sqr = fifo_sequencer::type_id::create("sqr",this);
            driver = fifo_driver::type_id::create("driver",this);
            mon = fifo_monitor::type_id::create("mon",this);
            agt_a_port = new("agt_a_port",this);

        endfunction

        function void connect_phase(uvm_phase phase);
            driver.fifo_driver_vif = fifo_config_obj.fifo_config_if;
            mon.fifo_monitor_vif = fifo_config_obj.fifo_config_if;
            driver.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_a_port.connect(agt_a_port);
        endfunction
    endclass
endpackage