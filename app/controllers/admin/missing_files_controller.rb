class Admin::MissingFilesController < Admin::MasterController

  skip_filter :set_resource,
              :find_item,
              :check_ownership_of_item,
              :check_if_user_can_perform_action_on_user,
              :check_if_user_can_perform_action_on_resource,
              :set_order,
              :set_fields

  def index
  end

  def show
  end

  private

  def resource_class
    params[:id].presence && params[:id].constantize
  end
  helper_method :resource_class

  def resource_classes
    [
      ApartmentFloorPlan,
      # AttachmentFile,
      Award,
      BodySlide,
      BozzutoBlogPost,
      CareersEntry,
      CarouselPanel,
      GreenFeature,
      GreenPackage,
      HomeCommunity,
      HomeFloorPlan,
      HomePage,
      HomePageSlide,
      LandingPage,
      Leader,
      MastheadSlide,
      MiniSlide,
      NewsPost,
      Photo,
      # Picture,
      ProjectUpdate,
      PropertySlide,
      PropertyFeature,
      Publication,
      Video
    ]
  end
  helper_method :resource_classes
end
