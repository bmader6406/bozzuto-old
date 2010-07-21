class LeadersController < SectionContentController
  layout "application"

  def index
    @leadership_groups = LeadershipGroup.all
    @leaders = Leader.all
  end
end
