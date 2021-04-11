defmodule KV.Register do
  use GenServer

  @impl true
  def init(_options), do: {:ok, %{}}

  @impl true
  def handle_call({:lookup, name}, _from, names_to_pid_map) do
    {:reply, Map.fetch(names_to_pid_map, name), names_to_pid_map}
  end

  @impl true
  def handle_cast({:create, name}, names_to_pid_map) do
    if Map.has_key?(names_to_pid_map, name) do
      {:norepy, names_to_pid_map}
    else
      {:ok, bucket} = KV.Bucket.start_link(%{})
      new_map = Map.put(names_to_pid_map, name, bucket)
      {:noreply, new_map}
    end
  end

  def start_link(opts) do
    # returns {:ok, pid} if succesful
    GenServer.start_link(__MODULE__, :ok, opts)
    # GenServer.start_link)
  end

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end
end
