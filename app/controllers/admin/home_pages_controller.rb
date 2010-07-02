# Controller generated by Typus, use it to extend admin functionality.
class Admin::HomePagesController < Admin::MasterController
  before_filter :initialize_and_redirect_to_edit, :only => [:index, :new]


  private

  def initialize_and_redirect_to_edit
    @home_page = HomePage.first || (HomePage.new.save(false) && HomePage.first)
    redirect_to :action => :edit, :id => @home_page.id
  end
end
