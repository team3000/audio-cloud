json.array!(@media_streams) do |media_stream|
  json.extract! media_stream, :name, :detail, :permalink_url, :url, :download_url, :image_url, :media_type, :duration, :likes
end
