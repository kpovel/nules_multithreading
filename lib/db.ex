defmodule DB do
  def execute_sqlite_query(query) do
    String.to_charlist("echo '#{query}' | sqlite3 lib/lab3_results.db")
    |> :os.cmd()
  end
end
