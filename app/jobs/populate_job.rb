class PopulateJob
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(from = 1.day.ago.beginning_of_day.iso8601, to = 1.day.ago.end_of_day.iso8601)
    news = News.new(ENV['NEWS_API_KEY'])
    page = 1

    loop do
      articles = news.get_everything(q: '"Florida Man"', sortBy: 'popularity', from: from, to: to, page: page, searchIn: 'title')
      articles.uniq(&:title).each do |art|
        Article.create(
          title: art.title,
          description: art.description,
          url: art.url,
          url_to_image: art.urlToImage,
          published_at: art.publishedAt
        )
      end

      break if articles.count < 100
      page += 1
    end
  end
end
