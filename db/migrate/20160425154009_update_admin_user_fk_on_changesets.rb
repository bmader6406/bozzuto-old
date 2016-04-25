class UpdateAdminUserFkOnChangesets < ActiveRecord::Migration
  def up
    remove_foreign_key :chronolog_changesets, :admin_users

    add_foreign_key :chronolog_changesets, :admin_users, on_delete: :nullify
  end

  def down
    # no op
  end
end
