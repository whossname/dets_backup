defmodule DetsBackup.LocalDisk do
  def lookup(table_name, key) do
    open_table(table_name)
    :dets.lookup(table_name, key)
  end

  def insert(table_name, key, value) do
    insert(table_name, {key, value})
  end

  def insert(table_name, tuple) when is_tuple(tuple) do
    table = open_table(table_name)
    resp = :dets.insert(table, tuple)
    :dets.close(table)
    resp
  end

  def delete(table_name, key) do
    table = open_table(table_name)
    resp = :dets.delete(table, key)
    :dets.close(table)
    resp
  end

  def list(table_name) do
    table = open_table(table_name)
    resp = :dets.foldl(&([&1 | &2]), [], table)
    :dets.close(table)
    resp
  end

  defp open_table(table_name) do
    {:ok, table} = :dets.open_file(table_name, [type: :set])
    table
  end
end
