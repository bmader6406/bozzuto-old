class PropertyRetailPage < PropertyPage
  has_many :slides, -> { order(:position) }, class_name: 'PropertyRetailSlide'

  def to_s
    property.title + ' Retail Page'
  end

  def show_contact_callout?
    false
  end
end
