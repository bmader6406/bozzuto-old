ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: I18n.t("active_admin.dashboard")

  content :title => proc{ I18n.t("active_admin.dashboard") } do

    panel 'Activity Log' do
      header_action link_to 'View All', [:admin, :changesets]

      table_for Chronolog::Changeset.recent.limit(10) do
        column 'Date' do |changeset|
          changeset.created_at.to_date
        end

        column 'Time' do |changeset|
          changeset.created_at.strftime("%I:%M %P")
        end

        column 'Message' do |changeset|
          change_summary changeset
        end

        column 'Changes' do |changeset|
          link_to 'View Changes', admin_changeset_path(changeset)
        end
      end
    end

    panel "Recent Buzz Leads" do
      header_action link_to "View All", [:admin, :buzzes]

      table_for Buzz.order(created_at: :desc).limit(4) do
        column :email do |buzz|
          link_to buzz.email, [:admin, buzz]
        end
        column :name
        column :created_at
      end

      div do
      end
    end

    panel "Recent Under Construction Leads" do
      header_action link_to "View All", [:admin, :under_construction_leads]

      table_for UnderConstructionLead.order(created_at: :desc).limit(4) do
        column :email do |lead|
          link_to lead.email, [:admin, lead]
        end
        column :name
        column :created_at
      end
    end
  end
end
