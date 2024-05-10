module systolic #(
    parameter N     = 4,
    parameter WIDTH = 4
) (
    input  logic clk , rst_n,start,
    input  logic [WIDTH - 1 : 0]  array[1 : 0] [N - 1 : 0], 
    output logic [WIDTH - 1 : 0]  Data [N - 1 : 0][N - 1 : 0] ,
    output logic finish
);
logic en , enable;
logic [WIDTH -1 : 0] conect [N - 1 : 0][N - 1 : 0][2];
localparam ittr =  N * N;
integer count;
assign en = start | enable ;
always@(posedge clk , negedge rst_n) begin
        if(!rst_n) begin
            finish <= 0;
            enable     <= 0;
            count  <= 0;
        end
        else if(start)
            enable     <= 1;
        else begin
            count  <= count + 1;
            if(count == ittr) begin
                finish <= 1;
                enable     <= 0;
            end
        end
end
genvar i , j;
generate
    for(i = 0 ; i < N ; i = i + 1) begin
        if( (i == 0)) begin
            block#(.WIDTH(WIDTH))
            b0(.clk(clk),.rst_n(rst_n),.en(en),.i_x(array[0][0]),.i_y(array[1][0]),.o_x(conect[0][0][0]),.o_y(conect[0][0][1]),.result(Data[0][0]));
            for(j = 1 ; j <= N - 1 ; j = j + 1) begin
            block#(.WIDTH(WIDTH))
            b1(.clk(clk),.rst_n(rst_n),.en(en),.i_x(array[0][j]),.i_y(conect[j-1][0][1]),.o_x(conect[j][0][0]),.o_y(conect[j][0][1]),.result(Data[j][0]));
            end
            for(j = 1 ; j <= N - 1 ; j = j + 1) begin
            block#(.WIDTH(WIDTH))
            b2(.clk(clk),.rst_n(rst_n),.en(en),.i_x(conect[0][j-1][0]),.i_y(array[1][j]),.o_x(conect[0][j][0]),.o_y(conect[0][j][1]),.result(Data[0][j]));
            end
        end
        else begin
            for(j = i ; j <= N - 1 ; j = j + 1) begin
            block#(.WIDTH(WIDTH))
            b3(.clk(clk),.rst_n(rst_n),.en(en),.i_x(conect[j][i-1][0]),.i_y(conect[j-1][i][1]),.o_x(conect[j][i][0]),.o_y(conect[j][i][1]),.result(Data[j][i]));
            end
            for(j = i + 1 ; j <= N - 1 ; j = j + 1) begin
            block#(.WIDTH(WIDTH))
            b4(.clk(clk),.rst_n(rst_n),.en(en),.i_x(conect[i][j-1][0]),.i_y(conect[i-1][j][1]),.o_x(conect[i][j][0]),.o_y(conect[i][j][1]),.result(Data[i][j]));
            end
        end
    end
endgenerate
endmodule