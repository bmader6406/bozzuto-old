class GreenPackage < ActiveRecord::Base

  attr_accessible :home_community,
                  :home_community_id,
                  :photo,
                  :ten_year_old_cost,
                  :graph_title,
                  :graph_tooltip,
                  :graph,
                  :disclaimer


  belongs_to :home_community

  has_many :green_package_items, -> { order(position: :asc) },
           :inverse_of => :green_package,
           :dependent  => :destroy

  has_many :green_features, -> { order('green_package_items.position ASC') },
           :through => :green_package_items


  has_attached_file :photo,
                    :url             => '/system/:class/:attachment/:id/:basename_:style.:extension',
                    :styles          => { :resized => '498x551#' },
                    :default_style   => :resized,
                    :convert_options => { :all => '-quality 80 -strip' }

  has_attached_file :graph,
                    :url             => '/system/:class/:attachment/:id/:basename_graph_:style.:extension',
                    :styles          => { :resized => '948x294#' },
                    :default_style   => :resized


  validates_presence_of :home_community, :ten_year_old_cost

  validates_attachment_presence :photo

  do_not_validate_attachment_file_type :photo
  do_not_validate_attachment_file_type :graph

  delegate :title, :to => :home_community, :prefix => :home_community

  alias_method :typus_name, :home_community_title

  def has_ultra_green_features?
    green_package_items.ultra_green.any?
  end

  def has_graph?
    graph_title.present? && graph.present?
  end

  def total_savings
    green_package_items.include_ultra_green(false).sum(:savings)
  end

  def total_savings_with_ultra_green
    green_package_items.include_ultra_green(true).sum(:savings)
  end

  def annual_savings
    (total_savings / ten_year_old_cost) * 100
  end

  def annual_savings_with_ultra_green
    (total_savings_with_ultra_green / ten_year_old_cost) * 100
  end
end
