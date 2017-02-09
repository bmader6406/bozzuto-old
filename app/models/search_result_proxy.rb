class SearchResultProxy < ActiveRecord::Base
  validates :query, :url, presence: true
  validate :url_is_valid

  private

  def url_is_valid
    if url?
      res = Net::HTTP.get_response(URI(url))
      unless res.code.to_i >= 200 && res.code.to_i < 400
        errors.add(:url, "is invalid")
      end
    end
  rescue
    errors.add(:url, "is invalid")
  end
end
