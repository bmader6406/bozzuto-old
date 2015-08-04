class FeedFile < ActiveRecord::Base
  FILE_TYPE = [
    'Photo',
    'Floorplan',
    'Logo',
    'Video',
    'Blueprint',
    'Other'
  ]

  IMAGE_EXTENSIONS = [
    '.jpg',
    '.jpeg',
    '.png'
  ]

  belongs_to :feed_record, :polymorphic => true

  validates :feed_record,
            :external_cms_id,
            :external_cms_type,
            :name,
            :format,
            :source,
            :presence => true

  validates :file_type, :inclusion => { :in => FILE_TYPE }, :allow_nil => true

  def self.parse_type_from(input, filename = nil)
    value = input.to_s.capitalize

    if FILE_TYPE.exclude?(value) || value == 'Other'
      IMAGE_EXTENSIONS.include?(File.extname(filename.to_s).downcase) ? 'Photo' : 'Other'
    else
      value
    end
  end

  def source_link
    "<a href=#{source} target=\"blank\">#{source}</a>".html_safe
  end
end
