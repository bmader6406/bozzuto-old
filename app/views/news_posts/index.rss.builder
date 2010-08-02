xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Bozzuto News"
    xml.description ''
    xml.link section_news_posts_url('about')

    @news_posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.body.try(:html_safe)
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link section_news_post_url('about', post)
      end
    end
  end
end

