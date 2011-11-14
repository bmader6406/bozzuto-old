class BuzzesController < SectionContentController
  def new
    @buzz = Buzz.new(:email => params[:email])
  end

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
