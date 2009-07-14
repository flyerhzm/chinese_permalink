require 'test/unit'

require 'rubygems'
require 'active_record'

require File.join(File.dirname(__FILE__), '../lib/chinese_permalink')
require File.join(File.dirname(__FILE__), '../init')

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => ':memory:')

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :posts do |t|
      t.column :title, :string
      t.column :category, :string
      t.column :permalink, :string
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Post < ActiveRecord::Base
  chinese_permalink :title
end

class CategoryPost < Post
  chinese_permalink [:category, :title]
end

class ComplicatedPost < Post
  chinese_permalink :title, :before_methods => :parse_c_sharp

  def parse_c_sharp
    permalink.gsub!(/C#/, /c-sharp/)
  end
end

class ChinesePermalinkTest < Test::Unit::TestCase
  def setup
    setup_db
  end

  def teardown
    teardown_db
  end

  def test_simple_chinese_title
    post = Post.create(:title => '中国人')
    assert_equal "#{post.id}-chinese", post.permalink

    post = Post.create(:title => '我是中国人')
    assert_equal "#{post.id}-i-am-a-chinese", post.permalink
  end

  def test_chinese_title_with_dash
    post = Post.create(:title => '我是中国人——上海')
    assert_equal "#{post.id}-i-am-a-chinese-shanghai", post.permalink

    post = Post.create(:title => '我是中国人──上海')
    assert_equal "#{post.id}-i-am-chinese-shanghai", post.permalink

    post = Post.create(:title => '上海+中国')
    assert_equal "#{post.id}-shanghai-china", post.permalink

    post = Post.create(:title => '上海/中国')
    assert_equal "#{post.id}-shanghai-china", post.permalink

    post = Post.create(:title => '“工作”')
    assert_equal "#{post.id}-work", post.permalink
    
    post = Post.create(:title => '妈妈的礼物')
    assert_equal "#{post.id}-mothers-gift", post.permalink

    post = Post.create(:title => '宝洁')
    assert_equal "#{post.id}-procter-gamble", post.permalink

    post = Post.create(:title => '自我介绍')
    assert_equal "#{post.id}-self-introduction", post.permalink
  end

  def test_chinese_category_and_title
    post = CategoryPost.create(:title => '我是中国人', :category => '介绍')
    assert_equal "#{post.id}-introduction-i-am-a-chinese", post.permalink
  end

  def test_complicated_title
    post = ComplicatedPost.create(:title => 'C#语言')
    assert_equal "#{post.id}-c-sharp-language", post.permalink
  end
end
