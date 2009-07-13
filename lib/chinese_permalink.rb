begin
  # rtranslate is a gem that can translate text based on google translate
  require 'rtranslate'
rescue Object
  puts "no rtranslate, you might want to look into it."
end

module ChinesePermalink

  def self.included(base)
    base.extend ClassMethods
    class <<base
      attr_accessor :permalink_attrs
      attr_accessor :permalink_field
    end
  end 

  private 
  def create_permalink
    permalink = self.class.permalink_attrs.collect do |attr_name|
      chinese_value = self.send(attr_name)
      english_value = Translate.t(chinese_value, 'CHINESE', 'ENGLISH')
      remove_tailing_dash(remove_non_ascii(remove_space(remove_punctuation(english_value)))).downcase
    end * '-'
    permalink = id.to_s + '-' + permalink
    self.update_attribute(self.class.permalink_field, permalink) if self.permalink.nil?
  end

  def remove_tailing_dash(text)
    text.gsub(/-+$/, '')
  end

  def remove_non_ascii(text)
    text.gsub(/[^-a-zA-Z0-9]/, '')
  end

  def remove_space(text)
    text.gsub(/\s+/, '-')
  end
  
  def remove_punctuation(text)
    text.gsub(/&#39;|&amp;|&quot;|&lt;|&gt;|-|\/|/, '')
  end

  module ClassMethods

    def chinese_permalink(attr_names = [], permalink_field = 'permalink')
      self.permalink_attrs = Array(attr_names)
      self.permalink_field = permalink_field

      after_save :create_permalink
    end
  end
end
