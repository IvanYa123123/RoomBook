class BaseSerializer
  def self.photo_url(photo, request)
    return nil unless photo
    Rails.application.routes.url_helpers.rails_blob_url(photo, host: request.base_url)
  end

  def self.photos(record, request)
    return [] unless record.photos.attached?
    record.photos.map do |photo|
      { id: photo.id, url: photo_url(photo, request) }
    end
  end
end
