# mix run -e HelloApp.main -- greeting-target.txt
defmodule HelloApp do
  def main(file \\ File, io \\ IO, system \\ System) do
    time_unit = :microsecond
    microseconds_before = system.monotonic_time time_unit
    target = system.argv |> List.first |> file.read!
    io.puts "Hello, #{target}!"
    microseconds_after = system.monotonic_time time_unit
    microseconds_duration = microseconds_after - microseconds_before
    io.puts "Took #{microseconds_duration} microseconds"
  end
end
