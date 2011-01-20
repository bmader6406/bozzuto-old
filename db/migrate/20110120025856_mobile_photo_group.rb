class MobilePhotoGroup < ActiveRecord::Migration
  def self.up
    say_with_time "Creating mobile PhotoGroup" do
      PhotoGroup.create(:title => 'For Mobile', :flickr_raw_title => 'mobile')
    end
  end

  def self.down
    say_with_time "Destroying mobile PhotoGroup" do
      PhotoGroup.destroy_all(:flickr_raw_title => 'mobile').size
    end
  end
end
