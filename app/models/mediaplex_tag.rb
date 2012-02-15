class MediaplexTag < ActiveRecord::Base
  belongs_to :trackable, :polymorphic => true
end
