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
end
