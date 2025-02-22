defmodule Lab6 do
  def print(foo) do
    IO.puts(foo)
  end
end

defmodule Eigenvalue do
  defp generate_matrix(size) do
    Enum.map(1..size, fn _ ->
      Enum.map(1..size, fn _ ->
        :rand.uniform(10)
      end)
    end)
  end

  defp matrix_vector_multiply(matrix, vector) do
    Enum.map(matrix, fn row ->
      Enum.zip(row, vector)
      |> Enum.map(fn {a, b} -> a * b end)
      |> Enum.sum()
    end)
  end

  defp normalize_vector(vector) do
    norm =
      vector
      |> Enum.map(fn x -> x * x end)
      |> Enum.sum()
      |> :math.sqrt()

    Enum.map(vector, fn x -> x / norm end)
  end

  defp power_method(matrix, initial_vector, iterations \\ 1000) do
    vector = initial_vector

    Enum.reduce(1..iterations, vector, fn _, acc ->
      new_vector = matrix_vector_multiply(matrix, acc)
      normalize_vector(new_vector)
    end)
  end

  defp dominant_eigenvalue(matrix, eigenvector) do
    product = matrix_vector_multiply(matrix, eigenvector)

    sum =
      Enum.zip(product, eigenvector)
      |> Enum.map(fn {a, b} -> a / b end)
      |> Enum.sum()

    sum / length(eigenvector)
  end

  def main() do
    size = 5
    matrix = generate_matrix(size) |> IO.inspect(label: "matrix")

    initial_vector = Enum.map(1..size, fn _ -> 1.0 end)
    eigenvector = power_method(matrix, initial_vector)
    eigenvalue = dominant_eigenvalue(matrix, eigenvector)

    IO.inspect(eigenvector, label: "Eigenvector")
    IO.inspect(eigenvalue, label: "Dominant Eigenvalue")
  end
end
