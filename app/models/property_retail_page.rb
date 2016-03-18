class PropertyRetailPage < PropertyPage
  has_many :slides, class_name: 'PropertyRetailSlide'

  def to_s
    property.title + ' Retail Page'
  end

  def typus_name
    to_s
  end
end
