def pick_random_line
    random_line = nil
    File.open("output.txt") do |file|
      file_lines = file.readlines()
      random_line = file_lines[Random.rand(0...file_lines.size())]
    end 
  
   
  end

def display_meme
    puts "
   ( o.o )

  ( > ^ < )
  I had fun using the ATM, but now I'm broke
  "
  puts pick_random_line
  
  end

  