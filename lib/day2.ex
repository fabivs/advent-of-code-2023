defmodule Day2 do
  @moduledoc """
  https://adventofcode.com/2023/day/2
  """

  defmodule Part1 do
    @spec id_sum_of_possible_games(binary(), map()) :: integer()
    def id_sum_of_possible_games(results, bag) do
      possible_games(results, bag)
      |> Enum.reduce(0, fn {game_id, possible?}, acc ->
        if possible? do
          acc + game_id
        else
          acc
        end
      end)
    end

    @spec possible_games(binary(), map()) :: [{binary(), boolean()}]
    defp possible_games(results, %{} = bag) do
      colors = bag |> Map.keys() |> Enum.map(&Atom.to_string/1)

      results
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn game ->
        id = game_id(game)

        results_per_color =
          Enum.map(colors, fn color ->
            {color, results_for_color(game, color)}
          end)
          |> Map.new()

        # check every value against the bag
        each_color_possible? =
          Enum.map(colors, fn color ->
            color_atom = String.to_existing_atom(color)
            max = Map.get(bag, color_atom)

            results_per_color
            |> Map.get(color)
            |> Enum.reduce(true, fn amount, acc -> amount <= max and acc end)
          end)

        # return game id and true or false
        {id, Enum.reduce(each_color_possible?, true, fn value, acc -> value and acc end)}
      end)
    end

    defp game_id(game), do: get_game_id_in_string(game)

    defp get_game_id_in_string(game_string) do
      game_title = game_string |> String.split(":") |> List.first()
      [_, id_string] = game_title |> String.split(" ")
      String.to_integer(id_string)
    end

    @spec results_for_color(binary(), binary()) :: [integer()]
    def results_for_color(game, color) do
      [_game_info, results] = String.split(game, ":")

      results
      |> String.split(";")
      |> Enum.map(fn single_extraction ->
        single_extraction
        |> String.split(",")
        |> Enum.find(&String.contains?(&1, color))
        |> case do
          nil -> 0
          string -> get_initial_number_in_string(string)
        end
      end)
    end

    # Eg. " 20 red"
    defp get_initial_number_in_string(string) do
      [number, _color] = string |> String.trim() |> String.split(" ")
      String.to_integer(number)
    end
  end

  defmodule Part2 do
    import Part1

    @spec sum_of_power_of_games(binary()) :: integer()
    def sum_of_power_of_games(results) do
      results
      |> String.trim()
      |> String.split("\n")
      # NOTE: game == line
      |> Enum.map(fn game ->
        game
        |> game_results_per_color()
        |> min_bag_size()
        |> power_of_game()
      end)
      |> Enum.sum()
    end

    @spec game_results_per_color(binary()) :: %{binary() => integer()}
    defp game_results_per_color(game) do
      colors = ["red", "green", "blue"]

      Enum.map(colors, fn color ->
        {color, results_for_color(game, color)}
      end)
      |> Map.new()
    end

    defp min_bag_size(%{} = game_results_per_color) do
      Enum.map(game_results_per_color, fn {color, values} ->
        {color, Enum.max(values)}
      end)
      |> Map.new()
    end

    defp power_of_game(%{} = min_bag_size) do
      Enum.reduce(min_bag_size, 1, fn {_color, amount_for_color}, acc ->
        amount_for_color * acc
      end)
    end
  end
end
