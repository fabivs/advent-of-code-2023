defmodule Day3Test do
  use ExUnit.Case, async: false

  @example_input """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  @solution_input File.read!("inputs/day3_input")

  test "part 1" do
    # Example
    assert 4361 == Day3.Part1.total_parts_numbers(@example_input)
    # Solution
    Day3.Part1.total_parts_numbers(@solution_input) |> IO.inspect(label: "Day 3, part 1 solution")
  end

  test "part 2" do
    # Example
    assert 467_835 == Day3.Part2.total_gear_ratios(@example_input)
    # Solution
    Day3.Part2.total_gear_ratios(@solution_input) |> IO.inspect(label: "Day 3, part 2 solution")
  end
end
