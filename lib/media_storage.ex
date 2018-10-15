defmodule MediaStorage do
  @moduledoc """
  Set of functions to work with virtual file storage system
  """
  alias ExAws.S3

  @spec upload_url(String.t(), Keyword.t()) :: {:ok, String.t()} | {:error, String.t()}

  def upload_url(val, opts \\ [])

  def upload_url("", _opts) do
    {:error, "upload file path cannot be empty string"}
  end

  def upload_url(to_path, opts) when is_bitstring(to_path) and to_path != "" do
    with {:ok, bucket} <- bucket(opts),
         expires_in <- opts |> Keyword.get(:expires_in, 3600) do
      config()
      |> S3.presigned_url(:put, bucket, to_path, expires_in: expires_in)
    else
      error -> error
    end
  end

  @spec download_url(String.t(), Keyword.t()) :: {:ok, String.t()} | {:error, String.t()}
  def download_url(val, opts \\ [])

  def download_url("", _opts) do
    {:error, "upload file path cannot be empty string"}
  end

  def download_url(from_path, opts) when is_bitstring(from_path) and from_path != "" do
    with {:ok, bucket} <- bucket(opts) do
      {:ok, "https://s3-#{region()}.amazonaws.com/#{bucket}/#{from_path}"}
    else
      error -> error
    end
  end

  @not_tested
  def upload_file([from: from_path, to: to_path] = opts) do
    with bucket <- bucket(opts) do
      from_path
      |> S3.Upload.stream_file()
      |> S3.upload(bucket, to_path, content_type: MIME.from_path(to_path))
      |> ExAws.request(config())
      |> case do
        {:ok, _} ->
          download_url(to_path, opts)

        {:error, _} = error ->
          error
      end
    end
  end

  @not_tested
  def download_file([from: from_path, to: to_path] = opts) do
    with bucket <- bucket(opts) do
      S3.download_file(bucket, from_path, to_path)
      |> ExAws.request(config())
      |> case do
        {:ok, :done} ->
          {:ok, to_path}
      end
    end
  end

  defp config do
    config = Application.get_all_env(:media_storage)

    ExAws.Config.new(
      :s3,
      %{
        access_key_id: config[:s3_access_key_id],
        secret_access_key: config[:s3_secret_access_key],
        region: config[:s3_region]
      }
    )
  end

  defp region do
    Application.get_env(:media_storage, :s3_region)
  end

  defp bucket(opts) do
    opts
    |> Keyword.get(:bucket, bucket())
    |> case do
      nil -> {:error, "bucket cannot be nil"}
      "" -> {:error, "bucket cannot be empty"}
      value -> {:ok, value}
    end
  end

  defp bucket do
    Application.get_env(:media_storage, :s3_bucket)
  end
end
