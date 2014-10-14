class BuzzesController < ApplicationController
  include Bozzuto::ContentController

  # TODO Mark for pending removal in lieu of HyLy form integration (only :create)
  has_mobile_actions :new, :create, :thank_you

  def new
  # TODO Mark for pending removal in lieu of HyLy form integration
    @buzz = Buzz.new(:email => params[:email])
  end

  # TODO Mark for pending removal in lieu of HyLy form integration
  def create
    @buzz = Buzz.new(params[:buzz])

    if @buzz.save
      flash[:buzz_email] = params[:buzz][:email]
      redirect_to :action => :thank_you
    else
      render :new
    end
  end

  def thank_you
    render
  end
end
