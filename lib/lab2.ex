defmodule Lab2 do
  defp calculate_list_result(list) do
    Enum.reduce(list, fn curr, acc ->
      (curr + 2 + acc / 2 - 2) * 42 / 27 * 6 / 9
    end)
  end

  defp rec(list, list_parts, curr, n) do
    linear =
      TaskTimer.timer(fn ->
        calculate_list_result(list)
      end)

    parallel =
      TaskTimer.timer(fn ->
        Enum.map(list_parts, fn part ->
          Task.async(fn -> calculate_list_result(part) end)
        end)
        |> Task.await_many()
        |> Enum.sum()
      end)

    if curr == n do
      [{linear, parallel}]
    else
      [{linear, parallel} | rec(list, list_parts, curr + 1, n)]
    end
  end

  def main(list_len, split_n) do
    full_list = Enum.to_list(1..list_len)
    split_list = Enum.chunk_every(full_list, trunc(list_len / split_n))

    results = rec(full_list, split_list, 1, 10)

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
