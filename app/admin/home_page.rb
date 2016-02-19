ActiveAdmin.register_page 'Home Page' do
  menu parent: 'Content'

  content do
    active_admin_form_for homepage, url: [:new_admin, :home_page], method: :put do |f|
      inputs do
        tabs do
          tab 'Details' do
            input :meta_title
            input :meta_description
            input :meta_keywords
            input :body # TODO WYSIWYG
            input :mobile_title
            input :mobile_banner_image
            input :mobile_body # TODO WYSIWYG
          end

          tab 'Reorder Slides' do
            panel nil do
              reorderable_table_for homepage.slides do
                column 'Drag to Reorder' do |slide|
                  image_tag slide.image
                end
              end
            end
          end
              
          tab 'Edit Slides' do
            has_many :slides, heading: false, allow_destroy: true do |slide|
              slide.input :image
              slide.input :link_url
            end
          end
        end

        actions
      end
    end
  end

  controller do
    def update
      if homepage.update_attributes(homepage_params)
        redirect_to new_admin_home_page_path, notice: t('flash.actions.update.notice', resource_name: 'HomePage')
      else
        render :index
      end
    end

    private

    def homepage
      @homepage ||= HomePage.first
    end
    helper_method :homepage

    def homepage_params
      params.require(:home_page).permit(
        :meta_title,
        :meta_description,
        :meta_keywords,
        :body,
        :mobile_title,
        :mobile_banner_image,
        :mobile_body,
        slides_attributes: [
          :id,
          :image,
          :link_url,
          :_destroy
        ]
      )
    end
  end
end
