defmodule Eigenvalue do
  def power_iteration(matrix, iterations \\ 1000, tolerance \\ 0.000001) do
    n = length(matrix)
    x = Enum.map(1..n, fn _ -> :rand.uniform() end) |> normalize()

    {_eigenvector, value} =
      Enum.reduce_while(1..iterations, {x, 0}, fn _, {x_k, eigenvalue_k} ->
        x_k1 = matrix_vector_multiply(matrix, x_k) |> normalize()
        eigenvalue_k1 = dot_product(x_k1, matrix_vector_multiply(matrix, x_k1))

        case abs(eigenvalue_k1 - eigenvalue_k) do
          value when value < tolerance -> {:halt, {x_k1, eigenvalue_k1}}
          _ -> {:cont, {x_k1, eigenvalue_k1}}
        end
      end)

    value
  end

  def matrix_vector_multiply(matrix, vector) do
    Enum.map(matrix, fn row -> dot_product(row, vector) end)
  end

  def dot_product(vector1, vector2) do
    Enum.zip(vector1, vector2)
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  def normalize(vector) do
    norm =
      vector
      |> Enum.map(fn x -> x * x end)
      |> Enum.sum()
      |> :math.sqrt()

    Enum.map(vector, fn x -> x / norm end)
  end

  def random_matrix(n) do
    Enum.map(1..n, fn _ ->
      Enum.map(1..n, fn _ ->
        trunc(:rand.uniform() * 20)
      end)
    end)
  end
end
