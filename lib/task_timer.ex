defmodule TaskTimer do
  def timer(task_fun) do
    start_time = System.monotonic_time()
    value = task_fun.()
    end_time = System.monotonic_time()

    {trunc((end_time - start_time) / 1_000_000), value}
  end
end
