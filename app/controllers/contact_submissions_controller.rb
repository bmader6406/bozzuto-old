class ContactSubmissionsController < ApplicationController
  include Bozzuto::ContentController

  has_mobile_actions :show, :create, :thank_you

  def show
  end

  def thank_you
  end


  private

  def find_section
    @section = Section.about
  end
end
