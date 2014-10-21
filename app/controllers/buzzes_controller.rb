class BuzzesController < ApplicationController
  include Bozzuto::ContentController

  has_mobile_actions :new, :thank_you

  def new
  end

  def thank_you
    render
  end
end
