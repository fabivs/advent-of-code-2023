defmodule Day4 do
  defmodule Part1 do
    def total_score(input) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.reduce(0, fn input_line, acc ->
        card_score_of(input_line) + acc
      end)
    end

    def card_score_of(input_line) do
      [_card, numbers] = String.split(input_line, ":")

      [winning_numbers, player_numbers] =
        numbers
        |> String.split("|")
        |> Enum.map(fn set_of_numbers ->
          set_of_numbers |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
        end)

      _line_score =
        Enum.reduce(winning_numbers, 0, fn winning_number, acc ->
          if Enum.find(player_numbers, fn player_number -> player_number == winning_number end) do
            increase_accumulator(acc)
          else
            acc
          end
        end)
    end

    defp increase_accumulator(0), do: 1
    defp increase_accumulator(acc), do: acc * 2
  end

  defmodule Part2 do
    def final_number_of_scratchcards(input) do
      # [{1, 4}, {2, 2}, {3, 2}, {4, 1}, {5, 0}, {6, 0}]
      card_with_matches_list =
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(fn input_line ->
          card_number = card_number_of_line(input_line)
          card_matches = number_of_matches_in_card(input_line)
          {card_number, card_matches}
        end)
        |> Enum.sort_by(fn {key, _val} -> key end)

      # [{1, 1}, {2, 1}, {3, 1}, {4, 1}, {5, 1}, {6, 1}]
      cards_with_amount_list =
        card_with_matches_list
        |> Enum.map(fn {key, _value} -> {key, 1} end)
        |> Enum.sort_by(fn {key, _val} -> key end)

      # Terrible hack: we have to use lists instead of maps to preserve the order of the cards

      final_cards_to_amounts =
        for {card_num, card_matches} <- card_with_matches_list,
            card_matches > 0,
            reduce: cards_with_amount_list do
          cards_with_amount_list ->
            amount_of_current_card = Map.get(Map.new(cards_with_amount_list), card_num, 0)

            for card_num_to_update <- (card_num + 1)..(card_num + card_matches),
                reduce: cards_with_amount_list do
              cards_with_amount_list ->
                Enum.map(cards_with_amount_list, fn {card_num, amount} ->
                  if card_num == card_num_to_update,
                  # each card amount increases by 1 times the amount of the current card we are evaluating
                    do: {card_num_to_update, Kernel.+(amount, amount_of_current_card)},
                    else: {card_num, amount}
                end)
            end
        end

      Enum.reduce(final_cards_to_amounts, 0, fn {_card_num, amount}, acc -> amount + acc end)
    end

    def card_number_of_line(input_line) do
      [_, card_number_str, _] = String.split(input_line, [" ", ":"], parts: 3, trim: true)
      String.to_integer(card_number_str)
    end

    def number_of_matches_in_card(input_line) do
      [_card, numbers] = String.split(input_line, ":")

      [winning_numbers, player_numbers] =
        numbers
        |> String.split("|")
        |> Enum.map(fn set_of_numbers ->
          set_of_numbers |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
        end)

      _line_score =
        Enum.reduce(winning_numbers, 0, fn winning_number, acc ->
          if Enum.find(player_numbers, fn player_number -> player_number == winning_number end) do
            acc + 1
          else
            acc
          end
        end)
    end
  end
end
