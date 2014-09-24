class Lead2LeaseSubmission
  include ActiveModel::Model

  ATTRIBUTES = [:first_name,
                :last_name,
                :address_1,
                :address_2,
                :city,
                :state,
                :zip_code,
                :primary_phone,
                :secondary_phone,
                :email,
                :move_in_date,
                :bedrooms,
                :bathrooms,
                :pets,
                :comments,
                :lead_channel]

  attr_accessor(*ATTRIBUTES)

  validates :email, :first_name, :last_name,
            :presence => true

  validates :email, :email_format => true

  def initialize(attrs = {})
    attrs ||= {}

    # Duplicate so we don't delete the fields from
    # the original params hash
    attrs = attrs.dup

    # Handle move_in_date form fields
    year  = attrs.delete('move_in_date(1i)')
    month = attrs.delete('move_in_date(2i)')
    day   = attrs.delete('move_in_date(3i)')

    build_move_in_date(year, month, day)

    super
  end

  def attributes
    ATTRIBUTES.inject({}) do |hash, attr|
      hash[attr] = send(attr)
      hash
    end
  end


  private

  def build_move_in_date(year, month, day)
    if year && month && day
      self.move_in_date = Date.new(year.to_i, month.to_i, day.to_i)
    end
  end
end
