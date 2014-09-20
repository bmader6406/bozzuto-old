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

  def attributes
    ATTRIBUTES.inject({}) do |hash, attr|
      hash[attr] = send(attr)
      hash
    end
  end
end
