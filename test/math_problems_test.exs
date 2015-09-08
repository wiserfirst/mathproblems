defmodule MathProblemsTest do
  use ExUnit.Case
  import MathProblems

  @default_count 10
  @limit 100
  @blank "___"

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "generate random integer between 1 and limit" do
    assert is_valid_operand(gen_random_int(@limit))
  end

  defp is_valid_operand(number), do: is_integer(number) and number >= 1 and number <= @limit
  defp is_valid_operator(operator), do: operator == :+ or operator == :-

  test "generate random operators :+ or :-" do
    assert is_valid_operator(gen_operator())
  end

  defp is_valid_problem([op1, :+, @blank, :=, result]) do
    assert result >= op1
    assert is_valid_operand(op1) and is_valid_operand(result)
  end
  defp is_valid_problem([@blank, :+, op2, :=, result]) do
    assert result >= op2
    assert is_valid_operand(op2) and is_valid_operand(result)
  end
  defp is_valid_problem([op1, :+, op2, :=, @blank]) do
    assert is_valid_operand(op1) and is_valid_operand(op2)
  end

  defp is_valid_problem([op1, :-, @blank, :=, result]) do
    assert op1 >= result
    assert is_valid_operand(op1) and is_valid_operand(result)
  end
  defp is_valid_problem([@blank, :-, op2, :=, result]) do
    assert is_valid_operand(op2) and is_valid_operand(result)
  end
  defp is_valid_problem([op1, :-, op2, :=, @blank]) do
    assert op1 >= op2
    assert is_valid_operand(op1) and is_valid_operand(op2)
  end

  test "generate valid math problem" do
    :random.seed(:os.timestamp)
    is_valid_problem(gen_math_problem(@limit))
  end

  test "parse argv correctly" do
    # :help
    assert parse_args(["something", "random", "-h"]) == :help
    assert parse_args(["another", "random", "thing", "--help"]) == :help

    # only count
    assert parse_args(["--count", "5"]) == {5, @limit}
    assert parse_args(["-c", "6"]) == {6, @limit}

    # only limit
    assert parse_args(["--limit", "50"]) == {@default_count, 50}
    assert parse_args(["-l", "200"]) == {@default_count, 200}

    # both count and limit
    assert parse_args(["--count", "5", "--limit", "50"]) == {5, 50}
    assert parse_args(["--limit", "120", "--count", "7"]) == {7, 120}
    assert parse_args(["-c", "4", "-l", "70"]) == {4, 70}
  end
end
