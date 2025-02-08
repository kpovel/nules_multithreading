defmodule Lab3 do
  @list_len 1_000_000

  defp calculate_list_result(list) do
    Enum.reduce(list, fn curr, acc ->
      (curr + 2 + acc / 2 - 2) * 42 / 27 * 6 / 9
    end)
  end

  defp do_rec(list_parts) do
    TaskTimer.timer(fn ->
      Enum.map(list_parts, fn part ->
        Task.async(fn -> calculate_list_result(part) end)
      end)
      |> Task.await_many()
      |> Enum.sum()
    end)
  end

  defp rec(list, repeat_curr, repeat_n, split_curr, split_n) do
    IO.puts("Repeat: #{repeat_curr}, split: #{split_curr}")

    list_parts = Enum.chunk_every(list, trunc(@list_len / split_curr))

    if repeat_curr == repeat_n do
      if split_curr == split_n do
        time = do_rec(list_parts)
        DB.execute_sqlite_query("insert into results(array_len, split_n, execution_time_ns)
        values (#{@list_len}, #{split_curr}, #{time});")
      else
        time = do_rec(list_parts)
        DB.execute_sqlite_query("insert into results(array_len, split_n, execution_time_ns)
        values (#{@list_len}, #{split_curr}, #{time});")

        rec(list, 1, repeat_n, split_curr + 1, split_n)
      end
    else
      time = do_rec(list_parts)
      DB.execute_sqlite_query("insert into results(array_len, split_n, execution_time_ns)
        values (#{@list_len}, #{split_curr}, #{time});")

      rec(list, repeat_curr + 1, repeat_n, split_curr, split_n)
    end
  end

  def main() do
    DB.execute_sqlite_query("delete from results;")

    full_list = Enum.to_list(1..@list_len)
    rec(full_list, 1, 5, 1, 10_000)

    IO.puts("Done")
  end
end
