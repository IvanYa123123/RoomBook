class ReviewSerializer < BaseSerializer
  def self.call(review)
    {
      id: review.id,
      rating: review.rating,
      body: review.body,
      authorName: review.user.full_name,
      createdAt: review.created_at.iso8601
    }
  end
end
