begin
  # rtranslate is a gem that can translate text based on google translate
  require 'easy_translate'
rescue Object
  puts "no easy_translate, you might want to look into it."
end

module ChinesePermalink

  def self.included(base)
    base.class_eval do
      class_inheritable_accessor :permalink_attrs, :permalink_field, :before_methods, :after_methods
    end
    base.extend ClassMethods
  end 

  private 
  def create_permalink
    if self.permalink.nil?
      chinese_permalink = self.class.permalink_attrs.collect do |attr_name|
        chinese_value = self.send(attr_name)
      end * '-'
      self.class.before_methods.each do |method|
        chinese_permalink = self.send(method, chinese_permalink)
      end

      english_permalink = EasyTranslate.translate(chinese_permalink, :from => 'zh-TW', :to => :en )
      self.class.after_methods.each do |method|
        english_permalink = self.send(method, english_permalink)
      end

      english_permalink = remove_duplicate_dash(remove_tailing_dash(remove_non_ascii(remove_space(remove_punctuation(english_permalink))))).downcase
      self.update_attribute(self.class.permalink_field, english_permalink)
    end
  end

  def remove_tailing_dash(text)
    text.gsub(/-+$/, '')
  end

  def remove_non_ascii(text)
    text.gsub('_', '-').gsub(/[^-a-zA-Z0-9]/, '')
  end

  def remove_space(text)
    text.gsub(/\s+/, '-')
  end
  
  def remove_punctuation(text)
    text.gsub(/&#39;|&amp;|&quot;|&lt;|&gt;|\/|/, '')
  end

  def remove_duplicate_dash(text)
    while text.index('--')
      text.gsub!('--', '-')
    end
    text
  end

  module ClassMethods

    def chinese_permalink(attr_names, options = {})
      options = {:permalink_field => 'permalink'}.merge(options)
      self.permalink_attrs = Array(attr_names)
      self.permalink_field = options[:permalink_field]
      self.before_methods = Array(options[:before_methods])
      self.after_methods = Array(options[:after_methods])

      after_save :create_permalink
    end
  end
end
