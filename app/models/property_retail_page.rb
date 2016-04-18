class PropertyRetailPage < PropertyPage
  has_many :slides, class_name: 'PropertyRetailSlide'

  def to_s
    property.title + ' Retail Page'
  end
end
