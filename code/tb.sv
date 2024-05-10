module tb ();
    localparam N     = 2;
    localparam WIDTH = 4;
    logic clk , rst_n,start;
    logic [WIDTH - 1 : 0]  array[1 : 0][N - 1 : 0];
    logic [WIDTH - 1 : 0]  Data [N - 1 : 0][N - 1 : 0];
    logic finish;
    logic [WIDTH - 1 : 0]  matrix_1[N * N - 1 : 0][N * N - 1 : 0];
    logic [WIDTH - 1 : 0]  matrix_2[N * N - 1 : 0][N * N - 1 : 0];
    always  
        #10 clk = ~clk;
    initial begin
        reset();
        load_data();
        print_data();
        $stop();
    end
    systolic #(
    .N(N),
    .WIDTH(WIDTH)
)
b1
( 
    .*
);
task automatic reset();
    rst_n = 0;
    clk   = 0;
    @(negedge clk)
        rst_n = 1;
endtask

task automatic load_data();
    @(negedge clk)
    array[0][0] = 2 ;
    array[0][1] = 0 ;
    array[1][0] = 2 ;
    array[1][1] = 0 ;
    start       = 1 ;
    @(negedge clk)
    array[0][0] = 4 ;
    array[0][1] = 1 ;
    array[1][0] = 1 ;
    array[1][1] = 1 ;
    start       = 0 ;
    @(negedge clk)
    array[0][0] = 0 ;
    array[0][1] = 3 ;
    array[1][0] = 0 ;
    array[1][1] = 1 ;
    while(!finish) begin
        @(negedge clk)
        array[0][0] = 0 ;
        array[1][0] = 0 ;
        array[0][1] = 0 ;
        array[1][1] = 0 ;
    end
endtask
task automatic print_data();
    for(int i = 0 ; i < N ; i = i + 1) begin
        for(int j = 0 ; j < N ; j = j + 1) begin
            $display("matrix [%0d][%0d] = %0d",i,j,Data[i][j]);
        end
    end

endtask
endmodule