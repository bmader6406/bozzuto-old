class Leader < ActiveRecord::Base
  has_many :leaderships,
           :dependent  => :destroy,
           :inverse_of => :leader

  validates_presence_of :name,
                        :title,
                        :company,
                        :bio

  has_friendly_id :name, :use_slug => true

  has_attached_file :image,
                    :url             => '/system/:class/:id/:style.:extension',
                    :styles          => {:rect => '230x220#'},
                    :default_style   => :rect,
                    :convert_options => { :all => '-quality 80 -strip' }

  def typus_name
    name
  end
end
