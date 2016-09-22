defmodule Doodit.Region do

  @doc """
  Starts a new region.
  """
  def start_link do
    Agent.start_link(fn -> Map.new end)
  end

  @doc """
  Gets a value from the `region` by `key`.
  """
  def get(region, key) do
    Agent.get(region, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `region`.
  """
  def put(region, key, value) do
    Agent.update(region, &Map.put(&1, key, value))
  end

  @doc """
  Deletes the `key` from `region`.
  Returns the current value of `key`, if `key` exists.
  """
  def delete(region, key) do
    Agent.get_and_update(region, &Map.pop(&1, key))
  end

end