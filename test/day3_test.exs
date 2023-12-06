defmodule Day3Test do
  use ExUnit.Case

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

  @solution_input File.read!("day3_input")

  test "part 1" do
    assert 4361 == Day3.Part1.total_parts_numbers(@example_input)
    assert 533_775 == Day3.Part1.total_parts_numbers(@solution_input)
  end

  test "part 2" do
    assert 467_835 == Day3.Part2.total_gear_ratios(@example_input)
    assert 78_236_071 == Day3.Part2.total_gear_ratios(@solution_input)
  end
end
