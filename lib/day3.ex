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

    def all_valid_numbers(input, symbols_coords) do
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
    def total_gear_ratios(input, current_total \\ 0) do
      IO.inspect(current_total)
      # Check only for * as valid stars
      # Maybe do it with the recursion, one star at a time
      # For every star, do the same, but add the constraint of exactly 2 numbers
      # Recursion by keeping the current gear ratio, until there are no stars left
      case input |> filter_first_star() |> first_star_valid_coords() do
        nil ->
          current_total

        first_star_valid_coords ->
          valid_numbers = Part1.all_valid_numbers(input, first_star_valid_coords)

          if length(valid_numbers) == 2 do
            gear_ratio = enum_multiply(valid_numbers)
            total_gear_ratios(input |> reject_first_star(), current_total + gear_ratio)
          else
            total_gear_ratios(input |> reject_first_star(), current_total)
          end
      end
    end

    defp reject_first_star(input) do
      String.replace(input, "*", ".", global: false)
    end

    defp filter_first_star(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.map_reduce({%{}, false}, fn {line, line_index}, {result_map, star_found?} ->
        if star_found? do
          {{[], line_index}, {result_map, true}}
        else
          line_stars_positions =
            line
            |> String.codepoints()
            |> Enum.with_index()
            |> Enum.filter(fn {char, _column_index} -> char == "*" end)
            |> Enum.map(fn {_star, position} -> position end)

          if length(line_stars_positions) > 0 do
            {{[List.first(line_stars_positions)], line_index}, {result_map, true}}
          else
            {{line_stars_positions, line_index}, {result_map, false}}
          end
        end
      end)
      |> elem(0)
      |> Map.new(fn {positions, line_index} -> {line_index, positions} end)
    end

    defp first_star_valid_coords(line_to_stars_positions_map) do
      case Enum.find(line_to_stars_positions_map, nil, fn {_line_index, line_positions} ->
             length(line_positions) > 0
           end) do
        nil ->
          nil

        {star_index, stars_positions} ->
          first_star_position = List.first(stars_positions)

          Enum.reduce(
            line_to_stars_positions_map,
            line_to_stars_positions_map,
            fn {current_line_index, _current_line_positions}, result_map ->
              if current_line_index == star_index do
                result_map
                |> update_map_if_index_in_bounds(current_line_index - 1, fn valid_positions ->
                  valid_positions ++
                    [first_star_position - 1, first_star_position, first_star_position + 1]
                end)
                |> update_map_if_index_in_bounds(current_line_index, fn valid_positions ->
                  valid_positions ++ [first_star_position - 1, first_star_position + 1]
                end)
                |> update_map_if_index_in_bounds(current_line_index + 1, fn valid_positions ->
                  valid_positions ++
                    [first_star_position - 1, first_star_position, first_star_position + 1]
                end)
              else
                result_map
              end
            end
          )
      end
    end
  end
end
