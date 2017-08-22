class HomePagesController < ApplicationController
  has_mobile_actions :index

  layout :detect_mobile_layout

  def index
    @home_page = HomePage.first
  end

  private

  def detect_mobile_layout
    mobile? ? 'application' : 'homepage'
  end

  def metros
    @metros ||= Metro.includes(areas: :neighborhoods).positioned.select(&:has_communities?)
  end
  helper_method :metros
end
