defmodule Day1Test do
  use ExUnit.Case, async: false

  @solution_input File.read!("inputs/day1_input")

  test "compute the calibration number" do
    example_input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    # Example
    assert 142 == Day1.find_calibration_result(example_input)
    # Solution
    Day1.find_calibration_result(@solution_input) |> IO.inspect(label: "Day 1, part 1 solution")
  end

  test "compute the calibration number with the improved version" do
    example_input = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    # Example
    assert 281 == Day1.find_calibration_result_improved(example_input)
    # Solution
    Day1.find_calibration_result_improved(@solution_input)
    |> IO.inspect(label: "Day 1, part 2 solution")
  end
end
