defmodule Lab1 do
  @array_len 300_000
  @list Enum.to_list(1..@array_len)
  @full_array :array.from_list(@list)
  @split_list Enum.chunk_every(@list, trunc(@array_len / 3))
  @split_array Enum.map(@split_list, fn list -> :array.from_list(list) end)

  defp calculate_list_result(arr) do
    :array.foldl(
      fn _idx, curr, acc ->
        curr + acc
      end,
      0,
      arr
    )
  end

  defp rec(arr, arr_parts, curr, n) do
    linear =
      TaskTimer.timer(fn ->
        calculate_list_result(arr)
      end)

    parallel =
      TaskTimer.timer(fn ->
        Enum.map(arr_parts, fn part ->
          Task.async(fn -> calculate_list_result(part) end)
        end)
        |> Task.await_many()
        |> Enum.sum()
      end)

    if curr == n do
      [{linear, parallel}]
    else
      [{linear, parallel} | rec(arr, arr_parts, curr + 1, n)]
    end
  end

  def main() do
    results = rec(@full_array, @split_array, 1, 10)

    {linear_sum, parallel_sum} =
      results
      |> Stream.map(fn {linear, parallel} = res ->
        IO.puts("Single threaded: #{linear}, Parallel: #{parallel}")
        res
      end)
      |> Enum.reduce(fn {linear, parallel}, {linear_acc, parallel_acc} ->
        {linear_acc + linear, parallel_acc + parallel}
      end)

    linear = linear_sum / Enum.count(results)
    parallel = parallel_sum / Enum.count(results)

    diff = trunc(linear - parallel)
    IO.puts("parallel > single threaded in: #{diff} ns")
  end
end
