defmodule Day1Test do
  use ExUnit.Case

  test "compute the calibration number" do
    example_input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    # Example
    example_result = 142
    assert example_result == Day1.find_calibration_result(example_input)

    # Solution
    solution_input = File.read!("inputs/day1_input")
    solution_result = 54968
    assert solution_result == Day1.find_calibration_result(solution_input)
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
    example_result = 281
    assert example_result == Day1.find_calibration_result_improved(example_input)

    # Solution
    solution_input = File.read!("inputs/day1_input")
    solution_result = 54094
    assert solution_result == Day1.find_calibration_result_improved(solution_input)
  end
end
