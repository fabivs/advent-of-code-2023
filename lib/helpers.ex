defmodule Helpers do
  @spec get_first_single_digit_number_in_string(binary()) :: binary()
  def get_first_single_digit_number_in_string(string) do
    string
    |> String.codepoints()
    |> Enum.find(&is_codepoint_a_number?/1)
  end

  def is_codepoint_a_number?(codepoint) do
    try do
      _ = String.to_integer(codepoint)
      true
    rescue
      _error -> false
    end
  end

  # Only update the map with the given function if the index is in bounds
  # otherwise return the map as is
  def update_map_if_index_in_bounds(map, index, update_function) do
    Map.update(map, index, map, update_function)
  end

  def enum_multiply(list_of_integers) do
    Enum.reduce(list_of_integers, 1, fn number, acc -> number * acc end)
  end
end
