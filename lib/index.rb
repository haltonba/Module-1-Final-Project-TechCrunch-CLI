require 'rest-client'
require 'json'
require 'pry'

def search_techcrunch
  response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
  response_hash = JSON.parse(response_string.body)
end

# def search_by_author(author)
#   search_full_api.find do |info| info["articles"][0]["name"] == author
#   end
# end

# def find_techcrunch(author)
#   response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
#   response_hash = JSON.parse(response_string.body)
# end
#
#
# def find_article(article)
#   Set.all.find do |article|
#     article.name == article
#   end
# end


def find_article_titles_by_author(author)
  @titles = []
  search_techcrunch["articles"].each do |article|
     if article["author"].include?(author)
       @titles << article["title"]
     end
  end
  @titles.each_with_index do |title, index| puts "#{index+1}. #{title}"
  end
  return nil
end

# def find_article_by_phrase(phrase)
#   @titles = []
#   search_techcrunch["articles"].each do |article|
#      if article["title"].include?(phrase) || article["content"].include?(phrase)
#        @titles << article["title"]
#        end
#      end
#   #Needs an if there is a title
#     if @titles.length != 0
#       puts "Please enter the number of the article you would like to view:"
#       @titles.each_with_index do |title, index| puts "#{index+1}. #{title}"
#       elsif
#       puts "Please enter another keyword(s)."
#     end
#   end
#   user_input = gets.chomp
#
#   return nil
# end

Pry.start
