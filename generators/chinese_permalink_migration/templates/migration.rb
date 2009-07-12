class Add<%= permalink_field_name.capitalize %>To<%= permalink_table_name.capitalize %> < ActiveRecord::Migration
  def self.up
    add_column :<%= permalink_table_name %>, :<%= permalink_field_name %>, :string, :default => nil

    klass = Object.const_get("<%= permalink_table_name.classify %>")
    klass.reset_column_information
    klass.all.each do |obj|
      obj.<%= permalink_field_name %> = nil
      obj.save
    end
  end

  def self.down
    remove_column :<%= permalink_table_name %>, :<%= permalink_field_name %>
  end
end
