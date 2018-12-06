
require 'rest-client'
require 'json'


class CommandLine

  #displays welcome message
  def welcome
    puts "
     _ _ _     _                      _          _____         _   _____                 _
    | | | |___| |___ ___ _____ ___   | |_ ___   |_   _|___ ___| |_|     |___ _ _ ___ ___| |_
    | | | | -_| |  _| . |     | -_|  |  _| . |    | | | -_|  _|   |   --|  _| | |   |  _|   |
    |_____|___|_|___|___|_|_|_|___|  |_| |___|    |_| |___|___|_|_|_____|_| |___|_|_|___|_|_|

    
"
    puts "Here You can find the latest articles straight from the amazing peeps at TechCrunch HQ.\n\nThe ultimately crunchy tech news that you need in your life. "
  end

  #menu page for user
  def menu
    puts "
    Please select from the following options - using numbers (1-6) as your input:
    - 1 - Titles and authors of latest 10 articles
    - 2 - Quick read of latest 10 articles
    - 3 - See all current authors
    - 4 - Find article(s) based on author
    - 5 - Check out the latest article
    - 6 - Exit the application
    "
    end

  #obtains user input from menu page
  def menu_choice
    user_input = gets.chomp
    case user_input
    when "1"
      show_all_article_titles_with_authors
      back_to_menu
    when "2"
      show_all_article_titles_with_content
      back_to_menu
    when "3"
      show_all_authors
      back_to_menu
    when "4"
      puts "Here are all the authors to choose from:\n"
      show_all_authors
      puts "\n Please provide an Author name:"
      author = gets.chomp
      find_article_titles_by_author(author)
      show_full_list_of_articles(author)
      back_to_menu
    when "5"
      show_latest_article
      back_to_menu
    when "6"
      puts "\n\nThanks for choosing TechCrunch Top 10! See you honeys later... ❤"
      exit
    else
      puts "Invalid option. Please select a number between 1 and 6."
      menu
      menu_choice
    end
  end

  def exit
    nil
  end

  def back_to_menu
    puts "\nWould you like to go back to the menu page? (y/n)"
    user_input = gets.chomp
    if user_input == "y"
    menu
    menu_choice
  elsif user_input == "n"
    puts "Would you like to exit the app? (y/n)"
    user_input = gets.chomp
    if user_input == "y"
      exit
    else
      menu
      menu_choice
    end
  end
  end

  def search_techcrunch
    response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
    response_hash = JSON.parse(response_string.body)
  end

  #shows a list of all articles - authors and title
  def all_article_titles_with_authors
    @all = {}
    search_techcrunch["articles"].each do |hash|
      author = hash["author"]
      title = hash["title"]
      @all[title] = author
    end
    return @all
  end

  def show_all_article_titles_with_authors
    @all = all_article_titles_with_authors
    @all.each do |title, author|
      puts "#{author} - #{title}"
    end
    return @all
  end

  def show_full_list_of_articles(author)
    puts "Would you like to read the article(s)?(y/n)"
    user_input = gets.chomp
    case user_input
    when "y"
      # puts show_all_article_titles_with_authors

      author_articles = all_article_titles_with_authors.select do |title, name|
        name.split(' ')[0] == author
      end
      hay = all_article_titles_with_content
      array = []
      author_articles.each do |title, name|
        if hay.keys.include?(title)
          array << hay[title]
        end
      end
      puts array
      # author_articles.each {|i| puts "#{author} \n\n #{content}"}
    when "n"
      puts "Sorry to hear that, we'll take you back to the menu now!"
      menu
      menu_choice
    end
  end

  #shows a list of all articles - title and content
  def show_all_article_titles_with_content
    @all = {}
    search_techcrunch["articles"].each do |hash|
      title = hash["title"]
      content = hash["content"]
      @all[content] = title
    end
    @all.each do |content, title| puts "#{dashes}\n#{title}\n#{dashes}\n#{content}\n\n"
    end
    return nil
  end

  def all_article_titles_with_content
    @all = {}
    search_techcrunch["articles"].each do |hash|
      title = hash["title"]
      content = hash["content"]
      @all[title] = content
    end
    @all
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

  def dashes
    return "------------------------------------------------------------------------------------------------------"
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
end
