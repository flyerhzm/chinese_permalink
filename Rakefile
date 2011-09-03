require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'jeweler'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the chinese_permalink plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the chinese_permalink plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ChinesePermalink'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Jeweler::Tasks.new do |gemspec|
  gemspec.name = "chinese_permalink"
  gemspec.summary = "This plugin adds a capability for AR model to create a seo permalink with your chinese text."
  gemspec.description = "This plugin adds a capability for AR model to create a seo permalink with your chinese text. It will translate your chinese text to english url based on google translate."
  gemspec.email = "flyerhzm@gmail.com"
  gemspec.homepage = "http://github.com/flyerhzm/chinese_permalink"
  gemspec.authors = ["Richard Huang"]
  gemspec.files.exclude '.gitignore'
  gemspec.files.exclude 'log/*'
end
Jeweler::GemcutterTasks.new
