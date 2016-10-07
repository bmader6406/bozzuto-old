class AddPressContactInfoSnippet < ActiveRecord::Migration
  def change
    Snippet.create(name: 'Press Contact Info', body: '<p>Allison Lane<br></p><p>Director – Corporate Communications & Marketing<br></p><p><a href=\"mailto:Allison.lane@bozzuto.com\">Allison.lane@bozzuto.com</a><br></p><p>301.245.1268</p>')
  end

  Snippet = Class.new(ActiveRecord::Base)
end
