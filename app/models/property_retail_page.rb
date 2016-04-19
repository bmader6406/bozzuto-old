class PropertyRetailPage < PropertyPage
  has_many :slides, -> { order(:position) }, class_name: 'PropertyRetailSlide'

  def to_s
    property.title + ' Retail Page'
  end
end
