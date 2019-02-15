defmodule DetsBackup.LocalDiskTest do
  use ExUnit.Case
  alias DetsBackup.LocalDisk, as: Storage

  @table 'test_local_disk_test'

  test "store and retrieve models" do
    Storage.insert(@table, @table, @table)
    assert [{@table, @table}] = Storage.lookup(@table, @table)
    assert [{@table, @table}] = Storage.list(@table)
    Storage.delete(@table, @table)
    assert [] = Storage.lookup(@table, @table)

    # clean up
    assert File.exists?("test_local_disk_test")
    File.rm("test_local_disk_test")
    assert !File.exists?("test_local_disk_test")
  end
end
