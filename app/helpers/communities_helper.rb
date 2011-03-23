module CommunitiesHelper
  def community_contact_callout(community)
    render 'communities/request_info', :community => community
  end
end
