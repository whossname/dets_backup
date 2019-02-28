defmodule DetsBackup.LocalMemory do
  def lookup(table_name, key) do
    table = open_table(table_name)
    :ets.lookup(table, key)
  end

  def insert(table_name, key, value) do
    insert(table_name, {key, value})
  end

  def insert(table_name, tuple) when is_tuple(tuple) do
    table = open_table(table_name)
    resp = :ets.insert(table, tuple)
    resp
  end

  def delete(table_name, key) do
    table = open_table(table_name)
    resp = :ets.delete(table, key)
    resp
  end

  def list(table_name) do
    table = open_table(table_name)
    resp = :ets.foldl(&[&1 | &2], [], table)
    resp
  end

  defp open_table(table_name) when is_list(table_name) do
    table_name = :erlang.list_to_atom(table_name)

    :ets.whereis(table_name)
    |> case do
      :undefined -> :ets.new(table_name, [:named_table])
      table -> table
    end
  end
end
