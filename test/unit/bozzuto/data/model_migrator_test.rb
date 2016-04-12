require 'test_helper'

class Bozzuto::Data::ModelMigratorTest < ActiveSupport::TestCase
  context 'Bozzuto::Data::ModelMigrator' do
    subject do
      Bozzuto::Data::ModelMigrator.new(
        origin_class: Property,
        target_class: Project,
        records:      Property.where(type: 'Project').map { |p| p.becomes(Property) }
      )
    end

    before do
      @section   = Section.make
      @property1 = Property.make
      @property2 = Property.make

      @property1.update_attributes(id: 10, type: 'Project', completion_date: Date.today, section_id: @section.id, title: 'Slug Test', slug: nil)
      @property2.update_attributes(id: 20, type: 'Project', completion_date: Date.today, section_id: @section.id)

      @slideshow1 = PropertySlideshow.make(property: @property1)
      @slideshow2 = PropertySlideshow.make(property: @property2)
    end

    describe "#migrate" do
      it "given a set of records of one class, creates records of the target class with all the same attributes and associations" do
        property1_slugs = @property1.slugs.map(&:slug)
        property2_slugs = @property2.slugs.map(&:slug)

        subject.migrate

        Project.count.should == 2

        Project.all.to_a.tap do |(project1, project2)|
          project1.id.should        == 10
          project1.section.should   == @section
          project1.slideshow.should == @slideshow1
          (project1.slugs.map(&:slug) & property1_slugs).should eq property1_slugs

          project2.id.should        == 20
          project2.section.should   == @section
          project2.slideshow.should == @slideshow2
          (project2.slugs.map(&:slug) & property2_slugs).should eq property2_slugs
        end

        @slideshow1.property_type.should == 'Property'
        @slideshow2.property_type.should == 'Property'

        subject.success_count.should == 0
        subject.failure_count.should == 2
      end

      context "when moving Property records to ApartmentCommunity" do
        subject do
          Bozzuto::Data::ModelMigrator.new(
            origin_class:         Property,
            target_class:         ApartmentCommunity,
            records:              Property.where(type: 'ApartmentCommunity').map { |p| p.becomes(Property) },
            ignore:               :office_hours,
            skip_validations_for: %i(position featured_position slug office_hours phone_number mobile_phone_number)
          )
        end

        before do
          @property = Property.make.tap do |p|
            p.update_columns(id: 1337, type: 'ApartmentCommunity')
          end

          @photo        = Photo.make(property: @property)
          @monday_hours = OfficeHour.make(property: @property, day: Date::DAYNAMES.index('Monday'))
          @friday_hours = OfficeHour.make(property: @property, day: Date::DAYNAMES.index('Friday'))
        end

        it "correctly copies the office hours" do
          subject.migrate

          ApartmentCommunity.count.should == 1

          ApartmentCommunity.first.tap do |community|
            community.id.should           == 1337
            community.photos.should       == [@photo]
            community.office_hours.should == [@monday_hours, @friday_hours]
          end
        end
      end
    end

    context "skipping validations on certain fields" do
      subject do
        Bozzuto::Data::ModelMigrator.new(
          origin_class:         Property,
          target_class:         Project,
          records:              Property.where(type: 'Project').map { |p| p.becomes(Property) },
          skip_validations_for: :position
        )
      end

      it "does not validate the specified fields" do
        subject.migrate

        subject.success_count.should == 2
        subject.failure_count.should == 0
      end
    end

    context "when associations are explicitly provided" do
      subject do
        Bozzuto::Data::ModelMigrator.new(
          origin_class:         Property,
          target_class:         Project,
          records:              Property.where(type: 'Project').map { |p| p.becomes(Property) },
          skip_validations_for: :position,
          associations:         :section
        )
      end

      it "only includes the specified associations" do
        subject.migrate

        Project.all.to_a.tap do |(project1, project2)|
          project1.section.should   == @section
          project1.slideshow.should == nil

          project2.section.should   == @section
          project2.slideshow.should == nil
        end

        @property1.slideshow.should == @slideshow1
        @property2.slideshow.should == @slideshow2
      end
    end

    context "when a record fails to save" do
      subject do
        Bozzuto::Data::ModelMigrator.new(
          origin_class: Property,
          target_class: Project,
          records:      [@property1.becomes(Property).tap { |p| p.title = nil }]
        )
      end

      before do
        @messages = Array.new.tap do |array|
          array.define_singleton_method :debug do |message|
            self.<< message
          end
        end

        subject.stubs(:logger).returns(@messages)
      end

      it "logs the errors and counts the failure" do
        subject.migrate

        subject.success_count.should == 0
        subject.failure_count.should == 1

        @messages.should include "\e[31mTitle can't be blank\e[0m"
      end
    end
  end
end
