defmodule Day2Test do
  use ExUnit.Case, async: false

  @example_input """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """

  @solution_input File.read!("inputs/day2_input")

  test "find the possible games" do
    example_bag = %{
      red: 12,
      green: 13,
      blue: 14
    }

    # Example
    assert 8 == Day2.Part1.id_sum_of_possible_games(@example_input, example_bag)

    # Solution
    solution_bag = %{
      red: 12,
      green: 13,
      blue: 14
    }

    Day2.Part1.id_sum_of_possible_games(@solution_input, solution_bag)
    |> IO.inspect(label: "Day 2, part 1 solution")
  end

  test "find the combined power of all games" do
    # Example
    assert 2286 == Day2.Part2.sum_of_power_of_games(@example_input)

    # Solution
    Day2.Part2.sum_of_power_of_games(@solution_input)
    |> IO.inspect(label: "Day 2, part 2 solution")
  end
end
