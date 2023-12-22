defmodule Day5Test do
  use ExUnit.Case, async: false

  @example_input """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  @solution_input File.read!("inputs/day5_input")

  test "part 1" do
    # Example
    assert 35 == Day5.Part1.calculate_solution(@example_input)
    # Solution
    Day5.Part1.calculate_solution(@solution_input) |> IO.inspect(label: "Day 5, part 1 solution")
  end

  # test "part 2" do
  #   # Example
  #   assert 30 == Day5.Part2.calculate_solution(@example_input)
  #   # Solution
  #   Day5.Part2.calculate_solution(@solution_input)
  #   |> IO.inspect(label: "Day 5, part 2 solution")
  # end
end
