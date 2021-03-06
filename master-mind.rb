require 'pry-byebug'
class Game
    @@round = 1
    def initialize(player_1_class, player_2_class)
        set_players(player_1_class, player_2_class)
        #print @@master.secret_codes
        puts ""
        play_game()
    end
    def set_players(player_1_class, player_2_class)
        puts "Input 1 to play as Master"
        puts "Input 2 to play as Cracker"
        player_1_mode = gets.chomp.to_i
        if(player_1_mode == 1)
            @@master = Master.new(player_1_class)
            @@cracker = Cracker.new(player_2_class)

            puts "Select 4 number from 1 to 6 to set secret code."
            @@master.generate_secret_codes()
        elsif(player_1_mode == 2)
            @@master = Master.new(player_2_class)
            @@cracker = Cracker.new(player_1_class)

            @@master.generate_secret_codes()
        end
    end

    def play_game
        while(@@round <= 11)
            puts "ROUND #{@@round}"
            @@cracker.guess_secret_code
            give_feedback()
            if(secret_codes_guessed?)
                puts "THE CODE HAS BEEN CRACKED!"
                return
            end
            @@round += 1
        end
        puts "THE CODE DIDN'T BREAK"
        print @@master.secret_codes
        puts ""
    end
    
    def give_feedback()
        print "Guessed Code is: "
        @@cracker.guess_codes.each_with_index do |code, index|
            print "-#{code}"
        end
        get_clues()
        puts "-#{@@cracker.clues_correct_position.join}#{@@cracker.clues_incorrect_position.join}"
        puts ""
    end
    
    def secret_codes_guessed?
        return (@@master.secret_codes == @@cracker.guess_codes)
    end
    def get_clues
        @@cracker.clues_correct_position.clear
        @@cracker.clues_incorrect_position.clear
        @@master.secret_codes.each_with_index do|code, index|
            code_index = @@cracker.guess_codes.index(code)
            if(code_index)
                if(@@cracker.guess_codes[index] == code)
                    @@cracker.clues_correct_position.push(" (*) ")
                else
                    @@cracker.clues_incorrect_position.push(" ( ) ")
                end
                @@cracker.guess_codes[code_index] = 0
            end
        end
        
    end
    class Master
        attr_reader :secret_codes
        def initialize(player_class)
            @secret_codes = []
            @@player = player_class.new()
        end
    
        def generate_secret_codes()
            @secret_codes = @@player.get_number
        end
    end
    class Cracker
        @guess_codes = Array.new(3, 1)
        attr_reader :guess_codes
        attr_reader :clues_correct_position
        attr_reader :clues_incorrect_position
        def initialize(player_class)
            @@player = player_class.new()
            @clues_correct_position = Array.new(4,0)
            @clues_incorrect_position = Array.new(4,0)
        end

        def get_number
            number = @@player.get_number
            return number
        end

        def guess_secret_code
            puts "Cracker is guessing the codes"
            @guess_codes = @@player.get_number
        end
    end
end

class Human
    def get_number
        number = gets.chomp.split("")
        if(number.length == 4)
            return number
        end
    end
    def guess_secret_code(*)
        number = gets.chomp.split("")
        if(number.length == 4)
            return number
        end
    end
end

class Computer
    def get_number
        counter = 0
        all_number = ""
        while(counter < 4)
            number = random_number()
            all_number += number
            counter += 1
        end
        return all_number.split("")
    end

    def guess_secret_code()
        return Array.new(4 ,random_number())
    end

    def random_number
        return ["1", "2", "3", "4", "5", "6"].shuffle[0]
    end
end
Game.new(Human, Computer)