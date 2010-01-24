# user this migration generator
# ruby script/generate chinese_permalink_migartion (migration name) (table name) [permalink column name]
# for example:
# ruby script/generate chinese_permalink_migration add_permalink_to_posts posts
# ruby script/generate chiense_permalink_migration add_permalink_to_posts posts slug_url
class ChinesePermalinkMigrationGenerator < Rails::Generator::NamedBase
  attr_reader :permalink_table_name
  attr_reader :permalink_field_name

  def initialize(runtime_args, runtime_options = {})
    super
    @permalink_table_name = runtime_args[0]
    @permalink_field_name = runtime_args[1] || 'permalink'
  end

  def manifest
    record do |m|
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "add_#{@permalink_field_name}_to_#{@permalink_table_name}"
    end
  end
end
