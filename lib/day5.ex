defmodule Day5 do
  defmodule Part1 do
    def calculate_solution(input) do
      [seeds_str, rest_of_input] = String.split(input, "\n", parts: 2, trim: true)

      seeds =
        Regex.scan(~r/\d+/, seeds_str)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)

      conversion_maps =
        rest_of_input
        |> String.split("\n\n")
        # "\nseed-to-soil map:\n50 98 2\n52 50 48"
        |> Enum.map(fn map_str ->
          Regex.scan(~r/(?:^\d+\s\d+\s\d+$)/m, map_str)
          |> List.flatten()
          # ["50 98 2", "52 50 48"]
          |> Enum.map(fn line ->
            [dest_start, src_start, range] =
              line |> String.split(" ") |> Enum.map(&String.to_integer/1)

            %{dest_start: dest_start, src_start: src_start, range: range}
          end)
        end)

      # For every seed, do the whole run through the maps
      locations =
        for seed <- seeds, reduce: [] do
          result_locations ->
            final_seed_location =
              for conversion_map <- conversion_maps, reduce: seed do
                current_val ->
                  # for each seed -> if the seed is in (src_start..src_start+range), then the new value will be
                  #   the corresponding dest_start + offset = dest_start + (seed - src_start) = seed + dest_start - src_start
                  Enum.reduce_while(
                    conversion_map,
                    current_val,
                    fn %{
                         range: range,
                         dest_start: dest_start,
                         src_start: src_start
                       },
                       current_val ->
                      if current_val in src_start..(src_start + range) do
                        {:halt, current_val + dest_start - src_start}
                      else
                        {:cont, current_val}
                      end
                    end
                  )
              end

            result_locations ++ [final_seed_location]
        end

      Enum.min(locations)
    end
  end

  defmodule Part2 do
  end
end
