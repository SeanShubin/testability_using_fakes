defmodule Fake do
  def with_io(f) do
    id = System.unique_integer([:positive])

    {_, io, _, _} = defmodule String.to_atom("IOFake#{id}") do
      use IOFake
    end

    io.start()
    result = f.(io)
    io.stop()
    result
  end

  def with_file(f) do
    id = System.unique_integer([:positive])

    {_, file, _, _} = defmodule String.to_atom("FileFake#{id}") do
      use FileFake
    end

    file.start()
    result = f.(file)
    file.stop()
    result
  end

  def with_system(f) do
    id = System.unique_integer([:positive])

    {_, system, _, _} = defmodule String.to_atom("SystemFake#{id}") do
      use SystemFake
    end

    system.start()
    result = f.(system)
    system.stop()
    result
  end

  def with_file_io_system(f) do
    with_file fn file ->
      with_io fn io ->
        with_system fn system ->
          f.(file, io, system)
        end
      end
    end
  end
end
