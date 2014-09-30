require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  context "A photo" do
    should belong_to(:property)
    should belong_to(:photo_group)

    should validate_presence_of(:title)
    should validate_presence_of(:photo_group)
    should validate_presence_of(:property)

    should have_attached_file(:image)

    describe ".typus_order_by" do
      it "returns the correct SQL" do
        Photo.typus_order_by.should == 'photo_groups.position ASC, photos.position ASC'
      end
    end

    describe "#typus_name" do
      before do
        @property    = ApartmentCommunity.make(:title => 'Wayne Manor')
        @photo_group = PhotoGroup.make(:title => 'Exteriors')
      end

      subject do
        Photo.new(
          :property    => @property,
          :photo_group => @photo_group,
          :position    => 4
        )
      end

      it "returns the property title, photo group title, and position" do
        subject.typus_name.should == 'Wayne Manor - Exteriors - Photo #4'
      end
    end

    describe "#thumbnail_tag" do
      subject { Photo.make }

      it "returns the img tag" do
        subject.thumbnail_tag.should =~ /\A<img src="#{subject.image.url(:thumb)}">\z/
      end
    end

    describe "#grouped" do
      before do
        @property = ApartmentCommunity.make

        @group_1 = PhotoGroup.make
        @group_1 = PhotoGroup.make
        @group_2 = PhotoGroup.make

        @photo_1 = Photo.make(:property => @property, :photo_group => @group_1)
        @photo_2 = Photo.make(:property => @property, :photo_group => @group_2)
      end

      it "returns the photos grouped by photo group" do
        Photo.grouped.should == {
          @group_1 => [@photo_1],
          @group_2 => [@photo_2]
        }
      end
    end

    describe "before saving" do
      before do
        @property_1 = ApartmentCommunity.make
        @property_2 = ApartmentCommunity.make

        @group_1 = PhotoGroup.make
        @group_2 = PhotoGroup.make

        # property_1's photos
        @photo_1 = Photo.make(:photo_group => @group_1, :property => @property_1)
        @photo_2 = Photo.make(:photo_group => @group_1, :property => @property_1)
        @photo_3 = Photo.make(:photo_group => @group_2, :property => @property_1)
        @photo_4 = Photo.make(:photo_group => @group_2, :property => @property_1)

        # property_2's photos
        @photo_5 = Photo.make(:photo_group => @group_1, :property => @property_2)
      end

      context "moving a photo to another group" do
        before do
          @photo_1.photo_group = @group_2
          @photo_1.save
        end

        it "updates the position" do
          @property_1.grouped_photos[@group_1].should == [@photo_2]
          @property_1.grouped_photos[@group_2].should == [@photo_3, @photo_4, @photo_1]
          @property_2.grouped_photos[@group_1].should == [@photo_5]

          @photo_2.reload.position.should == 1

          @photo_3.reload.position.should == 1
          @photo_4.reload.position.should == 2
          @photo_1.reload.position.should == 3

          @photo_5.reload.position.should == 1
        end
      end

      context "moving photo to another property" do
        before do
          @photo_1.property = @property_2
          @photo_1.save
        end

        it "updates the position" do
          @property_1.grouped_photos[@group_1].should == [@photo_2]
          @property_1.grouped_photos[@group_2].should == [@photo_3, @photo_4]
          @property_2.grouped_photos[@group_1].should == [@photo_5, @photo_1]

          @photo_2.reload.position.should == 1

          @photo_3.reload.position.should == 1
          @photo_4.reload.position.should == 2

          @photo_5.reload.position.should == 1
          @photo_1.reload.position.should == 2
        end
      end
    end
  end
end
