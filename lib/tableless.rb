module Tableless
  def self.included(base)
    base.extend ClassMethods
  end

  def save(validate = true) 
    validate ? valid? : true 
  end 


  module ClassMethods
    def columns
      @columns ||= []
    end
   
    def column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end
  end
end
