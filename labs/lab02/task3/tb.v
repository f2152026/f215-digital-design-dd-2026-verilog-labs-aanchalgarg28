module tb;

  reg  [1:0] t_a;
  reg  [1:0] t_b;

  wire t_gt;
  wire t_lt;
  wire t_eq;

  reg exp_gt;
  reg exp_lt;
  reg exp_eq;

  integer errors;
  integer total;
  integer i;
  integer j;

  comp2 U1 (
    .A(t_a),
    .B(t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
  );

  initial begin

    errors = 0;
    total = 0;

    // Test all 16 possible input combinations
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin

        t_a = i;
        t_b = j;

        // Independently calculate expected outputs
        if (i > j) begin
          exp_gt = 1;
          exp_lt = 0;
          exp_eq = 0;
        end
        else if (i < j) begin
          exp_gt = 0;
          exp_lt = 1;
          exp_eq = 0;
        end
        else begin
          exp_gt = 0;
          exp_lt = 0;
          exp_eq = 1;
        end

        #1;

        total = total + 1;

        // Compare actual outputs with expected outputs
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin

          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b,
                   t_gt, t_lt, t_eq,
                   exp_gt, exp_lt, exp_eq);

          errors = errors + 1;

        end
        else begin

          $display("PASS: A=%b B=%b  GT=%b LT=%b EQ=%b",
                   t_a, t_b, t_gt, t_lt, t_eq);

        end

      end
    end

    // Final summary
    $write("\nSUMMARY: %0d passed out of %0d tests, %0d failed\n",
           total - errors, total, errors);

    $finish;

  end

endmodule