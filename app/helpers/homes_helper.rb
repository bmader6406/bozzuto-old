module HomesHelper
  def render_homes_mobile_listings(community, exclude_home = nil)
    ''.tap { |output|
      community.homes.each do |home|
        unless exclude_home && home == exclude_home
          output << render(:partial => 'homes/listing',
            :locals => {
              :community => community,
              :home      => home
          }).to_s
        end
      end
    }.html_safe
  end
end
