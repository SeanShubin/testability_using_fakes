defmodule SystemFake do
  defmacro __using__(_) do
    quote do
      def loop(state) do
        receive do
          {:monotonic_time, caller, time_unit} ->
            monotonic_times = Map.get(state, :monotonic_times)
            [monotonic_time | new_monotonic_times] = monotonic_times
            send(caller, monotonic_time)
            new_state = Map.put(state, :monotonic_times, new_monotonic_times)
            loop(new_state)
          {:set_times_in_microseconds, monotonic_times} ->
            new_state = Map.put(state, :monotonic_times, monotonic_times)
            loop(new_state)
          {:argv, caller} ->
            argv = Map.get(state, :argv)
            send(caller, argv)
            loop(state)
          {:set_command_line_arguments, argv} ->
            new_state = Map.put(state, :argv, argv)
            loop(new_state)
          {:stop, caller} -> send(caller, :stopped)
          x -> raise "unmatched pattern #{inspect x}"
        end
      end
      def monotonic_time(time_unit) do
        send(__MODULE__, {:monotonic_time, self(), time_unit})
        receive do x -> x end
      end
      def argv do
        send(__MODULE__, {:argv, self()})
        receive do x -> x end
      end
      def set_times_in_microseconds(monotonic_times) do
        send(__MODULE__,{:set_times_in_microseconds, monotonic_times})
      end
      def set_command_line_arguments(command_line_arguments) do
        send(__MODULE__,{:set_command_line_arguments, command_line_arguments})
      end
      def start() do
        initial_state = %{}
        process = spawn_link(fn -> __MODULE__.loop(initial_state) end)
        Process.register(process, __MODULE__)
      end
      def stop() do
        send(__MODULE__, {:stop, self()})
        receive do x -> x end
      end
    end
  end
end
