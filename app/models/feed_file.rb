class FeedFile < ActiveRecord::Base
  FILE_TYPE = [
    'Photo',
    'Floorplan',
    'Logo',
    'Video',
    'Blueprint',
    'Other'
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
end
