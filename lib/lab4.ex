defmodule Lab4 do
  def main() do
    matrix = Eigenvalue.random_matrix(1_000)

    TaskTimer.timer(fn ->
      {_eigenvector, _eigenvalue} = Eigenvalue.power_iteration(matrix)
    end)
  end
end
