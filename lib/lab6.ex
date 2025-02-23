defmodule Lab6 do
  @remote :node2@nules

  def main() do
    {time1, l1} = task()
    IO.puts("L1 time: #{time1}")
    IO.puts("L1 value: #{l1}")

    true = Node.connect(@remote)
    {time2, l2} = :rpc.call(@remote, Lab6, :task, [])
    IO.puts("L2 time: #{time2}")
    IO.puts("L2 value: #{l2}")

    l3 = calculate_l3(l1, l2)

    IO.puts("L3 value: #{l3}")
  end

  def calculate_l3(l1, l2) do
    if l1 > l2 do
      l1 * l1 * l2
    else
      l1 * (l2 * l2)
    end
  end

  def task() do
    matrix = Eigenvalue.random_matrix(3_000)

    TaskTimer.timer(fn ->
      Eigenvalue.power_iteration(matrix)
    end)
  end
end
