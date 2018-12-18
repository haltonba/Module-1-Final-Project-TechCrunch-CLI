
require 'rest-client'
require 'json'
require 'rainbow'


class CommandLine

  #displays welcome message
  def welcome
    puts Rainbow("

    ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗    ████████╗ ██████╗
    ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝    ╚══██╔══╝██╔═══██╗
    ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗         ██║   ██║   ██║
    ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝         ██║   ██║   ██║
    ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗       ██║   ╚██████╔╝
     ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝       ╚═╝    ╚═════╝

    ████████╗███████╗ ██████╗██╗  ██╗ ██████╗██████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗
    ╚══██╔══╝██╔════╝██╔════╝██║  ██║██╔════╝██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║
       ██║   █████╗  ██║     ███████║██║     ██████╔╝██║   ██║██╔██╗ ██║██║     ███████║
       ██║   ██╔══╝  ██║     ██╔══██║██║     ██╔══██╗██║   ██║██║╚██╗██║██║     ██╔══██║
       ██║   ███████╗╚██████╗██║  ██║╚██████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║
       ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝
       ").magenta
    puts Rainbow("\n    Here you can find the latest articles straight from the amazing peeps at TechCrunch HQ.
              \n\n    The ultimate crunchy tech news that you need in your life.\n\n").white.bright
  end

  #menu page for user
  def menu
    puts "#{dashes}\n
    Please select from the following options - using numbers (1-6) as your input:\n
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
      puts Rainbow("Here are all the authors to choose from:\n").white.bright
      show_all_authors
      puts Rainbow("\nPlease provide an author name:").white.bright
      author = gets.chomp
      find_article_titles_by_author(author)
      show_full_list_of_articles(author)
      back_to_menu
    when "5"
      show_latest_article
      back_to_menu
    when "6"
      exit
    else
      puts Rainbow("Invalid option. Please select a number between 1 and 6.").white.bright
      menu
      menu_choice
    end
  end

  #exits the app
  def exit
    puts Rainbow("\n\n🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 Thanks for choosing TechCrunch Top 10! See you honeys later... ❤ 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑 🦑\n\n").magenta.bright
    nil
  end

  #reroutes user back to menu
  def back_to_menu
    puts Rainbow("\nWould you like to go back to the menu page? (y/n)").white.bright
    user_input = gets.chomp
    if user_input == "y"
    menu
    menu_choice
  elsif user_input == "n"
    puts Rainbow("Would you like to exit the app? (y/n)").white.bright
    user_input = gets.chomp
    if user_input == "y"
      exit
    else
      menu
      menu_choice
    end
  end
  end

  #loads the response hash
  def search_techcrunch
    response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
    response_hash = JSON.parse(response_string.body)
  end

  #creates an array of all articles - authors and title
  def all_article_titles_with_authors
    @all = {}
    search_techcrunch["articles"].each do |hash|
      author = hash["author"]
      title = hash["title"]
      @all[title] = author
    end
    return @all
  end

  #formats the array of all articles - authors and titles
  def show_all_article_titles_with_authors
    @all = all_article_titles_with_authors
    @all.each do |title, author|
      puts "#{author} - #{title}"
    end
    return @all
  end

  #prompts user with the choice to read the full article
  def show_full_list_of_articles(author)
    puts Rainbow("Would you like to read the article(s)?(y/n)").white.bright
    user_input = gets.chomp
    case user_input
    when "y"
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
      array.each_with_index do |article, index| puts "\n#{dashes}\n#{index+1}. #{article}\n#{dashes}\n"
      end
    when "n"
      puts Rainbow("Sorry to hear that, we'll take you back to the menu now!").white.bright
      menu
      menu_choice
    end
  end

  #shows a formatted array of all articles - title and content
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

  #supporting method used in show full list of articles
  def all_article_titles_with_content
    @all = {}
    search_techcrunch["articles"].each do |hash|
      title = hash["title"]
      content = hash["content"]
      @all[title] = content
    end
    @all
  end

  #shows an array of all authors in alphabetical order
  def show_all_authors
    @all = []
    search_techcrunch["articles"].each do |article|
      @all << article["author"]
    end
    unique_array = @all.uniq!.sort
    puts "#{dashes}\n"
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
    puts "#{dashes}\n#{title}\n\n#{content}\n\n#{author} - #{publish_time}\n#{dashes}"
    puts Rainbow("\nWould you like to read the full article? (y/n)").white.bright
    user_input = gets.chomp
      if user_input == "y"
        system("open #{url}")
      else
        puts Rainbow("\nNot your cuppa tea!?").white.bright
        menu
      end
  end

  #adds a line as a page breaker
  def dashes
    return "------------------------------------------------------------------------------------------------------"
  end

end
