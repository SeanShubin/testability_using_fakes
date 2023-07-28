defmodule IOFake do
  defmacro __using__(_) do
    quote do
      def loop(lines) do
        receive do
          {:get_lines, caller} ->
            send(caller, Enum.reverse(lines))
            loop(lines)
          {:puts, line} ->
            new_lines = [line | lines]
            loop(new_lines)
          {:stop, caller} ->
            send(caller, :stopped)
          x -> raise "unmatched pattern #{inspect x}"
        end
      end
      def puts(line) do
        send(__MODULE__, {:puts, line})
      end
      def get_lines() do
        send(__MODULE__, {:get_lines, self()})
        receive do x -> x end
      end
      def start() do
        process = spawn_link(fn -> __MODULE__.loop([]) end)
        Process.register(process, __MODULE__)
      end
      def stop() do
        send(__MODULE__, {:stop, self()})
        receive do x -> x end
      end
    end
  end
end
