module tb;

  reg [3:0] t_a;
  reg [3:0] t_b;
  reg       t_op;

  wire [3:0] t_result;

  integer errors;
  integer total;

  alu U1 (
    .a(t_a),
    .b(t_b),
    .op(t_op),
    .result(t_result)
  );

  // Test procedure
  task check;
    input [3:0] a_val;
    input [3:0] b_val;
    input       op_val;
    input [3:0] expected;

    begin
      t_a = a_val;
      t_b = b_val;
      t_op = op_val;

      #1;

      total = total + 1;

      if (t_result !== expected) begin
        $display("FAIL: a=%b b=%b op=%b | got=%b expected=%b",
                 t_a, t_b, t_op, t_result, expected);
        errors = errors + 1;
      end
      else begin
        $display("PASS: a=%b b=%b op=%b | result=%b",
                 t_a, t_b, t_op, t_result);
      end
    end
  endtask

  initial begin

    errors = 0;
    total = 0;

    // ADDITION tests: op = 0
    check(4'b0011, 4'b0010, 1'b0, 4'b0101); // 3 + 2 = 5
    check(4'b0101, 4'b0011, 1'b0, 4'b1000); // 5 + 3 = 8
    check(4'b1111, 4'b0001, 1'b0, 4'b0000); // 15 + 1 = 0 (4-bit)

    // SUBTRACTION tests: op = 1
    check(4'b0101, 4'b0010, 1'b1, 4'b0011); // 5 - 2 = 3
    check(4'b1001, 4'b0011, 1'b1, 4'b0110); // 9 - 3 = 6
    check(4'b0011, 4'b0101, 1'b1, 4'b1110); // 3 - 5 = -2 = 1110

    // Test changing OP while A and B stay the same
    t_a = 4'b0111;
    t_b = 4'b0010;
    t_op = 1'b0;
    #1;

    if (t_result !== 4'b1001) begin
      $display("FAIL: op=0 | a=%b b=%b | got=%b expected=1001",
               t_a, t_b, t_result);
      errors = errors + 1;
    end
    else begin
      $display("PASS: op=0 | a=%b b=%b | result=%b",
               t_a, t_b, t_result);
    end
    total = total + 1;

    // Now change ONLY op
    t_op = 1'b1;
    #1;

    if (t_result !== 4'b0101) begin
      $display("FAIL: op=1 | a=%b b=%b | got=%b expected=0101",
               t_a, t_b, t_result);
      errors = errors + 1;
    end
    else begin
      $display("PASS: op=1 | a=%b b=%b | result=%b",
               t_a, t_b, t_result);
    end
    total = total + 1;

    $display("--------------------------------");
    $display("SUMMARY: %0d passed out of %0d, %0d failed",
             total - errors, total, errors);

    $finish;

  end

endmodule