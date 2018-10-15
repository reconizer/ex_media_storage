# MediaStorage

## Installation

```elixir
def deps do
  [
    {:media_storage, git: "git@github.com:reconizer/ex_media_storage", tag: "0.1"}
  ]
end
```

## Config
```elixir
  config :media_storage,
    s3_access_key_id: "AWS_ACCESS_KEY",
    s3_secret_access_key: "AWS_SECRET",
    s3_region: "BUCKET_REGION",
    s3_bucket: "BUCKET_NAME"
```

## Downloading
```elixir
  # NOTE - BUCKET MUST BE PUBLIC
  MediaStorage.download_url("image.png") = {:ok, "https://s3-BUCKET_REGION.amazonaws.com/BUCKET_NAME/image.png"}

  MediaStorage.download_url("image.png", bucket: "test") = {:ok, "https://s3-BUCKET_REGION.amazonaws.com/test/image.png"}
```
## Uploading
```elixir
  MediaStorage.upload_url("image.png") = {:ok, "https://s3.BUCKET_REGION.amazonaws.com/BUCKET_NAME/image.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=...&X-Amz-Date=...&X-Amz-Expires=3600&X-Amz-SignedHeaders=host&X-Amz-Signature=..."}

  MediaStorage.upload_url("image.png", bucket: "test", expires_in: 7200) = {:ok, "https://s3.BUCKET_REGION.amazonaws.com/test/image.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=...&X-Amz-Date=...&X-Amz-Expires=7200&X-Amz-SignedHeaders=host&X-Amz-Signature=..."}
```