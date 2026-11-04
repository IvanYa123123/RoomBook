class PagesController < ApplicationController
  def home
    @popular_hotels = Hotel.includes(:rooms, :reviews, photos_attachments: :blob)
                           .order(created_at: :desc)
                           .limit(6)
  end
end
