class AddQuoteFieldsToMastheadSlide < ActiveRecord::Migration
  def self.up
    add_column :masthead_slides, :quote, :text
    add_column :masthead_slides, :quote_attribution, :string
    add_column :masthead_slides, :quote_job_title, :string
    add_column :masthead_slides, :quote_company, :string
  end

  def self.down
    remove_column :masthead_slides, :quote
    remove_column :masthead_slides, :quote_attribution
    remove_column :masthead_slides, :quote_job_title
    remove_column :masthead_slides, :quote_company
  end
end
