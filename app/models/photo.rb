class Photo < ActiveRecord::Base

  acts_as_list :scope => :photo_group_id

  belongs_to :photo_group
  belongs_to :property

  validates_presence_of :title, :photo_group, :property

  before_update :move_to_new_list,
                :if => proc { |p| p.photo_group_id_changed? || p.property_id_changed? }

  default_scope -> { includes(:photo_group) }

  scope :positioned, -> { includes(:photo_group).order('photo_groups.position ASC, photos.position ASC') }
  scope :in_group,   -> (group) { where(photo_group_id: group.id) }
  scope :for_mobile, -> { where(show_to_mobile: true) }

  has_attached_file :image,
                    :url             => '/system/:class/:id/photo_:id_:style.:extension',
                    :styles          => { :resized => '870x375#', :thumb => '55x55#', :mobile => '300>' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :image

  def self.grouped
    ActiveSupport::OrderedHash.new.tap do |hash|
      PhotoGroup.positioned.all.each do |group|
        photos = in_group(group)

        hash[group] = photos if photos.any?
      end
    end
  end

  def to_s
    "#{property.title} - #{photo_group.title} - Photo ##{position}"
  end

  def to_label
    to_s
  end

  def thumbnail_tag
    %{<img src="#{image.url(:thumb)}">}.html_safe
  end


  private

  def scope_condition
    "property_id = #{property_id} AND photo_group_id = #{photo_group_id}"
  end

  def move_to_new_list
    old_photo_group = PhotoGroup.find(changed_attributes['photo_group_id'] || photo_group_id)
    new_photo_group = photo_group

    old_property = Property.find(changed_attributes['property_id'] || property_id)
    new_property = property

    # remove from old list
    self.photo_group = old_photo_group
    self.property    = old_property

    remove_from_list

    # add to new list
    self.photo_group = new_photo_group
    self.property    = new_property

    self.position = bottom_position_in_list(self).to_i + 1
  end
end
