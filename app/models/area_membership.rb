class AreaMembership < ActiveRecord::Base
  include Bozzuto::Neighborhoods::Membership

  TIER = [1, 2, 3, 4]
end
