require 'test_helper'

class PagesHelperTest < ActionView::TestCase
  context 'PagesHelper' do
    context '#render_aside' do
      setup do
        @section = Section.make :title => 'Blah blah blah'
      end

      context 'with a partial that exists' do
        should 'render the partial' do
          assert_equal 'pages/blah_blah_blah_aside', render_aside
        end
      end
    end
  end

  def render(opts)
    opts[:partial]
  end
end
