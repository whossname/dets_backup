defmodule DetsBackup.AzureBlobTest do
  use ExUnit.Case

  @table 'test_azure_blob_test'

  defmodule UsingAzureBlob do
    @table_name 'test_azure_blob'
    use DetsBackup.AzureBlob

    def lookup(key) do
      Storage.lookup(@table_name, key)
    end

    def insert(key, value) do
      Storage.insert(@table_name, key, value)
    end

    def delete(key) do
      Storage.delete(@table_name, key)
    end

    def list() do
      Storage.list(@table_name)
    end
  end

  test "store and retrieve models" do
    UsingAzureBlob.insert(@table, @table)
    assert [{@table, @table}] = UsingAzureBlob.lookup(@table)
    assert [{@table, @table}] = UsingAzureBlob.list()
    UsingAzureBlob.delete(@table)
    assert [] = UsingAzureBlob.lookup(@table)
  end
end
