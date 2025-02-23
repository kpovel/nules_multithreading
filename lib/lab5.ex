defmodule Lab5 do
  @remote :node2@nules

  def main() do
    IO.inspect(task(), label: "my machine")

    true = Node.connect(@remote)
    remote_machine = :rpc.call(@remote, Lab5, :task, [])

    IO.inspect(remote_machine, label: "remote machine")
  end

  def task() do
    matrix = Eigenvalue.random_matrix(5_000)

    TaskTimer.timer(fn ->
      {_eigenvector, _eigenvalue} = Eigenvalue.power_iteration(matrix)
    end)
  end
end
