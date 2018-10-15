defmodule MediaStorageTest do
  use ExUnit.Case, async: true
  doctest MediaStorage

  describe "#upload_url/1" do
    test "expects correct params" do
      assert {:error, _} = MediaStorage.upload_url("")

      assert {:ok, _} = MediaStorage.upload_url("test")
    end

    test "generates correct url" do
      assert {:ok, url} = MediaStorage.upload_url("test.png", bucket: "testing-bucket")
      assert url =~ ~r/(testing-bucket)/
      assert url =~ ~r/\/test\.png/

      assert {:ok, url} = MediaStorage.upload_url("test/test.png", bucket: "testing-bucket")

      assert url =~ ~r/(testing-bucket)/
      assert url =~ ~r/test\/test\.png/

      assert {:ok, url} =
               MediaStorage.upload_url("test.png", bucket: "testing-bucket", expires_in: 800)

      assert url =~ ~r/(testing-bucket)/
      assert url =~ ~r/\/test\.png/
      assert url =~ ~r/(X\-Amz\-Expires\=800)/
    end
  end

  describe "#download_url/1" do
    test "expects correct params" do
      assert {:error, _} = MediaStorage.download_url("")

      assert {:ok, _} = MediaStorage.download_url("test")
    end

    test "generates correct url" do
      assert {:ok, url} = MediaStorage.download_url("test.png", bucket: "testing-bucket")
      assert url =~ ~r/(testing-bucket)/
      assert url =~ ~r/\/test\.png/

      assert {:ok, url} = MediaStorage.download_url("test/test.png", bucket: "testing-bucket")
      assert url =~ ~r/(testing-bucket)/
      assert url =~ ~r/test\/test\.png/
    end
  end
end
