defmodule DetsBackup.AzureBlob do
  defmacro __using__(_) do
    case Mix.env() do
      :prod ->
        quote do
          alias DetsBackup.AzureBlob, as: Storage
        end

      :dev ->
        quote do
          alias DetsBackup.LocalDisk, as: Storage
          @table_name @table_name ++ '_development'
        end

      :test ->
        quote do
          alias DetsBackup.LocalMemory, as: Storage
        end
    end
  end

  require Logger

  def lookup(table_name, key) do
    open_table(table_name)
    resp = :dets.lookup(table_name, key)
    :dets.close(table_name)
    resp
  end

  def insert(table_name, key, value) do
    insert(table_name, {key, value})
  end

  def insert(table_name, tuple) when is_tuple(tuple) do
    table = open_table(table_name)
    resp = :dets.insert(table, tuple)
    :dets.close(table)
    backup(table_name)
    resp
  end

  def delete(table_name, key) do
    table = open_table(table_name)
    resp = :dets.delete(table, key)
    :dets.close(table)
    backup(table_name)
    resp
  end

  def list(table_name) do
    table = open_table(table_name)
    resp = :dets.foldl(&[&1 | &2], [], table)
    :dets.close(table)
    resp
  end

  defp open_table(table_name) do
    if !File.exists?(table_name) do
      exists =
        table_name
        |> check_blob_exists()
        |> retrieve_blob(table_name)

      case exists do
        :no_blob ->
          Logger.warn("No dets file to retrieve")

        :ok ->
          Logger.info("Retrieved the dets file from AzureBlob")

        {:error, posix} ->
          Logger.error("Unable to retrieve the dets file from AzureBlob: #{posix}")
      end
    end

    {:ok, table} = :dets.open_file(table_name, type: :set)
    table
  end

  defp check_blob_exists(table_name) do
    {:ok, %{body: body}} = ExAzure.request(:list_blobs, [blob_container()])
    Enum.any?(body, fn blob -> Kernel.elem(blob, 1) == table_name end)
  end

  defp retrieve_blob(false, _), do: :no_blob

  defp retrieve_blob(true, table_name) do
    {:ok, {:ok, content}} = ExAzure.request(:get_blob, [blob_container(), table_name])
    File.write(table_name, content)
  end

  defp backup(table_name) do
    {:ok, file} = File.read(table_name)
    ExAzure.request(:put_block_blob, [blob_container(), table_name, file])
  end

  defp blob_container() do
    Application.get_env(:ex_azure, :blob_container)
  end
end
