ActiveAdmin.register PropertyFeedImport do
  menu parent: 'System'

  actions :index, :show

  scope :all,           default: true
  scope :vaultware
  scope :rent_cafe
  scope :property_link
  scope :psi

  filter :state, as: :select, collection: PropertyFeedImport::STATES

  index do
    column :type do |import|
      import.type.titleize
    end
    column :state do |import|
      status_tag import.state
    end
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :type do |import|
        import.type.titleize
      end
      row :state do |import|
        status_tag import.state
      end
      row :running_time do |import|
        if import.started_at.present? && import.finished_at.present?
          distance_of_time_in_words(
            import.finished_at,
            import.started_at,
            include_seconds: true
          )
        end
      end
      row :started_at
      row :finished_at
      row :file_file_name
      row :file_file_size
      row :error
      row :created_at
      row :updated_at
    end
  end
end
