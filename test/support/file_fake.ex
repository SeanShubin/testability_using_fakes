defmodule FileFake do
  defmacro __using__(_) do
    quote do
      def loop(state) do
        receive do
          {:set_file_contents, file, content} ->
            new_state = Map.put(state, file, content)
            loop(new_state)
          {:read!, caller, file} ->
            content = Map.get(state, file)
            send(caller, content)
            loop(state)
          {:stop, caller} -> send(caller, :stopped)
          x -> raise "unmatched pattern #{inspect x}"
        end
      end
      def set_file_contents(file, content) do
        send(__MODULE__, {:set_file_contents, file, content})
      end
      def read!(file) do
        send(__MODULE__, {:read!, self(), file})
        receive do x -> x end
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
