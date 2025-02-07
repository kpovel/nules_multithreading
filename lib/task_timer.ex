defmodule TaskTimer do
  def timer(task_fun) do
    start_time = System.monotonic_time()
    task_fun.()
    end_time = System.monotonic_time()

    end_time - start_time
  end
end
