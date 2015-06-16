module SharedFeaturableNewsTests
  include SharedExamples

  shared_example_for "a featurable news item" do |described_class|
    should allow_value(true).for(:show_as_featured_news)
    should allow_value(false).for(:show_as_featured_news)
    should_not allow_value(nil).for(:show_as_featured_news)

    context "with a featured news #{described_class}" do
      before do
        @flagged = described_class.make(:show_as_featured_news => true)
      end

      it "only allows one #{described_class} to be flagged as featured news at a time" do
        expect {
          described_class.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end

      it "keeps existing featured #{described_class}" do
        expect {
          described_class.make(:show_as_featured_news => false)
        }.to_not change {
          @flagged.reload.show_as_featured_news
        }.from(true)
      end
    end

    context "with a non-#{described_class} featured news item" do

      before do
        other_class = Bozzuto::Homepage::FeaturableNews.class_variable_get(:@@featurable_news_classes).find{ |klass| klass != described_class }

        @flagged = other_class.make(:show_as_featured_news => true)
      end

      it "only allows one featured news item -- regardless of class -- at a time" do
        expect {
          described_class.make(:show_as_featured_news => true)
        }.to change {
          @flagged.reload.show_as_featured_news
        }.from(true).to(false)
      end
    end
  end
end
