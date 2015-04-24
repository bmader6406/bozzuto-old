require 'test_helper'

module Bozzuto::Searches::Inclusive
  class FeatureSearchTest < ActiveSupport::TestCase
    context "Bozzuto::Searches::Inclusive::FeatureSearch" do
      subject { FeatureSearch.new }

      describe ".sql" do
        it "returns exclusive search SQL with ? in place of actual expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN properties_property_features
              ON properties.id = properties_property_features.property_id
              WHERE properties_property_features.property_feature_id IN (?)
            )
          ))
        end
      end

      describe "#main_class" do
        it "returns the main class" do
          subject.main_class.should == Property
        end
      end

      describe "#foreign_key" do
        it "returns the foreign key" do
          subject.foreign_key.should == 'property_id'
        end
      end

      describe "#search_column" do
        it "returns the search column" do
          subject.search_column.should == 'property_feature_id'
        end
      end

      describe "#sql" do
        subject { FeatureSearch.new([5,2,4]) }

        it "returns exclusive search SQL with the given expected values" do
          equalized(subject.sql).should == equalized(%q(
            properties.id IN (
              SELECT properties.id
              FROM properties
              INNER JOIN properties_property_features
              ON properties.id = properties_property_features.property_id
              WHERE properties_property_features.property_feature_id IN (5,2,4)
            )
          ))
        end
      end
    end

    # Take spacing and backticks out of the equation
    def equalized(string)
      string.gsub(/[\s`]/, '')
    end
  end
end
