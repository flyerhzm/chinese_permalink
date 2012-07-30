require 'bing_translator'

module ChinesePermalink
  def self.included(base)
    base.class_eval do
      class_attribute :permalink_attrs, :permalink_field, :before_methods, :after_methods
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

      english_permalink = Translate.t(chinese_permalink)
      self.class.after_methods.each do |method|
        english_permalink = self.send(method, english_permalink)
      end

      english_permalink = remove_duplicate_dash(remove_heading_dash(remove_tailing_dash(remove_non_ascii(remove_space(remove_punctuation(english_permalink)))))).downcase
      self.update_attribute(self.class.permalink_field, english_permalink)
    end
  end

  def remove_heading_dash(text)
    text.gsub(/^-+/, '')
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
    text.gsub(/&#39;|&amp;|&quot;|&lt;|&gt;/, '').gsub(/\//, '-')
  end

  def remove_duplicate_dash(text)
    text.gsub(/-{2,}/, '-')
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

  class Translate
    class <<self

      def config
        @config ||= YAML.load(File.open(File.join(Rails.root, "config/chinese_permalink.yml")))['bing']
      end

      def t(text)
        self.translator.translate(text, :from => config['language'], :to => 'en')
      end

      def translator
        @translator ||= BingTranslator.new(config['client_id'], config['client_secret'])
      end
    end
  end
end

ActiveRecord::Base.send :include, ChinesePermalink
