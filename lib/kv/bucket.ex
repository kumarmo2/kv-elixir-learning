defmodule KV.Bucket do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, fn store -> Map.get(store, key) end)
  end

  def put(bucket, key, value), do: Agent.update(bucket, &Map.put(&1, key, value))
end
