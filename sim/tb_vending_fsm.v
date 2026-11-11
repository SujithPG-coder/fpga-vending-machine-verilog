`timescale 1ns / 1ps
//==============================================================================
// Project : FPGA Based Vending Machine (Basys3, Xilinx Artix-7)
// File    : tb_vending_fsm.v
// Brief   : Self-checking testbench for the vending machine FSM (NSL).
//           Reproduces the four scenarios documented in the project report:
//             1. Exact payment      -> Dispense state (011)
//             2. Over-payment       -> Change state   (100)
//             3. Cancel transaction -> Refund state   (101)
//             4. Empty product      -> No Stock state (110)
//           Run: iverilog -o vend_tb sim/tb_vending_fsm.v rtl/NSL.v && vvp vend_tb
//==============================================================================
module tb_vending_fsm;

    // State encoding (must match NSL.v)
    localparam RESET = 3'd0, PROD_SEL = 3'd1, AMT_SEL = 3'd2, DISP = 3'd3,
               CHNG  = 3'd4, REFUND   = 3'd5, STOCK   = 3'd6;

    reg        clk = 1'b0;
    reg        btn = 1'b0, refnd = 1'b0;
    reg  [3:0] key = 4'h0;
    wire       dispense, led_reset;
    wire [2:0] ps;
    wire [3:0] change, E_quantity, CurrProd, CurrPrice, money;

    integer errors = 0;

    NSL dut (
        .clk_1ms(clk), .clk_1s(clk), .LED(key), .btn(btn), .refnd(refnd),
        .dispense(dispense), .change(change), .led_reset(led_reset), .ps(ps),
        .CurrProd(CurrProd), .CurrPrice(CurrPrice), .money(money), .E_quantity(E_quantity)
    );

    always #10 clk = ~clk;

    // Press a key for exactly one FSM clock, then release it
    task press(input [3:0] k);
        begin
            @(negedge clk) key = k;
            @(negedge clk) key = 4'h0;
        end
    endtask

    task idle(input integer n);
        repeat (n) @(negedge clk);
    endtask

    // Return to Reset with the btn switch
    task new_transaction;
        begin
            @(negedge clk) btn = 1'b1;
            idle(3);
            @(negedge clk) btn = 1'b0;
            idle(3);
        end
    endtask

    task check(input [8*64-1:0] name, input cond);
        begin
            if (cond) $display("  [PASS] %0s", name);
            else begin
                $display("  [FAIL] %0s  (ps=%0d money=%0d price=%0d change=%0d dispense=%b)",
                         name, ps, money, CurrPrice, change, dispense);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("vending_fsm.vcd");
        $dumpvars(0, tb_vending_fsm);

        idle(4);
        check("Power-up enters Reset state", ps == RESET);

        // ---------------- Scenario 1: Product C ($9), pay $5+$2+$2 ----------------
        $display("Scenario 1: Product C ($9), insert $5 + $2 + $2");
        press(4'hC); idle(2);
        check("Product C selected, price = 9", ps == PROD_SEL && CurrPrice == 4'd9);
        press(4'h5); idle(1);
        press(4'h2); idle(1);
        press(4'h2); idle(4);
        check("Exact payment -> Dispense state (011)", ps == DISP && dispense == 1'b1);
        new_transaction;
        check("Back to Reset after btn", ps == RESET);

        // ---------------- Scenario 2: Product A ($6), pay $9 ----------------
        $display("Scenario 2: Product A ($6), insert $2 + $2 + $5 = $9");
        press(4'hA); idle(2);
        press(4'h2); idle(1);
        press(4'h2); idle(1);
        press(4'h5); idle(6);
        check("Over-payment -> Change state (100)", ps == CHNG);
        check("Change returned = $3", change == 4'd3);
        new_transaction;

        // ---------------- Scenario 3: Product D ($4), pay $2 then cancel ----------------
        $display("Scenario 3: Product D ($4), insert $2 then cancel");
        press(4'hD); idle(2);
        press(4'h2); idle(2);
        @(negedge clk) refnd = 1'b1;
        idle(3);
        @(negedge clk) refnd = 1'b0;
        idle(2);
        check("Cancel -> Refund state (101)", ps == REFUND);
        check("Refund amount = $2", change == 4'd2);
        new_transaction;

        // ---------------- Scenario 4: Product E (out of stock) ----------------
        $display("Scenario 4: Product E (stock = 0)");
        press(4'hE); idle(3);
        check("Empty product -> No Stock state (110)", ps == STOCK);
        new_transaction;

        // ---------------- Scenario 5: Product C again (last unit was sold) ----------------
        $display("Scenario 5: Product C again (sold out in scenario 1)");
        press(4'hC); idle(3);
        check("Stock decremented -> C now No Stock", ps == STOCK);
        new_transaction;

        $display("--------------------------------------------");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule
