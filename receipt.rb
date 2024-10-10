class ATMReceipt
  # attr_accessor :date, :transaction_type, :amount, :balance

  def initialize( transaction_type, amount, balance,current_account)
    @transaction_type = transaction_type
    @amount = amount
    @balance = balance
    @current_account = current_account
  end


  def display_receipt
    puts "============================="
    puts "          ATM RECEIPT       "
    puts "============================="
    puts  Time.now.strftime("Date: %Y-%m-%d")
    puts " Transaction Type: #{@transaction_type}"
    puts " Balance: $#{'%.2f' % @balance}"
    puts " Amount: $#{'%.2f' % @amount}"
    puts "============================="
    puts " Thank you 🌸"
    puts "============================="
  end

  def generate_receipt
    transaction_type = @transaction_type # or "Withdraw"
    amount = @amount              # Static amount
    account_holder = @current_account    # Static account holder name
    date = Time.now.strftime("%Y-%m-%d %H:%M:%S") # Current date and time
  
    Prawn::Document.generate("#{@transaction_type}_receipt_#{Time.now.strftime("%Y%m%d_%H%M%S")}.pdf") do
      text "Transaction Receipt", align: :center, size: 20
      move_down 20
      text "Transaction Type: #{transaction_type}"
      text "Amount: $#{'%.2f' %  amount}"
      text "Account Holder: #{account_holder}"
      text "Date: #{date}"
      text "Thank you for using our ATM!"
    end
    puts "Receipt generated: #{@transaction_type}_receipt.pdf"
  end
end
