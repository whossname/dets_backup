defmodule DetsBackup.AzureBlobTest do
  use ExUnit.Case

  import Mock

  @table 'test_azure_blob_test'
  @dev_table "test_azure_blob_development"

  defmodule UsingAzureBlobTest do
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

  test "store and retrieve models - test environment" do
    UsingAzureBlobTest.insert(@table, @table)
    assert [{@table, @table}] = UsingAzureBlobTest.lookup(@table)
    assert [{@table, @table}] = UsingAzureBlobTest.list()
    UsingAzureBlobTest.delete(@table)
    assert [] = UsingAzureBlobTest.lookup(@table)
    assert !File.exists?(@dev_table)
  end

  test "store and retrieve models - dev environment" do
    with_mock Mix, env: fn -> :dev end do
      defmodule UsingAzureBlobDev do
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

      UsingAzureBlobDev.insert(@table, @table)
      assert [{@table, @table}] = UsingAzureBlobDev.lookup(@table)
      assert [{@table, @table}] = UsingAzureBlobDev.list()
      UsingAzureBlobDev.delete(@table)
      assert [] = UsingAzureBlobDev.lookup(@table)

      # clean up
      assert File.exists?(@dev_table)
      File.rm(@dev_table)
      assert !File.exists?(@dev_table)
    end
  end
end
