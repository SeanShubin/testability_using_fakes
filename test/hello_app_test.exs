defmodule HelloAppTest do
  use ExUnit.Case, async: true
  test "say hello to world" do
    Fake.with_file_io_system fn file, io, system ->
      # given
      file.set_file_contents("the-file.txt", "world")
      system.set_command_line_arguments(["the-file.txt"])
      system.set_times_in_microseconds([1000, 1234])

      # when
      HelloApp.main(file, io, system)

      # then
      actual = io.get_lines_emitted_to_console()
      expected = ["Hello, world!", "Took 234 microseconds"]
      assert expected == actual
    end
  end
end
