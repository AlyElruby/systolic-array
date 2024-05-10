module block #( 
    parameter WIDTH = 4
)
    (
    input  logic            en ,rst_n,clk,
    input  logic [WIDTH - 1 :0] i_x,i_y,
    output logic [WIDTH - 1 :0] o_x,o_y,result
);
    logic [WIDTH - 1 :0] sum = 0;
    logic [WIDTH - 1 :0] reg_x , reg_y;
    always@(posedge clk , negedge rst_n) begin
        if(!rst_n) begin
            sum      <= 0;
            reg_x    <= 0;
            reg_y    <= 0;
        end
        else if (en) begin
            reg_x  <= i_x;
            reg_y  <= i_y;
            sum    <= sum + ($unsigned(i_x) * $unsigned(i_y));
        end
        else begin
            sum <= sum;
            reg_x  <= reg_x;
            reg_y  <= reg_y;
        end
    end
    assign result  =  sum  ;
    assign o_x     =  reg_x;
    assign o_y     =  reg_y;
endmodule