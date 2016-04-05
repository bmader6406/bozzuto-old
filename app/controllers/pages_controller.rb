class PagesController < ApplicationController
  include Bozzuto::ContentController

  has_mobile_actions :show

  before_filter :find_page
  before_filter :verify_has_mobile_content

  def show
  end

  private

  def find_page
    @page = if params[:page].present?
      scope = admin_user ? @section.pages : @section.pages.published
      scope.find_by path: current_page_path
    else
      @section.pages.published.first
    end

    render_404 if @page.nil?
  end

  def verify_has_mobile_content
    if !@page.mobile_content?
      render_full_site!
    end
  end
end
