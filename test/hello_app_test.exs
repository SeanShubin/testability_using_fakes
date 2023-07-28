defmodule HelloAppTest do
  use ExUnit.Case, async: true
  test "say hello to world" do
    Fake.with_file_io_system fn file, io, system ->
      file.set_content("the-file.txt", "world")
      system.set_argv(["the-file.txt"])
      system.set_monotonic_times([1000, 1234])
      HelloApp.main(file, io, system)
      actual = io.get_lines()
      expected = ["Hello, world!", "Took 234 microseconds"]
      assert expected == actual
    end
  end
end
