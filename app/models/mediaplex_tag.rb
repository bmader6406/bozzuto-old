class MediaplexTag < ActiveRecord::Base

  attr_accessor :parser

  belongs_to :trackable, :polymorphic => true

end
