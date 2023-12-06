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
    assert 4361 == Day3.total_parts_numbers(@example_input)
    assert 533_775 == Day3.total_parts_numbers(@solution_input)
  end
end
