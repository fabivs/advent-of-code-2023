defmodule Day3 do
  import Helpers

  defmodule Part1 do
    def total_parts_numbers(input) do
      # 1st pass: save the coordinates of every symbol => %{0 => [], 1 => [3], ...}
      # Enrich the list with all the adjacent positions => %{0 => [[2, 3, 4]], 1 => [2, 3, 4], ...}
      valid_coords = input |> symbols_coords_from() |> all_valid_coords()

      # 2nd pass: look at every number and only take it if any of its coordinates are in valid_coords
      valid_numbers = all_valid_numbers(input, valid_coords)

      Enum.sum(valid_numbers)
    end

    defp symbols_coords_from(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map(fn {line, line_index} ->
        line_symbols_with_positions =
          line
          |> String.codepoints()
          |> Enum.with_index()
          |> Enum.filter(fn {char, _column_index} ->
            cond do
              is_codepoint_a_number?(char) -> nil
              char == "." -> nil
              true -> char
            end
          end)
          |> Enum.map(fn {_symbol, position} -> position end)

        {line_symbols_with_positions, line_index}
      end)
      |> Map.new(fn {line_positions, line_index} -> {line_index, line_positions} end)
    end

    defp all_valid_coords(line_to_symbols_positions_map) do
      Enum.reduce(
        line_to_symbols_positions_map,
        line_to_symbols_positions_map,
        fn {line_index, positions}, result_map ->
          case positions do
            [] ->
              result_map

            positions ->
              positions
              |> Enum.reduce(result_map, fn position, result_map ->
                result_map
                |> update_map_if_index_in_bounds(line_index - 1, fn valid_positions ->
                  valid_positions ++ [position - 1, position, position + 1]
                end)
                |> update_map_if_index_in_bounds(line_index, fn valid_positions ->
                  valid_positions ++ [position - 1, position + 1]
                end)
                |> update_map_if_index_in_bounds(line_index + 1, fn valid_positions ->
                  valid_positions ++ [position - 1, position, position + 1]
                end)
              end)
          end
        end
      )
    end

    defp update_map_if_index_in_bounds(map, index, update_function) do
      Map.update(map, index, map, update_function)
    end

    defp all_valid_numbers(input, symbols_coords) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map(fn {line, line_index} ->
        valid_positions_for_line = Map.get(symbols_coords, line_index)

        # find every number in the line, and its corresponding list of coords
        # Eg. numbers_with_positions = [{"467", [0, 1, 2]}, {"114", [5, 6, 7]}]
        numbers_with_positions =
          line
          |> String.codepoints()
          |> Enum.with_index()
          |> Enum.filter(fn {char, _column_index} ->
            cond do
              is_codepoint_a_number?(char) -> char
              char == "." -> nil
              true -> nil
            end
          end)
          |> Enum.map(fn {number, index} -> {number, [index]} end)
          |> merge_numbers_of_adjacent_positions()

        # cross check the positions with the ones of the symbols map
        valid_numbers =
          Enum.map(numbers_with_positions, fn {number, number_positions} ->
            if Enum.any?(number_positions, fn position ->
                 position in valid_positions_for_line
               end) do
              number
            else
              nil
            end
          end)

        # return only the numbers with the matching coordinates
        valid_numbers
      end)
      |> List.flatten()
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&String.to_integer/1)
    end

    defp merge_numbers_of_adjacent_positions(list_of_digit_and_position, current_list_index \\ 0)
    defp merge_numbers_of_adjacent_positions([], _), do: []

    # Eg. input: [{"4", [0]}, {"6", [1]}, {"7", [2]}, {"1", [5]}, {"1", [6]}, {"4", [7]}]
    # Eg. output: [{467, [0,1,2], {114, [5,6,7]}}]
    defp merge_numbers_of_adjacent_positions(list_of_digit_and_position, current_list_index) do
      {current_number_string, current_positions} =
        list_of_digit_and_position |> Enum.at(current_list_index)

      list_of_digit_and_position
      |> Enum.at(current_list_index + 1)
      |> case do
        nil ->
          list_of_digit_and_position

        {next_number_string, [next_position]} ->
          if next_position == Enum.max(current_positions) + 1 do
            merged_number = Enum.join([current_number_string, next_number_string])
            merged_positions = current_positions ++ [next_position]

            list_of_digit_and_position
            |> List.delete_at(current_list_index)
            |> List.delete_at(current_list_index)
            |> List.insert_at(current_list_index, {merged_number, merged_positions})
            |> merge_numbers_of_adjacent_positions(current_list_index)
          else
            merge_numbers_of_adjacent_positions(
              list_of_digit_and_position,
              current_list_index + 1
            )
          end
      end
    end
  end

  defmodule Part2 do
    def total_gear_ratios(input) do
      # Check only for * as valid symbols
      # Maybe do it with the recursion, one star at a time
      # For every star, do the same, but add the constraint of exactly 2 numbers
      # Recursion by keeping the current gear ratio, until there are no stars left
      0
    end
  end
end
