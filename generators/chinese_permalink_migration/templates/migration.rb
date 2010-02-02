class Add<%= permalink_field_name.camelize %>To<%= permalink_table_name.camelize %> < ActiveRecord::Migration
  def self.up
    add_column :<%= permalink_table_name %>, :<%= permalink_field_name %>, :string, :default => nil

    <%= permalink_table_name.classify %>.reset_column_information
    <%= permalink_table_name.classify %>.all.each do |obj|
      obj.<%= permalink_field_name %> = nil
      obj.save
    end
  end

  def self.down
    remove_column :<%= permalink_table_name %>, :<%= permalink_field_name %>
  end
end
