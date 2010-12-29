module Montage
  def self.included(base)
    base.class_eval do
      has_attached_file :left_montage_image,
        :url => '/system/:class/:id/montage/:style_left_montage_image.:extension',
        :styles => { :normal => '250x148#' },
        :default_style => :normal

      has_attached_file :middle_montage_image,
        :url => '/system/:class/:id/montage/:style_middle_montage_image.:extension',
        :styles => { :normal => '540x148#' },
        :default_style => :normal

      has_attached_file :right_montage_image,
        :url => '/system/:class/:id/montage/:style_right_montage_image.:extension',
        :styles => { :normal => '310x148#' },
        :default_style => :normal
    end
  end
  
  def montage?
    left_montage_image? && middle_montage_image? && right_montage_image?
  end
end