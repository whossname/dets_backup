defmodule DetsBackup.LocalMemoryTest do
  use ExUnit.Case
  alias DetsBackup.LocalMemory, as: Storage

  @table 'test_local_mem_test'

  test "store and retrieve models" do
    Storage.insert(@table, @table, @table)
    assert [{@table, @table}] = Storage.lookup(@table, @table)
    assert [{@table, @table}] = Storage.list(@table)
    Storage.delete(@table, @table)
    assert [] = Storage.lookup(@table, @table)

    Storage.insert(@table, :atom, [])
    assert [{:atom, []}] = Storage.lookup(@table, :atom)
  end
end

