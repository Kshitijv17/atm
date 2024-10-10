# require_relative 'account.rb'
# require_relative 'transaction_history'
# require_relative 'dino.rb'
require_relative 'currency_converter.rb'
require_relative 'receipt.rb'
require_relative 'meme_ansii.rb'
# require_relative 'expo.rb'
# require_relative './dino game/horizon.png'
# require_relative './dino game/obstacle.png'
# require_relative './dino game/trex.png'


require "rqrcode"
require 'ruby2d'
require 'prawn'
  require 'json'
 require 'gosu'
  require 'rainbow/refinement'
 using Rainbow


class ATM
    def initialize
      @accounts = load_accounts
#       @accounts={
# "tom" => { pin: 1234, balance: 12 },
# "jerry" => { pin: 1234, balance: 23 },
# "shandy" => { pin: 1234, balance: 34 },
# "rambo" => { pin: 1234, balance: 45 },
# "rosy" => { pin: 1234, balance: 21 }
# }
   
      @current_account = nil
    end

#load_account    
  def load_accounts
    if File.exist?('accounts.json')
      file = File.read('accounts.json')
      JSON.parse(file)
    else
      {} 
    end
  end

  def save_accounts
    File.open('accounts.json', 'w') do |file|
      file.write(JSON.pretty_generate(@accounts))
    end
    
  end

#timer
     def get_with_timer
         input = nil
    # Create a thread to handle the input
         input_thread = Thread.new do
        #  print "Please enter your input (you have 30 seconds): "
         input = gets.chomp
       end
     # Create a thread to handle the timer
       timer_thread = Thread.new do
        30.downto(1) do |i|
        sleep(1)
        end
     # If input_thread is still running after 30 seconds, print "Sorry, time's up"
      if input_thread.alive?
      puts "\nSorry, time's up!"
      boom = Sound.new('12.wav')
      boom.play
      input_thread.kill # Terminate the input thread
      # system("rundll32.exe user32.dll,MessageBeep") 
      sleep(2)
      system('cls')
      exit
      end
  end

  # Wait for either the input or timer thread to finish
  input_thread.join
  timer_thread.kill if input_thread.alive? # If input was received, kill the timer thread
  input
  end


    
#big bang    
    def start
      loop do
        # puts @accounts
        puts "Welcome to the ATM".bright
        puts "--------------------"
        puts "1. Login"
        puts "2. Create Account"
        puts "3. Delete Account".red
        puts "4. Exit"
        puts "5. just for fun"
        print "Choose an option: "
 
        option = get_with_timer.to_i
  
        case option
        when 1
          login
        when 2
          create_account
        when 3
          delete_account
        when 4
          puts "Thank you for using the ATM!"
          break
        when 5
          # chromosome
          random_meme
        else
          puts "Invalid option. Please try again."
        end
      end
    end
    
#login
    def login
        print "Enter your name: "
        name = get_with_timer.chomp
        
        if @accounts.key?(name)
            print "Enter your pin: "
            pin = get_with_timer.chomp.to_i
            if @accounts[name]["pin"] == pin
            #   puts "Welcome, #{name.capitalize}!"
              @current_account = name
              account_menu
              puts "Invalid PIN. Please try again."
            end
          else
            puts "Account not found. Please try again."
          end
      end

#create_account
      def create_account
        print "Enter your name: "
        name = get_with_timer.chomp.downcase 
        # Check
        if @accounts.key?(name)
          puts "An account with this name already exists. Please try a different name."
          return
        end
        print "Set your PIN (4 digits): "
        pin = get_with_timer.chomp.to_i
        # Validate that the PIN 
        if pin.to_s.length != 4
          puts "Invalid PIN. Please enter a 4-digit PIN."
          return
        end
        # Create a new account 
        @accounts[name] = { "pin" => pin, "balance" => 0 }
        save_accounts
        puts "Account created successfully for #{name.capitalize}!"
      end

#delete_account
       def delete_account
        print "Do you really really really want to delete your account?"
        # puts get_with_timer
        #  print "enter your name:"
        #  name = get_with_timer.chomp.downcase
        #  print "enter your pin"
         
        #   puts "deleted #{@accounts.delete(name)}\n\n   "
        #   save_accounts
         gets
        print "do you really really really want that"
        gets
        print "you son , take this"
        sleep(1)
        system('curl ascii.live/parrot')
        end

# dinosaur
# def chromosome
#   Game.new.show
# end

#account_menu
      def account_menu
        loop do
            puts "welcome #{@current_account}" 
          puts "--------------------"
          puts "1. View Balance"
          puts "2. Deposit"
          puts "3. Withdraw"
          puts "4. Transfer"
          puts "5. Currency conversion"
          puts "6. Change PIN"
          puts "7. About"
          puts "8. Logout"
          print "Choose an option: "
          option = get_with_timer.chomp.to_i
    
          case option
          when 1
            view_balance
          when 2
            deposit
          when 3
            withdraw
          when 4
            transfer
          when 5
            currency_conversion
          when 6
            change_pin
          when 7
            about
          when 8
            puts "Logging out..."
            @current_account = nil
            break
          else
            puts "Invalid option. Please try again."
          end
        end
      end

#view_balance
      def view_balance
        balance = @accounts[@current_account]["balance"]
        puts "Your current balance is: $#{balance}"
      end
#deposit
    def deposit
        print "Enter amount to deposit: "
        amount = get_with_timer.chomp.to_f
        @accounts[@current_account]["balance"] += amount
        puts "You have successfully deposited $#{amount}."
        transaction_type="deposit"
        balance=@accounts[@current_account]["balance"]
        paper_code=ATMReceipt.new(transaction_type,amount,balance,@current_account)
        paper_code.display_receipt
        #receipt
        print "do you want receipt (y or n)"
        input = get_with_timer.chomp
       if input =~ /\A[yY]/
        puts "collect your receipt in your : #{File.expand_path('../', __FILE__)}"
        paper_code.generate_receipt
       else
        p "saved a tree"
       end
      end
#withdrraw
    def withdraw
        print "Enter amount to withdraw: "
        amount = get_with_timer.chomp.to_f
        if amount <= @accounts[@current_account]["balance"]
          @accounts[@current_account]["balance"] -= amount
          puts "You have successfully withdrawn $#{amount}."
        else
          puts "Insufficient funds."
        end
        transaction_type="Withdraw"
        balance=@accounts[@current_account]["balance"]
        paper_code=ATMReceipt.new(transaction_type,amount,balance,@current_account)
        paper_code.display_receipt

         #receipt
         print "do you want receipt (y or n)"
         input = get_with_timer.chomp
        if input =~ /\A[yY]/
         puts "collect your receipt in your : #{File.expand_path('../', __FILE__)}"
         paper_code.generate_receipt
        else
         p "saved a tree"
        end
      end
#transfer
      def transfer
        print "Enter recipient's name: "
        recipient_pin = get_with_timer.chomp
        recipient_account = @accounts[recipient_pin]
    
        if recipient_account
          print "Enter amount to transfer: "
          amount = get_with_timer.chomp.to_f
          if amount <= @accounts[@current_account]["balance"]
            @accounts[@current_account]["balance"] -= amount
            recipient_account["balance"] += amount
            puts "Transfer successful! Your new balance is $#{@accounts[@current_account]["balance"]}."
            save_accounts
          else
            puts "Insufficient funds."
          end
        else
          puts "Invalid recipient PIN."
        end
      end
    
#currency_conversion
def currency_conversion
    
puts "Welcome to the judiator"
25.times { print "-" }
puts
puts "CURRENCY EXCHANGE "

print "Currency: "
currency = get_with_timer.chomp.upcase
print "Amount: "
amount = get_with_timer.chomp.to_f
print "To Currency: "
to_currency = get_with_timer.chomp.upcase
currency_converse=Cce.new(currency,amount,to_currency)
    currency_converse.conver
end

    #change_pin
      def change_pin
        print "Enter new PIN: "
                                     
        new_pin = get_with_timer.chomp
         @accounts.delete(@accounts[@current_account]["pin"])
        @accounts[@current_account]["pin"] = new_pin.to_i
        puts "PIN changed successfully!"
      end

      #about
      def about
          puts "------- Company Policies -------"
          puts "1. All transactions are secure."
          puts "2. Refunds are processed within 5-7 business days."
          puts "3. Customer service is available 24/7."
          puts "---------------------------------"
          loop do
            puts "Welcome to the ATM".bright
            puts "--------------------"
            puts "1. feedback"
            puts "2. random meme"
            puts "3. location"
            puts "4. buy me a coffee"
            puts "5. exit"
            print "Choose an option: "
            
     
            option = get_with_timer.to_i
      
            case option
            when 1
              feedback
            when 2
              random_meme
            when 3
              show_ascii_map
            when 4
              buy_coffee
            when 5
              puts "Thank you for using the ATM!"
              break
            else
              puts "Invalid option. Please try again."
            end
          end
        end
        def feedback
          print "Please enter your feedback: "
          feedback = gets.chomp
        
          print "How would you rate our service? (1-5): "
          rating = gets.chomp.to_i
        
          print "Would you like to provide any additional comments? (yes/no): "
          additional_comments = gets.chomp.downcase
        
          if additional_comments == "yes"
            print "Please enter your additional comments: "
            additional_comments = gets.chomp
          else
            additional_comments = "None"
          end
        
          puts "Thank you for your feedback!"
        
          # Save the feedback to a file or database
          save_feedback(feedback, rating, additional_comments)
        end
        
        def save_feedback(feedback, rating, additional_comments)
          # Save the feedback to a file
          File.open('.idea/feedback.txt', 'a') do |file|
            file.puts "#{@current_account}"
            file.puts "Feedback: #{feedback}"
            file.puts "Rating: #{rating}/5"
            file.puts "Additional Comments: #{additional_comments}"
            file.puts "------------------------"
          end
        end

#random meme
def random_meme
  display_meme
end




#map 
      def show_ascii_map
        cmd = 'telnet mapscii.me'
        system(cmd)
      end
      
# buy me 

def buy_coffee
qrcode = RQRCode::QRCode.new("9001306085@ptyes")

# NOTE: showing with default options specified explicitly
png = qrcode.as_ansi(
  bit_depth: 1,
  border_modules: 4,
  color_mode: ChunkyPNG::COLOR_GRAYSCALE,
  color: "black",
  file: nil,
  fill: "white",
  module_px_size: 6,
  resize_exactly_to: false,
  resize_gte_to: false,
  size: 12
)
puts png
IO.binwrite("github.png", png.to_s)

  # Image.new('pay.png')
  # show
end


end


    atm = ATM.new
    atm.start


    ######################################################################################
   