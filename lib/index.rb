require 'rest-client'
require 'json'
require 'pry'

def search_techcrunch
  response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
  response_hash = JSON.parse(response_string.body)
end

#shows a list of all authors and articles
def show_all_articles_with_authors
  @all = {}
  search_techcrunch["articles"].each do |hash|
    author = hash["author"]
    title = hash["title"]
    @all[title] = author
  end
  @all.each do |title, author| puts "#{author} - #{title}"
  end
  return nil
end

#shows all authors in alphabetical order
def show_all_authors
  @all = []
  search_techcrunch["articles"].each do |article|
    @all << article["author"]
  end
  unique_array = @all.uniq!.sort
  unique_array.each_with_index do |author, index| puts "#{index+1}. #{author}"
  end
  return nil
end

#finds all articles under the given author name (partial - first or last)
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

#shows the latest article
def show_latest_article
  author = search_techcrunch["articles"][0]["author"]
  title = search_techcrunch["articles"][0]["title"]
  content = search_techcrunch["articles"][0]["content"]
  publish_time = search_techcrunch["articles"][0]["publishedAt"]
  url = search_techcrunch["articles"][0]["url"]
  puts "#{title}\n\n#{content}\n\n#{author} - #{publish_time}"
  puts "\nWould you like to read the full article? (y/n)"
  user_input = gets.chomp
    if user_input == "y"
      system("open #{url}")
    else
      puts "\nNot your cuppa tea!? Do any of the following articles interest you?\n\n"
      show_all_articles_with_authors
    end
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
