module branch_flush (
    input  wire ex_pc_src,

    output wire if_id_flush,
    output wire id_ex_flush
);

assign if_id_flush = ex_pc_src;
assign id_ex_flush = ex_pc_src;

endmodule
