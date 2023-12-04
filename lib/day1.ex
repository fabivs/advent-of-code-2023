defmodule Day1 do
  @moduledoc """
  https://adventofcode.com/2023/day/1
  """

  import Helpers

  @numbers %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def find_calibration_result(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      first_value =
        line
        |> String.codepoints()
        |> Enum.find(&is_codepoint_a_number?/1)

      last_value =
        line
        |> String.codepoints()
        |> Enum.reverse()
        |> Enum.find(&is_codepoint_a_number?/1)

      Enum.join([first_value, last_value]) |> String.to_integer()
    end)
    |> Enum.reduce(0, &Kernel.+(&1, &2))
  end

  def find_calibration_result_improved(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line -> first_and_last_numbers_of_string_as_number(line) end)
    |> Enum.reduce(0, &Kernel.+(&1, &2))
  end

  defp first_and_last_numbers_of_string_as_number(line) do
    numbers_as_text_patterns = Map.keys(@numbers)

    first_value =
      line
      |> String.replace(numbers_as_text_patterns, fn matching_pattern ->
        Map.get(@numbers, matching_pattern, matching_pattern)
      end)
      |> get_first_single_digit_number_in_string()

    reversed_line = String.reverse(line)
    reversed_numbers_as_patterns = Enum.map(numbers_as_text_patterns, &String.reverse/1)

    last_value =
      reversed_line
      |> String.replace(reversed_numbers_as_patterns, fn matching_pattern ->
        restored_pattern = String.reverse(matching_pattern)
        Map.get(@numbers, restored_pattern, matching_pattern)
      end)
      |> get_first_single_digit_number_in_string()
      |> String.reverse()

    Enum.join([first_value, last_value]) |> String.to_integer()
  end
end
