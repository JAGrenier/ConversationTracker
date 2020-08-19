require "tty-prompt"
class Cli 
    prompt = TTY::Prompt.new
    attr_accessor :username_input

    # def initilize 

    #     @prompt = tty_prompt 
    # end

    # def tty_prompt
    #     TTY::Prompt.new
    #         #symbols: { marker: '' },
    #         #active_color: :cyan,
    #         #help_color: :bright_cyan
        
    # end

    def welcome 
        prompt = TTY::Prompt.new
        # binding.pry
        puts "Welcome to Friendly Reminder"  
        @username_input = prompt.ask("Please enter a new or existing username".colorize(:green)) do |q|
            q.required true
            q.modify :strip, :capitalize 
        end
        find_user
    end

    def find_user
        @found_user = Account.all.find_by(username: @username_input)
            if @found_user
                puts "Welcome back, #{@found_user.username}!".colorize(:green)
            else
                Account.create(username: @username_input)
                puts "Welcome, new friend, #{@username_input}!".colorize(:green)
            end
            main_menu
        end
    end
    
    def main_menu 
        prompt = TTY::Prompt.new
        choices = {
            "Create New Converastion" => 1,
            "Delete Conversation" => 2,
            "Update Conversation" => 3, 
            "View Your Friends" => 4, 
            "Exit Friendly Reminder" => 5
        }
        menu_response = prompt.select("Choose an option from below:".colorize(:green), choices)
        case menu_response
        when 1
            prompt = TTY::Prompt.new
            new_friend_name = prompt.ask("Who is your friend?") do |q|
                q.required true
                q.modify :strip, :capitalize 
            end
            date = prompt.ask ("On what date was your most recent conversation?")
            new_friend = Friend.create(name: new_friend_name, occupation: nil)
            Conversation.create account: @found_user, friend: new_friend, date: date
            puts "Your new friend has been entered! Remeber to keep in touch!"
            binding.pry
            main_menu
        when 2
            delete_conversation
        when 3 
            prompt = TTY::Prompt.new
            friend_chat = prompt.ask("Great job reaching out to a friend! Whom did you speak with?")
           newconvo = Conversation.find_by(friend: friend_chat)
           new_date = prompt.ask("On what date did you speak to them?")
           binding.pry
           newconvo.update(date: new_date)
           puts "Your conversation has been updated!"
        when 4 
            view_friends
        when 5 
            puts "We hope you enjoied your Friendly Reminder! Come back soon!"
            sleep(4)
            exit
        end

       def delete_conversation
            exfriend = prompt.ask("Who would you like to delete??")
            exfriend_name = Friend.find_by(name: exfriend)
            exfriend_name.destroy
            puts "delete"
        end
        
        def view_friends
            Converastions.pluck(:friend) 
            puts "here are your friends!"
        end
    end